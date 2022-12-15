// Code generated by codegen2; DO NOT EDIT.
package {{.PackageName}}

import (
	"encoding/json"
	"net/http"

	{{- if not .ChildTable}}
	"testing"
	"github.com/cloudquery/cloudquery/plugins/source/azure/client"
	{{- end}}

	"github.com/cloudquery/plugin-sdk/faker"
	"github.com/gorilla/mux"
	"{{.ImportPath}}"
)

func create{{.Name | ToCamel}}(router *mux.Router) (error) {  
  var item {{.Service}}.{{.ResponseStructName}}
	if err := faker.FakeObject(&item); err != nil {
		return err
	}
	{{if .ResponspeStructNextLink}}
	emptyStr := ""
	item.NextLink = &emptyStr
	{{end}}
	router.HandleFunc("{{.URL}}", func(w http.ResponseWriter, r *http.Request) {
		b, err := json.Marshal(&item)
		if err != nil {
			http.Error(w, "unable to marshal request: "+err.Error(), http.StatusBadRequest)
			return
		}
		if _, err := w.Write(b); err != nil {
			http.Error(w, "failed to write", http.StatusBadRequest)
			return
		}
	})

	{{- range .Relations}}
		create{{.Name | ToCamel}}(router)
	{{- end}}
	return nil
}

{{if not .ChildTable}}
func Test{{.Name | ToCamel}}(t *testing.T) {
	client.MockTestHelper(t, {{.Name | ToCamel}}(), create{{.Name | ToCamel}})
}
{{end}}