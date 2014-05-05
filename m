From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 0/7] users counter to manage ipv4 defragmentation on
 bridge
Date: Mon, 5 May 2014 22:57:57 +0200
Message-ID: <20140505205757.GB32448@breakpoint.cc>
References: <20140503233908.GA6297@localhost>
 <53678A3E.3060903@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37453 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbaEEU6A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 16:58:00 -0400
Content-Disposition: inline
In-Reply-To: <53678A3E.3060903@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@parallels.com> wrote:
> For nf_conntrack_ipv4 I increment counter once only,
> For TPROXY target and socket match I increment counter on checkentry and
> decrement on destroy hook. So if these modules are just loaded but are not
> used in net namespace, they will not affect ipv4 defragmentation.
> Please let me know if you have some better ideas.

bridges defrag packets (if the nf_defrag_ipv4 is loaded) because
brnf_call_iptables sysctl is set to 1 by default.

What about making this sysctl per-netns?

That way a bridge running inside a netns could disable
iptables processing, it seems to be global switch at this time.

This way you could not enable iptables processing on a bridge
without defrag enabled (again, if the module is loaded), OTOH I
don't see why one would want iptables on a bridge without conntrack
(might as well just use ebtables).
