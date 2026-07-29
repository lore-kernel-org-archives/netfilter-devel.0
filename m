Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C50C40EBB2
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317633; cv=none; b=iXoZB4HoorozM+kUSmKjjJvnHS7P4fVvHbA4qznrRgcyDTxZFnhtVPzyCYQ3TiB0LKxgxN7wBprCbl52uWPSMWKF+l+94DtRB9Pb7s7ktpIUC0rXPQ6R/Mbz2Vmm6IOoThp9upzKYyPo4g4f4oQpcb76Bq7SOeEjcojsSXcSeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317633; c=relaxed/simple;
	bh=xdtGxRvgKH79HJPSSoq6L4P8aZhFA0dSOVsU3HhJqU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SEvtoNvSiwacQ2ot0KH3JlbX/xqDDRGXLEZFvfMrrOGHaByQcpuMrQdeQVBZT7sQTnKVBO/kji/xpkG01hNjzJpjFijo10BnnD6QfMtkE+6AkSfkJcbI6S/Ir+u0+xuT4I0rjLHcA2FjHvT2GEKqXWOIEsqpslbUSK7PUESERLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nt1k464J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zc0OheEP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C/RZem1Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vsOn2qkR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nt1k464J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zc0OheEP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C/RZem1Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vsOn2qkR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 21B707C9DC;
	Wed, 29 Jul 2026 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785317624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbTwvz97aE2JyMyU+7iLR5uHygL66jAeLuo2ZNB3/Kg=;
	b=nt1k464Jk6KwULKxaW/lAfQvJXJ8uuRDa0G+yE+E84hJAoeYAAXd2FfnRNXkS4PtWBqkCM
	P0bMUK9EQ2TreSLOwfHEvsesHPBu9W6obpuBbE911aqhMopm7vthUcZ0OPlqb6IDvKbSnn
	mD/dvo/lmDvehqXXJYOo9NCYc+lI6V0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785317624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbTwvz97aE2JyMyU+7iLR5uHygL66jAeLuo2ZNB3/Kg=;
	b=zc0OheEP7I9Epl5cfMzbulkxZkIPqfRp5GNiMJVoscPcudJXTf7bZF43xV+5PP2oxlTfIq
	uuRbuGsyMhx7nRBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785317620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbTwvz97aE2JyMyU+7iLR5uHygL66jAeLuo2ZNB3/Kg=;
	b=C/RZem1YXJXJEjU7o7LTEYoKQq3sfjhpI8yWhUdiUu+AvhrPMj5sG3fwtAJ3s8nGONTenx
	BFpcknF8PkvFInq2K53RL8zbx0iAA9NGtTTasR4w1oyRiBtlQEcy+v7fhXLYJ+oU4Al2ZT
	+TqGUQQXkPKLNLm9PVfgHU0Ii3NKzn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785317620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbTwvz97aE2JyMyU+7iLR5uHygL66jAeLuo2ZNB3/Kg=;
	b=vsOn2qkRkinhYOMIjyjK/h9MGkyaeSdF2S2P51xl+dnxsDdfQAxcTvvh+e9epS8xfZayyM
	Jztjtq+wyVC44OAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE9A1779A1;
	Wed, 29 Jul 2026 09:33:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F9JlN/PIaWq+DwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 29 Jul 2026 09:33:39 +0000
Message-ID: <5ee31f48-b783-4e2a-8c35-933ef7fd9a66@suse.de>
Date: Wed, 29 Jul 2026 11:33:24 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nf_tables: call skb_valid_dst() before
 skb_dst()
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260728084006.101762-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260728084006.101762-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo,netfilter.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 7/28/26 10:40 AM, Pablo Neira Ayuso wrote:
> When fetching the dst_entry from the skb, check if it valid, ie. this is
> not a template dst.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Pablo,

I used a coccinelle script to see if this pattern is present in other 
places. So far in Netfilter I have found this in 
net/ipv6/netfilter/nf_reject_ipv6.c:nf_send_reset6()

         if (!skb_dst(oldskb)) {
                 nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
                 if (!dst)
                         return;
                 skb_dst_set(oldskb, dst);
         }

If I am not wrong the same problem happens here too.

> ---
>   net/netfilter/nft_meta.c | 6 ++++--
>   net/netfilter/nft_rt.c   | 6 ++++--
>   net/netfilter/nft_xfrm.c | 9 ++++++++-
>   3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 0a43e0787a68..01cfbaa36525 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -20,6 +20,7 @@
>   #include <net/dst.h>
>   #include <net/ip.h>
>   #include <net/sock.h>
> +#include <net/dst_metadata.h>
>   #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
>   #include <net/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables_core.h>
> @@ -279,11 +280,12 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
>   static noinline bool
>   nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
>   {
> -	const struct dst_entry *dst = skb_dst(skb);
> +	const struct dst_entry *dst;
>   
> -	if (!dst)
> +	if (!skb_valid_dst(skb))
>   		return false;
>   
> +	dst = skb_dst(skb);
>   	*dest = dst->tclassid;
>   	return true;
>   }
> diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
> index aeb0094eafd8..841c863a08db 100644
> --- a/net/netfilter/nft_rt.c
> +++ b/net/netfilter/nft_rt.c
> @@ -8,6 +8,7 @@
>   #include <linux/netfilter.h>
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/dst.h>
> +#include <net/dst_metadata.h>
>   #include <net/ip6_route.h>
>   #include <net/route.h>
>   #include <net/netfilter/nf_tables.h>
> @@ -59,10 +60,11 @@ void nft_rt_get_eval(const struct nft_expr *expr,
>   	u32 *dest = &regs->data[priv->dreg];
>   	const struct dst_entry *dst;
>   
> -	dst = skb_dst(skb);
> -	if (!dst)
> +	if (!skb_valid_dst(skb))
>   		goto err;
>   
> +	dst = skb_dst(skb);
> +
>   	switch (priv->key) {
>   #ifdef CONFIG_IP_ROUTE_CLASSID
>   	case NFT_RT_CLASSID:
> diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
> index 8cec43064319..c8bba697f993 100644
> --- a/net/netfilter/nft_xfrm.c
> +++ b/net/netfilter/nft_xfrm.c
> @@ -12,6 +12,7 @@
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables_core.h>
>   #include <net/netfilter/nf_tables.h>
> +#include <net/dst_metadata.h>
>   #include <linux/in.h>
>   #include <net/xfrm.h>
>   
> @@ -177,9 +178,15 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
>   				  struct nft_regs *regs,
>   				  const struct nft_pktinfo *pkt)
>   {
> -	const struct dst_entry *dst = skb_dst(pkt->skb);
> +	const struct dst_entry *dst;
>   	int i;
>   
> +	if (!skb_valid_dst(pkt->skb)) {
> +		regs->verdict.code = NFT_BREAK;
> +		return;
> +	}
> +
> +	dst = skb_dst(pkt->skb);
>   	for (i = 0; dst && dst->xfrm;
>   	     dst = ((const struct xfrm_dst *)dst)->child, i++) {
>   		if (i < priv->spnum)

