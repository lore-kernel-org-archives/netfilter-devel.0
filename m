From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] move ipt_error and ipt_standard to iptables.h
Date: Sat, 01 Jan 2005 23:05:11 +0100
Message-ID: <41D71E97.8020709@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060102080204040809090602"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------060102080204040809090602
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

ipt_error_target, ipt_error and ipt_standard are defined in every table. 
Move these declarations to ip_tables.h where I think they really belongs to.

Please, let me know if there any special reason to duplicate them that way.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------060102080204040809090602
Content-Type: text/x-patch;
 name="ipt_error_and_generic_redefinition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ipt_error_and_generic_redefinition.patch"

===== include/linux/netfilter_ipv4/ip_tables.h 1.12 vs edited =====
--- 1.12/include/linux/netfilter_ipv4/ip_tables.h	2004-11-02 01:39:53 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_tables.h	2004-12-29 13:32:56 +01:00
@@ -439,6 +447,25 @@
 
 	/* Set to THIS_MODULE. */
 	struct module *me;
+};
+
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
 };
 
 extern int ipt_register_table(struct ipt_table *table);
===== net/ipv4/netfilter/iptable_raw.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/iptable_raw.c	2004-06-23 16:44:05 +02:00
+++ edited/net/ipv4/netfilter/iptable_raw.c	2004-12-29 13:33:24 +01:00
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
===== net/ipv4/netfilter/iptable_mangle.c 1.17 vs edited =====
--- 1.17/net/ipv4/netfilter/iptable_mangle.c	2004-06-21 23:31:50 +02:00
+++ edited/net/ipv4/netfilter/iptable_mangle.c	2004-12-29 13:33:41 +01:00
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
===== net/ipv4/netfilter/iptable_filter.c 1.13 vs edited =====
--- 1.13/net/ipv4/netfilter/iptable_filter.c	2004-11-13 22:40:51 +01:00
+++ edited/net/ipv4/netfilter/iptable_filter.c	2004-12-29 13:33:05 +01:00
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
===== net/ipv4/netfilter/ip_nat_rule.c 1.15 vs edited =====
--- 1.15/net/ipv4/netfilter/ip_nat_rule.c	2004-11-13 22:40:51 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_rule.c	2004-12-29 13:34:07 +01:00
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

--------------060102080204040809090602--
