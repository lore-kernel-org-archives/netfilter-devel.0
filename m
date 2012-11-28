From: Florian Westphal <fw@strlen.de>
Subject: lnf_conntrack: nfct_cmp NFCT_CMP_TIMEOUT_* flags not supported?
Date: Wed, 28 Nov 2012 13:59:30 +0100
Message-ID: <20121128125930.GF14156@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53572 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284Ab2K1M7b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:59:31 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@strlen.de>)
	id 1TdhEg-0003T7-Cn
	for netfilter-devel@vger.kernel.org; Wed, 28 Nov 2012 13:59:30 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

I added api_tests for the various nfct_cmp timeout flags.
And guess what: They don't work 8-}

It fails on the 2nd assert below:
assert(nfct_cmp(ct, ct2, NFCT_CMP_TIMEOUT_EQ) == 1);
nfct_set_attr_u32(ct2, ATTR_TIMEOUT, nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1);
assert(nfct_cmp(ct2, ct, NFCT_CMP_TIMEOUT_EQ) == 0);

The reason is that __compare() doesn't know about NFCT_CMP_TIMEOUT*
flags and returns 1 unconditionally.

So, my question is:
How are the NFCT_CMP_TIMEOUT flags supposed to be used?

>From the documentation it appears as if they should be used
together with _ALL, _ORIG, _REPLY, or even standalone, i.e.
__compare needs to check for these, too:

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index b18f7fc..7cd28e7 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -407,5 +407,8 @@ int __compare(const struct nf_conntrack *ct1,
        if (flags & NFCT_CMP_REPL && !cmp_repl(ct1, ct2, flags))
                return 0;
 
+       if (flags & (NFCT_CMP_TIMEOUT_GT|NFCT_CMP_TIMEOUT_LE))
+               return cmp_meta(ct1, ct2, flags);
+
        return 1;
 }

With the above change the new tests pass.
