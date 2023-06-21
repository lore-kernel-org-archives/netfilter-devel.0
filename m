Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C82EB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 11:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjFULT0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjFULTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 07:19:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D1E1739
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 04:18:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qBvqp-0006kT-3u; Wed, 21 Jun 2023 13:18:15 +0200
Date:   Wed, 21 Jun 2023 13:18:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: avoid IPPROTO_MAX for array definitions
Message-ID: <20230621111815.GC24035@breakpoint.cc>
References: <20230620200836.22041-1-fw@strlen.de>
 <ZJIpBfHFHYj6PWfx@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJIpBfHFHYj6PWfx@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 20, 2023 at 10:08:36PM +0200, Florian Westphal wrote:
> > ip header can only accomodate 8but value, but IPPROTO_MAX has been bumped
> > due to uapi reasons to support MPTCP (262, which is used to toggle on
> > multipath support in tcp).
> 
> Maybe use IPPROTO_RAW + 1, hopefully that won't ever change.

If you don't like UINT8_MAX+1, would you be fine with open-coding, i.e.
[256] ?
