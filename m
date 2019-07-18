Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C14C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 16:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5B12184B
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 16:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbfGRQik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 12:38:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40582 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbfGRQik (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 12:38:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1ho9QU-00041B-0s; Thu, 18 Jul 2019 18:38:38 +0200
Date:   Thu, 18 Jul 2019 18:38:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: support for element deletion
Message-ID: <20190718163837.qg22xvvqr2q7tejz@breakpoint.cc>
References: <20190713160343.31620-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713160343.31620-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> This patch implements element deletion from ruleset.
> 
> Example:
> 
> 	table ip set-test {
> 		set testset {
> 			type ipv4_addr;
> 			flags timeout;
> 		}
> 
> 		chain outputchain {
> 			policy accept;
> 			type filter hook output priority filter;
> 
> 			delete @testset { ip saddr }
> 		}
> 	}

Care to add a test case for this?
Thanks.

Also:

src/nft --debug=netlink list ruleset
ip set-test outputchain 3
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ dynset unknown reg_key 1 set testset timeout 0ms ]

so this is missing a small libnftnl patch too.
Also wonder why this prints 'timeout 0ms'.  Can you investigate?

libnftnl should only print it if the attribute is set so we can
tell if the timeout is 0ms or if no timeout was set.

I've tested nft+kernel patch and I see ip saddr gets deleted again from
the set when i add an enty via 'nft add element',

So functionality-wise both the userspace and kernel space patches
are good.
