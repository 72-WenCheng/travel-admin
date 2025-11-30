<template>
  <div class="login-page">
    <!-- 左侧登录表单 -->
    <div class="login-left">
      <!-- 右侧渐变遮罩 -->
      <div class="gradient-overlay gradient-left"></div>
      
      <!-- 左侧背景装饰 -->
      <div class="left-decoration"></div>
      <div class="left-decoration-bottom"></div>
      <div class="left-decoration-middle"></div>
      
      <div class="login-container">
        <div class="login-header">
          <div class="logo-icon">
            <el-icon><Location /></el-icon>
          </div>
          <h1>智慧生态旅游系统</h1>
          <p>智能旅游攻略平台 · 生态旅游新体验</p>
        </div>
        
        <div class="login-form">
        <!-- 登录类型选择 -->
        <div class="login-type-selector">
          <el-radio-group v-model="loginType" @change="handleLoginTypeChange">
            <el-radio-button label="user">用户端登录</el-radio-button>
            <el-radio-button label="admin">管理端登录</el-radio-button>
          </el-radio-group>
        </div>
        
        <h2>{{ loginType === 'user' ? '用户登录' : '管理员登录' }}</h2>
        
        <el-form :model="loginForm" :rules="loginRules" ref="loginFormRef">
          <el-form-item prop="username">
            <el-input 
              v-model="loginForm.username" 
              placeholder="请输入账号"
              prefix-icon="User"
              size="large"
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input 
              v-model="loginForm.password" 
              type="password" 
              placeholder="请输入密码"
              prefix-icon="Lock"
              size="large"
              @keyup.enter="handleLogin"
            />
          </el-form-item>
          <el-form-item v-if="loginType === 'user'" class="login-options">
            <div class="options-container">
              <el-checkbox v-model="rememberMe">记住我</el-checkbox>
              <el-link type="primary" class="forgot-password" @click="handleForgotPassword">忘记密码？</el-link>
            </div>
          </el-form-item>
          <el-form-item>
            <el-button 
              type="primary" 
              @click="handleLogin" 
              :loading="loading"
              size="large"
              style="width: 100%;"
            >
              {{ loading ? '登录中...' : '登录' }}
            </el-button>
          </el-form-item>
        </el-form>
        
        <div v-if="loginType === 'user'" class="register-link">
          <div class="link-container">
            <span>还没有账号？</span>
            <el-link type="primary" @click="handleRegister" class="register-link-text">立即注册</el-link>
          </div>
        </div>
        </div>
      </div>
    </div>
    
    <!-- 右侧装饰区域 -->
    <div class="login-right">
      <!-- 左侧渐变遮罩 -->
      <div class="gradient-overlay gradient-right"></div>
      
      <div class="right-content">
        <div class="illustration-container">
          <!-- 浮动装饰元素 -->
          <div class="floating-elements">
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
            <div class="circle circle-3"></div>
            <div class="grid-pattern"></div>
          </div>
          
          <!-- 数据可视化元素 -->
          <div class="data-visualization">
            <div class="isometric-shape shape-1">
              <div class="shape-inner"></div>
            </div>
            <div class="isometric-shape shape-2">
              <div class="shape-inner"></div>
            </div>
            <div class="isometric-shape shape-3">
              <div class="shape-inner"></div>
            </div>
          </div>
          
          <!-- 科技感装饰 -->
          <div class="tech-decoration">
            <div class="tech-line line-1"></div>
            <div class="tech-line line-2"></div>
            <div class="tech-line line-3"></div>
          </div>
        </div>
        
        <div class="right-text">
          <h2>探索无限可能</h2>
          <p>开启您的智能旅游之旅</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { authAPI } from '@/api/auth'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'

const router = useRouter()

// 登录类型选择
const loginType = ref('user')

// 表单数据
const loginForm = reactive({
  username: '',
  password: ''
})

// 记住我
const rememberMe = ref(false)

// 页面加载时，从localStorage读取保存的账号和密码
onMounted(() => {
  const savedUsername = localStorage.getItem('remembered_username')
  const savedPassword = localStorage.getItem('remembered_password')
  const savedRememberMe = localStorage.getItem('remember_me')
  
  if (savedUsername) {
    loginForm.username = savedUsername
  }
  if (savedPassword) {
    loginForm.password = savedPassword
  }
  if (savedRememberMe === 'true') {
    rememberMe.value = true
  }
})

