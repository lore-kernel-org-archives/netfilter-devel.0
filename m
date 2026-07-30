Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160CC3FCB11;
	Thu, 30 Jul 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407659; cv=none; b=sdzPsBk4wHicb599xTb2jaSMaLA1DYqdrs7VKxx/9LmoyidM1rM7VUo5VnjPlItwuyjdo3yeEK7xVdg4avYm1M/GqepOXGSgDdI11YjUOBVcaMzEfK/Qd5qNwrBOAxmVHj1WRaBPXxCpl5P8CsElceLJqoIWS+7I4XAfbMV5cw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407659; c=relaxed/simple;
	bh=VDjs4OtnE6j8ZnglnZy6Dwh/ctT+PjMsnZDnmNQscYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEUBjoCH9tPnYweN205/UjhDU4WmXGZlN98DmNuiyt+riE0oQRcXufTZlnfvrie3Zf8NkQy2Lu0Vwp7h60IWpgFIVjdZEY8dYWuV4BoYmsgHYEJcgTFzZA0NEbNzh863gCJOL4FULptpDNWGU/tIHIxLvAF0ERl6bBb/QtwR964=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cPZ1nwEO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cPZ1nwEO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 16FB160191;
	Thu, 30 Jul 2026 12:34:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785407654;
	bh=UfPf8ZXWfKgLAc1mI2b+tpJ71lX1b8byn4g+HNH8yUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPZ1nwEO/l/NyBeJZdPa/NfbRVR/obh+rzaX1CN3qSZCYp/7z8KkR6pCCyBdIW4V3
	 Bsq/mjawQqYxt+ZhwM7GTq+Emkuh/jWiZl9iW1am6gY/VU2rwkL0mWJMO6+8HYPo2B
	 T+kWONO1oPW6WhU346Q9nQIuJCY4YYcJnHpE2IR8MTSuJrYPa0xumjb6tjIxYNn6Bb
	 hRTeFxpvXvQEnL7YOWflGXuw18eIea7u4W1RCdm2hnvQUMC+lztjaP8UXnBcyjNMWz
	 +bRovztEm/X66th0RiCGYhnm4thCGHRabawYvsDwBDkyqdvEUDGaU3+glQLeEE6e3y
	 jIFDWtJzq7cZw==
Date: Thu, 30 Jul 2026 12:34:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	kaber@trash.net, zhaojignmin@hotmail.com, vega@nebusec.ai
Subject: Re: [PATCH nf v2 1/1] netfilter: validate L4 headers after userspace
 packet writes
Message-ID: <amsoo3ZjITWDE5qy@chamomile>
References: <f0efaa7d67a580488fc5e32a09683c992db35742.1785392716.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f0efaa7d67a580488fc5e32a09683c992db35742.1785392716.git.zhilinz@nebusec.ai>

On Thu, Jul 30, 2026 at 03:30:26PM +0800, Zhiling Zou wrote:
[...]
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index b8aaf39cb4d8e..562b7bf6c8777 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -28,10 +28,16 @@
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nfnetlink_queue.h>
>  #include <linux/netfilter/nf_conntrack_common.h>
> +#include <linux/icmp.h>
> +#include <linux/icmpv6.h>
>  #include <linux/list.h>
> +#include <linux/sctp.h>
>  #include <linux/cgroup-defs.h>
>  #include <linux/rhashtable.h>
>  #include <linux/jhash.h>
> +#include <linux/tcp.h>
> +#include <linux/udp.h>
> +#include <net/gre.h>
>  #include <net/gso.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h>
> @@ -1192,6 +1198,49 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  	return err;
>  }
>  
> +static bool nfqnl_validate_l4(const u8 *data, unsigned int data_len,
> +			      const struct nf_queue_entry *e, u8 proto)
> +{
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	enum ip_conntrack_info ctinfo;
> +	const struct nf_conn *ct;
> +
> +	ct = nf_ct_get(e->skb, &ctinfo);
> +	if (ct && !nf_ct_is_template(ct) && nf_ct_protonum(ct) != proto)

I think it should be easier to disallow protocol number mangling in
the IP header (layer 3 restrictions), if not done already.

> +		return false;
> +#endif
> +
> +	switch (proto) {
> +	case IPPROTO_TCP: {
> +		const struct tcphdr *th = (const struct tcphdr *)data;

This needs to use skb_header_pointer() here, you cannot assume the tcp
header is in a linear area.

> +		unsigned int thlen;
> +
> +		if (data_len < sizeof(*th))
> +			return false;
> +
> +		thlen = __tcp_hdrlen(th);
> +		if (thlen < sizeof(*th) || data_len < thlen)
> +			return false;
> +
> +		return true;
> +	}
> +	case IPPROTO_UDP:
> +		return data_len >= sizeof(struct udphdr);
> +	case IPPROTO_ICMP:
> +		return data_len >= sizeof(struct icmphdr);
> +	case IPPROTO_ICMPV6:
> +		return data_len >= sizeof(struct icmp6hdr);
> +	case IPPROTO_SCTP:
> +		return data_len >= sizeof(struct sctphdr);
> +	case IPPROTO_GRE:
> +		return data_len >= sizeof(struct gre_base_hdr);
> +	case IPPROTO_NONE:

Remove this and make it part of default and return true if protocol is
unknown.

> +		return true;
> +	}
> +
> +	return false;

Default is false for an unknown protocol, should be true.

> +}
> +
>  static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
>  				  const struct nf_queue_entry *e)
>  {
> @@ -1229,7 +1278,9 @@ static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
>  	/* support for ipopts mangling would require
>  	 * recompile + skb transport header update.
>  	 */
> -	return nfqnl_validate_ipopts(iph, e);
> +	return nfqnl_validate_ipopts(iph, e) &&
> +	       nfqnl_validate_l4((const u8 *)iph + ihl, data_len - ihl, e,
> +				 iph->protocol);
>  }
>  
>  static bool nfqnl_validate_one_exthdr(const u8 *data,
> @@ -1286,7 +1337,8 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
>  		int hdrlen;
>  
>  		if (orig_nexthdr == NEXTHDR_NONE)
> -			return true;
> +			return nfqnl_validate_l4(data, data_len, e,
> +						 new_nexthdr);
>  
>  		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
>  			return false;
> @@ -1323,7 +1375,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
>  		data += hdrlen;
>  	}
>  
> -	return true;
> +	return nfqnl_validate_l4(data, data_len, e, new_nexthdr);
>  }
>  
>  static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index 391539a1ceaa7..63cf3b4f7420d 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -1077,6 +1077,17 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
>  	return false;
>  }
>  
> +static bool nft_th_write_ok(const struct nft_pktinfo *pkt,
> +			    const struct nft_payload_set *priv)
> +{
> +	unsigned int doff = offsetof(struct tcphdr, ack_seq) + sizeof(__be32);
> +
> +	if (pkt->tprot != IPPROTO_TCP)
> +		return true;
> +
> +	return priv->offset > doff || priv->offset + priv->len <= doff;
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

maybe simply check priv->offset >= doff here?

> +}
> +
>  static void nft_payload_set_eval(const struct nft_expr *expr,
>  				 struct nft_regs *regs,
>  				 const struct nft_pktinfo *pkt)
> @@ -1115,6 +1126,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
>  	case NFT_PAYLOAD_TRANSPORT_HEADER:
>  		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
>  			goto err;
> +		if (!nft_th_write_ok(pkt, priv))
> +			goto err;
>  		offset = nft_thoff(pkt);
>  		break;
>  	case NFT_PAYLOAD_INNER_HEADER:
> -- 
> 2.43.0
