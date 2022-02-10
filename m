Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B554C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbiBJI43 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 03:56:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238065AbiBJI41 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 03:56:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA79CD70;
        Thu, 10 Feb 2022 00:56:28 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA463601BA;
        Thu, 10 Feb 2022 09:56:13 +0100 (CET)
Date:   Thu, 10 Feb 2022 09:56:25 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] selftests: netfilter: disable rp_filter on router
Message-ID: <YgTTOWm0cN56pY+h@salvia>
References: <20220210033205.928458-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220210033205.928458-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 10, 2022 at 11:32:05AM +0800, Hangbin Liu wrote:
> Some distros may enalbe rp_filter by default. After ns1 change addr to
> 10.0.2.99 and set default router to 10.0.2.1, while the connected router
> address is still 10.0.1.1. The router will not reply the arp request
> from ns1. Fix it by setting the router's veth0 rp_filter to 0.
> 
> Before the fix:
>   # ./nft_fib.sh
>   PASS: fib expression did not cause unwanted packet drops
>   Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
>   table inet filter {
>           chain prerouting {
>                   type filter hook prerouting priority filter; policy accept;
>                   ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
>                   ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
>           }
>   }
> 
> After the fix:
>   # ./nft_fib.sh
>   PASS: fib expression did not cause unwanted packet drops
>   PASS: fib expression did drop packets for 1.1.1.1
>   PASS: fib expression did drop packets for 1c3::c01d

Applied
