From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] Introduce aliases for matches and targets
Date: Thu, 31 Jan 2013 20:40:09 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301312039260.26517@blackhole.kfki.hu>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu> <alpine.DEB.2.00.1301302204260.24048@blackhole.kfki.hu> <20130130234332.GA4371@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53986 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3AaTkM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:40:12 -0500
In-Reply-To: <20130130234332.GA4371@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 31 Jan 2013, Pablo Neira Ayuso wrote:

> On Wed, Jan 30, 2013 at 10:05:19PM +0100, Jozsef Kadlecsik wrote:
> > Hi Pablo,
> > 
> > On Mon, 28 Jan 2013, Jozsef Kadlecsik wrote:
> > 
> > > The next patches introduce the alias support for matches and targets in
> > > iptables. The goal is to keep the old syntax of matches/targets merged
> > > into "super" matches/targets. This way firewall scripts can run unmodified,
> > > using the old extensions.
> > > 
> > > The NOTRACK alias requires a new revision of the CT target (flags are checked
> > > in the current revision). Next follows the kernel part of the patches. Until
> > > the new revision is missing, instead of the warning, a notice is printed
> > > to the users.
> > > 
> > > Please comment/ACK the patches.
> > 
> > Is it OK then to apply these patches in the git tree of iptables?
> 
> You can apply the basic symmetric aliasing infrastructure plus the
> state match to the stable branch.
> 
> The aliasing for the CT target would have to wait in the next branch
> of iptables until 3.9-rc1 is released.

The patches are applied except the last one for the CT target.

Best regards
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
