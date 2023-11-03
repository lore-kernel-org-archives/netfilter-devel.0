Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE997C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 12:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjKCMTh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbjKCMTh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 08:19:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BB6D4D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:19:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyt9B-0005f3-7G; Fri, 03 Nov 2023 13:19:33 +0100
Date:   Fri, 3 Nov 2023 13:19:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <20231103121933.GB20723@breakpoint.cc>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
 <ZUPGRh7JZFGXfGgE@calendula>
 <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
 <ZUQL1690tW+XAnS4@calendula>
 <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
 <ZUTfHT189urOlmQA@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUTfHT189urOlmQA@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Do you have tests that explicitly refer to the lack of json callback
> > > for variable and symbol expressions just like in the warning above?
> > > 
> > > > /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-
> > > > 0041chain_binding_0.4/rc-failed-chkdump:<<<<
> > > > 
> > > > There are also other failures. e.g.
> > > > tests/shell/testcases/parsing/large_rule_pipe does not give stable
> > > > output. I need to drop that .json-nft file in v2.
> > > 
> > > What does 'unstable' mean in this case?
> > 
> > It seems, that the order of the elements of the list is unstable.
> 
> Ah, I see, so it is not easy to compare. Thanks for explaining.

If its really just that the element ordering is random, then I think
we should change libnftables to sort before printing, it should not
be too much work/code.
