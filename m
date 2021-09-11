Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1628BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Sep 2021 12:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E114261212
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Sep 2021 12:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhIKMHY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Sep 2021 08:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKMHY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Sep 2021 08:07:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85473C061574;
        Sat, 11 Sep 2021 05:06:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mP1lm-0005za-TQ; Sat, 11 Sep 2021 14:06:06 +0200
Date:   Sat, 11 Sep 2021 14:06:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.10.y 0/3] netfilter: nf_tables fixes for 5.10.y
Message-ID: <20210911120606.GL23554@breakpoint.cc>
References: <20210909140337.29707-1-fw@strlen.de>
 <YTofmaFaPAtGLFs8@kroah.com>
 <YTx5TXJ+M1Khn8uH@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTx5TXJ+M1Khn8uH@eldamar.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Salvatore Bonaccorso <carnil@debian.org> wrote:
> On Thu, Sep 09, 2021 at 04:52:09PM +0200, Greg KH wrote:
> > All now queued up, thanks!
> 
> Florian, thank you! My query originated from a bugreport in Debian
> triggering the issue with the 5.10.y kernels used.
> 
> Not really needed here as Greg already queued up but:
> 
> Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Thanks for testing!

Please let us know if anything else in netfilter territory
is not working as expected.
