Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C65C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4621161363
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353360AbhESMJM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 08:09:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353339AbhESMJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 08:09:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621426070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hd3svGuk2mYp3rN9KCnHoNsFLBCqHCu36XvXwJ0JCeU=;
        b=p7KwRis0uBfMCiATdxz75PxOGlBVpx2y7nISpR/Qb6ygRn9RkMRTKwaISuqkJO9xvTTWRU
        wfhF5d/w9BjS3Tju5zaM/PmD4lTgaxOaU24PmFjSU0qb8K7DP2Kj2wxv2S4qVPpQC6HmT5
        uGOnaAadSsoMbvJeXrv/js1GFyIiKbQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16F17AF19;
        Wed, 19 May 2021 12:07:50 +0000 (UTC)
Date:   Wed, 19 May 2021 14:07:49 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <20210519120749.gd32rnaaz6q2kggr@Fryzen495>
References: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
 <YJL30q7mCUezag48@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJL30q7mCUezag48@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05.05.2021 21:53, Florian Westphal wrote:
> Ali, sorry for coming back to this again and again.
> 
> What do you think of this change?

Hi Florian, I tested your patch and it solved the issue, no more NFS
hangs due to dropped RSTs. Please include it, together with the
following two patches I previously sent:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210428130911.cteglt52r5if7ynp@Fryzen495/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210430093601.zibczc4cjnwx3qwn@Fryzen495/

Thanks a lot!

> Its an incremental change on top of your patch.
> 
> The only real change is that this will skip window check if
> conntrack thinks connection is closing already.
> 
> In addition, tcp window check is skipped in that case.
> 
> This is supposed to expedite conntrack eviction in case of tuple reuse
> by some nat/pat middlebox, or a peer that has lower timeouts than
> conntrack before a port is re-used.
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -834,6 +834,22 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
>  	return true;
>  }
>  
> +static bool tcp_can_early_drop(const struct nf_conn *ct)
> +{
> +	switch (ct->proto.tcp.state) {
> +	case TCP_CONNTRACK_FIN_WAIT:
> +	case TCP_CONNTRACK_LAST_ACK:
> +	case TCP_CONNTRACK_TIME_WAIT:
> +	case TCP_CONNTRACK_CLOSE:
> +	case TCP_CONNTRACK_CLOSE_WAIT:
> +		return true;
> +	default:
> +		break;
> +	}
> +
> +	return false;
> +}
> +
>  /* Returns verdict for packet, or -1 for invalid. */
>  int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  			    struct sk_buff *skb,
> @@ -1053,8 +1069,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  			/* If we are not in established state, and an RST is
>  			 * observed with SEQ=0, this is most likely an answer
>  			 * to a SYN we had let go through above.
> +			 *
> +			 * Also expedite conntrack destruction: If we were already
> +			 * closing, peer or NAT/PAT might already have reused tuple.
>  			 */
> -			if (seq == 0 && !nf_conntrack_tcp_established(ct))
> +			if (!nf_conntrack_tcp_established(ct)) {
> +				if (seq == 0 || tcp_can_early_drop(ct))
> +					goto in_window;
> +			}
> +
> +			if (seq == ct->proto.tcp.seen[!dir].td_maxack)
>  				break;
>  
>  			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
> @@ -1066,10 +1090,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  				return -NF_ACCEPT;
>  			}
>  
> -			if (!nf_conntrack_tcp_established(ct) ||
> -			    seq == ct->proto.tcp.seen[!dir].td_maxack)
> -				break;
> -
>  			/* Check if rst is part of train, such as
>  			 *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
>  			 *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
> @@ -1181,22 +1201,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  	return NF_ACCEPT;
>  }
>  
> -static bool tcp_can_early_drop(const struct nf_conn *ct)
> -{
> -	switch (ct->proto.tcp.state) {
> -	case TCP_CONNTRACK_FIN_WAIT:
> -	case TCP_CONNTRACK_LAST_ACK:
> -	case TCP_CONNTRACK_TIME_WAIT:
> -	case TCP_CONNTRACK_CLOSE:
> -	case TCP_CONNTRACK_CLOSE_WAIT:
> -		return true;
> -	default:
> -		break;
> -	}
> -
> -	return false;
> -}
> -
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
>  
>  #include <linux/netfilter/nfnetlink.h>
> 

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

