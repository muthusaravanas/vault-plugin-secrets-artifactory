package artifactory

import (
	"testing"
)

func TestAcceptanceBackend_PathTokenCreate(t *testing.T) {
	if !runAcceptanceTests {
		t.SkipNow()
	}

	accTestEnv, err := newAcceptanceTestEnv()
	if err != nil {
		t.Fatal(err)
	}

	t.Run("configure backend", accTestEnv.UpdatePathConfig)
	t.Run("create role", accTestEnv.CreatePathRole)
	t.Run("create admin role", accTestEnv.CreatePathAdminRole)
	t.Run("create token for role", accTestEnv.CreatePathToken)
	t.Run("create scoped down token for admin role", accTestEnv.CreatePathScopedDownToken)
	t.Run("delete role", accTestEnv.DeletePathRole)
	t.Run("cleanup backend", accTestEnv.DeletePathConfig)
}
