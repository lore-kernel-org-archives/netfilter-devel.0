From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] #ifdef ->iptable_security, ->ip6table_security
Date: Sat, 16 Jan 2010 20:04:17 +0200
Message-ID: <20100116180417.GA9527@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36432 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0APSEZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:04:25 -0500
Received: by fxm7 with SMTP id 7so202134fxm.28
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2010 10:04:23 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'security' tables depend on SECURITY, so ifdef them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/netns/ipv4.h |    2 ++
 include/net/netns/ipv6.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -37,7 +37,9 @@ struct netns_ipv4 {
 	struct xt_table		*iptable_mangle;
 	struct xt_table		*iptable_raw;
 	struct xt_table		*arptable_filter;
+#ifdef CONFIG_SECURITY
 	struct xt_table		*iptable_security;
+#endif
 	struct xt_table		*nat_table;
 	struct hlist_head	*nat_bysource;
 	int			nat_vmalloced;
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -36,8 +36,10 @@ struct netns_ipv6 {
 	struct xt_table		*ip6table_filter;
 	struct xt_table		*ip6table_mangle;
 	struct xt_table		*ip6table_raw;
+#ifdef CONFIG_SECURITY
 	struct xt_table		*ip6table_security;
 #endif
+#endif
 	struct rt6_info         *ip6_null_entry;
 	struct rt6_statistics   *rt6_stats;
 	struct timer_list       ip6_fib_timer;
