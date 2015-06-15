From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 06/15] netfilter: x_tables: adapt xt_hook_link() to support pernet hooks
Date: Mon, 15 Jun 2015 17:46:48 +0200
Message-ID: <1434383217-13732-7-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbbFOPlt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:49 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This prepares the port of the existing tables to the pernet hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h     |    3 ++-
 net/ipv4/netfilter/arptable_filter.c   |    3 ++-
 net/ipv4/netfilter/iptable_filter.c    |    3 ++-
 net/ipv4/netfilter/iptable_mangle.c    |    3 ++-
 net/ipv4/netfilter/iptable_raw.c       |    2 +-
 net/ipv4/netfilter/iptable_security.c  |    3 ++-
 net/ipv6/netfilter/ip6table_filter.c   |    3 ++-
 net/ipv6/netfilter/ip6table_mangle.c   |    3 ++-
 net/ipv6/netfilter/ip6table_raw.c      |    2 +-
 net/ipv6/netfilter/ip6table_security.c |    3 ++-
 net/netfilter/x_tables.c               |    5 +++--
 11 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9969d79..8344092 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -402,7 +402,8 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
-struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
+struct nf_hook_ops *xt_hook_link(struct net *net, const struct xt_table *,
+				 nf_hookfn *);
 void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
 #ifdef CONFIG_COMPAT
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 93876d0..c7a7729 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -69,7 +69,8 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	arpfilter_ops = xt_hook_link(&packet_filter, arptable_filter_hook);
+	arpfilter_ops = xt_hook_link(&init_net, &packet_filter,
+				     arptable_filter_hook);
 	if (IS_ERR(arpfilter_ops)) {
 		ret = PTR_ERR(arpfilter_ops);
 		goto cleanup_table;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index a0f3bec..f0faa27 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -90,7 +90,8 @@ static int __init iptable_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, iptable_filter_hook);
+	filter_ops = xt_hook_link(&init_net, &packet_filter,
+				  iptable_filter_hook);
 	if (IS_ERR(filter_ops)) {
 		ret = PTR_ERR(filter_ops);
 		unregister_pernet_subsys(&iptable_filter_net_ops);
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 62cbb8c..bd294b4 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -128,7 +128,8 @@ static int __init iptable_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	mangle_ops = xt_hook_link(&packet_mangler, iptable_mangle_hook);
+	mangle_ops = xt_hook_link(&init_net, &packet_mangler,
+				  iptable_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
 		ret = PTR_ERR(mangle_ops);
 		unregister_pernet_subsys(&iptable_mangle_net_ops);
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 0356e6d..2541383 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -69,7 +69,7 @@ static int __init iptable_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_link(&packet_raw, iptable_raw_hook);
+	rawtable_ops = xt_hook_link(&init_net, &packet_raw, iptable_raw_hook);
 	if (IS_ERR(rawtable_ops)) {
 		ret = PTR_ERR(rawtable_ops);
 		unregister_pernet_subsys(&iptable_raw_net_ops);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 4bce398..0a0ddc7 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -86,7 +86,8 @@ static int __init iptable_security_init(void)
         if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_link(&security_table, iptable_security_hook);
+	sectbl_ops = xt_hook_link(&init_net, &security_table,
+				  iptable_security_hook);
 	if (IS_ERR(sectbl_ops)) {
 		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 5c33d8a..fe0bf52 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -82,7 +82,8 @@ static int __init ip6table_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, ip6table_filter_hook);
+	filter_ops = xt_hook_link(&init_net, &packet_filter,
+				  ip6table_filter_hook);
 	if (IS_ERR(filter_ops)) {
 		ret = PTR_ERR(filter_ops);
 		goto cleanup_table;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index b551f5b..50fea9e 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -122,7 +122,8 @@ static int __init ip6table_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	mangle_ops = xt_hook_link(&packet_mangler, ip6table_mangle_hook);
+	mangle_ops = xt_hook_link(&init_net, &packet_mangler,
+				  ip6table_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
 		ret = PTR_ERR(mangle_ops);
 		goto cleanup_table;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 0b33caa..141604f 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -61,7 +61,7 @@ static int __init ip6table_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_link(&packet_raw, ip6table_raw_hook);
+	rawtable_ops = xt_hook_link(&init_net, &packet_raw, ip6table_raw_hook);
 	if (IS_ERR(rawtable_ops)) {
 		ret = PTR_ERR(rawtable_ops);
 		goto cleanup_table;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index fcef83c..8d252f8 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -78,7 +78,8 @@ static int __init ip6table_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_link(&security_table, ip6table_security_hook);
+	sectbl_ops = xt_hook_link(&init_net, &security_table,
+				  ip6table_security_hook);
 	if (IS_ERR(sectbl_ops)) {
 		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0891564..fb846d6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1177,7 +1177,8 @@ static const struct file_operations xt_target_ops = {
  * This function will take care of creating and registering the necessary
  * Netfilter hooks for XT tables.
  */
-struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
+struct nf_hook_ops *xt_hook_link(struct net *net, const struct xt_table *table,
+				 nf_hookfn *fn)
 {
 	unsigned int hook_mask = table->valid_hooks;
 	uint8_t i, num_hooks = hweight32(hook_mask);
@@ -1201,7 +1202,7 @@ struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
 		++i;
 	}
 
-	ret = nf_register_hooks(&init_net, ops, num_hooks);
+	ret = nf_register_hooks(net, ops, num_hooks);
 	if (ret < 0) {
 		kfree(ops);
 		return ERR_PTR(ret);
-- 
1.7.10.4

