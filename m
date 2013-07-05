From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Fri, 5 Jul 2013 10:19:10 +0200
Message-ID: <20130705081910.GA25000@breakpoint.cc>
References: <20130705020312.25783ccd.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757171Ab3GEITR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:19:17 -0400
Content-Disposition: inline
In-Reply-To: <20130705020312.25783ccd.billfink@mindspring.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bill Fink <billfink@mindspring.com> wrote:
> 230 Anonymous login ok, restrictions apply.
> EPSV
> 229 Entering Extended Passive Mode (|||1584|)
> 
> As soon as I enter the EPSV command, I get the following
> conntrackd segfault:
> 
> Jul  5 00:41:06 sen-fw1 kernel: [274422.060695] conntrackd[4821]: segfault at 0 ip 000000000040c660 sp 00007fffebb098a8 error 4 in conntrackd[400000+3d000]

#0  0x000000000040f217 in jhash2 (k=0x0, length=4, initval=0) at
../include/jhash.h:99
99                      a += k[0];
(gdb) bt f
#0  0x000000000040f217 in jhash2 (k=0x0, length=4, initval=0) at ../include/jhash.h:99
        a = 2654435769 b = 2654435769 c = 0 len = 4
#1  0x000000000040f564 in ct_filter_hash6 (data=0x0, table=0x16ef630) at filter.c:57
#2  0x000000000040ad34 in hashtable_hash (table=0x16ef630, data=0x0) at hash.c:63
#3  0x000000000040fd19 in __ct_filter_test_ipv6 (f=0x16eeba0, ct=0x1703760) at filter.c:265
id_src = 51 id_dst = 24051376 src = 0x1703760 dst = 0x0

NULL deref in __ct_filter_test_ipv6.  Doesn't happen for ipv4 because
nfct_get_attr_u32() return 0, but nfct_get_attr() returns NULL instead.

@@ -261,8 +264,8 @@ __ct_filter_test_ipv6(struct ct_filter *f, const
		struct nf_conntrack *ct)
        src = nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
        dst = nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);

-       id_src = hashtable_hash(f->h6, src);
-       id_dst = hashtable_hash(f->h6, dst);
+       id_src = src ? hashtable_hash(f->h6, src) : 0;
+       id_dst = dst ? hashtable_hash(f->h6, dst) : 0;


Not sure if this is enough, there are other callers
of nfct_get_attr() that don't check for NULL.
