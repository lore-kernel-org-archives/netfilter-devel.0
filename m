From: Florian Westphal <fw@strlen.de>
Subject: [RFC] nftables: reverse path filtering for nft
Date: Sat, 10 Sep 2016 22:01:02 +0200
Message-ID: <20160910200102.GA11377@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52714 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751722AbcIJUBE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2016 16:01:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <fw@strlen.de>)
        id 1bioSU-00031b-Jh
        for netfilter-devel@vger.kernel.org; Sat, 10 Sep 2016 22:01:02 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

Linux has a builtin rp filter for ipv4, but not for ipv6.
xtables has rpfilter match for both ipv4 and ipv6.
nftables currently does not have such a feature.

Any idea on how specific or generic this should be for nft?

Current idea is to add 'fib' expression that initially supports
lookup of outinterface index for reply direction, i.e.:

nft ... fib reply oif ne 0 accept (found something)
nft ... fib reply oif eq 0 drop   (no route)
nft ... fib reply oif eq eth0 (reply would be routed via eth0)

Problem is that we might need some options to influence/control
input to the fib lookup routines, e.g. if we want to consider
skb->mark or if we're only interested in routes via particular interface
(ipv6 needs this, this is what the --loose option does for -m rpfilter
in iptables).

Unfortunately, use of 'mark' results in grammar ambiguity in the parser.

What would work is this:

fib_expr                :       FIB     STRING  fib_args fib_type
                        {
                                $$ = fib_expr_alloc(&@$, $4, get_dir($2));
                        }
                        ;

fib_type                :       OIF     { $$ = NFT_FIB_OIF; }
                        ;

fib_args                :       fib_arg
                        {
                                $<expr>$        = $<expr>0;
                        }
                        |       fib_args        fib_arg
                        ;

fib_arg                 :       MARK
                        {
                                $<expr>0->fib.use_mark = 1;
                        }
                        |       LOOSE
                        {
                                $<expr>0->fib.loose = 1;
                        }
                        ;


Which results in following syntax:

nft .. fib reply mark loose oif eq 0 drop   # no route at all
nft .. fib reply mark oif eq 0 drop   # no route via iif
nft .. fib reply oif eq 0 drop   # no route via iif, do not use skb->mark


Other features that might make sense to implement for fib:
- query mtu on the route  (maybe useful with future tcp option mangling
to create TCPMSS target equvalent...?)

- query what fib says about type of saddr/daddr (iptables -m addrtype match)


Main 'problem' is that I don't want to muck with the syntax later so
it should be flexible enough to cover other uses beside rpf.

What do others think?
