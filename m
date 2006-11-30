From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 6/12]: move some duplicated functions in ip[6]tables.c to
 xtables.c
Date: Thu, 30 Nov 2006 18:50:33 +0900 (JST)
Message-ID: <200611300950.kAU9oZGl002628@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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


string_to_number_ll, string_to_number_l, string_to_number,
service_to_port, parse_port, parse_interface, are moved.
---
 include/ip6tables.h       |    3 -
 include/iptables.h        |    3 -
 include/iptables_common.h |   12 -----
 include/xtables.h         |   17 +++++++
 ip6tables.c               |  106 ---------------------------------------------
 iptables.c                |  106 ---------------------------------------------
 xtables.c                 |  103 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 120 insertions(+), 230 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 0314393..f6da0b2 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -33,11 +33,8 @@ extern int line;
 extern void register_match6(struct ip6tables_match *me);
 extern void register_target6(struct ip6tables_target *me);
 
-extern int service_to_port(const char *name, const char *proto);
-extern u_int16_t parse_port(const char *port, const char *proto);
 extern int do_command6(int argc, char *argv[], char **table,
 		       ip6tc_handle_t *handle);
-extern void parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
diff --git a/include/iptables.h b/include/iptables.h
index 290c116..3b365ae 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -32,8 +32,6 @@ extern int line;
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
-extern int service_to_port(const char *name, const char *proto);
-extern u_int16_t parse_port(const char *port, const char *proto);
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern struct in_addr *dotted_to_mask(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
@@ -43,7 +41,6 @@ extern char *mask_to_dotted(const struct
 extern void parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
                       struct in_addr *maskp, unsigned int *naddrs);
 extern u_int16_t parse_protocol(const char *s);
-extern void parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
diff --git a/include/iptables_common.h b/include/iptables_common.h
index 3e19080..cf8a4ba 100644
--- a/include/iptables_common.h
+++ b/include/iptables_common.h
@@ -15,18 +15,6 @@ enum exittype {
 extern void exit_printhelp() __attribute__((noreturn));
 extern void exit_tryhelp(int) __attribute__((noreturn));
 int check_inverse(const char option[], int *invert, int *optind, int argc);
-extern int string_to_number(const char *, 
-			    unsigned int, 
-			    unsigned int,
-			    unsigned int *);
-extern int string_to_number_l(const char *, 
-			    unsigned long int, 
-			    unsigned long int,
-			    unsigned long *);
-extern int string_to_number_ll(const char *, 
-			    unsigned long long int, 
-			    unsigned long long int,
-			    unsigned long long *);
 void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
diff --git a/include/xtables.h b/include/xtables.h
index b2d4d70..e9caf4d 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -180,4 +180,21 @@ extern struct xtables_match *find_match(
 					struct xtables_rule_match **match);
 extern struct xtables_target *find_target(const char *name, enum xt_tryload);
 
+extern int string_to_number_ll(const char *s,
+			       unsigned long long min,
+			       unsigned long long max,
+			       unsigned long long *ret);
+extern int string_to_number_l(const char *s,
+			      unsigned long min,
+			      unsigned long max,
+			      unsigned long *ret);
+extern int string_to_number(const char *s,
+			    unsigned int min,
+			    unsigned int max,
+			    unsigned int *ret);
+extern int service_to_port(const char *name, const char *proto);
+extern u_int16_t parse_port(const char *port, const char *proto);
+extern void
+parse_interface(const char *arg, char *vianame, unsigned char *mask);
+
 #endif /* _XTABLES_H */
diff --git a/ip6tables.c b/ip6tables.c
index 3ebdd06..93d71ea 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -243,30 +243,6 @@ proto_to_name(u_int8_t proto, int nolook
 	return NULL;
 }
 
-int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
-u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
 static void
 in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
 {
@@ -772,43 +748,6 @@ static int is_exthdr(u_int16_t proto)
 		proto == IPPROTO_DSTOPTS);
 }
 
-void parse_interface(const char *arg, char *vianame, unsigned char *mask)
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
-	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
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
-			if (vianame[i] == ':' ||
-			    vianame[i] == '!' ||
-			    vianame[i] == '*') {
-				printf("Warning: weird character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
-				break;
-			}
-		}
-	}
-}
-
 /* Can't be zero. */
 static int
 parse_rulenumber(const char *rule)
@@ -843,51 +782,6 @@ parse_target(const char *targetname)
 	return targetname;
 }
 
-int
-string_to_number_ll(const char *s, unsigned long long min, unsigned long long max,
-		 unsigned long long *ret)
-{
-	unsigned long long number;
-	char *end;
-
-	/* Handle hex, octal, etc. */
-	errno = 0;
-	number = strtoull(s, &end, 0);
-	if (*end == '\0' && end != s) {
-		/* we parsed a number, let's see if we want this */
-		if (errno != ERANGE && min <= number && (!max || number <= max)) {
-			*ret = number;
-			return 0;
-		}
-	}
-	return -1;
-}
-
-int
-string_to_number_l(const char *s, unsigned long min, unsigned long max,
-		 unsigned long *ret)
-{
-	int result;
-	unsigned long long number;
-
-	result = string_to_number_ll(s, min, max, &number);
-	*ret = (unsigned long)number;
-
-	return result;
-}
-
-int string_to_number(const char *s, unsigned int min, unsigned int max,
-		unsigned int *ret)
-{
-	int result;
-	unsigned long number;
-
-	result = string_to_number_l(s, min, max, &number);
-	*ret = (unsigned int)number;
-
-	return result;
-}
-
 static void
 set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	   int invert)
