From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnf-queue] examples: attaching a conntrack information
Date: Thu, 10 Sep 2015 00:58:27 +0200
Message-ID: <20150909225827.GE24810@breakpoint.cc>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150909095851.GD11843@gmail.com>
 <20150909202932.GC24810@breakpoint.cc>
 <20150909222250.GA545@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53671 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbbIIW6a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 18:58:30 -0400
Content-Disposition: inline
In-Reply-To: <20150909222250.GA545@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> On Wed, Sep 09, 2015 at 10:29:32PM +0200, Florian Westphal wrote:
> > Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> > > +	if (attr == NULL)
> > > +		return MNL_CB_OK;
> > > +	attr->nla_len = 12;
> > 
> > What this?
> 
> I just wanted to test const qualifier... sorry.

I suspected as much ;)

> Would you mind deleting the line? or should I send it again?

I can delete it.
