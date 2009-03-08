From: Pierre Chifflier <p.chifflier@inl.fr>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sun, 8 Mar 2009 10:53:19 +0100
Message-ID: <20090308095318.GA4009@piche.inl.fr>
References: <49B166E0.7030201@netfilter.org> <20090307103406.GB4678@prithivi.gnumonks.org> <alpine.LSU.2.00.0903071542590.26625@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from AOrleans-204-1-39-42.w80-14.abo.wanadoo.fr ([80.14.48.42]:46192
	"EHLO fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZCHKRs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:17:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0903071542590.26625@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 07, 2009 at 03:43:47PM +0100, Jan Engelhardt wrote:
> 
> On Saturday 2009-03-07 11:34, Harald Welte wrote:
> >On Fri, Mar 06, 2009 at 07:09:36PM +0100, Pablo Neira Ayuso wrote:
> >>       Link ulogd2 with libpthread
> >
> >I was just reading this and all alarm sirens went on.  I don't know
> >why that is neccessary, and I hope it is just due to some library dependency.

Hi,

I plead guilty, I'm the one who did the commit ;)

The commit message explains why:
Explicitly link with libpthread. This allows to run ulogd within gdb,
else it fails with message: Cannot find new threads: generic error

I don't know why, but gdb fails on some configs if not linked with
libpthread. Maybe this is related to some other parameters (32/64 bits ?
libc version ?), yet adding -lpthread solves the problem.
One could argue that gdb should be fixed, though.

> >
> >When I created ulogd and ulogd2, I never intended them to become some kind of
> >multi-threaded monster with a complex locking and synchronization nightmare.

Yep, we did not change anything regarding to that (and share the same
view for the multi-thread beast).

> 
> Yeah there seems to be not a single pthread_ call or type in use,
> so I wonder why it was done.

Threads are not used, the -lpthread could even be dropped without
any other effect than causing problems again with gdb.

Pierre

