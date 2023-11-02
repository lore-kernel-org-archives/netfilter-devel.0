Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D943C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 20:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbjKBUvu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKBUvt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 16:51:49 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4762188
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 13:51:43 -0700 (PDT)
Received: from [78.30.35.151] (port=34680 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyefA-00AzR5-NK; Thu, 02 Nov 2023 21:51:42 +0100
Date:   Thu, 2 Nov 2023 21:51:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <ZUQL1690tW+XAnS4@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
 <ZUPGRh7JZFGXfGgE@calendula>
 <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 05:17:56PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 16:54 +0100, Pablo Neira Ayuso wrote:
> > What example would be triggering bug?
> 
> when you apply above patchset (and revert patch 2/7), and:
> 
>     $ make
>     $ ./tests/shell/run-tests.sh
>     ...
>     $ grep '^[^ ]*W[^ ]*:' /tmp/nft-test.latest.*/test.log
>     W: [CHK DUMP]     8/381 tests/shell/testcases/chains/0041chain_binding_0  
>     W: [CHK DUMP]    66/381 tests/shell/testcases/cache/0010_implicit_chain_0
>     W: [CHK DUMP]   226/381 tests/shell/testcases/nft-f/sample-ruleset
>     $ grep -R 'Command `./tests/shell/../../src/nft -j list ruleset""` failed' /tmp/nft-test.latest.*/
>     ...
> 
> Gives:
> 
> tests/shell/testcases/nft-f/sample-ruleset
> tests/shell/testcases/cache/0010_implicit_chain_0
> tests/shell/testcases/chains/0041chain_binding_0
> 
> For example:
> 
> /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_binding_0.4/rc-failed-chkdump:Command `./tests/shell/../../src/nft -j list ruleset""` failed
> /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_binding_0.4/rc-failed-chkdump:>>>>
> /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_binding_0.4/rc-failed-chkdump:warning: stmt ops chain have no json callback
> /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_binding_0.4/rc-failed-chkdump:warning: stmt ops chain have no json callback

Yes, chain statement is lacking a json output, that is correct, that
needs to be done.

But, as for variable and symbol expressions, I do not see how those
can be found in the 'list ruleset' path. Note that symbol expressions
represent a preliminary state of the expression, these type of
expressions go away after evaluation. Same thing applies to variable
expression. They have no use for listing path.

Do you have tests that explicitly refer to the lack of json callback
for variable and symbol expressions just like in the warning above?

> /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_binding_0.4/rc-failed-chkdump:<<<<
> 
> There are also other failures. e.g.
> tests/shell/testcases/parsing/large_rule_pipe does not give stable
> output. I need to drop that .json-nft file in v2.

What does 'unstable' mean in this case?
