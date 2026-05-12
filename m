Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50109367287
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778585368; cv=none; b=c7bFzUrNpPZjFQmAHWer+df++Wjqqn3R1dgX9AXgBBb8GBrJk1zBOOZz0iEEurE0y/LLH8eU9KI4u1o4iqGxW0I0Z/GqxyPnyVrutfC6ozkfgcKVJB3/TMtYsBQ/2cOok2As8djNFmQRfAZKJc8AeaMPSSos9IEnQUsVS8TQ374=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778585368; c=relaxed/simple;
	bh=6UApAOE2DjfVehBo/r0MhuDeQc/WD7MO7aza/MMoPnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfWCHNuB9koyMpxt9/HkxBFX+SbzcN47QJ2RKja72l/XzMYO9Fghhu/K7AOdCQZ9LGHGjwYPDCUxjWtCBpeb7hjBWBL0KPf/WJTxCVtqRNAgpsJk4eijkYHd1tnZe8XrOisJvQ4AZ911WxuxoQSqFiBcdtl9lQo99GLkCmL65U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E90B560613; Tue, 12 May 2026 13:29:23 +0200 (CEST)
Date: Tue, 12 May 2026 13:29:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, stephane.ml.bryant@gmail.com, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: nf_queue: hold bridge skb->dev while
 queued
Message-ID: <agMPEMOLSj_RGFfz@strlen.de>
References: <cover.1778493188.git.royenheart@gmail.com>
 <ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com>
 <agMN7WfUC7Xmc2cj@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agMN7WfUC7Xmc2cj@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, May 12, 2026 at 03:57:25PM +0800, Ren Wei wrote:
> > From: Haoze Xie <royenheart@gmail.com>
> > 
> > br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
> > master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
> > references on state.in/out and bridge physdevs, so a queued bridge
> > packet can retain a freed bridge master in skb->dev until reinjection.
> > 
> > When the verdict is reinjected later, br_netif_receive_skb() re-enters
> > the receive path with skb->dev still pointing at the freed bridge master,
> > triggering a use-after-free.
> > 
> > Store skb->dev in the queue entry for bridge builds, hold a reference on
> > it for the queue lifetime, and use the saved device when dropping queued
> > packets during NETDEV_DOWN handling.
> 
> Next attempt: Maybe hold reference on skb->dev...

> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index a6c81c04b3a5..26a4db5e17d4 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -66,6 +66,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>  	if (state->sk)
>  		nf_queue_sock_put(state->sk);
>  
> +	dev_put(entry->skb->dev);
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  	dev_put(entry->physin);
>  	dev_put(entry->physout);
> @@ -104,6 +105,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
>  
>  	dev_hold(state->in);
>  	dev_hold(state->out);
> +	dev_hold(entry->skb->dev);

We should also extend

net/netfilter/nfnetlink_queue.c:dev_cmp() to consider skb->dev, if set.

And I think skb->dev can be NULL here in output path.
