From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Sat, 14 Jul 2012 15:11:11 +0200
Message-ID: <20120714131111.GB31130@1984>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-5-git-send-email-jengelh@inai.de>
 <20120712154957.GE18793@1984>
 <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
 <20120713091648.GA20796@1984>
 <CAHo-OowA3Tc4DF_OGMOQxiqriqOu-63FM8pbaHwdJx4D0ww7gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45781 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab2GNNLR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:11:17 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OowA3Tc4DF_OGMOQxiqriqOu-63FM8pbaHwdJx4D0ww7gA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 13, 2012 at 06:43:36PM -0700, Maciej =C5=BBenczykowski wrot=
e:
> On Fri, Jul 13, 2012 at 2:16 AM, Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> > On Thu, Jul 12, 2012 at 06:25:13PM +0200, Jan Engelhardt wrote:
> >>
> >> On Thursday 2012-07-12 17:49, Pablo Neira Ayuso wrote:
> >> >> +config NETFILTER_XT_TARGET_SYSRQ
> >> >> +  tristate '"SYSRQ" - remote sysrq invocation'
> >> >
> >> >I guess this is useful for user, eg. you can reboot your crashed
> >> >system from your office in case that cheap comodity hardware with=
out
> >> >remote management tools (eg. HP's ILO or Dell's iDRAC).
> >> >
> >> >Still, I think that including this in Netfilter is a bit of abuse
> >> >since this is out of the scope of providing some firewalling feat=
ure.
> >>
> >> David Miller has stated his opinion already last year, and he's
> >> for the Netfilter variant:
> >> http://markmail.org/message/d7kpczdbtpcxwli6
> >
> > I think that affirmation is true in the context of:
> >
> > [PATCH]: Add Network Sysrq Support
> >
> > but not sure it's out of it.
> >
> > He probably prefered the Netfilter option because, comparing it to =
the
> > Netfilter approach, it looks nicer. Well, just look at all those sy=
sfs
> > and proc interfaces he was proposing for that approach (it seems qu=
ite
> > ugly to me).
> >
> > You can use the udp_encap hook (that Florian mentioned) plus some
> > genetlink interface and little user-space tool to make it out of
> > netfilter. Most of the xt_SYSRQ code can be reused and the genetlin=
k
> > interface plus one library can be added with little extra work.
> >
> > @David: just to put you into context. Jan is proposing to merge
> > xt_SYSRQ into mainstream, we are discussing if it would be better t=
o
> > make it out of it (so people do not depend on the firewalling
> > utilities to get it working) based on a different proposal describe=
d
> > above.
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter=
-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> For this to be truly useful, it has to work when all of userspace is
> dead and unresponsive (oom hell, swap hell, hdd disconnected, etc),
> and as such from the moment the magic packet gets received, to the
> command (reboot/etc) being executed it has to be a fully kernel based
> solution - preferably within the network softirq.
>=20
> Anything relying on userspace (outside of initial configuration) is
> not acceptable.

So far, nobody mentioned the possibility any sort of user-space daemon
;-).

That user-space tool would be used to configure it through genetlink
outside of netfilter. That's all.

And I think everybody here still think this is useful, what we're
discussing is the nicer approach.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
