From: Simon Lodal <simonl@parknet.dk>
Subject: [PATCH] Named realm - updated
Date: Sun, 4 Jun 2006 21:35:49 +0200
Message-ID: <200606042135.49361.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VYzgESk5LpGJN9B"
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

--Boundary-00=_VYzgESk5LpGJN9B
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Make the realm match accept named realms, defined in /etc/iproute2/rt_realms.

First sent 2006-05-21, improved since then:
- Only load rt_realms once, keep in memory.
- Output realm by name if it was originally specified that way, except if 
iptables -n.


Simon


--Boundary-00=_VYzgESk5LpGJN9B
Content-Type: text/x-diff; charset="us-ascii"; name="realm_named_linux.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="realm_named_linux.diff"

Index: linux-2.6/include/linux/netfilter/xt_realm.h
===================================================================
--- linux-2.6/include/linux/netfilter/xt_realm.h	(revision 44)
+++ linux-2.6/include/linux/netfilter/xt_realm.h	(revision 45)
@@ -5,6 +5,7 @@
 	u_int32_t id;
 	u_int32_t mask;
 	u_int8_t invert;
+	u_int8_t is_named_realm;
 };
 
 #endif /* _XT_REALM_H */

--Boundary-00=_VYzgESk5LpGJN9B
Content-Type: text/x-diff; charset="us-ascii"; name="realm_named_iptables.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="realm_named_iptables.diff"

diff -ruN iptables-1.3.5.base/extensions/libipt_realm.c iptables-1.3.5/extensions/libipt_realm.c
--- iptables-1.3.5.base/extensions/libipt_realm.c	2006-06-04 01:49:33.000000000 +0200
+++ iptables-1.3.5/extensions/libipt_realm.c	2006-06-04 01:50:06.000000000 +0200
@@ -3,6 +3,8 @@
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
+#include <errno.h>
+#include <ctype.h>
 #include <getopt.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
@@ -28,6 +30,116 @@
 	{0}
 };
 
