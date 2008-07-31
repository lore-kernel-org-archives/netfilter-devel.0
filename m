From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Thu, 31 Jul 2008 19:51:49 +0200
Message-ID: <4891FBB5.1050803@netfilter.org>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org> <48906E10.9020902@trash.net> <48917974.3090304@netfilter.org> <48917BD0.9050105@trash.net> <48918990.3010309@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070101050200070007000904"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45974 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbYGaRv5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:51:57 -0400
In-Reply-To: <48918990.3010309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070101050200070007000904
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Moreover, someone may remove the module in the middle just after the
>>> module loading but, well, we have lost the race in the case.
>> I'd do something similar to qdiscs etc:
>>
>> - lookup helper
>> - if not found: request_module, take lock again, repeat lookup, return
>> EAGAIN if found now
>> - in the nfnetlink command handler: if ret == EAGAIN replay message
>>
>> grep for "replay" in net/ for a few examples of this. This also
>> handles the race BTW.

While reworking the patches to do it as you pointed out, I have concerns
with the current RCU locking in ctnetlink_create_conntrack. This
function calls nf_ct_helper_ext_add with GFP_KERNEL so that it may
sleep. However, we hold the read-side lock. AFAIK, this is illegal.
Therefore, whether we call it with GFP_ATOMIC or we have to perform
another lookup.

Moreover, I think that:

rcu_assign_pointer(help->helper, helper);

should be:

help->helper = rcu_dereference(helper);

since we're fetching the pointer, not publishing a new object protected
by RCU. BTW, why do we need rcu_read_unlock once the entry has been
inserted? It should be fine to release it after the helper has been
assigned.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070101050200070007000904
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[PATCH] Fix RCU locking in ctnetlink_create_conntrack

This patch fixes an illegal allocation with GFP_KERNEL (that may sleep) 
while holding the read-side lock. Use rcu_dereference to fetch a pointer
protected by RCU instead of rcu_assign_pointer. And release the lock once
the helper has been assigned.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-31 19:41:43.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-31 19:43:13.000000000 +0200
@@ -1154,15 +1154,16 @@ ctnetlink_create_conntrack(struct nlattr
 	rcu_read_lock();
 	helper = __nf_ct_helper_find(rtuple);
 	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		/* we cannot sleep holding the read-side lock */
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL) {
 			rcu_read_unlock();
 			err = -ENOMEM;
 			goto err;
 		}
-		/* not in hash table yet so not strictly necessary */
-		rcu_assign_pointer(help->helper, helper);
+		help->helper = rcu_dereference(helper);
 	}
+	rcu_read_unlock();
 
 	/* setup master conntrack: this is a confirmed expectation */
 	if (master_ct) {
@@ -1172,7 +1173,6 @@ ctnetlink_create_conntrack(struct nlattr
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
-	rcu_read_unlock();
 
 	return 0;
 

--------------070101050200070007000904--
