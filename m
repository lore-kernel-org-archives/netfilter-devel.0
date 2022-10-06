Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB429C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 06:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJFG1g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 02:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJFG1f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 02:27:35 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CB04151E
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 23:27:35 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C8BE7586B5F69; Thu,  6 Oct 2022 08:27:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C837160C4DF89;
        Thu,  6 Oct 2022 08:27:33 +0200 (CEST)
Date:   Thu, 6 Oct 2022 08:27:33 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 11/12] extensions: Do not print all-one's
 netmasks
In-Reply-To: <20221006002802.4917-12-phil@nwl.cc>
Message-ID: <65q0r47-p696-s4p1-25nq-o2q60snqr42@vanv.qr>
References: <20221006002802.4917-1-phil@nwl.cc> <20221006002802.4917-12-phil@nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2022-10-06 02:28, Phil Sutter wrote:

>All one's netmasks are a trivial default, no point in printing them.
>
>@@ -64,7 +64,7 @@ static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
> 	bits = xtables_ip6mask_to_cidr(&a);
> 	if (bits < 0)
> 		printf("/%s", xtables_ip6addr_to_numeric(&a));
>-	else
>+	else if (bits < sizeof(a) * 8)
> 		printf("/%d", bits);

I would rather see it stay.
- iproute2 also always prints the /128 suffix
- test parsers need not special case the absence of /128

>--- a/extensions/libxt_MARK.c
>@@ -242,7 +242,9 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
> {
> 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
> 
>-	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
>+	printf(" --set-xmark 0x%x", info->mark);
>+	if (info->mask != 0xffffffffU)
>+		printf("/0x%x", info->mask);

if (info->mask != UINT32_MAX)
