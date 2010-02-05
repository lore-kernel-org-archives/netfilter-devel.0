From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfiler: compat out of scope fix
Date: Sat, 6 Feb 2010 00:17:57 +0200
Message-ID: <20100205221757.GD27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, viro@zeniv.linux.org.uk
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:38661 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791Ab0BEWSF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:18:05 -0500
Received: by fxm20 with SMTP id 20so4493016fxm.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Feb 2010 14:18:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As per 6.2.4(2) when temporary table data goes out of scope,
the behaviour is undefined:

	if (compat) {
		struct foo tmp;
		...
		private = &tmp;
	}
	[dereference private]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: stable@kernel.org
---

 net/ipv4/netfilter/arp_tables.c |    4 ++--
 net/ipv4/netfilter/ip_tables.c  |    4 ++--
 net/ipv6/netfilter/ip6_tables.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -925,10 +925,10 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(NFPROTO_ARP);
 			private = &tmp;
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1137,10 +1137,10 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(AF_INET);
 			private = &tmp;
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1169,10 +1169,10 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(AF_INET6);
 			private = &tmp;
