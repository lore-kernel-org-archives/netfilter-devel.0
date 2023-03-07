Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706E8C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 18:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjCGSsV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 13:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjCGSr4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 13:47:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CA938E8C
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 10:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678214124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSH/hWurmj33G6H+JeE+HDAabg7tb0wcjkZnFYtZ2CQ=;
        b=Uz/fnRaU2eXKrBdt9Yflyh03GjXiD4ds9JJu/dHiSFdmEhVJ/TjdPrYh2Y4M+qf0P1lsEE
        QfvA2hOT8y8XeKm1bGjZCo/uDmKSvYnXhCKsxrEqM9mH0RCOnKcBRBT9TOyiRhI3pv2sKU
        ASu8VynORaRP8WNrZgMnfwiFV9VA2Wk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-qocW7hWjO_2B6eM97TpYtw-1; Tue, 07 Mar 2023 13:32:13 -0500
X-MC-Unique: qocW7hWjO_2B6eM97TpYtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFE2D384D033;
        Tue,  7 Mar 2023 18:32:11 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E479140EBF4;
        Tue,  7 Mar 2023 18:32:11 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out
 of br_nf_check_hbh_len
References: <cover.1677888566.git.lucien.xin@gmail.com>
        <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
Date:   Tue, 07 Mar 2023 13:32:10 -0500
In-Reply-To: <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
        (Xin Long's message of "Fri, 3 Mar 2023 19:12:39 -0500")
Message-ID: <f7ty1o84dlh.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> br_nf_check_hbh_len() is a function to check the Hop-by-hop option
> header, and shouldn't do pskb_trim_rcsum() there. This patch is to
> pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
> after calling br_validate_ipv6() instead.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

>  net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
>
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 50f564c33551..07289e4f3213 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -43,11 +43,11 @@
>  /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
>   * anyway
>   */
> -static int br_nf_check_hbh_len(struct sk_buff *skb)
> +static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
>  {
>  	int len, off = sizeof(struct ipv6hdr);
>  	unsigned char *nh;
> -	u32 pkt_len;
> +	u32 pkt_len = 0;
>  
>  	if (!pskb_may_pull(skb, off + 8))
>  		return -1;
> @@ -83,10 +83,6 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  				return -1;
>  			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
>  				return -1;
> -			if (pskb_trim_rcsum(skb,
> -					    pkt_len + sizeof(struct ipv6hdr)))
> -				return -1;
> -			nh = skb_network_header(skb);
>  		}
>  		off += optlen;
>  		len -= optlen;
> @@ -94,6 +90,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  	if (len)
>  		return -1;
>  
> +	if (pkt_len)
> +		*plen = pkt_len;
>  	return 0;
>  }
>  
> @@ -116,22 +114,19 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
>  		goto inhdr_error;
>  
>  	pkt_len = ntohs(hdr->payload_len);
> +	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
> +		goto drop;
>  
> -	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
> -		if (pkt_len + ip6h_len > skb->len) {
> -			__IP6_INC_STATS(net, idev,
> -					IPSTATS_MIB_INTRUNCATEDPKTS);
> -			goto drop;
> -		}
> -		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
> -			__IP6_INC_STATS(net, idev,
> -					IPSTATS_MIB_INDISCARDS);
> -			goto drop;
> -		}
> -		hdr = ipv6_hdr(skb);
> +	if (pkt_len + ip6h_len > skb->len) {
> +		__IP6_INC_STATS(net, idev,
> +				IPSTATS_MIB_INTRUNCATEDPKTS);
> +		goto drop;
>  	}
> -	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb))
> +	if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
> +		__IP6_INC_STATS(net, idev,
> +				IPSTATS_MIB_INDISCARDS);
>  		goto drop;
> +	}
>  
>  	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
>  	/* No IP options in IPv6 header; however it should be

