Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273494;
	b=iHxjBUeEtIpBF4+aQX9D00UUb5V1Zbz5+3oV8HBhG/wwcndpdiSLrEIErlKqfvkqGBfD
	 AmbjpgoAOzHElr4Pr0LIRINLfgGW/rENkFBQf6SokIX16THmsl8TFvX2IgyMxMVnGliIi
	 IuKS/0GZjsDR3/QqcmQgGTzd66uZBWt95OSGXwoubhNjnKWRz7IWFGDIZrEqtEwaLLAlQ
	 ZHH4H2DBwm1gzqMq/YI0ixLZbSCJX/r057tH1CiiBE+g/sDjJEi9lsUr3PusmhipJ/nxk
	 PjIQXzp1nLFjGVeK80JT+STovnVr/QWFoQDK5Tr9qrMTqm/KzBsVxKdWXDGyze737Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273494;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=tjVTZSn+XDaK4kzFzUCDE27OhwqyotiavTeXKJ2X2ow=;
	b=4OpBpqwsY7tI7BH0xEeSnx7rpoWu4LumtMB1bCSbOyIAtoZBX6UzdSiZaqvVYWl2ytzr
	 GLw3fgWNWOfoDLL0+2bY1oTSaYcZ5IytQ/Cg4hOFvwyhudZIbZpJNWb22ZwyTzTltHQz+
	 sbLIzcfdU7Wdzghg0jRoaEoak15ZMcVK5Xr+UHn1OGorOdhKCa14qlCH7tjDqDTSlZ6Kg
	 hZy0xbO26Izqnvorogq0wTu70M6Un4PERYkYnMixtzLHhMZVzmr6ngWw++X5C1b/DasmD
	 05w207vCLDRVF2Y8v3GEziVOhTh8e1aAVWLrTqD4qxOv5fw80YaxYws4OgeGOczlVkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wka+4KDh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SGqzxJt1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wka+4KDh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SGqzxJt1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A9C606A327
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:31:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3A9C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wka+4KDh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SGqzxJt1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wka+4KDh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SGqzxJt1
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B421A21F41;
	Thu, 29 Oct 2026 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793273484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjVTZSn+XDaK4kzFzUCDE27OhwqyotiavTeXKJ2X2ow=;
	b=wka+4KDhldbLQT6m+X5KOCx2dB+6sSZtfaFc0xpw+DGa3gfmu/Uuzx/HATxfUTtaZbRUGz
	leEVoDAq34yufGiUlGnY7d3/BvPqn/M5GY6X3nbOrbzYbFkcVlYZ4970DFEaNNQoldvC7C
	sqPHFJc4KAYgVE4eDZQvm3A7QKhq2YM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793273484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjVTZSn+XDaK4kzFzUCDE27OhwqyotiavTeXKJ2X2ow=;
	b=SGqzxJt19DPz0ZsY9k6f4n6gtWdOJhqzZYrdl9tKY+LnfnYp2hNjL195plPP8xcFd+f1TR
	QyvKTyVPMqPbsaCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793273484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjVTZSn+XDaK4kzFzUCDE27OhwqyotiavTeXKJ2X2ow=;
	b=wka+4KDhldbLQT6m+X5KOCx2dB+6sSZtfaFc0xpw+DGa3gfmu/Uuzx/HATxfUTtaZbRUGz
	leEVoDAq34yufGiUlGnY7d3/BvPqn/M5GY6X3nbOrbzYbFkcVlYZ4970DFEaNNQoldvC7C
	sqPHFJc4KAYgVE4eDZQvm3A7QKhq2YM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793273484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjVTZSn+XDaK4kzFzUCDE27OhwqyotiavTeXKJ2X2ow=;
	b=SGqzxJt19DPz0ZsY9k6f4n6gtWdOJhqzZYrdl9tKY+LnfnYp2hNjL195plPP8xcFd+f1TR
	QyvKTyVPMqPbsaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F08513419;
	Thu, 29 Oct 2026 11:31:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UydtOIsu42qIBQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 29 Oct 2026 11:31:24 +0000
Message-ID: <cec680c8-7eb1-4a90-ba9a-e6723781cb79@suse.de>
Date: Thu, 29 Oct 2026 12:30:08 +0100
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
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: do not offload multicast
To: Koral Ilgun <koralilgun@gmail.com>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Koral Ilgun <koral.ilgun@adtran.com>
References: <20261028205938.662312-1-koralilgun@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261028205938.662312-1-koralilgun@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 10/28/26 9:59 PM, Koral Ilgun wrote:
> From: Koral Ilgun <koral.ilgun@adtran.com>
> 
> A flow holds one output per direction, which it resolves when it is
> added. The outputs of a multicast route change when listeners join
> or leave. So a multicast flow in the flowtable continues to send to
> the output that it resolved, also after the last listener left, and
> the counters of the multicast routing stop.
> 
> IPv4 multicast stays out of the flowtable only because the reverse
> route lookup in nft_flow_route() refuses a multicast source address.
> The IPv6 route lookup has no such check, so IPv6 multicast that
> ip6mr forwards goes into the flowtable.
> 
> Skip a multicast destination for both families, so that the result
> no longer depends on the route lookup.
> 
> Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
> Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
> ---
> Tested on an arm64 router with Linux 6.18.54, with an inet flowtable
> that offloads forwarded flows, and IPv4 and IPv6 multicast routed from
> the WAN to one VLAN. Without this change, the IPv6 flow went into the
> flowtable after its first packets: the ip6mr vif counters showed 25 of
> 1,500 packets, and the receiver still got all 400 packets after its
> leave. With it, the vif counters showed 1,500 of 1,500, the flow stayed
> out of the flowtable, and the stream stopped about 2.5 s after the
> leave. IPv4 multicast stayed out of the flowtable before and after.
> Unicast IPv4 and IPv6 flows still went into the flowtable.
> 
>   net/netfilter/nft_flow_offload.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index d3c5651dd699..1fc755e594b0 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -10,6 +10,7 @@
>   #include <linux/netfilter/nf_conntrack_common.h>
>   #include <linux/netfilter/nf_tables.h>
>   #include <net/ip.h>
> +#include <net/ipv6.h>
>   #include <net/flow.h>
>   #include <net/netfilter/nf_tables.h>
>   #include <net/netfilter/nf_tables_core.h>
> @@ -35,6 +36,16 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
>   			return true;
>   	}
>   
> +	/* A flow keeps the output it resolved at offload time, but the
> +	 * outputs of a multicast route change when listeners join or leave.
> +	 */
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +		return ipv4_is_multicast(ip_hdr(skb)->daddr);
> +	case NFPROTO_IPV6:
> +		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
> +	}
> +
>   	return false;
>   }

The patch is sound and I think it is better skip the flow earlier here. 
I believe there is a bigger problem with IPv6 route engine not rejecting 
a routing request for a saddr that is multicast, I am already looking 
into that. In any case, couldn't we simplify this code as:

diff --git a/net/netfilter/nft_flow_offload.c 
b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..7d0b87a1bca1 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -33,6 +33,10 @@ static bool nft_flow_offload_skip(struct sk_buff 
*skb, int family)

                 if (unlikely(opt->optlen))
                         return true;
+
+               return ipv4_is_multicast(ip_hdr(skb)->daddr);
+       } else if (family == NFPROTO_IPV6) {
+               return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
         }

         return false;


Thanks,
Fernando.

>   
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b

