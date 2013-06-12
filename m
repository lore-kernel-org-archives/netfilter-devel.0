From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Wed, 12 Jun 2013 12:06:05 +0200
Message-ID: <20130612100605.GB21252@breakpoint.cc>
References: <20130610093544.GA31559@gmail.com>
 <20130612075155.GA21252@breakpoint.cc>
 <20130612085037.GA10600@localhost>
 <20130612090815.GA13356@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35400 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab3FLKGJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:06:09 -0400
Content-Disposition: inline
In-Reply-To: <20130612090815.GA13356@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think this is still useful for people cross-compiling and installing
> > iptables in some custom location.
> 
> Hm, still, this may confuse people, as xt_connlabel always looks at:
> 
> #define CONNLABEL_CFG "/etc/xtables/connlabel.conf"

Right; this is easily fixable. However, this is also
the default in libnetfilter_conntrack.  But lnf-ct wont be
able to know what configure options iptables was built with.

So libnetfilter-conntrack and conntrack-tool would
end up having to try a couple of locations to find that
config file...
