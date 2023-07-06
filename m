Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5399FEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 15:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjGFPET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 11:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbjGFPEQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 11:04:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2E1199F
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 08:04:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qHQWb-0005eJ-GO; Thu, 06 Jul 2023 17:04:05 +0200
Date:   Thu, 6 Jul 2023 17:04:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] netlink_linearize: use div_round_up in byteorder
 length
Message-ID: <20230706150405.GJ3751@breakpoint.cc>
References: <20230706150237.47694-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706150237.47694-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Use div_round_up() to calculate the byteorder length, otherwise fields
> that take % BITS_PER_BYTE != 0 are not considered by the byteorder
> expression.

Thanks for fixing this!  Patch LGTM.
