Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC6EC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjKCLxK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjKCLxJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:53:09 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3951BC
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:53:06 -0700 (PDT)
Received: from [78.30.35.151] (port=40982 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qysjW-00EhlP-IF; Fri, 03 Nov 2023 12:53:04 +0100
Date:   Fri, 3 Nov 2023 12:53:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <ZUTfHT189urOlmQA@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
 <ZUPGRh7JZFGXfGgE@calendula>
 <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
 <ZUQL1690tW+XAnS4@calendula>
 <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Fri, Nov 03, 2023 at 09:45:38AM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 21:51 +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 02, 2023 at 05:17:56PM +0100, Thomas Haller wrote:
> > 
> > 
> > Yes, chain statement is lacking a json output, that is correct, that
> > needs to be done.
> 
> What is the correct JSON syntax for printing a chain?

There is currently no syntax, so this needs to be defined.

> For example, for test "tests/shell/testcases/nft-f/sample-ruleset" I
> get the following from `nft -j list ruleset`:
> 
>     [...]
>     {
>       "rule": {
>         "family": "inet",
>         "table": "filter",
>         "chain": "home_input",
>         "handle": 91,
>         "expr": [
>           {
>             "match": {
>               "op": "==",
>               "left": {
>                 "meta": {
>                   "key": "l4proto"
>                 }
>               },
>               "right": {
>                 "set": [
>                   "tcp",
>                   "udp"
>                 ]
>               }
>             }
>           },
>           {
>             "match": {
>               "op": "==",
>               "left": {
>                 "payload": {
>                   "protocol": "th",
>                   "field": "dport"
>                 }
>               },
>               "right": 53
>             }
>           },
>           "jump {\n\t\t\tip6 saddr != { fd00::/8, fe80::/64 } counter packets 0 bytes 0 reject with icmpv6 port-unreachable\n\t\t\taccept\n\t\t}"
>         ]
>       }
>     },
>     [...]
> 
> 
> In `man libnftables-json`, searching for "jump" only gives:
> 
>     { "jump": { "target": * STRING *}}
> 
> 
> Is there an example how this JSON output should look like?
> 
> (or a test, after all, I want to feed this output back into `nft -j --check -f -`).

Maybe something like:

     { "jump": { "chain" : [ rules here ] }

but I would need to sketch some code to explore how complicate this is
to reuse existing JSON code.

> > But, as for variable and symbol expressions, I do not see how those
> > can be found in the 'list ruleset' path. Note that symbol expressions
> > represent a preliminary state of the expression, these type of
> > expressions go away after evaluation. Same thing applies to variable
> > expression. They have no use for listing path.
> 
> ACK about symbol_expr_ops + variable_expr_ops. I will send a minor
> patch about that (essentially with code comments and remove the
> elaborate fallback code).

OK, so it is chain statement that is missing the json callback.

> > Do you have tests that explicitly refer to the lack of json callback
> > for variable and symbol expressions just like in the warning above?
> > 
> > > /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-
> > > 0041chain_binding_0.4/rc-failed-chkdump:<<<<
> > > 
> > > There are also other failures. e.g.
> > > tests/shell/testcases/parsing/large_rule_pipe does not give stable
> > > output. I need to drop that .json-nft file in v2.
> > 
> > What does 'unstable' mean in this case?
> 
> It seems, that the order of the elements of the list is unstable.

Ah, I see, so it is not easy to compare. Thanks for explaining.

> I didn't investigate. At this point, I only want to add the
> .json-nft files for tests that pass, and worry about the remaining
> issues after the basic test infrastructure about .json-nft tests is
> up.

