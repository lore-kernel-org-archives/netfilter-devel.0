Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA75238DE9
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2024 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715034635; cv=none; b=a9fg9+al4v1EDADOxGfGhi5CJU94GZW5aoepizVm8XuIUmideVzGG75j2B7FfAPNMDYV0DRQRq6u0Q3oZe8RtWXB91o1Pvows1yoPp3uoJUl+Jdb6cgm1BzkfDrV2t+kpnHPglG6zJiAb54NW24vCgO4I9y1bOG2M83nVJHXOcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715034635; c=relaxed/simple;
	bh=LRzt4NJZOxG950hIXpCkIhP8EwuKlpZPela5vc+5Nbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SO9EH+CeX00rgOpLFdlNCgHowLMUDeQHtRLOFMFCvTCpLbwsXhffkb8D052rTWoaFa3AV3OYcz0lWJ+jgpwo62crzMonVwIpyA0CHvRN4Z0zCy0yubEfd5jhMyZ5/WhL+4JSaApLb2XNWQM4cdfp6DhbQBmS41WDrPE22DfzNxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 7 May 2024 00:30:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, willemb@google.com,
	edumazet@google.com
Subject: Re: [PATCH net-next 1/2] netfilter: nft_queue: compute SCTP checksum
Message-ID: <ZjlaAyG9yF47pxcA@calendula>
References: <20240503113456.864063-1-aojea@google.com>
 <20240503113456.864063-2-aojea@google.com>
 <CAAdXToSN6h9vf8wSA3aQz6wU7pkuWsE5=tQ5qNRX_oQhTxNu=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdXToSN6h9vf8wSA3aQz6wU7pkuWsE5=tQ5qNRX_oQhTxNu=Q@mail.gmail.com>

On Fri, May 03, 2024 at 02:46:27PM +0200, Antonio Ojea wrote:
> On Fri, May 3, 2024 at 1:35 PM Antonio Ojea <aojea@google.com> wrote:
> >
> > when the packet is processed with GSO and is SCTP it has to take into
> > account the SCTP checksum.
> >
> > Signed-off-by: Antonio Ojea <aojea@google.com>
> > ---
> >  net/netfilter/nfnetlink_queue.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index 00f4bd21c59b..428014aea396 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -600,6 +600,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >         case NFQNL_COPY_PACKET:
> >                 if (!(queue->flags & NFQA_CFG_F_GSO) &&
> >                     entskb->ip_summed == CHECKSUM_PARTIAL &&
> > +                   (skb_csum_is_sctp(entskb) && skb_crc32c_csum_help(entskb)) &&
> 
> My bad, this is wrong, it should be an OR so skb_checksum_help is
> always evaluated.
> Pablo suggested in the bugzilla to use a helper, so I'm not sure this
> is the right fix, I've tried
> to look for similar solutions to find a more consistent solution but
> I'm completely new to the
> kernel codebase so some guidance will be appreciated.

skb_crc32c_csum_help() returns 0 on success.

> -                   skb_checksum_help(entskb))
> +                   ((skb_csum_is_sctp(entskb) &&
> skb_crc32c_csum_help(entskb)) ||
> +                   skb_checksum_help(entskb)))

skb_crc32c_csum_help() returns 0 on success, then this calls
skb_checksum_help() which is TCP/UDP specific, which corrupts the
packet.

I think you have to move this to a helper function like:

static int nf_queue_checksum_help(struct sk_buff *entskb)
{
        if (skb_csum_is_sctp(entskb))
                return skb_crc32c_csum_help(entskb);

        return skb_checksum_help(entskb);
}

I can see skb_crc32c_csum_help() could return -EINVAL, the fallback to
skb_checksum_help() is not wanted there in such case.

Thanks.
