From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Thu, 31 Jul 2008 23:27:30 +0200
Message-ID: <48922E42.5050005@netfilter.org>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org> <48906E10.9020902@trash.net> <48917974.3090304@netfilter.org> <48917BD0.9050105@trash.net> <48918990.3010309@netfilter.org> <4891FBB5.1050803@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090703090109020509070405"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58046 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753987AbYGaV1v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:27:51 -0400
In-Reply-To: <4891FBB5.1050803@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090703090109020509070405
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> While reworking the patches to do it as you pointed out, I have concerns
> with the current RCU locking in ctnetlink_create_conntrack. This
> function calls nf_ct_helper_ext_add with GFP_KERNEL so that it may
> sleep. However, we hold the read-side lock. AFAIK, this is illegal.
> Therefore, whether we call it with GFP_ATOMIC or we have to perform
> another lookup.
> 
> Moreover, I think that:
> 
> rcu_assign_pointer(help->helper, helper);
> 
> should be:
> 
> help->helper = rcu_dereference(helper);

Sorry, this is bogus. As the comment states, we can remove completely
the rcu_assign_pointer, but not replace it with this.

> since we're fetching the pointer, not publishing a new object protected
> by RCU. BTW, why do we need rcu_read_unlock once the entry has been
> inserted? It should be fine to release it after the helper has been
> assigned.

This also, it's there to prevent preemption. As the helper removal can
modify the conntrack's pointer, the rcu protects also help section in
the conntrack.

But at least, the sleep is illegal.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090703090109020509070405
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[PATCH] Remove GFP_KERNEL allocation under read-side lock in ctnetlink

This patch fixes an illegal allocation with GFP_KERNEL (that may sleep) 
while holding the read-side lock.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-31 19:41:43.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-31 23:25:39.000000000 +0200
@@ -1154,7 +1154,8 @@ ctnetlink_create_conntrack(struct nlattr
 	rcu_read_lock();
 	helper = __nf_ct_helper_find(rtuple);
 	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		/* we cannot sleep holding the read-side lock */
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL) {
 			rcu_read_unlock();
 			err = -ENOMEM;

--------------090703090109020509070405--
