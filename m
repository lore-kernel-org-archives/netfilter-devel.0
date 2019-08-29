Return-Path: <SRS0=245l=WZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E383C3A59F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 11:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1C82189D
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 11:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH2LSt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 07:18:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35814 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH2LSt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 07:18:49 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i3IRz-0008En-NY; Thu, 29 Aug 2019 13:18:47 +0200
Date:   Thu, 29 Aug 2019 13:18:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: json: add support for element deletion
Message-ID: <20190829111847.GA25650@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20190829093620.3594-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829093620.3594-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 29, 2019 at 11:36:20AM +0200, Florian Westphal wrote:
> also add a test case.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Fixes: a87f2a2227be2 ("netfilter: support for element deletion")
Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
