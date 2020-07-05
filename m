Return-Path: <SRS0=UuyC=AQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ED0C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jul 2020 12:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355CB20747
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jul 2020 12:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgGEMi1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jul 2020 08:38:27 -0400
Received: from mail.thelounge.net ([91.118.73.15]:34271 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgGEMi0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jul 2020 08:38:26 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4B07Xc55kQzXMK;
        Sun,  5 Jul 2020 14:38:24 +0200 (CEST)
Subject: Re: [PATCH 29/29] netfilter: nf_tables: merge ipv4 and ipv6 nat chain
 types
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190302183720.3220-1-pablo@netfilter.org>
 <20190302183720.3220-10-pablo@netfilter.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <0f286666-8736-80d2-9a72-22c91745a31b@thelounge.net>
Date:   Sun, 5 Jul 2020 14:38:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20190302183720.3220-10-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 02.03.19 um 19:37 schrieb Pablo Neira Ayuso:
> From: Florian Westphal <fw@strlen.de>
> 
> Merge the ipv4 and ipv6 nat chain type. This is the last
> missing piece which allows to provide inet family support
> for nat in a follow patch.
> 
> The kconfig knobs for ipv4/ipv6 nat chain are removed, the
> nat chain type will be built unconditionally if NFT_NAT
> expression is enabled.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    1576     896       0    2472     9a8 nft_chain_nat_ipv4.ko
>    1697     896       0    2593     a21 nft_chain_nat_ipv6.ko
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>    1832     896       0    2728     aa8 nft_chain_nat.ko

there are similar *probably* low hanging fruits with 5.7

"ip6_udp_tunnel" and "nf_defrag_ipv6" are unconditionally loaded even on
pure ipv4 setups and the two ipv6 sepcific rehect modules only when ipv6
is in use

3,5K udp_tunnel.ko.xz
2,5K ip6_udp_tunnel.ko.xz

2,4K nf_defrag_ipv4.ko.xz
6,7K nf_defrag_ipv6.ko.xz

2.3K ipt_REJECT.ko.xz
2.3K ip6t_REJECT.ko.xz

3.1K nf_reject_ipv4.ko.xz
4.1K nf_reject_ipv6.ko.x
