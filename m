Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693982;
	b=w2l3Bo3Vd1eZZOrCR7yxZKZp8eX8XAQynd930FIJWqqw4NfwDemrqqtCI6AFt3dsG/3/
	 4r3JDW3kZ9ySqM58p/30TEB6KA9UvctRky4491FPmvK975UEDp1XDRyb6jZXjRfVRQNwF
	 PLfPlkgpR0nv6xKjtz+vGhmrdV/HwUfLpzVXLw077HjpQZawGJcA9D6Ex05DxTzqUGw3g
	 R9id9Vh4cz3owTLZu3xFWF22kHS/ECX/7OtqA5NLclCrw17ubuIZxxkru7cNJSRQqXsOy
	 b9gTyjC0BgXTdxO26+8zCSakbZ2Q766HfqBZ21/FRCkymxcMA0A0Dw176TCIPIeERhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693982;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=wxcJuXgpIpnmTrPxZ66emot0kDZ7LimYplbMWd40hfw=;
	b=LD/5Sga/qfWAkelI6SDt/N6XsL/Ygym04tA0K7AizAq0j3SwL/EFF0yDxnKry9a6iYnf
	 JWOGxdFx54vTrff7jkhdhGMP+kSpTyoUvrvCWe51VLbZXOluohgiYMNvc+HaCLg6lWiVq
	 FJO0M5jw7nVJOv3LMqdJ3gpkspn53p5Gpt/83T5vHg2uQgcTw8BZdOLXUz24os2SryQEe
	 JF+hGuMyd7r9MtLVmQMGRNhw7AUuQ/AEv/dRrqxAQz8QAbTmIThVWPcVoeavG0ZYC4Y8H
	 zIHF2nq6Fd2yhzHJwAnQZ00CB6onLzVf7KoYVhKRV1fAeaOmxY0B8oU9xUX0cjnApTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XgCmwYc8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pWeJSdo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XgCmwYc8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pWeJSdo;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0878606A93D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 18:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0878606A93D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XgCmwYc8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pWeJSdo;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XgCmwYc8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pWeJSdo
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA1002202C;
	Thu, 22 Oct 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792693979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxcJuXgpIpnmTrPxZ66emot0kDZ7LimYplbMWd40hfw=;
	b=XgCmwYc8GWu5/e9Z/ZkLgUxbpQOAGoGhIJDGZRVNoepuKrsPOL4v74XXUL86+S6LcM0OvO
	nLjw8pd8OqTSsufbQTrfPa68pKzOyno4EUfzQ3++Jc8tYVzMSpMF9zLnF4E8OKNNHnOdwP
	YTS9vvzfzdHQOKsV/b8jrHWYHn2gma0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792693979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxcJuXgpIpnmTrPxZ66emot0kDZ7LimYplbMWd40hfw=;
	b=+pWeJSdoXNCreDFtIcfcyp06RMOsI0p75oUNKBm/iaz1K1DK8BZrIcwLM8K9fTSMRxkc60
	+1fona7CmPqXKrBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792693979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxcJuXgpIpnmTrPxZ66emot0kDZ7LimYplbMWd40hfw=;
	b=XgCmwYc8GWu5/e9Z/ZkLgUxbpQOAGoGhIJDGZRVNoepuKrsPOL4v74XXUL86+S6LcM0OvO
	nLjw8pd8OqTSsufbQTrfPa68pKzOyno4EUfzQ3++Jc8tYVzMSpMF9zLnF4E8OKNNHnOdwP
	YTS9vvzfzdHQOKsV/b8jrHWYHn2gma0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792693979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxcJuXgpIpnmTrPxZ66emot0kDZ7LimYplbMWd40hfw=;
	b=+pWeJSdoXNCreDFtIcfcyp06RMOsI0p75oUNKBm/iaz1K1DK8BZrIcwLM8K9fTSMRxkc60
	+1fona7CmPqXKrBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B326133F3;
	Thu, 22 Oct 2026 18:32:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tiHsOtpW2moWLAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 22 Oct 2026 18:32:59 +0000
