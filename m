Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4813C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 22:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjKBWhG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 18:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjKBWhG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 18:37:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D845B7
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 15:37:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qygJA-00025I-Df; Thu, 02 Nov 2023 23:37:00 +0100
Date:   Thu, 2 Nov 2023 23:37:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: meta: test hour decoding wrap
Message-ID: <20231102223700.GA2852@breakpoint.cc>
References: <20231102143416.179305-1-fw@strlen.de>
 <ZUPJysvIcO/Y1r34@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUPJysvIcO/Y1r34@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Nov 02, 2023 at 03:34:13PM +0100, Florian Westphal wrote:
> > Add a test case for
> > "meta: fix hour decoding when timezone offset is negative".
> 
> Could you coalese the test with the patch to the fix?

Sure.  Applied and pushed after squashing it with the test case.
