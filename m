From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Tue, 25 Jun 2013 18:01:41 +0200
Message-ID: <20130625160141.GA5816@localhost>
References: <20130610093544.GA31559@gmail.com>
 <20130612075155.GA21252@breakpoint.cc>
 <20130612085037.GA10600@localhost>
 <20130612090815.GA13356@localhost>
 <20130612100605.GB21252@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55524 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FYQBr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20130612100605.GB21252@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 12, 2013 at 12:06:05PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I think this is still useful for people cross-compiling and installing
> > > iptables in some custom location.
> > 
> > Hm, still, this may confuse people, as xt_connlabel always looks at:
> > 
> > #define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
> 
> Right; this is easily fixable. However, this is also
> the default in libnetfilter_conntrack.  But lnf-ct wont be
> able to know what configure options iptables was built with.

We can define the default location in libnetfilter_conntrack.h, eg.

#define NFCT_CONNLABEL_CFG "/etc/xtables/connlabel.conf"

I think connlabel is not of much use without libnetfilter_conntrack,
since it provides the translation of the connlabel mapping. So we can
conditionally compile connlabel support if libnetfilter_conntrack is
installed. We can make it a soft dependency, ie. no need for
--enable-connlabel.

Regards.
