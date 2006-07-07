From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/10][CTNETLINK] Fix race condition on conntrack creation
Date: Fri, 07 Jul 2006 14:51:25 +0200
Message-ID: <44AE58CD.6060404@netfilter.org>
References: <44ADC336.1060004@netfilter.org> <44ADE6F4.2090909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44ADE6F4.2090909@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>Current conntrack creation path can run into rare race conditions, make
>>the creation process atomic.
>>
>>As side-effect, this patch simplifies the conntrack core API.
>>
>>This patch depends on [PATCH 4/10] and [PATCH 5/10]
>>
>>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> 
> Commenting on this and the next two at once, since they belong together.
> First of all, they are ordered incorrectly, the code should compile and
> stay working between all patches, otherwise it makes understanding and
> testing individual patches harder and people doing bisections will
> have unpleasant surprises. This patch uses a function that is only
> introduced two patches later and introduces a deadlock by only removing
> the lock inside ip_conntrack_hash_insert one patch later. All this looks
> like it belongs in a single patch.

Yup, this should go in a single patch, I'll merge them and resend. Sorry.

>>------------------------------------------------------------------------
>>
>>[CTNETLINK] Fix race condition on conntrack creation
>>
>>Current conntrack creation path can run into rare race conditions, make
>>the creation process atomic.
> 
> 
> In patch 5 you refer to timer activation and hash insertion. Why does
> helper lookup needs to be done inside the lock?

On helper module removal, the conntracks in the hashes are unhelped but 
the conntrack that we are about to create is not yet in hashes, and it 
will be refering to a unexistant helper. To overcome this Harald added 
the function helper_find_get() that uses appropiate module refcounting, 
so the helper can not vanish in the ctnetlink conntrack creation path. 
At the time that I was cooking the patch, I realised that we don't need 
find_get() anymore if we can move the helper lookup inside the locked 
section.

>>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>>Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
>>===================================================================
>>--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 00:15:14.000000000 +0200
>>+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 01:52:14.000000000 +0200
>>@@ -1059,13 +1059,12 @@ ctnetlink_create_conntrack(struct nfattr
>> 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
>> #endif
>> 
>>-	ct->helper = ip_conntrack_helper_find_get(rtuple);
>>-
>>-	add_timer(&ct->timeout);
>>+	/* we do no want any races on hash insertion */
>>+	write_lock_bh(&ip_conntrack_lock);
>>+	ct->helper = ip_conntrack_helper_find(rtuple);
>> 	ip_conntrack_hash_insert(ct);
>>-
>>-	if (ct->helper)
>>-		ip_conntrack_helper_put(ct->helper);
>>+	add_timer(&ct->timeout);
>>+	write_unlock_bh(&ip_conntrack_lock);
>> 
>> 	DEBUGP("conntrack with id %u inserted\n", ct->id);
>> 	return 0;
> 
> 
> I also see another race, the caller of create_conntrack does a lookup
> within locks, drops the locks and we reaquire them here. The entire
> lookup-insertion needs to be atomic.

Not really, the lookup-update must be atomic, as it is now, since the 
conntrack is in the hashes, but for the lookup-creation-insertion I 
don't see why we would need to. The conntrack that we are creating is 
not yet in the hashes, therefore we only need the locking in the step of 
timer activation and insertion.

> From patch 5:
> 
> 
>>--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c 2006-07-06
> 
> 23:27:55.000000000 +0200
> 
>>+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06
> 
> 23:28:41.000000000 +0200
> 
>>@@ -428,12 +428,12 @@ void ip_conntrack_hash_insert(struct ip_
>> {
>>	unsigned int hash, repl_hash;
>>
>>+	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
>>+	
>> 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>> 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
>>
>>-	write_lock_bh(&ip_conntrack_lock);
>> 	__ip_conntrack_hash_insert(ct, hash, repl_hash);
>>-	write_unlock_bh(&ip_conntrack_lock);
>> }
> 
> 
> Since we already have the hash values in the caller of create_conntrack
> and should hold the locks across the lookup-insertion anyway I think
> this obsoletes this entire function.

Same comment as above.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