diff --git a/iptables.c b/iptables.c
index 25aab09..989e539 100644
--- a/iptables.c
+++ b/iptables.c
@@ -246,30 +246,6 @@ proto_to_name(u_int8_t proto, int nolook
 	return NULL;
 }
 
-int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-	return -1;
-}
-
-u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
 enum {
 	IPT_DOTTED_ADDR = 0,
 	IPT_DOTTED_MASK
@@ -753,43 +729,6 @@ parse_protocol(const char *s)
 	return (u_int16_t)proto;
 }
 
-void parse_interface(const char *arg, char *vianame, unsigned char *mask)
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
-	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
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
-			if (vianame[i] == ':' ||
-			    vianame[i] == '!' ||
-			    vianame[i] == '*') {
-				printf("Warning: weird character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
-				break;
-			}
-		}
-	}
-}
-
 /* Can't be zero. */
 static int
 parse_rulenumber(const char *rule)
@@ -884,51 +823,6 @@ mask_to_dotted(const struct in_addr *mas
 	return buf;
 }
 
-int
-string_to_number_ll(const char *s, unsigned long long min, unsigned long long max,
-		 unsigned long long *ret)
-{
-	unsigned long long number;
-	char *end;
-
-	/* Handle hex, octal, etc. */
-	errno = 0;
-	number = strtoull(s, &end, 0);
-	if (*end == '\0' && end != s) {
-		/* we parsed a number, let's see if we want this */
-		if (errno != ERANGE && min <= number && (!max || number <= max)) {
-			*ret = number;
-			return 0;
-		}
-	}
-	return -1;
-}
-
-int
-string_to_number_l(const char *s, unsigned long min, unsigned long max,
-		 unsigned long *ret)
-{
-	int result;
-	unsigned long long number;
-
-	result = string_to_number_ll(s, min, max, &number);
-	*ret = (unsigned long)number;
-
-	return result;
-}
-
-int string_to_number(const char *s, unsigned int min, unsigned int max,
-		unsigned int *ret)
-{
-	int result;
-	unsigned long number;
-
-	result = string_to_number_l(s, min, max, &number);
-	*ret = (unsigned int)number;
-
-	return result;
-}
-
 static void
 set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	   int invert)
diff --git a/xtables.c b/xtables.c
index 8879a1c..b92824b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -19,6 +19,7 @@
 #include <dlfcn.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <netdb.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -143,6 +144,108 @@ int load_xtables_ko(const char *modprobe
 	return ret;
 }
 
+int string_to_number_ll(const char *s, unsigned long long min,
+			unsigned long long max, unsigned long long *ret)
+{
+	unsigned long long number;
+	char *end;
+
+	/* Handle hex, octal, etc. */
+	errno = 0;
+	number = strtoull(s, &end, 0);
+	if (*end == '\0' && end != s) {
+		/* we parsed a number, let's see if we want this */
+		if (errno != ERANGE && min <= number && (!max || number <= max)) {
+			*ret = number;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+int string_to_number_l(const char *s, unsigned long min, unsigned long max,
+		       unsigned long *ret)
+{
+	int result;
+	unsigned long long number;
+
+	result = string_to_number_ll(s, min, max, &number);
+	*ret = (unsigned long)number;
+
+	return result;
+}
+
+int string_to_number(const char *s, unsigned int min, unsigned int max,
+		unsigned int *ret)
+{
+	int result;
+	unsigned long number;
+
+	result = string_to_number_l(s, min, max, &number);
+	*ret = (unsigned int)number;
+
+	return result;
+}
+
+int service_to_port(const char *name, const char *proto)
+{
+	struct servent *service;
+
+	if ((service = getservbyname(name, proto)) != NULL)
+		return ntohs((unsigned short) service->s_port);
+
+	return -1;
+}
+
+u_int16_t parse_port(const char *port, const char *proto)
+{
+	unsigned int portnum;
+
+	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
+	    (portnum = service_to_port(port, proto)) != -1)
+		return (u_int16_t)portnum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid port/service `%s' specified", port);
+}
+
+void parse_interface(const char *arg, char *vianame, unsigned char *mask)
+{
+	int vialen = strlen(arg);
+	unsigned int i;
+
+	memset(mask, 0, IFNAMSIZ);
+	memset(vianame, 0, IFNAMSIZ);
+
+	if (vialen + 1 > IFNAMSIZ)
+		exit_error(PARAMETER_PROBLEM,
+			   "interface name `%s' must be shorter than IFNAMSIZ"
+			   " (%i)", arg, IFNAMSIZ-1);
+
+	strcpy(vianame, arg);
+	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
+		memset(mask, 0, IFNAMSIZ);
+	else if (vianame[vialen - 1] == '+') {
+		memset(mask, 0xFF, vialen - 1);
+		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
+		/* Don't remove `+' here! -HW */
+	} else {
+		/* Include nul-terminator in match */
+		memset(mask, 0xFF, vialen + 1);
+		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
+		for (i = 0; vianame[i]; i++) {
+			if (vianame[i] == ':' ||
+			    vianame[i] == '!' ||
+			    vianame[i] == '*') {
+				printf("Warning: weird character in interface"
+				       " `%s' (No aliases, :, ! or *).\n",
+				       vianame);
+				break;
+			}
+		}
+	}
+}
+
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 				 struct xtables_rule_match **matches)
 {
-- 
1.4.4
