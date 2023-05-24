Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11709C77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 May 2023 11:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjEXLeb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 May 2023 07:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjEXLea (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2023 07:34:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102B3122
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2023 04:34:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q1ml8-0003M0-Vt; Wed, 24 May 2023 13:34:27 +0200
Date:   Wed, 24 May 2023 13:34:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, f@calendula,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables; key update with symbolic values/immediates
Message-ID: <20230524113426.GA12567@breakpoint.cc>
References: <20230523172931.GB17561@breakpoint.cc>
 <ZG3Bqcz3Dru4xOBS@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG3Bqcz3Dru4xOBS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If you have a use-case for this, go ahead.

Thanks, will do.

> Is there any other issue you can forecast on the delinearize path? Or
> is it just that the code to handle this is missing?

Its just missing, I hope it doesn't require any insane stunts.
