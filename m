From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Wed, 12 Jun 2013 10:50:37 +0200
Message-ID: <20130612085037.GA10600@localhost>
References: <20130610093544.GA31559@gmail.com>
 <20130612075155.GA21252@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49264 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3FLIum (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:50:42 -0400
Content-Disposition: inline
In-Reply-To: <20130612075155.GA21252@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 12, 2013 at 09:51:55AM +0200, Florian Westphal wrote:
> Phil Oester <kernel@linuxace.com> wrote:
> > As reported by Danny Rawlins in bug #828, connlabel.conf is unconditionally
> > installed in /etc/xtables instead of using prefix set at configure time.  Fix
> > to use sysconfdir variable.
> 
> It was intentional.
> I don't want userspace to start guessing where the config file is.

Sorry Florian, we crossed emails while replying this.

I think this is still useful for people cross-compiling and installing
iptables in some custom location.

Regards.
