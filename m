From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Sat,  1 Sep 2012 13:51:51 +0100
Message-ID: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Eric Leblond <eric@regit.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50503 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2IAMwT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Sep 2012 08:52:19 -0400
Received: by wgbdr13 with SMTP id dr13so3272956wgb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Sep 2012 05:52:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a NULL pointer reference bug which existed in the
PGSQL output plugin, as well as enables SSL connections to be made
to PostgreSQL server by the ulog daemon. Parameters introduced are:

'sslmode' - one of:

    disable - only try a non-SSL connection
      allow - first try a non-SSL connection; if that fails, try SSL
	      connection
     prefer - (default) first try an SSL connection; if that fails, try=
 a
              non-SSL connection
    require - only try an SSL connection
 requiressl - equivalent to 'require', but for older PostgreSQL server
	      versions
  verify-ca - only try an SSL connection, and verify that the server
	      certificate is issued by a trusted CA
verify-full - only try an SSL connection, verify that the server certif=
icate
	      is issued by a trusted CA and that the server host name matches
	      that in the certificate

In addition to the above parameter, 4 other connection options can be
specified:

'sslcert' - This parameter specifies the file name of the client SSL
	    certificate. This parameter is ignored if an SSL connection
	    is not made.
 'sslkey' - This parameter specifies the location for the secret key us=
ed
	    for the client certificate. It can either specify a file name that
	    will be used or it can specify a key obtained from an external
	    =E2=80=9Cengine=E2=80=9D (engines are OpenSSL loadable modules). A=
n external
	    engine specification should consist of a colon-separated engine
	    name and an engine-specific key identifier. This parameter is
	    ignored if SSL connection is not made. If this key is protected
	    with a password, this will be asked when the connection is made.
	    It is asked every time an attempt for a connection is made.
'sslroot' - This parameter specifies the name of a file containing SSL
	    certificate authority (CA) certificate(s). If the file exists,
	    the server's certificate will be verified to be signed by one of
	    these authorities.
 'sslcrl' - This parameter specifies the file name of the SSL certifica=
te
	    revocation list (CRL). Certificates listed in this file, if it
	    exists, will be rejected while attempting to authenticate the
	    server's certificate.

Example of use:

ulogd.conf
~~~~~~~~~~
[pgsql3]
db=3D"ulogdb"
host=3D"10.1.1.17"
port=3D5432
user=3D"ulogd"
pass=3D"changeme"
table=3D"nfacct"
procedure=3D"INSERT_NFACCT"
sslmode=3D"verify-full"
sslcert=3D"/etc/pki/tls/private/postgresql.crt"
sslkey=3D"/etc/pki/tls/private/postgresql.key"
sslroot=3D"/etc/pki/tls/private/root.crt"
sslcrl=3D"/etc/pki/tls/private/root.crl"

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
 output/pgsql/ulogd_output_PGSQL.c |   99 +++++++++++++++++++++++++++++=
+++-----
 ulogd.conf.in                     |   26 ++++++++++
 2 files changed, 113 insertions(+), 12 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_out=
