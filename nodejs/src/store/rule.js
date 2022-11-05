import VuetifyJetValidator from 'vuetify-jet-validator'
export default  {
  data ()  {
    const that = this
    const validator = new VuetifyJetValidator();
    return {
      rule: {
        validator,
        email: [
          validator.rules.required("이메일을 입력하세요."),
          validator.rules.email("이메일을 정확하게 입력하세요."),
        ],
        required: [
          validator.rules.required('빈칸을 채워주세요')
        ],
        select: [
          validator.rules.required('반드시 선택해야합니다.')
        ],
        password: [
          validator.rules.required("비밀번호를 입력하세요."),
          validator.rules.minLength(8, "비밀번호는 최소 8글자 입니다."),
          validator.rules.maxLength(16, "비밀번호는 최대 16글자 입니다.")
        ],
        confirmPassword: [
          validator.rules.matches(that, "data.password", "비밀번호가 다릅니다.")
        ],

      }
    }
  },
  methods: {
    ruleRequired (message) {
      return this.rule.validator.rules.required(message)
    },
    ruleEmail (message) {
      return this.rule.validator.rules.email(message)
    },
    ruleSelect (message) {
      return this.rule.validator.rules.required(message)
    },
    ruleMin (message, value) {
      return this.rule.validator.rules.minLength(value, message.replace('{0}', value))
    },
    ruleMax (message, value) {
      return this.rule.validator.rules.maxLength(value, message.replace('{0}', value))
    },
  }

}