Message-ID: <33f02ffd-0b32-44a8-8169-1f1c936e83ca@suse.de>
Date: Thu, 22 Oct 2026 20:32:50 +0200
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 Yu Junzhe <junzheyu1@gmail.com>
References: <20260924201328.6323-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260924201328.6323-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 9/24/26 10:13 PM, Fernando Fernandez Mancera wrote:
> nftables payload-mangling rules can rewrite packet contents (such as TCP
> flags) before they are evaluated by reject targets. This defeats the
> content-based loop guards, allowing unbounded hook recursion that leads
> to kernel stack exhaustion and panics.
> 
> Fix this by extracting the per-CPU xmit recursion limit previously used
> by the netdev duplication/forwarding paths into a shared header, and
> apply it to the inet and inet6 reject transmit functions. It disables BH
> while transmitting the skb to address a possible migration to different
> CPU leading to imbalanced decrementation of the recursion counters.
> 
> Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
> enabled does not require this recursion guard. In that scenario, the
> generated reset packet is transmitted directly at Layer 2. Because the
> packet egresses from a different hook, it cannot synchronously loop. In
> addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
> transmit functions are protected against recursion by the
> icmp_xmit_lock() and icmpv6_xmit_lock() guards.
> 
> Reported-by: Yu Junzhe <junzheyu1@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/20260921061320.543-1-junzheyu1@gmail.com/
> Fixes: bee11dc78fc8 ("netfilter: nft_reject: support for IPv6 and TCP reset")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v3: fixed build robot errors due to the struct member being guarded by
> CONFIG_NF_DUP_NETDEV instead of CONFIG_NETFILTER and renamed the struct
> member too.

Is there something missing for this patch? It would be nice if we can 
get this in the next nf.git since it was discover by a real user (or it 
looks like so).

