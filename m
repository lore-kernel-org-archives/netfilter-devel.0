Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E4AC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 15:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbjKCPQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjKCPQu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 11:16:50 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7BFD48
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 08:16:47 -0700 (PDT)
Received: from [78.30.35.151] (port=58230 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyvud-00FXK0-NX; Fri, 03 Nov 2023 16:16:45 +0100
Date:   Fri, 3 Nov 2023 16:16:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <ZUUO21MKrtxB6a4m@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
 <ZUPGRh7JZFGXfGgE@calendula>
 <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
 <ZUQL1690tW+XAnS4@calendula>
 <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
 <ZUTfHT189urOlmQA@calendula>
 <20231103121933.GB20723@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231103121933.GB20723@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 01:19:33PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Do you have tests that explicitly refer to the lack of json callback
> > > > for variable and symbol expressions just like in the warning above?
> > > > 
> > > > > /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-
> > > > > 0041chain_binding_0.4/rc-failed-chkdump:<<<<
> > > > > 
> > > > > There are also other failures. e.g.
> > > > > tests/shell/testcases/parsing/large_rule_pipe does not give stable
> > > > > output. I need to drop that .json-nft file in v2.
> > > > 
> > > > What does 'unstable' mean in this case?
> > > 
> > > It seems, that the order of the elements of the list is unstable.
> > 
> > Ah, I see, so it is not easy to compare. Thanks for explaining.
> 
> If its really just that the element ordering is random, then I think
> we should change libnftables to sort before printing, it should not
> be too much work/code.

There is a sort function that is already used when listing elements IIRC.

Maybe this is missing the json codepath?
