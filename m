From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec)
 [part 2]
Date: Fri, 23 Mar 2012 11:26:23 +0100
Message-ID: <20120323102623.GA22440@1984>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
 <1332361663.9433.8.camel@edumazet-glaptop>
 <CANP3RGdUHYzLKaGR2APoWzbV2LSquujXoNdsTN-yYs8=bT=5kw@mail.gmail.com>
 <1332362670.9433.9.camel@edumazet-glaptop>
 <CAHo-OozsBkyQ-hq0Hkuef3uohemnHCh1qBo02By-kE5Rpt92Lg@mail.gmail.com>
 <20120322112120.GA16645@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35701 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab2CWK0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:26:36 -0400
Content-Disposition: inline
In-Reply-To: <20120322112120.GA16645@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 22, 2012 at 12:21:20PM +0100, Pablo Neira Ayuso wrote:
> Hi Maciej,
>=20
> On Wed, Mar 21, 2012 at 01:50:59PM -0700, Maciej =C5=BBenczykowski wr=
ote:
> > > True, but CLOEXEC on iptables... I mean... how is it mandatory ?
> >=20
> > I'm not sure what you mean by mandatory.
>=20
> If this patch is needed, I think we have to stick to fcntl for
> backward compatibility reasons as well.
>=20
> > iptables does potentially fork/exec modprobe to load modules.
> > That can cause a selinux 'domain'/'role'/whatever-it-is-called cros=
sing.
> > You can do automated inspection of what gets carried across such
> > privilege changes and any unexpected open file descriptors flag
> > problems, patches like this cut down on the noise.
>=20
> Could you resend the patch including the description of the precise
> problem that this fixes in selinux?

No need to do it. I've applied this to git.netfilter.org.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
