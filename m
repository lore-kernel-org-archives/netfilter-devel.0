From: Iain Barnes <zenadsl3030@zen.co.uk>
Subject: Re: [PATCH] DSCP match/target patches
Date: 17 Jun 2002 18:50:32 +0100
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1024336232.1301.3.camel@desktop>
References: <20020610135311.246C1453D@lists.samba.org>
	  <20020611094130.E11177@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XQKXhCpO7cHrE8FNjUdM"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020611094130.E11177@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-XQKXhCpO7cHrE8FNjUdM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Harald

Ok, here is the first cut of a set of patches.

The only thing missing is the Makefile modifications. My knowledge of
the fine art of Makefile writing is sorely lacking, so any help on that
front, from anybody, would be greatly appreciated.

The helper functions have been placed in a libipt_dscp_helper.c file in
the extensions directory.

Both the DSCP match and target have been modified to use the new
functions.


Iain 





On Tue, 2002-06-11 at 08:41, Harald Welte wrote:
> On Mon, Jun 10, 2002 at 01:49:13PM +0000, zenadsl3030@zen.co.uk wrote:
> > Hi,
> > 
> > Here is a simple patch to the DSCP match to allow the use of DiffServ class
> > names in the matches, in a similar manner to the target.
> > 
> > Also attached is a one line fix for a typo in the DSCP target where CS6 was
> > defined twice in the match list.
> 
> thanks for your contribution.  What about putting all the class name <->
> numerical resolving in a seperate .c file, which is then compiled once and
> linked into both libipt_dscp.so and libipt_DSCP.so ?
> 
> I think this would be the ideal case, without any code duplication.
> 
> > Iain
> 
> -- 
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> ============================================================================
> GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
> V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
-- 
Iain Barnes <zenadsl3030@zen.co.uk>

--=-XQKXhCpO7cHrE8FNjUdM
Content-Disposition: attachment; filename=dscp-helper.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=dscp-helper.diff; charset=ISO-8859-15

diff -urN userspace-cvs/extensions/libipt_DSCP.c userspace/extensions/libip=
t_DSCP.c
--- userspace-cvs/extensions/libipt_DSCP.c	Mon Jun 17 18:29:08 2002
+++ userspace/extensions/libipt_DSCP.c	Mon Jun 17 18:41:00 2002
@@ -18,39 +18,8 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_DSCP.h>
=20
+extern unsigned int class_to_dscp(const char *name);
=20
-/* see http://www.iana.org/assignments/dscp-registry */
-
-static struct ds_class=20
-{
-	char *class;
-	unsigned int dscp;
-} ds_classes[] =3D=20
-{
-	{ "CS0",   0 },
-	{ "CS1",  0x08 },
-	{ "CS2",  0x10 },
-	{ "CS3",  0x18 },
-	{ "CS3",  0x18 },
-	{ "CS4",  0x20 },
-	{ "CS5",  0x28 },
-	{ "CS6",  0x30 },
-	{ "CS6",  0x38 },
-	{ "BE",    0 },
-	{ "AF11", 0x0a },
-	{ "AF12", 0x0c },
-	{ "AF13", 0x0e },
-	{ "AF21", 0x12 },
-	{ "AF22", 0x14 },
-	{ "AF23", 0x16 },
-	{ "AF31", 0x1a },
-	{ "AF32", 0x1c },
-	{ "AF33", 0x1e },
-	{ "AF41", 0x22 },
-	{ "AF42", 0x24 },
-	{ "AF43", 0x26 },
-	{ "EF",   0x2e }
-};
=20
 static void init(struct ipt_entry_target *t, unsigned int *nfcache)=20
 {
@@ -99,17 +68,10 @@
 static void
 parse_class(const unsigned char *s, struct ipt_DSCP_info *dinfo)
 {
-	int i;
-
-	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
-		if (!strncasecmp(s, ds_classes[i].class,=20
-				strlen(ds_classes[i].class))) {
-			dinfo->dscp =3D (u_int8_t)ds_classes[i].dscp;
-			return;
-		}
-	}
+	unsigned int dscp =3D class_to_dscp(s);
=20
-	exit_error(PARAMETER_PROBLEM, "Invalid DSCP class value '%s'", s);
+	/* Assign the value */
+	dinfo->dscp =3D (u_int8_t)dscp;
 }
=20
=20
diff -urN userspace-cvs/extensions/libipt_dscp.c userspace/extensions/libip=
t_dscp.c
--- userspace-cvs/extensions/libipt_dscp.c	Mon Jun 17 18:29:08 2002
+++ userspace/extensions/libipt_dscp.c	Mon Jun 17 18:42:11 2002
@@ -6,6 +6,8 @@
  *
  * libipt_dscp.c borrowed heavily from libipt_tos.c
  *
