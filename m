From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in death_by_timeout()
Date: Tue, 18 Nov 2008 14:27:44 +0100
Message-ID: <4922C2D0.9060207@trash.net>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050906080206070202050504"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYKRN1u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:27:50 -0500
In-Reply-To: <4922C0F7.3050604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050906080206070202050504
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> BORBELY Zoltan wrote:
>> On Tue, Nov 18, 2008 at 12:07:20PM +0100, Patrick McHardy wrote:
>>>> --- /tmp/nf_conntrack_netlink.c-orig    2008-09-29 
>>>> 23:28:55.000000000 +0200
>>>> +++ /tmp/nf_conntrack_netlink.c    2008-09-29 23:29:11.000000000 +0200
>>>> @@ -1177,8 +1177,8 @@
>>>>          ct->master = master_ct;
>>>>      }
>>>>  -    add_timer(&ct->timeout);
>>>>      nf_conntrack_hash_insert(ct);
>>>> +    add_timer(&ct->timeout);
>>>>      rcu_read_unlock();
>>> That code looks very fishy. We should be holding the conntrack lock,
>>> otherwise the addition is not only racy against the timer, but also
>>> against addition of identical conntracks. Let me look into what
>>> happened here.
>>
>> We have experienced a lot of kernel crashes, _every time_ in the
>> death_by_timeout() function while we were trying to add a new conntrack
>> entry from userspace via netlink (attached the disassembled version
>> of the function, ===> points to the EIP upon the crash). There was a
>> possibility, that we tried to add conntrack entries with zero timeout
>> value, maybe it's necessary to trigger this crash. The previous patch
>> has definitly solved the problem for us.
>>
>> I've got photos from various crashes, but it takes a little time to
>> find them. Please let me know if you want to see them.
> 
> Thats not necessary, the problem is pretty obvious, I was mainly
> wondering at what point we broke it.
> 
> I'll send you a patch soon.

Could you try whether this patch fixes the problem?

Pablo, do you recall the reason why the lock isn't held in
ctnetlink_create_conntrack()?

--------------050906080206070202050504
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 622d7c6..233fdd2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -305,9 +305,7 @@ void nf_conntrack_hash_insert(struct nf_conn *ct)
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	spin_lock_bh(&nf_conntrack_lock);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
-	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a040d46..3b009a3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1090,7 +1090,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
 
-	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_KERNEL);
+	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_ATOMIC);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;
 
@@ -1212,13 +1212,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			atomic_inc(&master_ct->ct_general.use);
 		}
 
-		spin_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda,
 							 &otuple,
 							 &rtuple,
 							 master_ct);
+		spin_unlock_bh(&nf_conntrack_lock);
+
 		if (err < 0 && master_ct)
 			nf_ct_put(master_ct);
 

--------------050906080206070202050504--
