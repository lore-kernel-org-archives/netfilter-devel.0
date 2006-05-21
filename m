From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH 2/2] Accept named realm
Date: Sun, 21 May 2006 18:13:21 +0200
Message-ID: <200605211813.21301.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hGJcExJLUgxf42B"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_hGJcExJLUgxf42B
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Make the realm match accept named realms, defined in /etc/iproute2/rt_realms.

--Boundary-00=_hGJcExJLUgxf42B
Content-Type: text/x-diff;
  charset="us-ascii";
  name="realm_named.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="realm_named.diff"

diff -ruN iptables-1.3.5.mod1/extensions/libipt_realm.c iptables-1.3.5.mod2/extensions/libipt_realm.c
--- iptables-1.3.5.mod1/extensions/libipt_realm.c	2006-05-21 17:50:24.000000000 +0200
+++ iptables-1.3.5.mod2/extensions/libipt_realm.c	2006-05-21 17:51:19.000000000 +0200
@@ -3,6 +3,7 @@
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
+#include <errno.h>
 #include <getopt.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
@@ -28,6 +29,46 @@
 	{0}
 };
 
+/* Lookup realm in /etc/iproute2/rt_realms. Return: True and realm id in *rid
+ * if found, false and *rid not touched if not found.
+ */
+static int
+find_named_realm(const char* rnm, u_int32_t* rid)
+{
+	const char* rfnm = "/etc/iproute2/rt_realms";
+	char buf[512];
+	FILE *fil;
+	char *cur, *nxt;
+	unsigned long int id;
+	int	len = strlen(rnm);
+
+	fil = fopen(rfnm, "r");
+	if (!fil) return 0;
+
+	while (fgets(buf, sizeof(buf), fil)) {
+		cur = buf;
+		while ((*cur == ' ') || (*cur == '\t')) cur++;
+		if ((*cur == '#') || (*cur == '\n')) continue;
+
+		id = strtoul(cur, &nxt, 0);
+		if ((nxt == cur) || errno) continue;
+		cur = nxt;
+
+		while ((*cur == ' ') || (*cur == '\t')) cur++;
+		if (strncmp(cur, rnm, len)) continue;
+		nxt = cur + len;
+		while ((*nxt == ' ') || (*nxt == '\t')) nxt++;
+		if ((*nxt == '\n') || (*nxt == 0) || (*nxt == '#')) {
+			*rid = (u_int32_t)id;
+			fclose(fil);
+			return 1;
+		}
+	}
+
+	fclose(fil);
+	return 0;
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -42,14 +83,23 @@
 		char *end;
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		optarg = argv[optind-1];
+		end = optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			realminfo->mask = strtoul(end+1, &end, 0);
-		} else
-			realminfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad realm value `%s'", optarg);
+		if ((end != optarg) && (('/' == *end) || ('\0' == *end))) {
+			if (*end == '/') {
+				realminfo->mask = strtoul(end+1, &end, 0);
+			} else
+				realminfo->mask = 0xffffffff;
+			if (*end != '\0' || end == optarg)
+				exit_error(PARAMETER_PROBLEM,
+					   "Bad realm value `%s'", optarg);
+		} else {
+			if (find_named_realm(optarg, &realminfo->id))
+				realminfo->mask = 0xffffffff;
+			else
+				exit_error(PARAMETER_PROBLEM,
+					   "Realm `%s' not found", optarg);
+		}
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;
diff -ruN iptables-1.3.5.mod1/extensions/libipt_realm.man iptables-1.3.5.mod2/extensions/libipt_realm.man
--- iptables-1.3.5.mod1/extensions/libipt_realm.man	2004-10-10 11:56:27.000000000 +0200
+++ iptables-1.3.5.mod2/extensions/libipt_realm.man	2006-05-21 17:51:17.000000000 +0200
@@ -1,5 +1,7 @@
 This matches the routing realm.  Routing realms are used in complex routing
 setups involving dynamic routing protocols like BGP.
 .TP
-.BI "--realm " "[!]" "value[/mask]"
-Matches a given realm number (and optionally mask).
+.BI "--realm " "[!] " "value[/mask]"
+Matches a given realm number (and optionally mask). If not a number, value
+can be a named realm from /etc/iproute2/rt_realms (mask can not be used in
+that case).

--Boundary-00=_hGJcExJLUgxf42B--
