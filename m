From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] conntrack: fix nfct_clone with certain attribute
 data types
Date: Tue, 27 Nov 2012 22:15:23 +0100
Message-ID: <20121127211523.GA5131@1984>
References: <1354030656-23507-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38556 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab2K0VPb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:15:31 -0500
Content-Disposition: inline
In-Reply-To: <1354030656-23507-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 04:37:36PM +0100, Florian Westphal wrote:
> some attributes are pointers to malloc'd objects.  Simply copying the
> pointer results in use-after free when the original or the clone is
> destroyed.
> 
> Fix it by using nfct_copy instead of memcpy and add proper test case
> for cloned objects:
> - nfct_cmp of orig and clone should return 1 (equal)
> - freeing both the original and the clone should
>   neither leak memory nor result in double-frees.
> 
> the testsuite changes revealed a few more problems:
>  - ct1->timeout == ct2->timeout returned 0, ie. same timeout
>    was considered "not equal" by nfct_cmp
>  - secctx comparision causes "Invalid address" valgrind warnings
>    when pointer is NULL
>  - NFCT_CP_OVERRIDE did not handle helper attribute and
>    erronously freed ct1 secctx memory.
> 
> While at it, bump qa_test data dummy to 256 (else, valgrind
> complains about move-depends-on-uninitialized-memory).
> 
> Lastly, fix compilation of test_api by killing bogus ATTR_CONNLABEL.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

This is great, thanks Florian.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
