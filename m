From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 10/43] fixed warning on compilation, part 2
Date: Fri, 20 Jul 2007 20:11:27 +0900 (JST)
Message-ID: <200707201111.l6KBBS5Q003622@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


changed the type of arguments as follows in multiport, DNAT, SNAT,
MASQUERADE, and REDIRECT

- ip[6]t_ip[6] * -> void *
- ip[6]t_entry * -> void *

and adds lines to cast these pointer with intended type.
---
 extensions/libip6t_multiport.c |   26 ++++++++++++++++----------
 extensions/libipt_DNAT.c       |    7 ++++---
 extensions/libipt_MASQUERADE.c |    7 ++++---
 extensions/libipt_REDIRECT.c   |    7 ++++---
 extensions/libipt_SNAT.c       |    7 ++++---
 extensions/libipt_multiport.c  |   21 ++++++++++++++-------
 6 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/extensions/libip6t_multiport.c b/extensions/libip6t_multiport.c
index bb55f23..2ff77fe 100644
--- a/extensions/libip6t_multiport.c
+++ b/extensions/libip6t_multiport.c
@@ -135,8 +135,9 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
 }
 
 static const char *
-check_proto(const struct ip6t_entry *entry)
+check_proto(const void *e)
 {
+	const struct ip6t_entry *entry = e;
 	char *proto;
 
 	if ((proto = proto_to_name(entry->ipv6.proto)) != NULL)
@@ -153,10 +154,11 @@ check_proto(const struct ip6t_entry *entry)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *e,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
+	const struct ip6t_entry *entry = e;
 	const char *proto;
 	struct ip6t_multiport *multiinfo
 		= (struct ip6t_multiport *)(*match)->data;
@@ -203,10 +205,11 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ip6t_entry *entry,
+	 const void *e,
 	 unsigned int *nfcache,
-	 struct ip6t_entry_match **match)
+	 struct xt_entry_match **match)
 {
+	const struct ip6t_entry *entry = e;
 	const char *proto;
 	struct ip6t_multiport_v1 *multiinfo
 		= (struct ip6t_multiport_v1 *)(*match)->data;
@@ -279,10 +282,11 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip_void,
       const struct xt_entry_match *match,
       int numeric)
 {
+	const struct ip6t_ip6 *ip = ip_void;
 	const struct ip6t_multiport *multiinfo
 		= (const struct ip6t_multiport *)match->data;
 	unsigned int i;
@@ -315,10 +319,11 @@ print(const struct ip6t_ip6 *ip,
 }
 
 static void
-print_v1(const struct ip6t_ip6 *ip,
-	 const struct ip6t_entry_match *match,
+print_v1(const void *ip_void,
+	 const struct xt_entry_match *match,
 	 int numeric)
 {
+	const struct ip6t_ip6 *ip = ip_void;
 	const struct ip6t_multiport_v1 *multiinfo
 		= (const struct ip6t_multiport_v1 *)match->data;
 	unsigned int i;
@@ -358,8 +363,9 @@ print_v1(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ip6t_ip6 *ip = ip_void;
 	const struct ip6t_multiport *multiinfo
 		= (const struct ip6t_multiport *)match->data;
 	unsigned int i;
@@ -385,9 +391,9 @@ static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 	printf(" ");
 }
 
-static void save_v1(const struct ip6t_ip6 *ip, 
-		    const struct ip6t_entry_match *match)
+static void save_v1(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ip6t_ip6 *ip = ip_void;
 	const struct ip6t_multiport_v1 *multiinfo
 		= (const struct ip6t_multiport_v1 *)match->data;
 	unsigned int i;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 7dce2d4..21b79ad 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -141,9 +141,10 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
 
@@ -215,7 +216,7 @@ static void print_range(const struct ip_nat_range *r)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -233,7 +234,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 8db6bdd..0a94939 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -78,9 +78,10 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = e;
 	int portok;
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -121,7 +122,7 @@ static void final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -143,7 +144,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 3810b99..ee42eb7 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -80,9 +80,10 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = e;
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
 	int portok;
@@ -130,7 +131,7 @@ static void final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -151,7 +152,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index bdf9429..ead5ab8 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -141,9 +141,10 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
 
@@ -217,7 +218,7 @@ static void print_range(const struct ip_nat_range *r)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -235,7 +236,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index 889e439..6de25c3 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -137,8 +137,9 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
 }
 
 static const char *
-check_proto(const struct ipt_entry *entry)
+check_proto(const void *e)
 {
+	const struct ipt_entry *entry = e;
 	char *proto;
 
 	if (entry->ip.invflags & IPT_INV_PROTO)
@@ -160,10 +161,11 @@ check_proto(const struct ipt_entry *entry)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
+	const struct ipt_entry *entry = e;
 	const char *proto;
 	struct ipt_multiport *multiinfo
 		= (struct ipt_multiport *)(*match)->data;
@@ -210,10 +212,11 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *e,
 	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
+	const struct ipt_entry *entry = e;
 	const char *proto;
 	struct ipt_multiport_v1 *multiinfo
 		= (struct ipt_multiport_v1 *)(*match)->data;
@@ -286,10 +289,11 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip_void,
       const struct xt_entry_match *match,
       int numeric)
 {
+	const struct ipt_ip *ip = ip_void;
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
@@ -322,10 +326,11 @@ print(const struct ipt_ip *ip,
 }
 
 static void
-print_v1(const struct ipt_ip *ip,
+print_v1(const void *ip_void,
 	 const struct xt_entry_match *match,
 	 int numeric)
 {
+	const struct ipt_ip *ip = ip_void;
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
 	unsigned int i;
@@ -365,8 +370,9 @@ print_v1(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ipt_ip *ip = ip_void;
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
@@ -392,9 +398,10 @@ static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 	printf(" ");
 }
 
-static void save_v1(const struct ipt_ip *ip, 
+static void save_v1(const void *ip_void,
 		    const struct xt_entry_match *match)
 {
+	const struct ipt_ip *ip = ip_void;
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
 	unsigned int i;
-- 
1.5.2.2
