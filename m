From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-ct V3] conntrack: api: add nfct_snprintf_labels
Date: Thu, 4 Jul 2013 11:02:04 +0200
Message-ID: <20130704090204.GB3798@localhost>
References: <1372849582-14738-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3GDJCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:02:15 -0400
Content-Disposition: inline
In-Reply-To: <1372849582-14738-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 03, 2013 at 01:06:22PM +0200, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> nfct_snprintf doesn't print connlabels, as they're system specific
> and can easily generate lots of output.
> 
> This adds a new helper function, nfct_snprintf_labels. It behaves like
> nfct_snprintf, except that the label names in the labelmap whose bits are
> contained in connlabel attribute bitset are added to the buffer.
> 
> output looks like this:
> output looks like this:
> ... mark=0 use=1 labels=eth0-in,eth1-in
> or
> <labels>
> <label>eth0-in</label>
> <label>eth1-in</label>
> </labels>

Looks good, thanks Florian!
