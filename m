Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445B93BB9FA;
	Sun, 11 Oct 2026 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730731; cv=none; b=rQo2Ir4MqppunWGCdGD2ysPArcnBbIbUhcBrSakQfZy5G1ayEIAn99rUxFTAG6bkbCBmxA+NKf3U59zstrkXa6RbbH3Zyswp1neNIOe2uTBze/PJCXoi/TbpznzrlkrpZIvE7SzHaa3Kd6mu2FhibL5iXYOzRzyIP71lwOdo/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730731; c=relaxed/simple;
	bh=OBCNmVTTVR79iK7xPFxybcN8jLC2FdjCKnvkb0K8zwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao5TRfY5IZPtzuhZz8Uwt6LrqcJ5M+6iiIGEnygl28TqlbnV9tFSnPdNscxPx5wZi2f5K3LCr/bkctAkBNlYw+KA0iwkVZkGmgpA4iT9jOzkX6DalwhXAYi/K7tMyFTAQ7/PNWsFUN0fXiRLR73pVZ4P4mHethEFlyHg2gxLc54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C6803602F5; Sun, 11 Oct 2026 16:58:40 +0200 (CEST)
Date: Sun, 11 Oct 2026 16:58:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, pablo@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	jengelh@medozas.de, lukas@wunner.de, vega@nebusec.ai,
	root@tr0jan.top
Subject: Re: [PATCH nf v7 1/1] netfilter: nf_dup: preserve duplication guard
 across NFQUEUE
Message-ID: <asukIMajFpbzx3PH@strlen.de>
References: <cover.1791688819.git.zihanx@nebusec.ai>
 <9c51ddfce3069d585b6c9b87e7e1bf3a3b0a2761.1791688819.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c51ddfce3069d585b6c9b87e7e1bf3a3b0a2761.1791688819.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> nf_dup_ipv4() and nf_dup_ipv6() set current->in_nf_duplicate while the
> cloned skb traverses output hooks. NFQUEUE can retain the clone and return
> NF_STOLEN while that traversal is in progress. Once ip_local_out() or
> ip6_local_out() returns, the task-local guard is cleared. NF_ACCEPT then
> resumes hook traversal after the queued hook in the verdict task, where
> the guard is no longer set. A later dup rule can clone the packet again,
> causing repeated packet processing and resource consumption.

I find this waaaaay too complex.

>  include/linux/sched.h            |  2 ++
>  include/net/netfilter/nf_queue.h |  1 +
>  net/ipv4/netfilter/ip_tables.c   |  5 ++++-
>  net/ipv4/netfilter/nf_dup_ipv4.c |  5 ++++-
>  net/ipv6/netfilter/ip6_tables.c  |  5 ++++-
>  net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++++-
>  net/netfilter/nf_dup_netdev.c    | 13 ++++++++++++-
>  net/netfilter/nf_queue.c         |  4 ++++
>  net/netfilter/nfnetlink_queue.c  |  8 +++++++-
>  9 files changed, 43 insertions(+), 6 deletions(-)

Holy cow...  This is waaaay to large/complex, sorry.

>  	unsigned			in_nf_duplicate:1;
> +	unsigned			in_nf_dup_netdev:1;	/* netdev dup output is active */
> +	unsigned			in_nf_duplicate_reinject:1;	/* NFQUEUE resume */

I don't understand this.

>  	struct nf_hook_state	state;
> +	bool			in_nf_duplicate;	/* skb is on a duplication path */

OK.

> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 809441ced..7c2027ef8 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -14,6 +14,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/netdevice.h>
>  #include <linux/module.h>
> +#include <linux/preempt.h>
>  #include <net/ip.h>
>  #include <net/compat.h>
>  #include <linux/uaccess.h>
> @@ -270,7 +271,9 @@ ipt_do_table(void *priv,
>  	 * but it is no problem since absolute verdict is issued by these.
>  	 */
>  	if (static_key_false(&xt_tee_enabled))
> -		jumpstack += private->stacksize * current->in_nf_duplicate;
> +		jumpstack += private->stacksize *
> +			     (current->in_nf_duplicate ||
> +			      (in_task() && current->in_nf_duplicate_reinject));

?  Aside from me not getting the need for in_nf_duplicate_reinject, why
is the in_task() needed but for in_nf_duplicate its not needed...?

As those are bits they even reside on same address...

>  {
>  	struct iphdr *iph;
> +	bool in_nf_duplicate_reinject = in_task() &&
> +					current->in_nf_duplicate_reinject;

Same question.

>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> @@ -219,6 +220,9 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
>  	*entry = (struct nf_queue_entry) {
>  		.skb	= skb,
>  		.skb_dev = skb->dev,
> +		.in_nf_duplicate = current->in_nf_duplicate ||
> +				  (in_task() && current->in_nf_duplicate_reinject) ||
> +				  current->in_nf_dup_netdev,

Why not simply

	.in_nf_dup_netdev = current->in_nf_duplicate ?


> +	bool old_in_nf_duplicate_reinject;
>  
>  	net = entry->state.net;
>  	pf = entry->state.pf;
> +	old_in_nf_duplicate_reinject = current->in_nf_duplicate_reinject;
> +	current->in_nf_duplicate_reinject |= entry->in_nf_duplicate;

Don't understand the need to store the old current state here.
Nor the "|=".

> @@ -378,7 +382,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	if (!hooks || i >= hooks->num_hook_entries) {
>  		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
>  		nf_queue_entry_free(entry);
> -		return;
> +		goto out;
>  	}
>  
>  	hook_entry = &hooks->hooks[i];
> @@ -417,6 +421,8 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	}
>  
>  	nf_queue_entry_free(entry);
> +out:
> +	current->in_nf_duplicate_reinject = old_in_nf_duplicate_reinject;

... nor this.  AFAICS the only change we really need is to move the
local_bh_disable/enable pair to cover the hook iteration is well in
nf_reinject() to avoid BH interference clearing current->in_nf_duplicate
resp. acting on wron rect "current" task state.

I think we either need to find a way to make this patch way simpler or
go back to the "no duplication/TEE in userns".  As I already wrote
earlier, I see no use case for dup/TEE is namespaces, except for CI
maybe.

Also, I think there are many many other ways to make kernel eat lots of
RAM, so I don't think there is any need to ftarget nf tree either.

Sorry, I know you've been spinning on this for a while, but this is too
hard for me to comprehend.
