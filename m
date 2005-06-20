From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH IPTABLES] kill duplicated parse_interface()
Date: Mon, 20 Jun 2005 18:28:40 +0900 (JST)
Message-ID: <200506200928.j5K9SeTQ019333@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Jun_20_18:28:40_2005_620)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Mon_Jun_20_18:28:40_2005_620)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

This patch deletes parse_interface() in libip{6}t_physdev.c and uses same
function in ip{6}tables.c instead. This cleanup will also fix the bug reported
last year.

https://lists.netfilter.org/pipermail/netfilter-devel/2004-April/014893.html

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_Jun_20_18:28:40_2005_620)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="parse_interface.patch"

Index: include/ip6tables.h
===================================================================
--- include/ip6tables.h	(revision 3958)
+++ include/ip6tables.h	(working copy)
@@ -137,6 +137,8 @@
 extern struct ip6tables_target *find_target(const char *name, enum ip6t_tryload);
 extern struct ip6tables_match *find_match(const char *name, enum ip6t_tryload, struct ip6tables_rule_match **match);
 
+extern void parse_interface(const char *arg, char *vianame, unsigned char *mask);
+
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
Index: include/iptables.h
===================================================================
--- include/iptables.h	(revision 3958)
+++ include/iptables.h	(working copy)
@@ -152,6 +152,7 @@
 extern void parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
                       struct in_addr *maskp, unsigned int *naddrs);
 extern u_int16_t parse_protocol(const char *s);
+extern void parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
Index: iptables.c
===================================================================
--- iptables.c	(revision 3958)
+++ iptables.c	(working copy)
@@ -769,8 +769,7 @@
 	return (u_int16_t)proto;
 }
 
-static void
-parse_interface(const char *arg, char *vianame, unsigned char *mask)
+void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 {
 	int vialen = strlen(arg);
 	unsigned int i;
Index: extensions/libipt_physdev.c
===================================================================
--- extensions/libipt_physdev.c	(revision 3958)
+++ extensions/libipt_physdev.c	(working copy)
@@ -34,46 +34,7 @@
 	{0}
 };
 
-/* copied from iptables.c */
 static void
-parse_interface(const char *arg, char *vianame, unsigned char *mask)
-{
-	int vialen = strlen(arg);
-	unsigned int i;
-
-	memset(mask, 0, IFNAMSIZ);
-	memset(vianame, 0, IFNAMSIZ);
-
-	if (vialen + 1 > IFNAMSIZ)
-		exit_error(PARAMETER_PROBLEM,
-			   "interface name `%s' must be shorter than IFNAMSIZ"
-			   " (%i)", arg, IFNAMSIZ-1);
-
-	strcpy(vianame, arg);
-	if (vialen == 0)
-		memset(mask, 0, IFNAMSIZ);
-	else if (vianame[vialen - 1] == '+') {
-		memset(mask, 0xFF, vialen - 1);
-		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
-		/* Don't remove `+' here! -HW */
-	} else {
-		/* Include nul-terminator in match */
-		memset(mask, 0xFF, vialen + 1);
-		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
-		for (i = 0; vianame[i]; i++) {
-			if (!isalnum(vianame[i])
-			    && vianame[i] != '_'
-			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
-				break;
-			}
-		}
-	}
-}
-
-static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
 }
Index: extensions/libip6t_physdev.c
===================================================================
--- extensions/libip6t_physdev.c	(revision 3958)
+++ extensions/libip6t_physdev.c	(working copy)
@@ -34,46 +34,7 @@
 	{0}
 };
 
-/* copied from iptables.c */
 static void
-parse_interface(const char *arg, char *vianame, unsigned char *mask)
-{
-	int vialen = strlen(arg);
-	unsigned int i;
-
-	memset(mask, 0, IFNAMSIZ);
-	memset(vianame, 0, IFNAMSIZ);
-
-	if (vialen + 1 > IFNAMSIZ)
-		exit_error(PARAMETER_PROBLEM,
-			   "interface name `%s' must be shorter than IFNAMSIZ"
-			   " (%i)", arg, IFNAMSIZ-1);
-
-	strcpy(vianame, arg);
-	if (vialen == 0)
-		memset(mask, 0, IFNAMSIZ);
-	else if (vianame[vialen - 1] == '+') {
-		memset(mask, 0xFF, vialen - 1);
-		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
-		/* Don't remove `+' here! -HW */
-	} else {
-		/* Include nul-terminator in match */
-		memset(mask, 0xFF, vialen + 1);
-		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
-		for (i = 0; vianame[i]; i++) {
-			if (!isalnum(vianame[i])
-			    && vianame[i] != '_'
-			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
-				break;
-			}
-		}
-	}
-}
-
-static void
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
 {
 }
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 3958)
+++ ip6tables.c	(working copy)
@@ -829,8 +829,7 @@
 	return (u_int16_t)proto;
 }
 
-static void
-parse_interface(const char *arg, char *vianame, unsigned char *mask)
+void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 {
 	int vialen = strlen(arg);
 	unsigned int i;

----Next_Part(Mon_Jun_20_18:28:40_2005_620)----
