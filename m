From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 18:12:36 +0200
Message-ID: <20100211161235.GA4099@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:39886 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0BKQMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:12:37 -0500
Received: by fg-out-1718.google.com with SMTP id 19so22552fgg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 08:12:35 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Calling POST_ROUTING hook with NULL input device is not going to work.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/iptable_mangle.c  |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -85,7 +85,7 @@ iptable_mangle_hook(unsigned int hook,
 		     const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
+	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
 		return ipt_local_hook(hook, skb, in, out, okfn);
 
 	/* PREROUTING/INPUT/FORWARD: */
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -79,7 +79,7 @@ ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
+	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
 		return ip6t_local_out_hook(hook, skb, out, okfn);
 
 	/* INPUT/FORWARD */
