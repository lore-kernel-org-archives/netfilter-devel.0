From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnf-queue] api: add nfq_nlmsg_get_timestamp helper
Date: Wed, 28 Aug 2013 10:46:52 +0200
Message-ID: <20130828084652.GJ32493@breakpoint.cc>
References: <1377184037-19790-1-git-send-email-fw@strlen.de>
 <20130826225325.GA4695@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37041 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132Ab3H1Iqy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:46:54 -0400
Content-Disposition: inline
In-Reply-To: <20130826225325.GA4695@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Thu, Aug 22, 2013 at 05:07:17PM +0200, Florian Westphal wrote:
> > The NFQA_TIMESTAMP structure is in network byte order, so it seems
> > appropriate to add a helper to convert it to a timeval struct.
[..]

> I think we can update nfq_get_timestamp to use libmnl without breaking
> backward compatibility. Same thing with all other getter functions
> that we have.

How did you plan to do this without breaking api/abi?

To call the existing libnfnetlink based function given an libmnl attr[] array
you need to:

struct nfq_data d;
d.data = (void **) &attr[1];
nfq_get_timestamp(&d, &tv);

Which is just "ewww".
