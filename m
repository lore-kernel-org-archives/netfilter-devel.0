From: Darren Willis <djw@google.com>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Fri, 2 Mar 2012 12:59:15 +0900
Message-ID: <CAFntDkzLUzL3S6BBhYXMy67gNyCi-xEAUg=eEkaS0WsAgdaz6Q@mail.gmail.com>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
	<alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
	<CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
	<alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
	<CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
	<20120224175420.GA11587@1984>
	<CAFntDkz4QtCrgHNFNp6Bn1dGco3HCWthYaFLN_-bUVb2q0wPjQ@mail.gmail.com>
	<20120228235456.GA30286@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42198 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2CBD7Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:59:16 -0500
Received: by vbbff1 with SMTP id ff1so1159144vbb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Mar 2012 19:59:16 -0800 (PST)
In-Reply-To: <20120228235456.GA30286@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 29, 2012 at 08:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Yes. I'd like to send a patch for RFC to the mailing list any time
> soon. I'll include you in the CC.

Thanks, sounds interesting.

> I'm currently working on one user-space helper infrastructure. We can
> use that infrastructure to implement this helper and many others.
>
> I've got the patch in one branch of my kernel tree, it's still
> experimental stuff, but I expect to have it done soon.
>
> Would you be OK with we make this (and other helpers that will surely
> follow up) in user-space?

Well, I think long-term that's the way to go. I'd still like to get
this in its current form, if possible, since it's a simple thing in a
pretty OK state right now, so it could be ready to go quite quickly.
Whereas, although I think your helper framework sounds great and is
the right thing to do, it's also an unknown amount of time away.
Unless it's going to be landing in the next few weeks?

Of course, I don't want to make a lot of work for you - I'll be more
than happy to revisit this, remove the dhcpv6 helper and re-implement
it for your new helper framework when it's ready for external
contributions.
