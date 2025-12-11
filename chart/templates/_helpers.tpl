{{- define "my-chart.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "my-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "my-chart.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "my-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end }}