+ * --class support added by Iain Barnes
+ *=20
  * For a list of DSCP codepoints see=20
  * http://www.iana.org/assignments/dscp-registry
  *
@@ -19,6 +21,9 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_dscp.h>
=20
+
+extern unsigned int class_to_dscp(const char *name);
+
 static void init(struct ipt_entry_match *m, unsigned int *nfcache)=20
 {
 	*nfcache |=3D NFC_IP_TOS;
@@ -30,12 +35,18 @@
 "DSCP match v%s options\n"
 "[!] --dscp value		Match DSCP codepoint with numerical value\n"
 "  		                This value can be in decimal (ex: 32)\n"
-"               		or in hex (ex: 0x20)\n", IPTABLES_VERSION
+"               		or in hex (ex: 0x20)\n"
+"[!] --class name		Match the DiffServ class. This value may\n"
+"				be any of the BE,EF, AFxx or CSx classes\n"
+"\n"
+"				These two options are mutually exclusive !\n"
+				, IPTABLES_VERSION
 );
 }
=20
 static struct option opts[] =3D {
 	{ "dscp", 1, 0, 'F' },
+	{ "class", 1, 0, 'G' },
 	{ 0 }
 };
=20
@@ -56,6 +67,17 @@
     	return;
 }
=20
+
+static void
+parse_class(const char *s, struct ipt_dscp_info *dinfo)
+{
+	unsigned int dscp =3D class_to_dscp(s);
+
+	/* Assign the value */
+	dinfo->dscp =3D (u_int8_t)dscp;
+}
+
+
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
@@ -72,6 +94,17 @@
 			           "DSCP match: Only use --dscp ONCE!");
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_dscp(argv[optind-1], dinfo);
+		if (invert)
+			dinfo->invert =3D 1;
+		*flags =3D 1;
+		break;
+
+	case 'G':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+					"DSCP match: Only use --class ONCE!");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_class(argv[optind - 1], dinfo);
 		if (invert)
 			dinfo->invert =3D 1;
 		*flags =3D 1;
diff -urN userspace-cvs/extensions/libipt_dscp_helper.c userspace/extension=
s/libipt_dscp_helper.c
--- userspace-cvs/extensions/libipt_dscp_helper.c	Thu Jan  1 01:00:00 1970
+++ userspace/extensions/libipt_dscp_helper.c	Mon Jun 17 18:44:51 2002
@@ -0,0 +1,82 @@
+/*
+ * DiffServ classname <-> DiffServ codepoint mapping functions.
+ *
+ * The latest list of the mappings can be found at:
+ * <http://www.iana.org/assignments/dscp-registry>
+ *
+ * This code is released under the GNU GPL v2, 1991
+ *=20
+ * Author: Iain Barnes
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <iptables_common.h>
+
+
+
+static struct ds_class
+{
+	const char *name;
+	unsigned int dscp;
+} ds_classes[] =3D=20
+{
+	{ "CS0", 0x00 },
+	{ "CS1", 0x08 },
+	{ "CS2", 0x10 },
+	{ "CS3", 0x18 },
+	{ "CS4", 0x20 },
+	{ "CS5", 0x28 },
+	{ "CS6", 0x30 },
+	{ "CS7", 0x38 },
+	{ "BE", 0x00 },
+	{ "AF11", 0x0a },
+	{ "AF12", 0x0c },
+	{ "AF13", 0x0e },
+	{ "AF21", 0x12 },
+	{ "AF22", 0x14 },
+	{ "AF23", 0x16 },
+	{ "AF31", 0x1a },
+	{ "AF32", 0x1c },
+	{ "AF33", 0x1e },
+	{ "AF41", 0x22 },
+	{ "AF42", 0x24 },
+	{ "AF43", 0x26 },
+	{ "EF", 0x2e }
+};
+
+
+
+unsigned int=20
+class_to_dscp(const char *name)
+{
+	int i;
+
+	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+		if (!strncasecmp(name, ds_classes[i].name,
+					strlen(ds_classes[i].name)))=20
+			return ds_classes[i].dscp;
+	}
+
+	exit_error(PARAMETER_PROBLEM,=20
+			"Invalid DSCP value `%d'\n", dscp);
+}
+
+
+
+const char *
+dscp_to_name(unsigned int dscp)
+{
+	int i;
+
+	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+		if (dscp =3D=3D ds_classes[i].dscp)
+			return ds_classes[i].name;
+	}
+
+=09
+	exit_error(PARAMETER_PROBLEM,
+			"Invalid DiffServ class name `%s'\n", name);
+}
+
+

--=-XQKXhCpO7cHrE8FNjUdM--
