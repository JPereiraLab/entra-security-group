entra-security-group/
├── .github/
│   └── workflows/
│       ├── create-group-manual-oidc.yml      ← Original (manual REST)
│       └── create-group-azure-login.yml      ← New (azure/login@v2)
├── README.md                                  ← Explains both
└── docs/
    ├── manual-oidc-explained.md              ← Deep dive on manual approach
    └── azure-login-explained.md              ← Deep dive on action approach
