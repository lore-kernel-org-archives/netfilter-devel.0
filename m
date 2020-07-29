Return-Path: <SRS0=EzAQ=BI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1E0C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jul 2020 20:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E6B82068F
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jul 2020 20:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgG2Un2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jul 2020 16:43:28 -0400
Received: from correo.us.es ([193.147.175.20]:55682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgG2Un2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jul 2020 16:43:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45E9AFB365
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 22:43:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3686DDA78A
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2020 22:43:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C084DA722; Wed, 29 Jul 2020 22:43:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DF27DA73D;
        Wed, 29 Jul 2020 22:43:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jul 2020 22:43:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E96E4265A2F;
        Wed, 29 Jul 2020 22:43:23 +0200 (CEST)
Date:   Wed, 29 Jul 2020 22:43:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Zhou <mzhou@cse.unsw.edu.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/netfilter/ip6t_NPT: rewrite addresses in ICMPv6
 original packet
Message-ID: <20200729204323.GA11285@salvia>
References: <20200720131701.17941-1-mzhou@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720131701.17941-1-mzhou@cse.unsw.edu.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jul 20, 2020 at 11:17:01PM +1000, Michael Zhou wrote:
> Detect and rewrite a prefix embedded in an ICMPv6 original packet that was
> rewritten by a corresponding DNPT/SNPT rule so it will be recognised by
> the host that sent the original packet.

Thanks for submitting your patch, a few comments below.

> Example
> 
> Rules in effect on the 1:2:3:4::/64 + 5:6:7:8::/64 side router:
> * SNPT src-pfx 1:2:3:4::/64 dst-pfx 5:6:7:8::/64
> * DNPT src-pfx 5:6:7:8::/64 dst-pfx 1:2:3:4::/64
> 
> No rules on the 9:a:b:c::/64 side.
> 
> 1. 1:2:3:4::1 sends UDP packet to 9:a:b:c::1
> 2. Router applies SNPT changing src to 5:6:7:8::ffef::1
> 3. 9:a:b:c::1 receives packet with (src 5:6:7:8::ffef::1 dst 9:a:b:c::1)
> 	and replies with ICMPv6 port unreachable to 5:6:7:8::ffef::1,
> 	including original packet (src 5:6:7:8::ffef::1 dst 9:a:b:c::1)
> 4. Router forwards ICMPv6 packet with (src 9:a:b:c::1 dst 5:6:7:8::ffef::1)
> 	including original packet (src 5:6:7:8::ffef::1 dst 9:a:b:c::1)
> 	and applies DNPT changing dst to 1:2:3:4::1
> 5. 1:2:3:4::1 receives ICMPv6 packet with (src 9:a:b:c::1 dst 1:2:3:4::1)
> 	including original packet (src 5:6:7:8::ffef::1 dst 9:a:b:c::1).
> 	It doesn't recognise the original packet as the src doesn't
> 	match anything it originally sent
> 
> With this change, at step 4, DNPT will also rewrite the original packet
> src to 1:2:3:4::1, so at step 5, 1:2:3:4::1 will recognise the ICMPv6
> error and provide feedback to the application properly.
> 
> Conversely, SNPT will help when ICMPv6 errors are sent from the
> translated network.
> 
> 1. 9:a:b:c::1 sends UDP packet to 5:6:7:8::ffef::1
> 2. Router applies DNPT changing dst to 1:2:3:4::1
> 3. 1:2:3:4::1 receives packet with (src 9:a:b:c::1 dst 1:2:3:4::1)
> 	and replies with ICMPv6 port unreachable to 9:a:b:c::1
> 	including original packet (src 9:a:b:c::1 dst 1:2:3:4::1)
> 4. Router forwards ICMPv6 packet with (src 1:2:3:4::1 dst 9:a:b:c::1)
> 	including original packet (src 9:a:b:c::1 dst 1:2:3:4::1)
> 	and applies SNPT changing src to 5:6:7:8::ffef::1
> 5. 9:a:b:c::1 receives ICMPv6 packet with
> 	(src 5:6:7:8::ffef::1 dst 9:a:b:c::1) including
> 	original packet (src 9:a:b:c::1 dst 1:2:3:4::1).
> 	It doesn't recognise the original packet as the dst doesn't
> 	match anything it already sent
> 
> The change to SNPT means the ICMPv6 original packet dst will be
> rewritten to 5:6:7:8::ffef::1 in step 4, allowing the error to be
> properly recognised in step 5.
> 
> Signed-off-by: Michael Zhou <mzhou@cse.unsw.edu.au>
> ---
>  net/ipv6/netfilter/ip6t_NPT.c | 37 +++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
> index 9ee077bf4f49..b25e786607ed 100644
> --- a/net/ipv6/netfilter/ip6t_NPT.c
> +++ b/net/ipv6/netfilter/ip6t_NPT.c
> @@ -77,16 +77,42 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
>  	return true;
>  }
>  
> +static struct ipv6hdr *ip6t_npt_icmpv6_bounced_ipv6hdr(struct sk_buff *skb)
> +{
> +	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6)
> +		return NULL;
> +
> +	if (!icmpv6_is_err(icmp6_hdr(skb)->icmp6_type))
> +		return NULL;
> +
> +	if ((const unsigned char *)&icmp6_hdr(skb)[1] + sizeof(struct ipv6hdr) >
> +			skb_tail_pointer(skb))
> +		return NULL;
> +
> +	return (struct ipv6hdr *)&icmp6_hdr(skb)[1];

This ICMPv6 header might fall withing the non-linear data of the
skbuff.

BTW, does rfc6296 describes what to do with icmp traffic?
