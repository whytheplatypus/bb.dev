
# psword for certs: changeit
build:
	cd beneficiary-fhir-data/apps; mvn clean install -DskipITs

verify:
	cd beneficiary-fhir-data/apps; mvn clean verify

run: build
	cd beneficiary-fhir-data/apps/bfd-server; mvn --projects bfd-server-war package dependency:copy antrun:run org.codehaus.mojo:exec-maven-plugin:exec@server-start

docker: build
	cd beneficiary-fhir-data/apps/bfd-server; mvn -Dits.db.url="jdbc:postgresql://bfddb:5432/bfd?user=bfd&password=InsecureLocalDev" --projects bfd-server-war package dependency:copy antrun:run org.codehaus.mojo:exec-maven-plugin:exec@server-start
	tail -f /code/beneficiary-fhir-data/apps/bfd-server/bfd-server-war/target/server-work/server-console.log

stop:
	cd beneficiary-fhir-data/apps/bfd-server; mvn --projects bfd-server-war package dependency:copy antrun:run org.codehaus.mojo:exec-maven-plugin:exec@server-stop

fix: build
	cd beneficiary-fhir-data/apps/bfd-pipeline/bfd-pipeline-rif-extract; mvn exec:java -Dexec.mainClass="gov.cms.bfd.pipeline.rif.extract.synthetic.SyntheticDataFixer4" -Dexec.classpathScope=test

load: build
	cd beneficiary-fhir-data/apps/bfd-pipeline/bfd-pipeline-rif-load; mvn -Dits.db.url=jdbc:postgresql://bfddb:5432/bfd -Dits.db.username=bfd -Dits.db.password=InsecureLocalDev -Dit.test=RifLoaderIT#loadLocalSyntheticData clean verify
