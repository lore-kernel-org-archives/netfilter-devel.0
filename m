From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next] netfilter: tcp: Use TCP_MAX_WSCALE instead of literal 14
Date: Fri, 21 Apr 2017 09:28:03 +0800
Message-ID: <002701d2ba3e$859eef10$90dccd30$@foxmail.com>
References: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>  <20170419155822.GA8603@salvia>  <1492618928.22296.2.camel@edumazet-glaptop3.roam.corp.google.com>       <20170419195755.GA16404@salvia> <20170419203816.GA25446@salvia>         <002901d2b96f$47891400$d69b3c00$@foxmail.com> <1492690022.22296.27.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg298.qq.com ([184.105.67.102]:38263 "EHLO smtpbg298.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034159AbdDUB2O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 21:28:14 -0400
In-Reply-To: <1492690022.22296.27.camel@edumazet-glaptop3.roam.corp.google.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> On Thu, 2017-04-20 at 08:44 +0800, Gao Feng wrote:
> > > On Wed, Apr 19, 2017 at 09:57:55PM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Apr 19, 2017 at 09:22:08AM -0700, Eric Dumazet wrote:
> > > > > On Wed, 2017-04-19 at 17:58 +0200, Pablo Neira Ayuso wrote:
> > > > > > On Wed, Apr 19, 2017 at 09:23:42AM +0800,
> > > > > > gfree.wind@foxmail.com
> > > wrote:
> > > > > > > From: Gao Feng <fgao@ikuai8.com>
> > > > > > >
> > > > > > > The window scale may be enlarged from 14 to 15 according =
to
> > > > > > > the itef draft
> > https://tools.ietf.org/html/draft-nishida-tcpm-maxwin-03.
> > > > > > >
> > > > > > > Use the macro TCP_MAX_WSCALE to support it easily with TCP
> > > > > > > stack in the future.
> > > > > >
> > > > > > Applied, thanks.
> > > > >
> > > > > Note that linux kernel is not ready yet for a TCP_MAX_WSCALE
> > > > > being changed to 15.
> > > > >
> > > > > Signed 32bit sk counters can already be abused with 1GB TCP
> > > > > windows, for malicious peers sending SACK forcing linux to
> > > > > increase its memory usage above 2GB and overflows are pretty =
bad.
> > > >
> > > > We have tend to use our own definitions for the TCP connection
> > > > tracking so far. This one I checked it refers RFC1323 too.
> > > >
> > > > If this semantics may change from one way to another in a way =
that
> > > > may break conntracking, please let me know, I can toss it here.
> > >
> > > Or I can just amend the commit here to remove the "enlarged from =
14 to
> 15"
> > > comment, I was going to push out this now, but I'll wait a bit.
> >
> > Thanks Eric & Pablo,
> > When the wscale is really enlarged to 15 one day, these Netfilter
> > codes may be modified.
> > Because it would reset the wscale value to the max value which
> > Netfilter support it.
> > 	if (state->td_scale > 14)
> > 		state->td_scale =3D 14;
> > It would cause the receive see a less window size than sender
> > announced actually.
>=20
> Simply because some middle boxes are enforcing the limit of 14, a =
change of
> TCP stacks on peers might be simply not possible without causing =
serious
> interoperability issues.
>=20
> This IETF draft assumes TCP peers can freely decide of what they can =
do, but
> experience shows that they can not.
>=20
> TCP FastOpen for example hit a bug in linux TCP conntracking, and some =
linux
> middle boxes are still having this bug.
>=20
> ( SYN messages with data payload was not really considered in the past =
)
>=20

Thanks Eric, I learn a lot.

Best Regards
Feng

