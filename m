From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 2/2 nf] netfilter: conntrack: fix race between
 confirmation and flush
Date: Tue, 25 Nov 2014 21:29:22 +0100
Message-ID: <20141125212922.7435923c@redhat.com>
References: <1416870887-5285-1-git-send-email-pablo@netfilter.org>
	<1416870887-5285-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: brouer@redhat.com, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com, jp.pozzi@izzop.net, programme110@gmail.com,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaKYU3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:29:40 -0500
In-Reply-To: <1416870887-5285-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Nov 2014 00:14:47 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Commit 5195c14c8b27c ("netfilter: conntrack: fix race in
> __nf_conntrack_confirm against get_next_corpse") aimed to resolve the
> race condition between the confirmation (packet path) and the flush
> command (from control plane). However, it introduced a crash when
> several packets race to add a new conntrack, which seems easier to
> reproduce when nf_queue is in place.
> 
> Fix this race, in __nf_conntrack_confirm(), by removing the CT
> from unconfirmed list before checking the DYING bit. In case
> race occured, re-add the CT to the dying list

Re-adding it (to some list) case the hash race occurs should fix the
problem (the reverted patch introduced).

> This patch also changes the verdict from NF_ACCEPT to NF_DROP when
> we lose race. Basically, the confirmation happens for the first packet
> that we see in a flow. If you just invoked conntrack -F once (which
> should be the common case), then this is likely to be the first packet
> of the flow (unless you already called flush anytime soon in the past).
> This should be hard to trigger, but better drop this packet, otherwise
> we leave things in inconsistent state since the destination will likely
> reply to this packet, but it will find no conntrack, unless the origin
> retransmits.
> 
> The change of the verdict has been discussed in:
> https://www.marc.info/?l=linux-netdev&m=141588039530056&w=2
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Note: I will check and re-test this again tomorrow morning with fresh
> mind, compile tested only.
> 
>  net/netfilter/nf_conntrack_core.c |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 5016a69..c588012 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -611,16 +611,15 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  	 */
>  	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
>  	pr_debug("Confirming conntrack %p\n", ct);
> -	/* We have to check the DYING flag inside the lock to prevent
> -	   a race against nf_ct_get_next_corpse() possibly called from
> -	   user context, else we insert an already 'dead' hash, blocking
> -	   further use of that particular connection -JM */
> +	/* We have to check the DYING flag after unlink to prevent
> +	 * a race against nf_ct_get_next_corpse() possibly called from
> +	 * user context, else we insert an already 'dead' hash, blocking
> +	 * further use of that particular connection -JM.
> +	 */
> +	nf_ct_del_from_dying_or_unconfirmed_list(ct);
>  
> -	if (unlikely(nf_ct_is_dying(ct))) {
> -		nf_conntrack_double_unlock(hash, reply_hash);
> -		local_bh_enable();
> -		return NF_ACCEPT;
> -	}
> +	if (unlikely(nf_ct_is_dying(ct)))
> +		goto out;
>  
>  	/* See if there's one in the list already, including reverse:
>  	   NAT could have grabbed it without realizing, since we're
> @@ -636,8 +635,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
>  			goto out;
>  
> -	nf_ct_del_from_dying_or_unconfirmed_list(ct);
> -
>  	/* Timer relative to confirmation time, not original
>  	   setting time, otherwise we'd get timer wrap in
>  	   weird delay cases. */
> @@ -673,6 +670,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  	return NF_ACCEPT;
>  
>  out:
> +	nf_ct_add_to_dying_list(ct);
>  	nf_conntrack_double_unlock(hash, reply_hash);
>  	NF_CT_STAT_INC(net, insert_failed);
>  	local_bh_enable();

The change looks good to me.  And we only re-add it to dying_list in
the goto "out" error cases.

I know Florian had some ideas of howto get rid of the unconfirmed list
all together (which would be a fairly good optimization), but I guess
we want a fairly simple patch for just fixing the bug first?

Thanks for taking care of this Pablo.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