// 表单验证规则 - 移除前端验证，交由后端处理
const loginRules = {
  username: [],
  password: []
}

// 表单引用
const loginFormRef = ref()
const loading = ref(false)

// 登录类型切换
const handleLoginTypeChange = (value: string) => {
  // 清空表单
  loginForm.username = ''
  loginForm.password = ''
  rememberMe.value = false
}

// 登录处理
const handleLogin = async () => {
  try {
    // 移除前端验证，交由后端处理
    // await loginFormRef.value.validate()
    loading.value = true
    
    console.log('发送登录请求 - 用户名:', loginForm.username, '密码:', loginForm.password, '登录类型:', loginType.value)
    
    // 调用登录API
    const response = await authAPI.login({
      username: loginForm.username,
      password: loginForm.password,
      loginType: loginType.value
    })
    
    console.log('登录响应:', response)
    console.log('登录响应code:', response.code)
    console.log('登录响应message:', response.message)
    
    if (response.code === 200) {
      // 存储token和用户信息
      localStorage.setItem('travel_token', response.data.token)
      localStorage.setItem('travel_user_info', JSON.stringify(response.data.user))
      
      // 根据"记住我"选项，保存或清除账号密码
      if (rememberMe.value) {
        localStorage.setItem('remembered_username', loginForm.username)
        localStorage.setItem('remembered_password', loginForm.password)
        localStorage.setItem('remember_me', 'true')
      } else {
        localStorage.removeItem('remembered_username')
        localStorage.removeItem('remembered_password')
        localStorage.removeItem('remember_me')
      }
      
      // 更新用户store
      const userStore = useUserStore()
      userStore.setToken(response.data.token)
      userStore.setUserInfo(response.data.user)
      
      ElMessage.success('登录成功')
      
      // 根据用户角色跳转
      const user = response.data.user
      console.log('用户信息:', user)
      console.log('用户角色 (role):', user.role)
      console.log('个性化标签 (userType):', user.userType)
      
      // 使用 role 字段判断用户角色（不是 userType！）
      // role: 1=管理员, 2=普通用户
      // userType: 1=个人, 2=情侣, 3=家庭, 4=团队（个性化标签）
      const role = user.role
      console.log('最终用户角色:', role, '类型:', typeof role)
      
      if (role === 1) {
        // 管理员 - 跳转到管理端（/home/admin，有左侧菜单栏）
        console.log('管理员登录，跳转到管理端')
        router.push('/home/admin/dashboard')
      } else if (role === 2) {
        // 普通用户 - 跳转到用户端（/home/user，无左侧菜单栏）
        console.log('普通用户登录，跳转到用户端')
        router.push('/home/user/dashboard')
      } else {
        // 默认跳转到用户端
        console.log('默认跳转到用户端，用户角色:', role)
        router.push('/home/user/dashboard')
      }
    } else {
      ElMessage.error(response.message || '登录失败')
    }
  } catch (error: any) {
    console.error('登录错误:', error)
    console.error('错误response:', error.response)
    console.error('错误response.data:', error.response?.data)
    
    // 提取用户友好的错误信息
    let errorMessage = '登录失败，请重试'
    
    // 优先使用后端返回的错误信息
    // 后端返回格式: { code: 400, message: "错误信息", data: null }
    if (error.response?.data?.message) {
      errorMessage = error.response.data.message
      console.log('使用后端返回的错误信息:', errorMessage)
    } else if (error.response?.data?.data) {
      errorMessage = error.response.data.data
      console.log('使用后端返回的数据信息:', errorMessage)
    } else if (error.message) {
      // 过滤掉技术性的错误信息
      if (error.message.includes('selectOne') || 
          error.message.includes('TooManyResults') ||
          error.message.includes('Expected one result') ||
          error.message.includes('but found:')) {
        errorMessage = '账号信息异常，请联系管理员'
      } else if (error.message.includes('Connection') || 
                 error.message.includes('timeout')) {
        errorMessage = '网络连接异常，请检查网络后重试'
      } else if (error.message.includes('500') || 
                 error.message.includes('Internal Server Error')) {
        errorMessage = '服务器异常，请稍后重试'
      } else {
        errorMessage = error.message
      }
      console.log('使用错误message:', errorMessage)
    }
    
    console.log('最终错误信息:', errorMessage)
    ElMessage.error(errorMessage)
  } finally {
    loading.value = false
  }
}