+struct realmname { 
+	int	id;
+	char*	name;
+	int	len;
+	struct realmname* next;
+};
+
+/* array of realms from /etc/iproute2/rt_realms */
+static struct realmname *realms = NULL;
+/* 1 if loading failed */
+static int rdberr = 0;
+
+
+void load_realms()
+{
+	const char* rfnm = "/etc/iproute2/rt_realms";
+	char buf[512];
+	FILE *fil;
+	char *cur, *nxt;
+	int id;
+	struct realmname *oldnm = NULL, *newnm = NULL;
+
+	fil = fopen(rfnm, "r");
+	if (!fil) {
+		rdberr = 1;
+		return;
+	}
+
+	while (fgets(buf, sizeof(buf), fil)) {
+		cur = buf;
+		while ((*cur == ' ') || (*cur == '\t')) cur++;
+		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
+			continue;
+
+		/* iproute2 allows hex and dec format */
+		errno = 0;
+		id = strtoul(cur, &nxt, strncmp(cur, "0x", 2) ? 10 : 16);
+		if ((nxt == cur) || errno) {
+			continue;
+		}
+
+		/* same boundaries as in iproute2 */
+		if (id < 0 || id > 256) continue;
+		cur = nxt;
+
+		if (!isspace(*cur)) continue;
+		while ((*cur == ' ') || (*cur == '\t')) cur++;
+		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
+			continue;
+		nxt = cur;
+		while ((*nxt != 0) && !isspace(*nxt)) nxt++;
+		if (nxt == cur) continue;
+
+		/* found valid data */
+		newnm = (struct realmname*)malloc(sizeof(struct realmname));
+		if (NULL == newnm) {
+			perror("libipt_realm: malloc failed");
+			exit(1);
+		}
+		newnm->id = id;
+		newnm->len = nxt - cur;
+		newnm->name = (char*)malloc(newnm->len + 1);
+		if (NULL == newnm->name) {
+			perror("libipt_realm: malloc failed");
+			exit(1);
+		}
+		strncpy(newnm->name, cur, newnm->len);
+		newnm->name[newnm->len] = 0;
+		newnm->next = NULL;
+
+		if (oldnm) {
+			oldnm->next = newnm;
+		} else {
+			realms = newnm;
+		}
+		oldnm = newnm;
+	}
+
+	fclose(fil);
+}
+
+/* get realm id for name, -1 if error/not found */
+int realm_name2id(const char* name)
+{
+	if ((NULL == realms) && (0 == rdberr)) load_realms();
+	if (NULL == realms) return -1;
+
+	struct realmname* cur = realms;
+	while (cur) {
+		if (!strncmp(name, cur->name, cur->len + 1)) return cur->id;
+		cur = cur->next;
+	}
+	return -1;
+}
+
+/* get realm name for id, NULL if error/not found */
+const char* realm_id2name(int id)
+{
+	if ((NULL == realms) && (0 == rdberr)) load_realms();
+	if (NULL == realms) return NULL;
+
+	struct realmname* cur = realms;
+	while (cur) {
+		if (id == cur->id) return cur->name;
+		cur = cur->next;
+	}
+	return NULL;
+}
+
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -42,14 +154,26 @@
 		char *end;
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		optarg = argv[optind-1];
+		end = optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			realminfo->mask = strtoul(end+1, &end, 0);
-		} else
+		if ((end != optarg) && (('/' == *end) || ('\0' == *end))) {
+			if (*end == '/') {
+				realminfo->mask = strtoul(end+1, &end, 0);
+			} else
+				realminfo->mask = 0xffffffff;
+			if (*end != '\0' || end == optarg)
+				exit_error(PARAMETER_PROBLEM,
+					   "Bad realm value `%s'", optarg);
+		} else {
+			int id = realm_name2id(optarg);
+			if (-1 == id) {
+				exit_error(PARAMETER_PROBLEM,
+					   "Realm `%s' not found", optarg);
+			}
+			realminfo->id = (u_int32_t)id;
 			realminfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad realm value `%s'", optarg);
+			realminfo->is_named_realm = 1;
+		}
 		if (invert)
 			realminfo->invert = 1;
 		*flags = 1;
@@ -62,12 +186,22 @@
 }
 
 static void
-print_realm(unsigned long id, unsigned long mask)
+print_realm(unsigned long id, unsigned long mask, int is_named)
 {
+	const char* name = NULL;
+
 	if (mask != 0xffffffff)
 		printf("0x%lx/0x%lx ", id, mask);
-	else
-		printf("0x%lx ", id);
+	else {
+		if (1 == is_named) {
+			name = realm_id2name(id);
+		}
+		if (name) {
+			printf("%s ", name);
+		} else {
+			printf("0x%lx ", id);
+		}
+	}
 }
 
 /* Prints out the matchinfo. */
@@ -82,7 +216,7 @@
 		printf("! ");
 
 	printf("realm ");
-	print_realm(ri->id, ri->mask);
+	print_realm(ri->id, ri->mask, numeric ? 0 : ri->is_named_realm);
 }
 
 
@@ -96,7 +230,7 @@
 		printf("! ");
 
 	printf("--realm ");
-	print_realm(ri->id, ri->mask);
+	print_realm(ri->id, ri->mask, ri->is_named_realm);
 }
 
 /* Final check; must have specified --mark. */
diff -ruN iptables-1.3.5.base/extensions/libipt_realm.man iptables-1.3.5/extensions/libipt_realm.man
--- iptables-1.3.5.base/extensions/libipt_realm.man	2004-10-10 11:56:27.000000000 +0200
+++ iptables-1.3.5/extensions/libipt_realm.man	2006-06-04 01:50:15.000000000 +0200
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

--Boundary-00=_VYzgESk5LpGJN9B--
