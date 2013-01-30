From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] Introduce aliases for matches and targets
Date: Thu, 31 Jan 2013 00:43:32 +0100
Message-ID: <20130130234332.GA4371@localhost>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
 <alpine.DEB.2.00.1301302204260.24048@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:41259 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756418Ab3A3Xng (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:43:36 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301302204260.24048@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 30, 2013 at 10:05:19PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Mon, 28 Jan 2013, Jozsef Kadlecsik wrote:
> 
> > The next patches introduce the alias support for matches and targets in
> > iptables. The goal is to keep the old syntax of matches/targets merged
> > into "super" matches/targets. This way firewall scripts can run unmodified,
> > using the old extensions.
> > 
> > The NOTRACK alias requires a new revision of the CT target (flags are checked
> > in the current revision). Next follows the kernel part of the patches. Until
> > the new revision is missing, instead of the warning, a notice is printed
> > to the users.
> > 
> > Please comment/ACK the patches.
> 
> Is it OK then to apply these patches in the git tree of iptables?

You can apply the basic symmetric aliasing infrastructure plus the
state match to the stable branch.

The aliasing for the CT target would have to wait in the next branch
of iptables until 3.9-rc1 is released.

Thanks Jozsef.
