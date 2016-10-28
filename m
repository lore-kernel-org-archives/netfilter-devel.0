From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nftables] rt: introduce routing expression
Date: Fri, 28 Oct 2016 10:43:05 +0200
Message-ID: <20161028084305.GA29228@salvia>
References: <1477634191.1059.30.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45268 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756227AbcJ1InL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 04:43:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 029DD26E08
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:43:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E71FCBAC2F
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:43:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0400BAC27
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:43:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477634191.1059.30.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One comment though, it would be great if you can send me a follow up
patch to update 

On Fri, Oct 28, 2016 at 05:56:32AM +0000, Anders K. Pedersen | Cohaesio wrote:
> diff --git a/tests/files/expr-rt b/tests/files/expr-rt
> new file mode 100644
> index 0000000..4c15409
> --- /dev/null
> +++ b/tests/files/expr-rt
> @@ -0,0 +1,21 @@
> +#! nft -f
> +
> +add table ip filter
> +add chain ip filter output { type filter hook output priority 0 ; }
> +
> +add table ip6 filter
> +add chain ip6 filter output { type filter hook output priority 0 ; }
> +
> +add table inet filter
> +add chain inet filter output { type filter hook output priority 0 ; }
> +
> +# rt: classid (see /etc/iproute2/rt_realms)
> +add rule ip filter output rt classid cosmos counter
> +add rule ip6 filter output rt classid cosmos counter
> +add rule inet filter output rt classid cosmos counter
> +
> +# rt: nexthop
> +add rule ip filter output rt nexthop 192.168.0.1 counter
> +add rule ip6 filter output rt nexthop fd00::1 counter
> +add rule inet filter output ether type ip rt nexthop 192.168.0.1 counter
> +add rule inet filter output ether type ip6 rt nexthop fd00::1 counter

Please, move this test to tests/py/inet/rt.t

You will also need to generate the rt.t.payload* files, it should be
easy to generate them, just a bit timeconsuming janitoring task, but
definitely not hard.

We'll remove test/files/ soon, several files there are
broken/obsolete, and remaining working stuff we will merge into
tests/shell.

Thanks.
