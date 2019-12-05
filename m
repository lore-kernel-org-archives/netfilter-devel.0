Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC370C2BD09
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB1D32464F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 10:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfLEKuD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:50:03 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54942 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729017AbfLEKuC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 05:50:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1icohr-0003cy-DW; Thu, 05 Dec 2019 11:49:59 +0100
Date:   Thu, 5 Dec 2019 11:49:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Message-ID: <20191205104959.GX795@breakpoint.cc>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191205085657.GF133447@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205085657.GF133447@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Pablo, comparing the x_tables and nftables connmark implementations I
> see that nftables doesn't support all the bit-twiddling that x_tables
> does.  Why is this?  Was it not wanted or has it just not been imple-
> mented?

The latter.  It would be needed to extend nft_bitwise.c to accept
a second register value and extend nft userspace to accept non-immediate
values as second operand.
