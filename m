Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805218;
	b=2iWOxLcjb2xq18/A+viqnTmX7zRMb/AXxwyhhawQZ1Wtl0Kl4jDAdz4zj4w3RjX1b/Pn
	 ZhY19VEHbqxS+UghsKxF/lgHxjjs1qzjvnyooCKEdDpJDHJPArdszw1QiV1hBHhzLHVJo
	 z74VYnEHgUm2c/29pig43GrCRiIFMVGqRmEeGVgDdEampHpNlK99zjuPGmOFpZt/cDNaZ
	 EeF2lSuWkI/3NqBC2pyhYCFnNYMXuzullj73qbzda+C4yCH1DZFtoCcAPQj1QmTAGP7Zb
	 UdP/M+qIaOF/nCA2jUT6/e8YgM1+cu8rDCSrTeurWMHLG2mERV9OzZJAdyn3KCPhkdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805218;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=GfpcW45NVvxVdS/3Pq4MdBKSLUO7H4TIlxRjKgjgYJs=;
	b=NCT5Fioci6W6AVol/3N7CNXGfB1FG+9BnlpXFYu13X16rXumYnMC8ewL7NOTv5mykmm0
	 Zpa7QpUsnJZD6DyyzPQPTxDBF+IAQsuTrGy0pzQkCeW1c+AklSz1ve+PghYGXbx6uMxUJ
	 Qn9jhyk7GkWHhzuYyj/BZahImEuQla+phQtG1O+P4Kt3YRKfWfY6du5+fXUUAoFwQgDkK
	 61GmC0r8KIDWxcACL5CKjeQdoVbrmX/DLw/uso/oicaRV84/JZaAb2g8rN2g/IyHtYr88
	 cb+5y7yol39OfMj4CmgKL6H4mYB8AN/+ww93RB6fjXKlL8OAqz/8FzAfeNwN+tdAHeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bkvqdvc2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+N502gmj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bkvqdvc2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+N502gmj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C2606A31B
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 15:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 444C2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bkvqdvc2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+N502gmj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bkvqdvc2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+N502gmj
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6846021DAE;
	Wed,  4 Nov 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793805215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfpcW45NVvxVdS/3Pq4MdBKSLUO7H4TIlxRjKgjgYJs=;
	b=bkvqdvc26Ntakvs2LMyCTdNZB6tTJNKVEM8+jjInr2lWpkB7c62hjkLd4Srs5yicJfei/A
	GFMFyej1IcSlY9NW18j11oEB8ijvDoDxdPj1yANoyiQRZDWs9tSzXHo3OA4p9r6pNMBUvJ
	Jttr8mBoW36xw+T8fFZpFuQSZGnJYnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793805215;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfpcW45NVvxVdS/3Pq4MdBKSLUO7H4TIlxRjKgjgYJs=;
	b=+N502gmjmcbusfvFKWJxC5aH7WbxkjLAsbxBvl5T+urvDyPfJ6o03avrfC7//WwDDYH/V4
	/ArUikKNAFOTQTAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkvqdvc2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+N502gmj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793805215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfpcW45NVvxVdS/3Pq4MdBKSLUO7H4TIlxRjKgjgYJs=;
	b=bkvqdvc26Ntakvs2LMyCTdNZB6tTJNKVEM8+jjInr2lWpkB7c62hjkLd4Srs5yicJfei/A
	GFMFyej1IcSlY9NW18j11oEB8ijvDoDxdPj1yANoyiQRZDWs9tSzXHo3OA4p9r6pNMBUvJ
	Jttr8mBoW36xw+T8fFZpFuQSZGnJYnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793805215;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfpcW45NVvxVdS/3Pq4MdBKSLUO7H4TIlxRjKgjgYJs=;
	b=+N502gmjmcbusfvFKWJxC5aH7WbxkjLAsbxBvl5T+urvDyPfJ6o03avrfC7//WwDDYH/V4
	/ArUikKNAFOTQTAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21DB3134A5;
	Wed,  4 Nov 2026 15:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bXLnOJ5L62osHgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 15:13:35 +0000
Message-ID: <fc455027-912a-45a2-ac85-8f1a312123ea@suse.de>
Date: Wed, 4 Nov 2026 16:12:21 +0100
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
Subject: Re: [PATCH nf 3/4] netfilter: nfnetlink_log: fix up dev_parse_header
 usage
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261030154433.13601-1-fw@strlen.de>
 <20261030154433.13601-4-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261030154433.13601-4-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 6846021DAE