put_PGSQL.c
index cd793ca..c99a0d7 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -38,7 +38,7 @@ struct pgsql_instance {
=20
 /* our configuration directives */
 static struct config_keyset pgsql_kset =3D {
-	.num_ces =3D DB_CE_NUM + 6,
+	.num_ces =3D DB_CE_NUM + 11,
 	.ces =3D {
 		DB_CES,
 		{=20
@@ -70,8 +70,32 @@ static struct config_keyset pgsql_kset =3D {
 			.key =3D "schema",=20
 			.type =3D CONFIG_TYPE_STRING,
 			.options =3D CONFIG_OPT_NONE,
-			.u.string =3D "public",
 		},
+		{  // sslmode=3Ddisable|allow|prefer|require|requiressl|verify-ca|ve=
rify-full
+			.key =3D "sslmode",=20
+			.type =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+		{
+			.key =3D "sslcert",=20
+			.type =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+		{
+			.key =3D "sslkey",=20
+			.type =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+		{
+			.key =3D "sslroot",=20
+			.type =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
+		{
+			.key =3D "sslcrl",=20
+			.type =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+ 		},
 	},
 };
 #define db_ce(x)	(x->ces[DB_CE_NUM+0])
@@ -80,6 +104,11 @@ static struct config_keyset pgsql_kset =3D {
 #define pass_ce(x)	(x->ces[DB_CE_NUM+3])
 #define port_ce(x)	(x->ces[DB_CE_NUM+4])
 #define schema_ce(x)	(x->ces[DB_CE_NUM+5])
+#define sslmode_ce(x)	(x->ces[DB_CE_NUM+6])
+#define sslcert_ce(x)	(x->ces[DB_CE_NUM+7])
+#define sslkey_ce(x)	(x->ces[DB_CE_NUM+8])
+#define sslroot_ce(x)	(x->ces[DB_CE_NUM+9])
+#define sslcrl_ce(x)	(x->ces[DB_CE_NUM+10])
=20
 #define PGSQL_HAVE_NAMESPACE_TEMPLATE 			\
 	"SELECT nspname FROM pg_namespace n WHERE n.nspname=3D'%s'"
@@ -127,9 +156,12 @@ static int pgsql_namespace(struct ulogd_pluginstan=
ce *upi)
 static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi =3D (struct pgsql_instance *) upi->private;
+	char *table =3D table_ce(upi->config_kset).u.string;
+	char *schema =3D schema_ce(upi->config_kset).u.string;
+	int schema_len =3D strlen(schema);
 	char pgbuf[strlen(PGSQL_GETCOLUMN_TEMPLATE_SCHEMA)
-		   + strlen(table_ce(upi->config_kset).u.string)=20
-		   + strlen(pi->db_inst.schema) + 2];
+		   + strlen(table)=20
+		   + schema_len + 2];
 	int i;
=20
 	if (!pi->dbh) {
@@ -137,14 +169,14 @@ static int get_columns_pgsql(struct ulogd_plugins=
tance *upi)
 		return 1;
 	}
=20
-	if (pi->db_inst.schema) {
+	if (schema_len > 0) {
 		snprintf(pgbuf, sizeof(pgbuf)-1,
 			 PGSQL_GETCOLUMN_TEMPLATE_SCHEMA,
-			 table_ce(upi->config_kset).u.string,
-			 pi->db_inst.schema);
+			 schema,
+			 table);
 	} else {
 		snprintf(pgbuf, sizeof(pgbuf)-1, PGSQL_GETCOLUMN_TEMPLATE,
-			 table_ce(upi->config_kset).u.string);
+			 table);
 	}
=20
 	ulogd_log(ULOGD_DEBUG, "%s\n", pgbuf);
@@ -217,23 +249,39 @@ static int open_db_pgsql(struct ulogd_pluginstanc=
e *upi)
 {
 	struct pgsql_instance *pi =3D (struct pgsql_instance *) upi->private;
 	int len;
+	int status;
 	char *connstr;
 	char *server =3D host_ce(upi->config_kset).u.string;
 	unsigned int port =3D port_ce(upi->config_kset).u.value;
 	char *user =3D user_ce(upi->config_kset).u.string;
 	char *pass =3D pass_ce(upi->config_kset).u.string;
 	char *db =3D db_ce(upi->config_kset).u.string;
+	char *sslmode =3D sslmode_ce(upi->config_kset).u.string;=09
+	char *sslcert =3D sslcert_ce(upi->config_kset).u.string;=09
+	char *sslkey =3D sslkey_ce(upi->config_kset).u.string;=09
+	char *sslroot =3D sslroot_ce(upi->config_kset).u.string;=09
+	char *sslcrl =3D sslcrl_ce(upi->config_kset).u.string;=09
=20
 	/* 80 is more than what we need for the fixed parts below */
 	len =3D 80 + strlen(user) + strlen(db);
=20
-	/* hostname and  and password are the only optionals */
+	/* hostname and password are not the only optional parameters */
 	if (server)
 		len +=3D strlen(server);
 	if (pass)
 		len +=3D strlen(pass);
 	if (port)
 		len +=3D 20;
+	if (sslmode)
+		len +=3D strlen(sslmode);
+	if (sslcert)
+		len +=3D strlen(sslcert);
+	if (sslkey)
+		len +=3D strlen(sslkey);
+	if (sslroot)
+		len +=3D strlen(sslroot);
+	if (sslcrl)
+		len +=3D strlen(sslcrl);
=20
 	connstr =3D (char *) malloc(len);
 	if (!connstr)=20
@@ -261,10 +309,37 @@ static int open_db_pgsql(struct ulogd_pluginstanc=
e *upi)
 		strcat(connstr, pass);
 	}
 =09
+	if (sslmode && strlen(sslmode) > 0) {
+		if (strncmp(sslmode, "requiressl", 10) =3D=3D 0) {
+			strcat(connstr, " requiressl=3D1");
+		} else {
+			strcat(connstr, " sslmode=3D");
+			strcat(connstr, sslmode);
+		}
+
+		if (sslcert && strlen(sslcert) > 0) {
+			strcat(connstr, " sslcert=3D");
+			strcat(connstr, sslcert);
+		}
+		if (sslkey && strlen(sslkey)) {
+			strcat(connstr, " sslkey=3D");
+			strcat(connstr, sslkey);
+		}
+		if (sslroot && strlen(sslroot)) {
+			strcat(connstr, " sslrootcert=3D");
+			strcat(connstr, sslroot);
+		}
+		if (sslcrl && strlen(sslcrl)) {
+			strcat(connstr, " sslcrl=3D");
+			strcat(connstr, sslcrl);
+		}
+ 	}
+
 	pi->dbh =3D PQconnectdb(connstr);
-	if (PQstatus(pi->dbh) !=3D CONNECTION_OK) {
-		ulogd_log(ULOGD_ERROR, "unable to connect to db (%s): %s\n",
-			  connstr, PQerrorMessage(pi->dbh));
+	status =3D PQstatus(pi->dbh);
+	if (status !=3D CONNECTION_OK) {
+		ulogd_log(ULOGD_ERROR, "unable to connect to db (%s): %s; status=3D%=
u\n",
+			  connstr, PQerrorMessage(pi->dbh),status);
 		close_db_pgsql(upi);
 		return -1;
 	}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 3bd464b..81dabdc 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -240,6 +240,32 @@ table=3D"nfacct"
 pass=3D"changeme"
 procedure=3D"INSERT_NFACCT"
=20
+[pgsql5]
+db=3D"nulog"
+host=3D"localhost"
+user=3D"nupik"
+table=3D"ulog2_ct"
+pass=3D"changeme"
+procedure=3D"INSERT_OR_REPLACE_CT"
+sslmode=3D"prefer"
+sslcert=3D"/etc/pki/tls/private/ct.crt"
+sslkey=3D"/etc/pki/tls/private/ct.key"
+sslroot=3D"/etc/pki/tls/private/root.crt"
+sslcrl=3D"/etc/pki/tls/private/root.crl"
+
+[pgsql6]
+db=3D"nulog"
+host=3D"localhost"
+user=3D"nupik"
+table=3D"nfacct"
+pass=3D"changeme"
+procedure=3D"INSERT_NFACCT"
+sslmode=3D"verify-full"
+sslcert=3D"/etc/pki/tls/private/nfacct.crt"
+sslkey=3D"/etc/pki/tls/private/nfacct.key"
+sslroot=3D"/etc/pki/tls/private/root.crt"
+sslcrl=3D"/etc/pki/tls/private/root.crl"
+
 [dbi1]
 db=3D"ulog2"
 dbtype=3D"pgsql"
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
