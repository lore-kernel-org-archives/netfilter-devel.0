From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH] realm: enable named realms
Date: Wed, 22 Sep 2004 04:15:38 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150E04A.4090003@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sampsa Ranta <sampsa@netsonic.fi>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Enable '--realm [!] realm_name', not just numeric realms. Does lookup in /etc/iproute2/rt_realms.


Simon Lodal


diff -ruN iptables-1.2.11.orig/extensions/libipt_realm.c iptables-1.2.11.realm_named/extensions/libipt_realm.c
--- iptables-1.2.11.orig/extensions/libipt_realm.c	Wed Sep 22 03:14:48 2004
+++ iptables-1.2.11.realm_named/extensions/libipt_realm.c	Wed Sep 22 03:14:04 2004
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <errno.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
 #else
@@ -36,6 +37,47 @@
 	*nfcache |= NFC_UNKNOWN;
 }
 
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
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -51,12 +93,19 @@
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
 		realminfo->id = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			realminfo->mask = strtoul(end+1, &end, 0);
-		} else
-			realminfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad REALM value `%s'", optarg);
+		if ((optarg != end) && ((*end = '/') || (*end = '0'))) {
+			if (*end == '/') {
+				realminfo->mask = strtoul(end+1, &end, 0);
+			} else
+				realminfo->mask = 0xffffffff;
+			if (*end != '\0')
+				exit_error(PARAMETER_PROBLEM, "Bad REALM value `%s'", optarg);
+		} else {
+			if (find_named_realm(optarg, &realminfo->id))
+				realminfo->mask = 0xffffffff;
+			else
+				exit_error(PARAMETER_PROBLEM, "Realm `%s' not found", optarg);
+		}
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;
diff -ruN iptables-1.2.11.orig/extensions/libipt_realm.man iptables-1.2.11.realm_named/extensions/libipt_realm.man
--- iptables-1.2.11.orig/extensions/libipt_realm.man	Wed Sep 22 03:53:58 2004
+++ iptables-1.2.11.realm_named/extensions/libipt_realm.man	Wed Sep 22 04:00:17 2004
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
