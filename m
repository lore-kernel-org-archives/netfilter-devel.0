Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1786CDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 09:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjJSJUg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 05:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJSJUg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 05:20:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D705FA3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 02:20:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qtPCi-0006qr-27; Thu, 19 Oct 2023 11:20:32 +0200
Date:   Thu, 19 Oct 2023 11:20:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests/shell: add NFT_TEST_FAIL_ON_SKIP_EXCEPT
 for allow-list of skipped tests (XFAIL)
Message-ID: <20231019092032.GA2230@breakpoint.cc>
References: <20231017223450.2613981-1-thaller@redhat.com>
 <ZS+mfyhHzEld2gJ6@calendula>
 <651666347a414eecbb11ad97d6a75a0e1a401bf3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <651666347a414eecbb11ad97d6a75a0e1a401bf3.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> Unless you think, that the current SKIP mechanism (feature
> detection/probing) in master is 100% reliable, and there is no need to
> worry about SKIP hiding a bug.

Yes, I do not worry about SKIP, because I never see a SKIP *unless*
I run the test suite on an old kernel.

"Old" here means 5.14.y or so.
