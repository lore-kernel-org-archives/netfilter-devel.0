From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Wed, 12 Jun 2013 11:08:15 +0200
Message-ID: <20130612090815.GA13356@localhost>
References: <20130610093544.GA31559@gmail.com>
 <20130612075155.GA21252@breakpoint.cc>
 <20130612085037.GA10600@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55306 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab3FLJIV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:08:21 -0400
Content-Disposition: inline
In-Reply-To: <20130612085037.GA10600@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 12, 2013 at 10:50:37AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 12, 2013 at 09:51:55AM +0200, Florian Westphal wrote:
> > Phil Oester <kernel@linuxace.com> wrote:
> > > As reported by Danny Rawlins in bug #828, connlabel.conf is unconditionally
> > > installed in /etc/xtables instead of using prefix set at configure time.  Fix
> > > to use sysconfdir variable.
> > 
> > It was intentional.
> > I don't want userspace to start guessing where the config file is.
> 
> Sorry Florian, we crossed emails while replying this.
> 
> I think this is still useful for people cross-compiling and installing
> iptables in some custom location.

Hm, still, this may confuse people, as xt_connlabel always looks at:

#define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
