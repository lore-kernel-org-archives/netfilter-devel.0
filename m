Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18270C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 13:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9CF61528
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 13:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhI3NES (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 09:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbhI3NES (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 09:04:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8805AC06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 06:02:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mVvho-00033A-TF; Thu, 30 Sep 2021 15:02:32 +0200
Date:   Thu, 30 Sep 2021 15:02:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Senthil Kumar Balasubramanian <senthilb@qubercomm.com>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: ebtables behaving weirdly on MIPS platform
Message-ID: <20210930130232.GE2935@breakpoint.cc>
References: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
 <20210930103840.GP32194@orbyte.nwl.cc>
 <20210930105223.GD2935@breakpoint.cc>
 <20210930123927.GA82795@QBC-Ruckus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930123927.GA82795@QBC-Ruckus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Senthil Kumar Balasubramanian <senthilb@qubercomm.com> wrote:
> Yes. this patch work... Good and quick catch..

Thanks, I pushed this patch to ebtables.git.
