Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026F6CD8C9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjJJOsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjJJOsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:48:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3417999
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 07:48:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qqE1t-0001L8-OP; Tue, 10 Oct 2023 16:48:13 +0200
Date:   Tue, 10 Oct 2023 16:48:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] doc: remove references to timeout in reset command
Message-ID: <20231010144813.GA1407@breakpoint.cc>
References: <20231010142704.54741-1-pablo@netfilter.org>
 <ZSVgOhTI8mWeeNIp@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSVgOhTI8mWeeNIp@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Tue, Oct 10, 2023 at 04:27:04PM +0200, Pablo Neira Ayuso wrote:
> > After Linux kernel's patch ("netfilter: nf_tables: do not refresh
> > timeout when resetting element") timers are not reset anymore, update
> > documentation to keep this in sync.
> 
> How is limit statement being reset? The dump callbacks in nft_limit.c
> ignore the 'bool reset' parameter.

Was that deliberate?  I don't see why it would be exempt?
