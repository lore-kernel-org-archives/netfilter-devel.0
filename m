Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3983C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 12:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjKCMOu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjKCMOu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 08:14:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD62CE
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:14:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyt4W-0005dS-2l; Fri, 03 Nov 2023 13:14:44 +0100
Date:   Fri, 3 Nov 2023 13:14:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
Message-ID: <20231103121444.GA20723@breakpoint.cc>
References: <20231102112122.383527-1-thaller@redhat.com>
 <20231102112122.383527-2-thaller@redhat.com>
 <ZUOHkxVCA1FyJvNd@calendula>
 <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
 <ZUPGRh7JZFGXfGgE@calendula>
 <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
 <ZUQL1690tW+XAnS4@calendula>
 <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> What is the correct JSON syntax for printing a chain?

Thats the problem, the chain has no user-visible name :-)

Its a shortcut syntax alias.  Essentially, this:

 meta l4proto { tcp, udp } th dport domain jump {
   ip6 saddr != $private_ip6 counter reject
   accept
 }

is the same as
 chain $RANDOM_NAME {
   ip6 saddr != $private_ip6 counter reject
   accept
 }
  meta l4proto { tcp, udp } th dport domain jump $RANDOM_NAME

Except that, if you remove the rule, then $RANDOM_NAME chain
is deleted as well and that $RANDOM_NAME is readonly after creation
(you cannot add or remove rules from it).

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
> Is there an example how this JSON output should look like?

We need to define a new syntax for this case.
I think it would be best to recurse, i.e. something like:

# i.e., make it clear that this is a jump ("left" :)
and that the target is a complete, anonymous chain with
0 or more rules embedded within.

 },
 "jump" : {"chain" : { "rule" : {
    "family" : "inet",
    "table": "t", "chain": "c",
    "handle": 5,
    "expr":
       [{"match": {"op": "!=", "left": {
      "payload": {
      "protocol": "ip6",
      "field": "saddr"}},
       "right": {
          "set":
	      [{"prefix": {"addr": "fd00::", "len": 8}}, { ....

