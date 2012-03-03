From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Sat, 3 Mar 2012 14:35:10 +0100
Message-ID: <20120303133510.GB18802@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
 <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
 <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
 <alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
 <CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
 <20120224175420.GA11587@1984>
 <CAFntDkz4QtCrgHNFNp6Bn1dGco3HCWthYaFLN_-bUVb2q0wPjQ@mail.gmail.com>
 <20120228235456.GA30286@1984>
 <CAFntDkzLUzL3S6BBhYXMy67gNyCi-xEAUg=eEkaS0WsAgdaz6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58549 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2CCNfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 08:35:14 -0500
Content-Disposition: inline
In-Reply-To: <CAFntDkzLUzL3S6BBhYXMy67gNyCi-xEAUg=eEkaS0WsAgdaz6Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 02, 2012 at 12:59:15PM +0900, Darren Willis wrote:
> On Wed, Feb 29, 2012 at 08:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes. I'd like to send a patch for RFC to the mailing list any time
> > soon. I'll include you in the CC.
> 
> Thanks, sounds interesting.
> 
> > I'm currently working on one user-space helper infrastructure. We can
> > use that infrastructure to implement this helper and many others.
> >
> > I've got the patch in one branch of my kernel tree, it's still
> > experimental stuff, but I expect to have it done soon.
> >
> > Would you be OK with we make this (and other helpers that will surely
> > follow up) in user-space?
> 
> Well, I think long-term that's the way to go. I'd still like to get
> this in its current form, if possible, since it's a simple thing in a
> pretty OK state right now, so it could be ready to go quite quickly.
> Whereas, although I think your helper framework sounds great and is
> the right thing to do, it's also an unknown amount of time away.
> Unless it's going to be landing in the next few weeks?

If we apply this, we'll have to live with it for long time until we
can remove. It's easy to get something it, but not evident to get it
out because somebody will be using it.

> Of course, I don't want to make a lot of work for you - I'll be more
> than happy to revisit this, remove the dhcpv6 helper and re-implement
> it for your new helper framework when it's ready for external
> contributions.

One firewall vendor is supporting the development of this helper
user-space infrastructure, so we'll have the infrastructure soon (by
next kernel release cycle).

Please, ping me in three months or so if you see no advances in this
regard.
