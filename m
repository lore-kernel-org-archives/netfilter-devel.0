From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Fri, 19 Oct 2012 10:19:59 +0200
Message-ID: <20121019081959.GA11880@1984>
References: <1350577344-16321-1-git-send-email-fw@strlen.de>
 <20121018165104.GA15142@1984>
 <20121018203809.GA18674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab2JSIUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:20:05 -0400
Content-Disposition: inline
In-Reply-To: <20121018203809.GA18674@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Oct 18, 2012 at 10:38:09PM +0200, Florian Westphal wrote:
[...]
> The problem i have with this is that 32 unique bits is a bit (pun intended)
> low.  If its used as enumeration its plentiful but i specifically want
> to be able to attach 'lots of' different labels to a conntrack entry.

Ah I see. You want overlapping labels, I like that idea :-)

What if we provide overlapping and non-overlapping label types,
something like:

struct nf_conn_label {
        uint64_t overlapping:56,
                 enumerated:8;
};

That provides 56 overlapping labels and 256 non-overlapping labels.
There will be two configuration files to be used depending on what you
want. I'm not sure what amount of labels would be fine.

Probably, this alternative semantics could be useful:

struct nf_conn_label {
        uint64_t mask:56,
                 type:8;
};

For each type (we would have 2^8), we have 56 overlapping labels.

Thus, we make sure this extension only requires 64-bits (plus the
extension structure, of course).

My only concern with dynamically allocated purely bit-based labels is
that users may bloat the size of each conntrack entry.

Let me know.

Regards.
