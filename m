From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: crash in death_by_timeout()
Date: Tue, 18 Nov 2008 23:25:50 +0100
Message-ID: <492340EE.1020607@netfilter.org>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010306050300020505010001"
Cc: BORBELY Zoltan <bozo@andrews.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44100 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753569AbYKRW0I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:26:08 -0500
In-Reply-To: <4922C2D0.9060207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010306050300020505010001
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> BORBELY Zoltan wrote:
>>> On Tue, Nov 18, 2008 at 12:07:20PM +0100, Patrick McHardy wrote:
>>>>> --- /tmp/nf_conntrack_netlink.c-orig    2008-09-29
>>>>> 23:28:55.000000000 +0200
>>>>> +++ /tmp/nf_conntrack_netlink.c    2008-09-29 23:29:11.000000000 +0200
>>>>> @@ -1177,8 +1177,8 @@
>>>>>          ct->master = master_ct;
>>>>>      }
>>>>>  -    add_timer(&ct->timeout);
>>>>>      nf_conntrack_hash_insert(ct);
>>>>> +    add_timer(&ct->timeout);
>>>>>      rcu_read_unlock();
>>>> That code looks very fishy. We should be holding the conntrack lock,
>>>> otherwise the addition is not only racy against the timer, but also
>>>> against addition of identical conntracks. Let me look into what
>>>> happened here.
>>>
>>> We have experienced a lot of kernel crashes, _every time_ in the
>>> death_by_timeout() function while we were trying to add a new conntrack
>>> entry from userspace via netlink (attached the disassembled version
>>> of the function, ===> points to the EIP upon the crash). There was a
>>> possibility, that we tried to add conntrack entries with zero timeout
>>> value, maybe it's necessary to trigger this crash. The previous patch
>>> has definitly solved the problem for us.
>>>
>>> I've got photos from various crashes, but it takes a little time to
>>> find them. Please let me know if you want to see them.
>>
>> Thats not necessary, the problem is pretty obvious, I was mainly
>> wondering at what point we broke it.
>>
>> I'll send you a patch soon.
> 
> Could you try whether this patch fixes the problem?
> 
> Pablo, do you recall the reason why the lock isn't held in
> ctnetlink_create_conntrack()?

The creation is done under the nfnl_mutex so that requests to create
identical entries cannot race. Of course, this is not enough to avoid
the race with the timer if we set a very small timer for a conntrack :(.

AFAICS, we don't need to enclose the whole conntrack creation path.
Would you prefer the patch attached? This patch should apply fine to
2.6.28-rc.

I can send this patch to -stable. BTW, this patch may conflict with my
patch enqueued for 2.6.29 that adds userspace reporting, let me know if
I can give you a hand in some way (like sending it on top of this one or
yours again, whatever).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010306050300020505010001
Content-Type: text/x-diff;
 name="fix-creation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-creation.patch"

netfilter: ctnetlink: fix racy timer in the creation path

If we set a very small timer for new conntrack created via
ctnetlink, the entry may expire before it is in the hashes,
resulting in a crash. To fix this problem, the timer
addition and the insertion into the hashes is done holding
the nf_conntrack spin lock bh.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h |    2 +-
 net/netfilter/nf_conntrack_core.c    |    7 ++-----
 net/netfilter/nf_conntrack_netlink.c |    4 +++-
 3 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b76a868..a05e2e2 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -197,7 +197,7 @@ extern void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced,
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple);
 
-extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+extern void __nf_conntrack_insert(struct nf_conn *ct);
 
 extern void nf_conntrack_flush(struct net *net);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 622d7c6..22246ec 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -298,18 +298,15 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 			   &net->ct.hash[repl_hash]);
 }
 
-void nf_conntrack_hash_insert(struct nf_conn *ct)
+void __nf_conntrack_insert(struct nf_conn *ct)
 {
 	unsigned int hash, repl_hash;
 
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-
-	spin_lock_bh(&nf_conntrack_lock);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
-	spin_unlock_bh(&nf_conntrack_lock);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
+EXPORT_SYMBOL_GPL(__nf_conntrack_insert);
 
 /* Confirm a connection given skb; places it in hash table */
 int
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b132124..2eb8fd3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1151,8 +1151,10 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		ct->master = master_ct;
 	}
 
+	spin_lock_bh(&nf_conntrack_lock);
 	add_timer(&ct->timeout);
-	nf_conntrack_hash_insert(ct);
+	__nf_conntrack_insert(ct);
+	spin_unlock_bh(&nf_conntrack_lock);
 	rcu_read_unlock();
 
 	return 0;

--------------010306050300020505010001--
