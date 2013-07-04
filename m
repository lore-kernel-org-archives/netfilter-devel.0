From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] iptables: set errno correctly in iptcc_chain_index_alloc
Date: Thu, 4 Jul 2013 09:18:45 -0700
Message-ID: <20130704161845.GA11465@linuxace.com>
References: <20130704011610.GA9791@linuxace.com>
 <20130704074222.GC2351@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41370 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3GDQSs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:18:48 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so1341147pbb.20
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jul 2013 09:18:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130704074222.GC2351@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 04, 2013 at 09:42:22AM +0200, Florian Westphal wrote:
> Personally I think libraries should not change errno at all.

OK, but then we output misleading error messages.

> I don't understand how this changes anything?

Simulate an out of memory condition with this patch

@@ -500,9 +500,11 @@ static int iptcc_chain_index_alloc(struct xtc_handle *h)
              array_elems, array_mem);

        h->chain_index = malloc(array_mem);
-       if (h->chain_index == NULL && array_mem > 0) {
+       //if (h->chain_index == NULL && array_mem > 0) {
+       if (1) {
                h->chain_index_sz = 0;

With the patch, the error message returned to user:

   ...can't initialize iptables table `filter': Memory allocation problem

without the patch:

   ...can't initialize iptables table `filter': Incompatible with this kernel

The former seems better, no?

Phil
