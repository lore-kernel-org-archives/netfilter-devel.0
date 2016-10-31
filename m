From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] Allow concatenation of rt nexthop etc.
Date: Mon, 31 Oct 2016 15:08:33 +0100
Message-ID: <20161031140833.GA20216@salvia>
References: <1477734549.1059.65.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943136AbcJaOIj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:08:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C62DFE8392
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:08:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6CE4BAC2F
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:08:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6955ABAC2F
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:08:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477734549.1059.65.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 29, 2016 at 09:49:09AM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> Concatenations of rt nexthop or ct {orignal | reply} {saddr | daddr} fail
> due to
> 
>  # nft add rule ip filter postrouting flow table acct \{ ip saddr . rt nexthop counter \}
>  <cmdline>:1:61-70: Error: can not use variable sized data types (invalid) in concat expressions
>  add rule ip filter postrouting flow table acct { ip saddr . rt nexthop counter }
>                                                   ~~~~~~~~~~~^^^^^^^^^^
> 
> Fix this by reordering the check for variable size data types in
> expr_evaluate_concat() to happen after expr_evaluate() has been called (via
> list_member_evaluate()) for the sub expression. This allows
> expr_evaluate_[cr]t() to call [cr]t_expr_update_type() and set the data type
> before the check.

Applied, thanks Anders.

P.S: I can see git am sometimes complain about trailing CRLF, also
patchwork seems to skip some of your patches for some reason, which
makes it easier for us to lose stuff from you. I guess it's probably
MUA related problem, it would be great if you find the root cause.