> ---
>   include/linux/netdevice_xmit.h        |  4 +--
>   include/net/netfilter/nf_dup_netdev.h | 35 ----------------------
>   include/net/netfilter/nf_recursion.h  | 42 +++++++++++++++++++++++++++
>   net/ipv4/netfilter/nf_reject_ipv4.c   | 12 ++++++++
>   net/ipv6/netfilter/nf_reject_ipv6.c   | 13 +++++++++
>   net/netfilter/nf_dup_netdev.c         |  1 +
>   net/netfilter/nft_fwd_netdev.c        |  1 +
>   7 files changed, 71 insertions(+), 37 deletions(-)
>   create mode 100644 include/net/netfilter/nf_recursion.h
> 
> diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
> index cc232508e695..286ae5a6101e 100644
> --- a/include/linux/netdevice_xmit.h
> +++ b/include/linux/netdevice_xmit.h
> @@ -18,8 +18,8 @@ struct netdev_xmit {
>   	u8			sched_mirred_nest;
>   	struct net_device	*sched_mirred_dev[MIRRED_NEST_LIMIT];
>   #endif
> -#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
> -	u8 nf_dup_skb_recursion;
> +#if IS_ENABLED(CONFIG_NETFILTER)
> +	u8 nf_xmit_skb_recursion;
>   #endif
>   };
>   
> diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> index f6b05bd80c3f..a39411264614 100644
> --- a/include/net/netfilter/nf_dup_netdev.h
> +++ b/include/net/netfilter/nf_dup_netdev.h
> @@ -9,41 +9,6 @@
>   void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>   void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>   
> -#define NF_RECURSION_LIMIT	2
> -
> -#ifndef CONFIG_PREEMPT_RT
> -static inline bool nf_dev_xmit_recursion(void)
> -{
> -	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
> -			NF_RECURSION_LIMIT);
> -}
> -
> -static inline void nf_dev_xmit_recursion_inc(void)
> -{
> -	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
> -}
> -
> -static inline void nf_dev_xmit_recursion_dec(void)
> -{
> -	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
> -}
> -#else
> -static inline bool nf_dev_xmit_recursion(void)
> -{
> -	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
> -}
> -
> -static inline void nf_dev_xmit_recursion_inc(void)
> -{
> -	current->net_xmit.nf_dup_skb_recursion++;
> -}
> -
> -static inline void nf_dev_xmit_recursion_dec(void)
> -{
> -	current->net_xmit.nf_dup_skb_recursion--;
> -}
> -#endif
> -
>   struct nft_offload_ctx;
>   struct nft_flow_rule;
>   
> diff --git a/include/net/netfilter/nf_recursion.h b/include/net/netfilter/nf_recursion.h
> new file mode 100644
> index 000000000000..1ac65f7793f1
> --- /dev/null
> +++ b/include/net/netfilter/nf_recursion.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _NF_RECURSION_H_
> +#define _NF_RECURSION_H_
> +
> +#include <linux/netdevice.h>
> +
> +#define NF_RECURSION_LIMIT	2
> +
> +#ifndef CONFIG_PREEMPT_RT
> +static inline bool nf_dev_xmit_recursion(void)
> +{
> +	return unlikely(__this_cpu_read(softnet_data.xmit.nf_xmit_skb_recursion) >
> +			NF_RECURSION_LIMIT);
> +}
> +
> +static inline void nf_dev_xmit_recursion_inc(void)
> +{
> +	__this_cpu_inc(softnet_data.xmit.nf_xmit_skb_recursion);
> +}
> +
> +static inline void nf_dev_xmit_recursion_dec(void)
> +{
> +	__this_cpu_dec(softnet_data.xmit.nf_xmit_skb_recursion);
> +}
> +#else
> +static inline bool nf_dev_xmit_recursion(void)
> +{
> +	return unlikely(current->net_xmit.nf_xmit_skb_recursion > NF_RECURSION_LIMIT);
> +}
> +
> +static inline void nf_dev_xmit_recursion_inc(void)
> +{
> +	current->net_xmit.nf_xmit_skb_recursion++;
> +}
> +
> +static inline void nf_dev_xmit_recursion_dec(void)
> +{
> +	current->net_xmit.nf_xmit_skb_recursion--;
> +}
> +#endif
> +
> +#endif /* _NF_RECURSION_H_ */
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 59ec465a9df9..3f227a094312 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -10,6 +10,7 @@
>   #include <net/dst.h>
>   #include <net/dst_metadata.h>
>   #include <net/netfilter/ipv4/nf_reject.h>
> +#include <net/netfilter/nf_recursion.h>
>   #include <linux/netfilter_ipv4.h>
>   #include <linux/netfilter_bridge.h>
>   
> @@ -336,7 +337,18 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>   		dev_queue_xmit(nskb);
>   	} else
>   #endif
> +	{
> +		local_bh_disable();
> +		if (nf_dev_xmit_recursion()) {
> +			local_bh_enable();
> +			goto free_nskb;
> +		}
> +
> +		nf_dev_xmit_recursion_inc();
>   		ip_local_out(net, nskb->sk, nskb);
> +		nf_dev_xmit_recursion_dec();
> +		local_bh_enable();
> +	}
>   
>   	return;
>   
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index 07cdaa10da0d..f69ddfe72030 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -10,6 +10,7 @@
>   #include <net/ip6_checksum.h>
>   #include <net/dst_metadata.h>
>   #include <net/netfilter/ipv6/nf_reject.h>
> +#include <net/netfilter/nf_recursion.h>
>   #include <linux/netfilter_ipv6.h>
>   #include <linux/netfilter_bridge.h>
>   
> @@ -409,7 +410,19 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>   		dev_queue_xmit(nskb);
>   	} else
>   #endif
> +	{
> +		local_bh_disable();
> +		if (nf_dev_xmit_recursion()) {
> +			local_bh_enable();
> +			kfree_skb(nskb);
> +			return;
> +		}
> +
> +		nf_dev_xmit_recursion_inc();
>   		ip6_local_out(net, sk, nskb);
> +		nf_dev_xmit_recursion_dec();
> +		local_bh_enable();
> +	}
>   }
>   EXPORT_SYMBOL_GPL(nf_send_reset6);
>   
> diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> index c6bd5c29bed6..918716629c15 100644
> --- a/net/netfilter/nf_dup_netdev.c
> +++ b/net/netfilter/nf_dup_netdev.c
> @@ -12,6 +12,7 @@
>   #include <net/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables_offload.h>
>   #include <net/netfilter/nf_dup_netdev.h>
> +#include <net/netfilter/nf_recursion.h>
>   
>   static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
>   				enum nf_dev_hooks hook)
> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index a48c2f765bba..7447da931a95 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -14,6 +14,7 @@
>   #include <net/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables_offload.h>
>   #include <net/netfilter/nf_dup_netdev.h>
> +#include <net/netfilter/nf_recursion.h>
>   #include <net/neighbour.h>
>   #include <net/ip.h>
>   

