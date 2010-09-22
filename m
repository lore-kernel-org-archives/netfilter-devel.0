From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/6] build: nfct and nflog can be disabled via configure option
Date: Wed, 22 Sep 2010 02:47:17 +0200
Message-ID: <1285116442-32490-2-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34300 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0IVArb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:47:31 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the build system to be able to disable the compilat=
ion
of NFCT and NFLOG input plugin. They are dependant of external librarie=
s
which can not be available on the system.
Default is to compile these input plugin which make compilation behavio=
ur
conservative.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.ac              |   19 ++++++++++++++++---
 input/flow/Makefile.am    |    2 ++
 input/packet/Makefile.am  |    5 +++++
 output/ulogd_output_XML.c |   12 ++++++++++--
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index e5a64fe..af14f36 100644
--- a/configure.ac
+++ b/configure.ac
@@ -38,11 +38,21 @@ LIBNFNETLINK_REQUIRED=3D0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=3D0.0.95
 LIBNETFILTER_LOG_REQUIRED=3D1.0.0
=20
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >=3D $LIBNFNETLINK_REQUIR=
ED,, AC_MSG_ERROR(Cannot find libnfnetlink >=3D $LIBNFNETLINK_REQUIRED)=
)
+AC_ARG_ENABLE(nfct,   [AC_HELP_STRING(--disable-nfct, Do not build NFC=
T input plugin)],build_nfct=3D$enableval, build_nfct=3D"yes")
+AC_ARG_ENABLE(nflog,   [AC_HELP_STRING(--disable-nflog, Do not build N=
=46LOG input plugin)],build_nflog=3D$enableval, build_nflog=3D"yes")
+if test "${build_nfct}" =3D "yes" ||=C2=A0test "${build_nflog}" =3D "y=
es" ; then
+	PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >=3D $LIBNFNETLINK_REQUI=
RED,, AC_MSG_ERROR(Cannot find libnfnetlink >=3D $LIBNFNETLINK_REQUIRED=
))
+fi
=20
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >=3D =
$LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilte=
r_conntrack >=3D $LIBNETFILTER_CONNTRACK_REQUIRED))
+if test "${build_nfct}" =3D "yes"; then
+	PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >=3D=
 $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilt=
er_conntrack >=3D $LIBNETFILTER_CONNTRACK_REQUIRED))
+	AC_DEFINE_UNQUOTED([HAVE_LIBNETFILTER_CONNTRACK],[1],[libnetfilter_co=
nntrack is available])
+fi
=20
-PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >=3D $LIBNETFILTE=
R_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >=3D $LIBNET=
=46ILTER_LOG_REQUIRED))
+if test "${build_nflog}" =3D "yes"; then
+	PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >=3D $LIBNETFILT=
ER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >=3D $LIBNE=
TFILTER_LOG_REQUIRED))
+	AC_DEFINE_UNQUOTED([HAVE_LIBNETFILTER_LOG],[1],[libnetfilter_log is a=
vailable])
+fi
=20
=20
 CT_CHECK_POSTGRES_DB()
@@ -60,6 +70,9 @@ AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" !=3D "x")
 CT_CHECK_PCAP()
 AM_CONDITIONAL(HAVE_PCAP, test "x$PCAP_LIB" !=3D "x")
=20
+AM_CONDITIONAL(HAVE_NFCT, test "x$build_nfct" !=3D "xno")
+AM_CONDITIONAL(HAVE_NFLOG, test "x$build_nflog" !=3D "xno")
+
=20
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 11bf217..5d7bdc4 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,11 +2,13 @@
 AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=3D-fPIC -Wall
=20
+if HAVE_NFCT
 pkglib_LTLIBRARIES =3D ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
=20
 ulogd_inpflow_NFCT_la_SOURCES =3D ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTE=
R_CONNTRACK_LIBS)
 ulogd_inpflow_NFCT_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK=
_CFLAGS)
+endif
=20
 #ulogd_inpflow_IPFIX_la_SOURCES =3D ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS =3D -avoid-version -module
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index e90e46e..44b7442 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -3,12 +3,17 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/inclu=
de
 AM_CFLAGS=3D-fPIC -Wall
 LIBS=3D
=20
+if HAVE_NFLOG
 pkglib_LTLIBRARIES =3D ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
=20
 ulogd_inppkt_NFLOG_la_SOURCES =3D ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTE=
R_LOG_LIBS)
 ulogd_inppkt_NFLOG_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAG=
S)
=20
+else
+pkglib_LTLIBRARIES =3D ulogd_inppkt_ULOG.la
+endif
+
 ulogd_inppkt_ULOG_la_SOURCES =3D ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS =3D -avoid-version -module
 ulogd_inppkt_ULOG_la_LIBADD =3D ../../libipulog/libipulog.la
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 1ec9d8c..55ccd5a 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -18,8 +18,11 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
  */
=20
+#include <config.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#ifdef HAVE_LIBNETFILTER_LOG
 #include <libnetfilter_log/libnetfilter_log.h>
+#endif
 #include <ulogd/ulogd.h>
 #include <sys/param.h>
 #include <time.h>
@@ -95,6 +98,7 @@ xml_output_flow(struct ulogd_key *inp, char *buf, ssi=
ze_t size)
 	return 0;
 }
=20
+#ifdef HAVE_LIBNETFILTER_LOG
 static int
 xml_output_packet(struct ulogd_key *inp, char *buf, ssize_t size)
 {
@@ -107,6 +111,7 @@ xml_output_packet(struct ulogd_key *inp, char *buf,=
 ssize_t size)
=20
 	return 0;
 }
+#endif
=20
 static int xml_output(struct ulogd_pluginstance *upi)
 {
@@ -117,8 +122,11 @@ static int xml_output(struct ulogd_pluginstance *u=
pi)
=20
 	if (pp_is_valid(inp, KEY_CT))
 		ret =3D xml_output_flow(inp, buf, sizeof(buf));
-	else if (pp_is_valid(inp, KEY_PCKT))
-		ret =3D xml_output_packet(inp, buf, sizeof(buf));
+	else
+#ifdef HAVE_LIBNETFILTER_LOG
+		if (pp_is_valid(inp, KEY_PCKT))
+			ret =3D xml_output_packet(inp, buf, sizeof(buf));
+#endif
=20
 	if (ret < 0)
 		return ULOGD_IRET_ERR;
--=20
1.6.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
