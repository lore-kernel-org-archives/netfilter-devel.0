From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/5] fib: Support existence check
Date: Fri, 10 Mar 2017 19:07:25 +0100
Message-ID: <20170310180725.GB25458@salvia>
References: <20170310171353.28868-1-phil@nwl.cc>
 <20170310171353.28868-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755480AbdCJSHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 13:07:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12DF01B8407
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:07:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2E21DA804
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:07:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B73BADA808
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:07:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170310171353.28868-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 10, 2017 at 06:13:52PM +0100, Phil Sutter wrote:
[...]
> diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
> index f5258165384dc..e928a19649133 100644
> --- a/tests/py/inet/fib.t.payload
> +++ b/tests/py/inet/fib.t.payload
> @@ -20,3 +20,13 @@ __map%d test-ip 0
>  ip test-ip prerouting
>    [ fib daddr . iif type => reg 1 ]
>    [ lookup reg 1 set __map%d dreg 0 ]
> +
> +# fib daddr oif exists
> +ip test-ip prerouting
> +  [ fib daddr oif => reg 1 ]

Instead of casting out the flag like this:

@@ -173,7 +173,7 @@  nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 {
        struct nftnl_expr_fib *fib = nftnl_expr_data(e);
        int len = size, offset = 0, ret, i;
-       uint32_t flags = fib->flags;
+       uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
        static const struct {
                int bit;
                const char *name;

I think it would be better if we have a different fib output for the
present case, eg.

        [ fib daddr oif present => reg 1 ]

So we can see from --debug=netlink this generates bytecode to check
the presence.

Same thing applies to:

# exthdr hbh exists
ip6 test-ip6 input
  [ exthdr load 1b @ 43 + 0 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

Instead, I'd suggest something like:

  [ exthdr 43 present => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

You would need to send a follow up to amend test for 3/5, but that
should be no problem.

Thanks!