// 注册处理
const handleRegister = () => {
  router.push('/register')
}

// 忘记密码处理
const handleForgotPassword = () => {
  router.push('/forgot-password')
}
</script>

<style lang="scss" scoped>
.login-page {
  height: 100vh;
  display: flex;
  overflow: hidden;
}

// 左侧登录表单区域
.login-left {
  flex: 0 0 50%;
  background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  position: relative;
  overflow: hidden;
  
  // 添加弧线分割
  &::after {
    content: '';
    position: absolute;
    top: 0;
    right: -80px;
    width: 200px;
    height: 100%;
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.2) 0%, transparent 50%);
    clip-path: ellipse(70% 90% at 70% 50%);
    pointer-events: none;
    z-index: 2;
  }
  
  // 装饰性背景元素
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(102, 126, 234, 0.08) 1px, transparent 1px);
    background-size: 30px 30px;
    animation: float 30s infinite linear;
  }
}

// 添加左侧背景装饰
.login-left {
  // 左侧装饰圆圈
  & .left-decoration {
    position: absolute;
    top: 10%;
    left: 5%;
    width: 200px;
    height: 200px;
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.12), rgba(118, 75, 162, 0.08));
    border-radius: 50%;
    filter: blur(40px);
    animation: float 15s infinite ease-in-out;
    z-index: 0;
  }
  
  // 左下角装饰
  & .left-decoration-bottom {
    position: absolute;
    bottom: 10%;
    left: 8%;
    width: 150px;
    height: 150px;
    background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.06));
    border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
    filter: blur(30px);
    animation: float 20s infinite ease-in-out;
    animation-delay: 2s;
    z-index: 0;
  }
  
  // 中间装饰形状
  & .left-decoration-middle {
    position: absolute;
    top: 50%;
    left: 3%;
    width: 100px;
    height: 100px;
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.08), rgba(118, 75, 162, 0.05));
    border-radius: 50%;
    filter: blur(25px);
    animation: float 18s infinite ease-in-out;
    animation-delay: 4s;
    z-index: 0;
  }
}

