From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Tue, 25 Jun 2013 21:52:00 +0200
Message-ID: <20130625195200.GB28818@breakpoint.cc>
References: <20130610093544.GA31559@gmail.com>
 <20130612075155.GA21252@breakpoint.cc>
 <20130612085037.GA10600@localhost>
 <20130612090815.GA13356@localhost>
 <20130612100605.GB21252@breakpoint.cc>
 <20130625160141.GA5816@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52737 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab3FYTwC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:52:02 -0400
Content-Disposition: inline
In-Reply-To: <20130625160141.GA5816@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 12, 2013 at 12:06:05PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > I think this is still useful for people cross-compiling and installing
> > > > iptables in some custom location.
> > > 
> > > Hm, still, this may confuse people, as xt_connlabel always looks at:
> > > 
> > > #define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
> > 
> > Right; this is easily fixable. However, this is also
> > the default in libnetfilter_conntrack.  But lnf-ct wont be
> > able to know what configure options iptables was built with.
> 
> We can define the default location in libnetfilter_conntrack.h, eg.
> 
> #define NFCT_CONNLABEL_CFG "/etc/xtables/connlabel.conf"

Sure, I can move the definition from conntrack/labels.c
to a public header.

> I think connlabel is not of much use without libnetfilter_conntrack,
> since it provides the translation of the connlabel mapping. So we can
> conditionally compile connlabel support if libnetfilter_conntrack is
> installed. We can make it a soft dependency, ie. no need for
> --enable-connlabel.

Hrm, the iptables connlabel extension currently parses the labels
config itself.

What we can do is to add soft dependency in iptables for
libnetfilter_conntrack, build the connlabel extension
conditionally and then remove the default file from iptables.

Is that what you have in mind?
