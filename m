From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Wed, 9 Nov 2011 01:16:35 +0300
Message-ID: <20111108221634.GA13261@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: alex@alex.org.uk, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1KHWQk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:16:40 -0500
Received: by bke11 with SMTP id 11so873944bke.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Nov 2011 14:16:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for delay.

I recall myself writing that net->nfnl NULL check is racy or
something like that (but I can't find this email in archives).

I've read the code once again, and I'm quite sure,
NULL ->nfnl check is correct if RCU precautions are made.

Regarding ->report check, I think it's bogus.

If there are no listeners, there are NO listeners
and whether to report back to userspace doesn't matter.

I'm sure I'm missing something obvious here.

Please, review.
------------------------------------------------------------------
[PATCH] netfilter: fix ->nfnl NULL oops

Base on bugreport and patch by Alex Bligh.

nfnetlink and nfconntrack modules can be loaded in either order.
If nfnetlink is loaded after nfconntrack, code clearing ->nfnl socket
will be called after code which does conntrack cleanup.
However, nfconntrack "calls" into nfnetlink by dereferencing socket
pointer, and thus can't survive (see netlink_has_listeners()).

Check for NULL ->nfnl socket.

This is OK, because
a) RCU
b) dying netns has refcount 0, and no userspace which can access
   netlink socket directly or indirectly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_conntrack_netlink.c |    4 ++--
 net/netfilter/nfnetlink.c            |   11 ++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -570,7 +570,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		return 0;
 
 	net = nf_ct_net(ct);
-	if (!item->report && !nfnetlink_has_listeners(net, group))
+	if (!nfnetlink_has_listeners(net, group))
 		return 0;
 
 	skb = nlmsg_new(ctnetlink_nlmsg_size(ct), GFP_ATOMIC);
@@ -1723,7 +1723,7 @@ ctnetlink_expect_event(unsigned int events, struct nf_exp_event *item)
 	} else
 		return 0;
 
-	if (!item->report && !nfnetlink_has_listeners(net, group))
+	if (!nfnetlink_has_listeners(net, group))
 		return 0;
 
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -99,7 +99,16 @@ nfnetlink_find_client(u_int16_t type, const struct nfnetlink_subsystem *ss)
 
 int nfnetlink_has_listeners(struct net *net, unsigned int group)
 {
-	return netlink_has_listeners(net->nfnl, group);
+	struct sock *nfnl;
+
+	/*
+	 * nfnetlink and nfconntrack can be loaded legitimately in either order,
+	 * thus can die legitimately in either order.
+	 * But, no socket -- no listeners!
+	 * Refcount of dying netns is 0, there is no userspace waiting for events.
+	 */
+	nfnl = rcu_dereference(net->nfnl);
+	return nfnl && netlink_has_listeners(nfnl, group);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 