// 右侧装饰区域
.login-right {
  flex: 0 0 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  
  // 添加弧线分割
  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: -120px;
    width: 200px;
    height: 100%;
    background: linear-gradient(225deg, rgba(255, 255, 255, 0.15) 0%, transparent 50%);
    clip-path: ellipse(70% 90% at 30% 50%);
    pointer-events: none;
    z-index: 2;
  }
  
  .right-content {
    position: relative;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 1;
  }
  
  .illustration-container {
    position: relative;
    width: 100%;
    height: 70%;
    overflow: hidden;
  }
  
  .floating-elements {
    position: absolute;
    width: 100%;
    height: 100%;
    
    .circle {
      position: absolute;
      border-radius: 50%;
      animation: float 15s infinite ease-in-out;
      
      &.circle-1 {
        width: 300px;
        height: 300px;
        background: rgba(255, 255, 255, 0.1);
        top: 10%;
        left: 10%;
        animation-delay: 0s;
      }
      
      &.circle-2 {
        width: 200px;
        height: 200px;
        background: rgba(255, 255, 255, 0.08);
        top: 60%;
        right: 15%;
        animation-delay: 2s;
      }
      
      &.circle-3 {
        width: 150px;
        height: 150px;
        background: rgba(255, 255, 255, 0.06);
        bottom: 20%;
        left: 20%;
        animation-delay: 4s;
      }
    }
    
    .grid-pattern {
      position: absolute;
      width: 100%;
      height: 100%;
      background-image: 
        linear-gradient(rgba(255, 255, 255, 0.1) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255, 255, 255, 0.1) 1px, transparent 1px);
      background-size: 50px 50px;
      opacity: 0.3;
    }
  }
  
  .data-visualization {
    position: absolute;
    width: 100%;
    height: 100%;
    
    .isometric-shape {
      position: absolute;
      animation: float 20s infinite ease-in-out;
      
      &.shape-1 {
        width: 120px;
        height: 120px;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
        top: 20%;
        left: 15%;
        transform: rotate(45deg);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        animation-delay: 0s;
        
        .shape-inner {
          width: 60%;
          height: 60%;
          background: rgba(255, 255, 255, 0.3);
          margin: 20%;
          box-shadow: inset 0 0 20px rgba(255, 255, 255, 0.5);
        }
      }
      
      &.shape-2 {
        width: 100px;
        height: 100px;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0.08));
        top: 50%;
        right: 20%;
        transform: rotate(-45deg);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        animation-delay: 3s;
        
        .shape-inner {
          width: 70%;
          height: 70%;
          background: rgba(255, 255, 255, 0.25);
          margin: 15%;
          box-shadow: inset 0 0 15px rgba(255, 255, 255, 0.4);
        }
      }
      
      &.shape-3 {
        width: 80px;
        height: 80px;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.05));
        bottom: 25%;
        left: 25%;
        transform: rotate(30deg);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        animation-delay: 6s;
        
        .shape-inner {
          width: 65%;
          height: 65%;
          background: rgba(255, 255, 255, 0.2);
          margin: 17.5%;
          box-shadow: inset 0 0 12px rgba(255, 255, 255, 0.35);
        }
      }
    }
  }
  
  .tech-decoration {
    position: absolute;
    width: 100%;
    height: 100%;
    
    .tech-line {
      position: absolute;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      animation: techLine 8s infinite ease-in-out;
      
      &.line-1 {
        width: 2px;
        height: 100px;
        top: 30%;
        left: 25%;
        animation-delay: 0s;
      }
      
      &.line-2 {
        width: 100px;
        height: 2px;
        top: 55%;
        right: 30%;
        animation-delay: 2s;
      }
      
      &.line-3 {
        width: 2px;
        height: 80px;
        bottom: 30%;
        left: 40%;
        animation-delay: 4s;
      }
    }
  }
  
  .right-text {
    margin-top: 30px;
    text-align: center;
    color: white;
    
    h2 {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 16px;
      text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    }
    
    p {
      font-size: 18px;
      opacity: 0.9;
      text-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);
    }
  }
}

// 渐变遮罩层（使用弧线后，可以移除或保留）
.gradient-overlay {
  display: none; // 暂时隐藏，使用弧线分割替代
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(180deg); }
}

@keyframes techLine {
  0%, 100% { opacity: 0; transform: scale(0.8); }
  50% { opacity: 1; transform: scale(1); }
}

// 响应式设计
@media (max-width: 1024px) {
  .login-page {
    flex-direction: column;
  }
  
  .login-left,
  .login-right {
    flex: 0 0 50%;
  }
  
  .login-right {
    .right-text {
      h2 {
        font-size: 28px;
      }
      
      p {
        font-size: 16px;
      }
    }
  }
}

@media (max-width: 768px) {
  .login-right {
    display: none;
  }
  
  .login-left {
    flex: 0 0 100%;
  }
}

.login-container {
  width: 100%;
  max-width: 420px;
  background: transparent;
  position: relative;
  z-index: 1;
}

