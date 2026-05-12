Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E7F21CFE0
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778583827; cv=none; b=SxkYXcIVQqRz5e+f2jA+B68eWwgHzlacfpEy58SnYXBkuex3awjFO23aJfMbwYm0TroridBmz77V4rmLRAHljTNTf7xCrLdfB+HsHYHhQS1U3asNj+k3wBdfp3X4YJB2jaU+j8DKQGdehnXoQ8sRR5q2b170Y4X/BPF5dya1iUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778583827; c=relaxed/simple;
	bh=tEiSrHD31zlZUDMW24yXMxaQw5PQHY+3hUBoO55bm7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRSw5XoOC2oO16L+1xqB/MV5YclgvFUGxbJYz6WurUYm7IowuEasRoLT00/pr/AXWh5MnflcVghDlbMwEkoYjaY+adWkTEQZXS+DhcDzQpLBFSqxRmw7D8RMcmlZGw+zg46fUJ60N69ckFWj4URXVXrJ3h+DtjzP+iWjsVIAXBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kds2NCiA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kds2NCiA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 53C296017E;
	Tue, 12 May 2026 13:03:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778583824;
	bh=SRB3w9dHXz311fb7OV3TOm1VpZb7ZrfpEBaeZ+hy9U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kds2NCiAG+INsVw3C34g48RwgjFUOMUOEx8v95dfZM+p3+J+A0vJKDw7L/AsSkJAe
	 dAbA9UnWIKhb7+SZWg9rKMjGvPqMMQKQjjbJSzuavfRHQtjimhaoluZsFFKxrfQgMa
	 wwUoygSY6dasygH6iI3mktB+D8HHjPp67fzb+/kIoZ0093jL+8DGfIOTbwoesmBZbc
	 2hBQyhKXCcpxTrCJWcL8sqt/wvtk9gvpVpPKaN+sGuZW6upaJ6xxPLyZDg8aKINegp
	 4uCFKRsAckTHmgNDGasXdGq9QcRbMqstm1M55SkqYDVZ1oZ9HrS5dUTtHaRs6j7bDV
	 e03PNXxK9jZLQ==
Date: Tue, 12 May 2026 13:03:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	stephane.ml.bryant@gmail.com, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: nf_queue: hold bridge skb->dev while
 queued
Message-ID: <agMJDiBJlL3oqSOq@chamomile>
References: <cover.1778493188.git.royenheart@gmail.com>
 <ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com>
 <agMCAScREzJjke_u@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agMCAScREzJjke_u@chamomile>

On Tue, May 12, 2026 at 12:33:37PM +0200, Pablo Neira Ayuso wrote:
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
> > 
> > Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
> > Cc: stable@kernel.org
> > Reported-by: Yuan Tan <yuantan098@gmail.com>
> > Reported-by: Yifan Wu <yifanwucs@gmail.com>
> > Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> > Reported-by: Xin Liu <bird@lzu.edu.cn>
> > Tested-by: Haoze Xie <royenheart@gmail.com>
> > Signed-off-by: Haoze Xie <royenheart@gmail.com>
> > Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> > ---
> >  include/net/netfilter/nf_queue.h | 1 +
> >  net/netfilter/nf_queue.c         | 5 +++++
> >  net/netfilter/nfnetlink_queue.c  | 3 +++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> > index d17035d14d96..1e7eb8e85932 100644
> > --- a/include/net/netfilter/nf_queue.h
> > +++ b/include/net/netfilter/nf_queue.h
> > @@ -17,6 +17,7 @@ struct nf_queue_entry {
> >  	unsigned int		id;
> >  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
> >  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> > +	struct net_device	*skb_dev;
> 
> patch is not correct, this is only fixing it for br_netfilter.
> 
> >  	struct net_device	*physin;
> >  	struct net_device	*physout;
> >  #endif
> 
> Maybe normalize this special case with this patch instead? I will
> propose it to the bridge maintainer.
> 
> It is strange that skb->dev != indev.
> 
> I have to take a second look, but I don't a usecase where skb->dev is
> used in the netfilter tree can could break.

Scratch this proposal, it also breaks.