On 10/30/26 4:44 PM, Florian Westphal wrote:
> dev_parse_header() grabs the source hw address from the skb and stores
> it in the given buffer.
> 
> e.g.: eth_header_parse() is simply:
> 
> int eth_header_parse(const struct sk_buff *skb,
> 		     const struct net_device *dev,
> 		     unsigned char *haddr)
> {
> 	memcpy(haddr, eth_hdr(skb->h_source, ETH_ALEN);
> 	return ETH_ALEN;
> }
> 
> Problem is that the compound structure used by the UABI in nfnetlink_log
> and nfnetlink_queue has a fixed 8-byte size.
> Enough for ETH_ALEN, but not necessarily enough for other address types.
> 
> Move this to a helper and allow sharing it between the copypasted users.
> 
> The struct layout of the two container structures have same layout:
> add BUILD_BUG_ON checks to assert this.
> 
> Due to the nature of the dev_parse_header() helpers:
> 
> 1. skb MUST have a valid mac header, else we read garbage
> 2. users MUST NOT use this when ingress device and skb->dev
> have diverged (we can't know we would decode something
> meaningful anymore).
> 3. Because container structure only has space for 8 octets,
>     we have to clamp the result.
> 
> Do all of this in the common helper.
> 
> This is an LLM finding, no bug was ever reported about this.
> 
> Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
> Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   net/netfilter/nfnetlink_log.c        | 18 ++---
>   net/netfilter/nfnetlink_log_common.h | 99 ++++++++++++++++++++++++++++
>   net/netfilter/nfnetlink_queue.c      | 18 ++---
>   3 files changed, 107 insertions(+), 28 deletions(-)
>   create mode 100644 net/netfilter/nfnetlink_log_common.h
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 0b590c117f4c..29530b753928 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -47,6 +47,8 @@
>   #include <net/netfilter/nf_conntrack.h>
>   #endif
>   
> +#include "nfnetlink_log_common.h"
> +
>   #define NFULNL_COPY_DISABLED	0xff
>   #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
>   #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
> @@ -587,20 +589,8 @@ __build_packet_message(struct nfnl_log_net *log,
>   	    nla_put_be32(inst->skb, NFULA_MARK, htonl(skb->mark)))
>   		goto nla_put_failure;
>   
> -	if (indev && skb->dev &&
> -	    skb_mac_header_was_set(skb) &&
> -	    skb_mac_header_len(skb) != 0) {
> -		struct nfulnl_msg_packet_hw phw;
> -		int len;
> -
> -		memset(&phw, 0, sizeof(phw));
> -		len = dev_parse_header(skb, phw.hw_addr);
> -		if (len > 0) {
> -			phw.hw_addrlen = htons(len);
> -			if (nla_put(inst->skb, NFULA_HWADDR, sizeof(phw), &phw))
> -				goto nla_put_failure;
> -		}
> -	}
> +	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
> +		goto nla_put_failure;
>   
>   	if (indev && skb_mac_header_was_set(skb)) {
>   		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
> diff --git a/net/netfilter/nfnetlink_log_common.h b/net/netfilter/nfnetlink_log_common.h
> new file mode 100644
> index 000000000000..755a3364c8a0
> --- /dev/null
> +++ b/net/netfilter/nfnetlink_log_common.h
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _NF_NETLINK_LOG_COMMON_H
> +#define _NF_NETLINK_LOG_COMMON_H
> +
> +#include <linux/netfilter/nfnetlink_queue.h>
> +#include <linux/netfilter/nfnetlink_log.h>
> +
> +/* nfnetlink_log and nfnetlink_queue suffer from copypaste; avoid adding
> + * more and place shared code here.
> + */
> +static __always_inline void assert_nfqnl_nfunl_hdrs(void)
> +{
> +	struct nfulnl_msg_packet_hw phwu;
> +	struct nfqnl_msg_packet_hw phwq;
> +
> +	BUILD_BUG_ON(sizeof(phwu) != sizeof(phwq));
> +
> +#define X(memb) offsetof(struct nfulnl_msg_packet_hw, memb) != \
> +		offsetof(struct nfqnl_msg_packet_hw, memb)
> +
> +	BUILD_BUG_ON(X(hw_addrlen));
> +	BUILD_BUG_ON(X(hw_addr));
> +#undef X
> +#define X(memb) sizeof(phwu.memb) != sizeof(phwq.memb)
> +	BUILD_BUG_ON(X(hw_addrlen));
> +#undef X
> +}
> +
> +/**
> + * nfnetlink_put_hwaddr - Serialize the L2 hardware address into a netlink attribute.
> + * @nlskb: netlink message to append the attribute to.
> + * @skb: the packet whose hardware address is being serialized.
> + * @indev: the input device; must equal @skb->dev.
> + * @attr: netlink attribute type identifier.
> + *
> + * Extracts the MAC header from @skb using dev_parse_header() and appends
> + * it as a netlink attribute of type @attr to @nlskb.
> + *
> + * UAPI NOTE: The attribute is serialized in a legacy container structure
> + * (nfnl_msg_packet_hw) rather than a plain nla_put(hwaddr, len). The
> + * hw_addrlen member in that structure is redundant -- userspace already
> + * knows the size from the netlink attribute length -- but is retained
> + * for ABI compatibility. nfnetlink_queue duplicates this layout; both
> + * structs are layout-identical, so this one helper serves both.
> + *
> + * The maximum address length is 8 octets (MAX_ADDR_LEN / ETH_ALEN upper
> + * bound), even though netlink itself supports longer addresses. This is a
> + * limitation of the compound-structure ABI, not of netlink.
> + *
> + * This helper checks:
> + *  - @skb->dev is non-NULL.
> + *  - @indev is equal @skb->dev; dev_parse_header() dereferences
> + *    dev->header_ops on skb->dev, so a mismatched device (e.g. egress
> + *    device on an egress path) would parse the wrong L2 header.
> + *  - L2 header is present.
> + *
> + * Return: -EMSGSIZE if the tailroom of the skb is insufficient to store
> + * the attribute header and payload.
> + */
> +static inline int
> +nfnetlink_put_hwaddr(struct sk_buff *nlskb,
> +		     const struct sk_buff *skb,
> +		     const struct net_device *indev,
> +		     u16 attr)
> +{
> +	char hw_addr[MAX_ADDR_LEN];
> +	unsigned int mac_len;
> +	int len;
> +
> +	if (!skb->dev ||
> +	    indev != skb->dev ||
> +	    !skb_mac_header_was_set(skb))
> +		return 0;
> +

Hi Florian,

I think Sashiko's feedback here is right. As for bridge hook INPUT is 
br0 and in FORWARD it should be the egress port I believe. What about 
checking that indev->header_ops == skb->dev->header_ops?

I think as dev_parse_header checks on header_ops->parse function, that 
should be enough.

Sashiko feedback here: 
https://sashiko.dev/#/message/20261030154433.13601-4-fw%40strlen.de

About the second message I am not so sure about it being real tho.

Thanks,
Fernando.

> +	mac_len = skb_mac_header_len(skb);
> +	if (mac_len == 0)
> +		return 0;
> +
> +	len = dev_parse_header(skb, hw_addr);
> +	if (len > 0) {
> +		struct nfulnl_msg_packet_hw phw;
> +		const int max_hwlen = (int)sizeof(phw.hw_addr);
> +
> +		assert_nfqnl_nfunl_hdrs();
> +
> +		/* UAPI limitation, must clamp. */
> +		if (len > max_hwlen)
> +			len = max_hwlen;
> +
> +		memset(&phw, 0, sizeof(phw));
> +		memcpy(phw.hw_addr, hw_addr, len);
> +		phw.hw_addrlen = htons(len);
> +
> +		return nla_put(nlskb, attr, sizeof(phw), &phw);
> +	}
> +
> +	return 0;
> +}
> +#endif
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 90d887546f7d..7c0fb4777852 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -56,6 +56,8 @@
>   #include <net/netfilter/nf_conntrack.h>
>   #endif
>   
> +#include "nfnetlink_log_common.h"
> +
>   #define NFQNL_QMAX_DEFAULT 1024
>   #define NFQNL_HASH_MIN     8
>   #define NFQNL_HASH_MAX     32768
> @@ -906,20 +908,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>   	    nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
>   		goto nla_put_failure;
>   
> -	if (indev && entskb->dev &&
> -	    skb_mac_header_was_set(entskb) &&
> -	    skb_mac_header_len(entskb) != 0) {
> -		struct nfqnl_msg_packet_hw phw;
> -		int len;
> -
> -		memset(&phw, 0, sizeof(phw));
> -		len = dev_parse_header(entskb, phw.hw_addr);
> -		if (len) {
> -			phw.hw_addrlen = htons(len);
> -			if (nla_put(skb, NFQA_HWADDR, sizeof(phw), &phw))
> -				goto nla_put_failure;
> -		}
> -	}
> +	if (nfnetlink_put_hwaddr(skb, entskb, indev, NFQA_HWADDR))
> +		goto nla_put_failure;
>   
>   	if (nfqnl_put_bridge(entry, skb) < 0)
>   		goto nla_put_failure;

