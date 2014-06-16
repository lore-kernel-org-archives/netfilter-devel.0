From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Mon, 16 Jun 2014 15:24:25 +0200
Message-ID: <20140616132425.GK1982@breakpoint.cc>
References: <20140616114154.GI1982@breakpoint.cc>
 <20140616131931.GA29940@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33409 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbaFPNY1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:24:27 -0400
Content-Disposition: inline
In-Reply-To: <20140616131931.GA29940@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> Sorry for lack of explanation.
> 
> On Mon, Jun 16, 2014 at 01:41:54PM +0200, Florian Westphal wrote:
> > So, if only ct2 has attr:
> > nfct_get_attr_u16(ct1, ATTR_ZONE) -> returns 0
> > nfct_get_attr_u16(ct2, ATTR_ZONE) -> returns the zone id
> > 
> > ct1 and ct2 would be equal if ct2 zone is 0.
> 
> And nfct_cmp(ct1, ct2, NFCT_CMP_MASK) is expected to return
> true if ct2 zone is not 0.

You're right.  I think your patch is the right thing to do.