.login-header {
  text-align: center;
  margin-bottom: 40px;
  
  .logo-icon {
    margin-bottom: 20px;
    
    .el-icon {
      font-size: 48px;
      color: #667eea;
      background: linear-gradient(135deg, #667eea, #764ba2);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  }
  
  h1 {
    font-size: 28px;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 12px;
    line-height: 1.2;
  }
  
  p {
    font-size: 16px;
    color: #666;
    font-weight: 400;
    opacity: 0.8;
  }
}

.login-form {
  .login-type-selector {
    margin-bottom: 35px;
    text-align: center;
    
    :deep(.el-radio-group) {
      background: rgba(102, 126, 234, 0.1);
      border-radius: 16px;
      padding: 4px;
      display: inline-flex;
      
      .el-radio-button {
        margin: 0;
        
        .el-radio-button__inner {
          padding: 12px 24px;
          font-size: 14px;
          font-weight: 600;
          border: none;
          border-radius: 12px;
          background: transparent;
          color: #666;
          transition: all 0.3s ease;
          min-width: 120px;
          
          &:hover {
            color: #667eea;
            background: rgba(255, 255, 255, 0.5);
          }
        }
        
        .el-radio-button__orig-radio:checked + .el-radio-button__inner {
          background: linear-gradient(135deg, #667eea, #764ba2);
          color: #fff;
          box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
          transform: translateY(-1px);
        }
      }
    }
  }
  
  h2 {
    text-align: center;
    font-size: 22px;
    font-weight: 600;
    color: #333;
    margin-bottom: 35px;
    position: relative;
    
    &::after {
      content: '';
      position: absolute;
      bottom: -8px;
      left: 50%;
      transform: translateX(-50%);
      width: 40px;
      height: 3px;
      background: linear-gradient(90deg, #667eea, #764ba2);
      border-radius: 2px;
    }
  }
  
  :deep(.el-form-item) {
    margin-bottom: 28px;
    
    .el-form-item__error {
      font-size: 12px;
      margin-top: 6px;
    }
  }
  
  :deep(.el-input) {
    .el-input__wrapper {
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      border: 2px solid transparent;
      transition: all 0.3s ease;
      background: rgba(255, 255, 255, 0.8);
      
      &:hover {
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
        border-color: rgba(102, 126, 234, 0.3);
      }
      
      &.is-focus {
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        border-color: #667eea;
      }
    }
    
    .el-input__inner {
      font-size: 15px;
      padding: 0 16px;
      height: 48px;
      
      &::placeholder {
        color: #999;
        font-weight: 400;
      }
    }
    
    .el-input__prefix {
      left: 16px;
      
      .el-icon {
        font-size: 18px;
        color: #667eea;
      }
    }
  }
  
  .login-options {
    margin-bottom: 20px !important;
    
    .options-container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
    }
  }
  
  :deep(.el-checkbox) {
    .el-checkbox__label {
      color: #666;
      font-size: 14px;
      margin-left: 8px;
    }
    
    .el-checkbox__input.is-checked .el-checkbox__inner {
      background: linear-gradient(135deg, #667eea, #764ba2);
      border-color: #667eea;
    }
  }
  
  .forgot-password {
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    
    &:hover {
      text-decoration: underline;
    }
  }
  
  :deep(.el-link) {
    color: #667eea;
    font-weight: 500;
    
    &:hover {
      color: #764ba2;
    }
  }
  
  :deep(.el-button) {
    border-radius: 16px;
    font-weight: 600;
    font-size: 16px;
    height: 52px;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    
    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.5s;
    }
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
      
      &::before {
        left: 100%;
      }
    }
    
    &:active {
      transform: translateY(0);
    }
  }
  
  .register-link {
    text-align: center;
    margin-top: 25px;
    font-size: 14px;
    color: #666;
    
    .link-container {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
    }
    
    .register-link-text {
      font-weight: 500;
      text-decoration: none;
      
      &:hover {
        text-decoration: underline;
      }
    }
  }
}

@media (max-width: 480px) {
  .login-page {
    padding: 10px;
  }
  
  .login-container {
    padding: 40px 25px;
    border-radius: 20px;
  }
  
  .login-header {
    margin-bottom: 30px;
    
    .logo-icon .el-icon {
      font-size: 40px;
    }
    
    h1 {
      font-size: 24px;
    }
    
    p {
      font-size: 14px;
    }
  }
  
  .login-form {
    .login-type-selector {
      margin-bottom: 25px;
      
      :deep(.el-radio-group) {
        .el-radio-button .el-radio-button__inner {
          padding: 10px 16px;
          font-size: 13px;
          min-width: 100px;
        }
      }
    }
    
    h2 {
      font-size: 20px;
      margin-bottom: 25px;
    }
    
    :deep(.el-input) {
      .el-input__wrapper {
        border-radius: 12px;
      }
      
      .el-input__inner {
        height: 44px;
        font-size: 14px;
      }
    }
    
    :deep(.el-button) {
      height: 48px;
      font-size: 15px;
      border-radius: 12px;
    }
  }
}
</style>