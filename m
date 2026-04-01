Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39101377019;
	Wed,  1 Apr 2026 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075971; cv=none; b=XY849aVOuklbebE1fxpI44wU6UFlYkkNIatqOJfIOLS9aSKTEz8CHQ+rS9bVOVHdvQ2h9aT2sK9at5SHdf47GlYRG3aH2bh14yYr4pVam95oMssSLMbdAGM/kQyrwukZxHjLTHL+rj3XSQGLW5gOM9uo5G2FwnqWY4MVzGED16M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075971; c=relaxed/simple;
	bh=RMcC1RFy7SJ8yeiRPFiOJZ2LkeIQfqRlpHf4R5yQknw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0GTnb0CWqPDtKIZRulkvCDOkHlu4Vzdt1Z+IRX2reOx4V0RQV7JPHb54VhF5kvQ8NPzQgsrG+hDbbT1jOacJzXJmGn1vOgXnOgQYFTSQyU6I47ClVoYTbOMGIadv/YvZSqfeMQ7bO6GV4T8wkMFe3mbT6i9O1yhz9O7YprKhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 66ABA605E7; Wed, 01 Apr 2026 22:39:25 +0200 (CEST)
Date: Wed, 1 Apr 2026 22:39:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Xiang Mei <xmei5@asu.edu>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, eric@inl.fr, coreteam@netfilter.org,
	netdev@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH net] netfilter: nfnetlink_log: initialize nfgenmsg in
 NLMSG_DONE terminator
Message-ID: <ac2Ce-hHidTY8Z6V@strlen.de>
References: <20260401195735.564488-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401195735.564488-1-xmei5@asu.edu>

Xiang Mei <xmei5@asu.edu> wrote:
> When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
> appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload via
> nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
> helper only zeroes alignment padding after the payload, not the payload
> itself, so four bytes of stale kernel heap data are leaked to userspace
> in the NLMSG_DONE message body.
> 
> Initialize the nfgenmsg struct after nlmsg_put(), consistent with how
> __build_packet_message() populates nfgenmsg for regular NFULNL_MSG_PACKET
> messages, to prevent leaking kernel heap data to userspace.
> 
> Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multipart messages")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/netfilter/nfnetlink_log.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index fcbe54940b2e..ad4eaf27590e 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -361,6 +361,7 @@ static void
>  __nfulnl_send(struct nfulnl_instance *inst)
>  {
>  	if (inst->qlen > 1) {
> +		struct nfgenmsg *nfmsg;
>  		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
>  						 NLMSG_DONE,
>  						 sizeof(struct nfgenmsg),

Would you mind sending a v2 that replaces nlmsg_put with nfnl_msg_put() ?

We already use this helper in __build_packet_message() and it takes
care of initialising the nfgenmsg.
