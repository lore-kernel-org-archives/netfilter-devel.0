From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/15]: ip6_tables: remove redundant structure
	definitions
Date: Wed,  7 Feb 2007 09:23:11 +0100 (MET)
Message-ID: <20070207082310.27478.11451.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_tables: remove redundant structure definitions

Move ip6t_standard/ip6t_error_target/ip6t_error definitions to ip6_tables.h
instead of defining them in each table individually.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7e5c95832a67b0181f395669002e2346173e4866
tree cb59a3637401b5fd807daf02dafbb5aa05c197af
parent 86f832bd66647a6001f2cc345c4b62f8491bc2c2
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:14 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:14 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |   19 +++++++++++++++++++
 net/ipv6/netfilter/ip6table_filter.c      |   19 -------------------
 net/ipv6/netfilter/ip6table_mangle.c      |   19 -------------------
 net/ipv6/netfilter/ip6table_raw.c         |   19 -------------------
 4 files changed, 19 insertions(+), 57 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index e37698c..61aa104 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -104,6 +104,25 @@ struct ip6t_entry
 	unsigned char elems[0];
 };
 
+/* Standard entry */
+struct ip6t_standard
+{
+	struct ip6t_entry entry;
+	struct ip6t_standard_target target;
+};
+
+struct ip6t_error_target
+{
+	struct ip6t_entry_target target;
+	char errorname[IP6T_FUNCTION_MAXNAMELEN];
+};
+
+struct ip6t_error
+{
+	struct ip6t_entry entry;
+	struct ip6t_error_target target;
+};
+
 /*
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 45b8342..112a21d 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -19,25 +19,6 @@ MODULE_DESCRIPTION("ip6tables filter tab
 
 #define FILTER_VALID_HOOKS ((1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD) | (1 << NF_IP6_LOCAL_OUT))
 
-/* Standard entry. */
-struct ip6t_standard
-{
-	struct ip6t_entry entry;
-	struct ip6t_standard_target target;
-};
-
-struct ip6t_error_target
-{
-	struct ip6t_entry_target target;
-	char errorname[IP6T_FUNCTION_MAXNAMELEN];
-};
-
-struct ip6t_error
-{
-	struct ip6t_entry entry;
-	struct ip6t_error_target target;
-};
-
 static struct
 {
 	struct ip6t_replace repl;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 6f67ee1..5f5aa0e 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -29,25 +29,6 @@ #else
 #define DEBUGP(x, args...)
 #endif
 
-/* Standard entry. */
-struct ip6t_standard
-{
-	struct ip6t_entry entry;
-	struct ip6t_standard_target target;
-};
-
-struct ip6t_error_target
-{
-	struct ip6t_entry_target target;
-	char errorname[IP6T_FUNCTION_MAXNAMELEN];
-};
-
-struct ip6t_error
-{
-	struct ip6t_entry entry;
-	struct ip6t_error_target target;
-};
-
 static struct
 {
 	struct ip6t_replace repl;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index b4154da..277bf34 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -14,25 +14,6 @@ #else
 #define DEBUGP(x, args...)
 #endif
 
-/* Standard entry. */
-struct ip6t_standard
-{
-	struct ip6t_entry entry;
-	struct ip6t_standard_target target;
-};
-
-struct ip6t_error_target
-{
-	struct ip6t_entry_target target;
-	char errorname[IP6T_FUNCTION_MAXNAMELEN];
-};
-
-struct ip6t_error
-{
-	struct ip6t_entry entry;
-	struct ip6t_error_target target;
-};
-
 static struct
 {
 	struct ip6t_replace repl;
