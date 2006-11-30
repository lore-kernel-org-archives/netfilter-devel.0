From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 10/12]: fixed warning on compilation, part 2
Date: Thu, 30 Nov 2006 18:52:08 +0900 (JST)
Message-ID: <200611300952.kAU9q9nF003802@toshiba.co.jp>
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
index bb55f23..11c4a51 100644
--- a/extensions/libip6t_multiport.c
+++ b/extensions/libip6t_multiport.c
@@ -135,8 +135,9 @@ init(struct xt_entry_match *m, unsigned
 }
 
 static const char *
-check_proto(const struct ip6t_entry *entry)
+check_proto(const void *e)
 {
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
 	char *proto;
 
 	if ((proto = proto_to_name(entry->ipv6.proto)) != NULL)
@@ -153,10 +154,11 @@ check_proto(const struct ip6t_entry *ent
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *e,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
 	const char *proto;
 	struct ip6t_multiport *multiinfo
 		= (struct ip6t_multiport *)(*match)->data;
@@ -203,10 +205,11 @@ parse(int c, char **argv, int invert, un
 
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ip6t_entry *entry,
+	 const void *e,
 	 unsigned int *nfcache,
-	 struct ip6t_entry_match **match)
+	 struct xt_entry_match **match)
 {
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
 	const char *proto;
 	struct ip6t_multiport_v1 *multiinfo
 		= (struct ip6t_multiport_v1 *)(*match)->data;
@@ -279,10 +282,11 @@ print_port(u_int16_t port, u_int8_t prot
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip_void,
       const struct xt_entry_match *match,
       int numeric)
 {
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
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
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
 	const struct ip6t_multiport_v1 *multiinfo
 		= (const struct ip6t_multiport_v1 *)match->data;
 	unsigned int i;
@@ -358,8 +363,9 @@ print_v1(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
 	const struct ip6t_multiport *multiinfo
 		= (const struct ip6t_multiport *)match->data;
 	unsigned int i;
@@ -385,9 +391,9 @@ static void save(const struct ip6t_ip6 *
 	printf(" ");
 }
 
-static void save_v1(const struct ip6t_ip6 *ip, 
-		    const struct ip6t_entry_match *match)
+static void save_v1(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
 	const struct ip6t_multiport_v1 *multiinfo
 		= (const struct ip6t_multiport_v1 *)match->data;
 	unsigned int i;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 3a5740b..52b2137 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -136,9 +136,10 @@ parse_to(char *arg, int portok, struct i
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
 
@@ -201,7 +202,7 @@ static void print_range(const struct ip_
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -217,7 +218,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 60047fe..ad21c9e 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -73,9 +73,10 @@ parse_ports(const char *arg, struct ip_n
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	int portok;
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -112,7 +113,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -131,7 +132,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 9805b38..f7a3105 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -76,9 +76,10 @@ parse_ports(const char *arg, struct ip_n
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
 	int portok;
@@ -115,7 +116,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -134,7 +135,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 9e12094..8d8f8b0 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -136,9 +136,10 @@ parse_to(char *arg, int portok, struct i
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       struct xt_entry_target **target)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
 
@@ -201,7 +202,7 @@ static void print_range(const struct ip_
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -217,7 +218,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index 384eda8..3f2a4e7 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -135,8 +135,9 @@ init(struct xt_entry_match *m, unsigned
 }
 
 static const char *
-check_proto(const struct ipt_entry *entry)
+check_proto(const void *e)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	char *proto;
 
 	if (entry->ip.invflags & IPT_INV_PROTO)
@@ -157,10 +158,11 @@ check_proto(const struct ipt_entry *entr
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *e,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	const char *proto;
 	struct ipt_multiport *multiinfo
 		= (struct ipt_multiport *)(*match)->data;
@@ -207,10 +209,11 @@ parse(int c, char **argv, int invert, un
 
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *e,
 	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
+	const struct ipt_entry *entry = (const struct ipt_entry *)e;
 	const char *proto;
 	struct ipt_multiport_v1 *multiinfo
 		= (struct ipt_multiport_v1 *)(*match)->data;
@@ -283,10 +286,11 @@ print_port(u_int16_t port, u_int8_t prot
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip_void,
       const struct xt_entry_match *match,
       int numeric)
 {
+	const struct ipt_ip *ip = (const struct ipt_ip *)ip_void;
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
@@ -319,10 +323,11 @@ print(const struct ipt_ip *ip,
 }
 
 static void
-print_v1(const struct ipt_ip *ip,
+print_v1(const void *ip_void,
 	 const struct xt_entry_match *match,
 	 int numeric)
 {
+	const struct ipt_ip *ip = (const struct ipt_ip *)ip_void;
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
 	unsigned int i;
@@ -362,8 +367,9 @@ print_v1(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip_void, const struct xt_entry_match *match)
 {
+	const struct ipt_ip *ip = (const struct ipt_ip *)ip_void;
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
@@ -389,9 +395,10 @@ static void save(const struct ipt_ip *ip
 	printf(" ");
 }
 
-static void save_v1(const struct ipt_ip *ip, 
+static void save_v1(const void *ip_void, 
 		    const struct xt_entry_match *match)
 {
+	const struct ipt_ip *ip = (const struct ipt_ip *)ip_void;
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
 	unsigned int i;
-- 
1.4.4
