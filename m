Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDB4C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 11:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJFLyd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJFLyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 07:54:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5387297EEC
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2022 04:54:30 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ogPSO-0008Mq-Ni; Thu, 06 Oct 2022 13:54:28 +0200
Date:   Thu, 6 Oct 2022 13:54:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 11/12] extensions: Do not print all-one's
 netmasks
Message-ID: <Yz7B9DZ2IC6V+bjQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20221006002802.4917-1-phil@nwl.cc>
 <20221006002802.4917-12-phil@nwl.cc>
 <65q0r47-p696-s4p1-25nq-o2q60snqr42@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65q0r47-p696-s4p1-25nq-o2q60snqr42@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Oct 06, 2022 at 08:27:33AM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2022-10-06 02:28, Phil Sutter wrote:
> 
> >All one's netmasks are a trivial default, no point in printing them.
> >
> >@@ -64,7 +64,7 @@ static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
> > 	bits = xtables_ip6mask_to_cidr(&a);
> > 	if (bits < 0)
> > 		printf("/%s", xtables_ip6addr_to_numeric(&a));
> >-	else
> >+	else if (bits < sizeof(a) * 8)
> > 		printf("/%d", bits);
> 
> I would rather see it stay.
> - iproute2 also always prints the /128 suffix
> - test parsers need not special case the absence of /128

I get your point. Screen-scraping is also not uncommon among iptables
users, so care has to be taken when "optimizing" output.

OTOH we're a bit inconsistent: xtables_ip(6)mask_to_numeric() explicitly
omits output if it would print "/32" or "/128".

Maybe I'll just leave the code as-is and adjust only the test cases
instead?

> >--- a/extensions/libxt_MARK.c
> >@@ -242,7 +242,9 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
> > {
> > 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
> > 
> >-	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
> >+	printf(" --set-xmark 0x%x", info->mark);
> >+	if (info->mask != 0xffffffffU)
> >+		printf("/0x%x", info->mask);
> 
> if (info->mask != UINT32_MAX)

ACK. I copied from mark_tg_print(), so that's a useful fix unrelated to
the discussion above.

Thanks, Phil
