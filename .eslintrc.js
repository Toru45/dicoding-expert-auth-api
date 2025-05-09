module.exports = {
  env: {
    node: true,
    commonjs: true,
    es2021: true,
    jest: true, // For testing environments
  },
  extends: ["eslint:recommended", "airbnb-base"],
  parserOptions: {
    ecmaVersion: 2021,
  },
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? "error" : "warn",
    "no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
    quotes: ["error", "single", { avoidEscape: true }],
    "comma-dangle": ["error", "always-multiline"],
    "max-len": ["error", { code: 100 }],
    camelcase: "error",
    "no-use-before-define": ["error", { functions: false }],
    "no-underscore-dangle": "off",
    "import/no-extraneous-dependencies": [
      "error",
      { devDependencies: ["**/*.test.js", "**/*.spec.js"] },
    ],
  },
};
