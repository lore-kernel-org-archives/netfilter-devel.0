From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/6]: move ipt_error and ipt_standard to iptables.h
Date: Tue, 11 Jan 2005 13:49:56 +0100
Message-ID: <41E3CB74.5040907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080107070708050100090405"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080107070708050100090405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------080107070708050100090405
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:45:03+01:00 pablo@eurodev.net 
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_raw.c
#   2005/01/11 03:44:54+01:00 pablo@eurodev.net +0 -19
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_mangle.c
#   2005/01/11 03:44:54+01:00 pablo@eurodev.net +0 -19
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_filter.c
#   2005/01/11 03:44:54+01:00 pablo@eurodev.net +0 -19
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_rule.c
#   2005/01/11 03:44:54+01:00 pablo@eurodev.net +0 -19
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_tables.h
#   2005/01/11 03:44:54+01:00 pablo@eurodev.net +19 -0
#   [NETFILTER]: move ipt_error and ipt_standard to iptables.h
#   
#   Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
--- a/include/linux/netfilter_ipv4/ip_tables.h	2005-01-11 13:39:58 +01:00
+++ b/include/linux/netfilter_ipv4/ip_tables.h	2005-01-11 13:39:58 +01:00
@@ -459,6 +459,25 @@
 /* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
 extern struct ipt_target *ipt_find_target(const char *name, u8 revision);
 
+/* Standard entry. */
+struct ipt_standard
+{
+	struct ipt_entry entry;
+	struct ipt_standard_target target;
+};
+
+struct ipt_error_target
+{
+	struct ipt_entry_target target;
+	char errorname[IPT_FUNCTION_MAXNAMELEN];
+};
+
+struct ipt_error
+{
+	struct ipt_entry entry;
+	struct ipt_error_target target;
+};
+
 extern int ipt_register_table(struct ipt_table *table);
 extern void ipt_unregister_table(struct ipt_table *table);
 extern unsigned int ipt_do_table(struct sk_buff **pskb,
diff -Nru a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 13:39:58 +01:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 13:39:58 +01:00
@@ -35,25 +35,6 @@
 
 #define NAT_VALID_HOOKS ((1<<NF_IP_PRE_ROUTING) | (1<<NF_IP_POST_ROUTING) | (1<<NF_IP_LOCAL_OUT))
 
-/* Standard entry. */
-struct ipt_standard
-{
-	struct ipt_entry entry;
-	struct ipt_standard_target target;
-};
-
-struct ipt_error_target
-{
-	struct ipt_entry_target target;
-	char errorname[IPT_FUNCTION_MAXNAMELEN];
-};
-
-struct ipt_error
-{
-	struct ipt_entry entry;
-	struct ipt_error_target target;
-};
-
 static struct
 {
 	struct ipt_replace repl;
diff -Nru a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
--- a/net/ipv4/netfilter/iptable_filter.c	2005-01-11 13:39:58 +01:00
+++ b/net/ipv4/netfilter/iptable_filter.c	2005-01-11 13:39:58 +01:00
@@ -20,25 +20,6 @@
 
 #define FILTER_VALID_HOOKS ((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT))
 
-/* Standard entry. */
-struct ipt_standard
-{
-	struct ipt_entry entry;
-	struct ipt_standard_target target;
-};
-
-struct ipt_error_target
-{
-	struct ipt_entry_target target;
-	char errorname[IPT_FUNCTION_MAXNAMELEN];
-};
-
-struct ipt_error
-{
-	struct ipt_entry entry;
-	struct ipt_error_target target;
-};
-
 static struct
 {
 	struct ipt_replace repl;
diff -Nru a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
--- a/net/ipv4/netfilter/iptable_mangle.c	2005-01-11 13:39:58 +01:00
+++ b/net/ipv4/netfilter/iptable_mangle.c	2005-01-11 13:39:58 +01:00
@@ -29,25 +29,6 @@
 			    (1 << NF_IP_LOCAL_OUT) | \
 			    (1 << NF_IP_POST_ROUTING))
 
-/* Standard entry. */
-struct ipt_standard
-{
-	struct ipt_entry entry;
-	struct ipt_standard_target target;
-};
-
-struct ipt_error_target
-{
-	struct ipt_entry_target target;
-	char errorname[IPT_FUNCTION_MAXNAMELEN];
-};
-
-struct ipt_error
-{
-	struct ipt_entry entry;
-	struct ipt_error_target target;
-};
-
 /* Ouch - five different hooks? Maybe this should be a config option..... -- BC */
 static struct
 {
diff -Nru a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
--- a/net/ipv4/netfilter/iptable_raw.c	2005-01-11 13:39:58 +01:00
+++ b/net/ipv4/netfilter/iptable_raw.c	2005-01-11 13:39:58 +01:00
@@ -8,25 +8,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))
 
-/* Standard entry. */
-struct ipt_standard
-{
-	struct ipt_entry entry;
-	struct ipt_standard_target target;
-};
-
-struct ipt_error_target
-{
-	struct ipt_entry_target target;
-	char errorname[IPT_FUNCTION_MAXNAMELEN];
-};
-
-struct ipt_error
-{
-	struct ipt_entry entry;
-	struct ipt_error_target target;
-};
-
 static struct
 {
 	struct ipt_replace repl;

--------------080107070708050100090405--
