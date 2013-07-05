From: Bill Fink <billfink@mindspring.com>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Fri, 5 Jul 2013 15:45:27 -0400
Message-ID: <20130705154527.8f18a181.billfink@mindspring.com>
References: <20130705020312.25783ccd.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:41357 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162Ab3GETp2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:45:28 -0400
In-Reply-To: <20130705020312.25783ccd.billfink@mindspring.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Please Cc: me on replies as I am not subscribed]

Florian,

First, many thanks for the quick fix!

On Fri, 5 Jul 2013, Florian Westphal wrote:

> Bill Fink <billfink@xxxxxxxxxxxxxx> wrote:
> > 230 Anonymous login ok, restrictions apply.
> > EPSV
> > 229 Entering Extended Passive Mode (|||1584|)
> > 
> > As soon as I enter the EPSV command, I get the following
> > conntrackd segfault:
> > 
> > Jul  5 00:41:06 sen-fw1 kernel: [274422.060695] conntrackd[4821]: segfault at 0 ip 000000000040c660 sp 00007fffebb098a8 error 4 in conntrackd[400000+3d000]
> 
> #0  0x000000000040f217 in jhash2 (k=0x0, length=4, initval=0) at
> ../include/jhash.h:99
> 99                      a += k[0];
> (gdb) bt f
> #0  0x000000000040f217 in jhash2 (k=0x0, length=4, initval=0) at ../include/jhash.h:99
>         a = 2654435769 b = 2654435769 c = 0 len = 4
> #1  0x000000000040f564 in ct_filter_hash6 (data=0x0, table=0x16ef630) at filter.c:57
> #2  0x000000000040ad34 in hashtable_hash (table=0x16ef630, data=0x0) at hash.c:63
> #3  0x000000000040fd19 in __ct_filter_test_ipv6 (f=0x16eeba0, ct=0x1703760) at filter.c:265
> id_src = 51 id_dst = 24051376 src = 0x1703760 dst = 0x0
> 
> NULL deref in __ct_filter_test_ipv6.  Doesn't happen for ipv4 because
> nfct_get_attr_u32() return 0, but nfct_get_attr() returns NULL instead.
> 
> @@ -261,8 +264,8 @@ __ct_filter_test_ipv6(struct ct_filter *f, const
> 		struct nf_conntrack *ct)
>         src = nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
>         dst = nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);
> 
> -       id_src = hashtable_hash(f->h6, src);
> -       id_dst = hashtable_hash(f->h6, dst);
> +       id_src = src ? hashtable_hash(f->h6, src) : 0;
> +       id_dst = dst ? hashtable_hash(f->h6, dst) : 0;
> 
> 
> Not sure if this is enough, there are other callers
> of nfct_get_attr() that don't check for NULL.

This cured my immediate problem.  conntrackd no longer segfaults
and I now get IPv6 expectations.

[root@sen-fw1 ~]# conntrackd -i expect
proto=6 src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=0 dport=23046 mask-src=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff mask-dst=ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff sport=0 dport=65535 master-src=2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx master-dst=2001:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy:yyyy sport=38142 dport=21 class=0 helper=ftp [active since 44s]

I will now continue further testing.

I did need my patch to successfully resync the IPv6 expectations
from the kernel via "conntrackd -R" after flushing the conntrackd
cache via "conntrackd -f".

I guess I should submit my patch as an RFC patch to get
comments on it.

					-Thanks

					-Bill
