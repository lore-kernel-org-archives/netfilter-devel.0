From: Aft nix <aftnix@gmail.com>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Sat, 14 Jul 2012 20:49:59 +0600
Message-ID: <CAGuaRCuu0LcRDdOFESppq5TNSbBhm9p2w1yZkorw3yTshLecMA@mail.gmail.com>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
	<1341964350-13809-5-git-send-email-jengelh@inai.de>
	<20120712154957.GE18793@1984>
	<alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
	<20120713091648.GA20796@1984>
	<CAHo-OowA3Tc4DF_OGMOQxiqriqOu-63FM8pbaHwdJx4D0ww7gA@mail.gmail.com>
	<20120714131111.GB31130@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
	Jan Engelhardt <jengelh@inai.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57237 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2GNOuA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:50:00 -0400
Received: by yhmm54 with SMTP id m54so4603140yhm.19
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jul 2012 07:50:00 -0700 (PDT)
In-Reply-To: <20120714131111.GB31130@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 14, 2012 at 7:11 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> On Fri, Jul 13, 2012 at 06:43:36PM -0700, Maciej =C5=BBenczykowski wr=
ote:
>> On Fri, Jul 13, 2012 at 2:16 AM, Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>> > On Thu, Jul 12, 2012 at 06:25:13PM +0200, Jan Engelhardt wrote:
>> >>
>> >> On Thursday 2012-07-12 17:49, Pablo Neira Ayuso wrote:
>> >> >> +config NETFILTER_XT_TARGET_SYSRQ
>> >> >> +  tristate '"SYSRQ" - remote sysrq invocation'
>> >> >
>> >> >I guess this is useful for user, eg. you can reboot your crashed
>> >> >system from your office in case that cheap comodity hardware wit=
hout
>> >> >remote management tools (eg. HP's ILO or Dell's iDRAC).
>> >> >
>> >> >Still, I think that including this in Netfilter is a bit of abus=
e
>> >> >since this is out of the scope of providing some firewalling fea=
ture.
>> >>
>> >> David Miller has stated his opinion already last year, and he's
>> >> for the Netfilter variant:
>> >> http://markmail.org/message/d7kpczdbtpcxwli6
>> >
>> > I think that affirmation is true in the context of:
>> >
>> > [PATCH]: Add Network Sysrq Support
>> >
>> > but not sure it's out of it.
>> >
>> > He probably prefered the Netfilter option because, comparing it to=
 the
>> > Netfilter approach, it looks nicer. Well, just look at all those s=
ysfs
>> > and proc interfaces he was proposing for that approach (it seems q=
uite
>> > ugly to me).
>> >
>> > You can use the udp_encap hook (that Florian mentioned) plus some
>> > genetlink interface and little user-space tool to make it out of
>> > netfilter. Most of the xt_SYSRQ code can be reused and the genetli=
nk
>> > interface plus one library can be added with little extra work.
>> >
>> > @David: just to put you into context. Jan is proposing to merge
>> > xt_SYSRQ into mainstream, we are discussing if it would be better =
to
>> > make it out of it (so people do not depend on the firewalling
>> > utilities to get it working) based on a different proposal describ=
ed
>> > above.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe netfilte=
r-devel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> For this to be truly useful, it has to work when all of userspace is
>> dead and unresponsive (oom hell, swap hell, hdd disconnected, etc),
>> and as such from the moment the magic packet gets received, to the
>> command (reboot/etc) being executed it has to be a fully kernel base=
d
>> solution - preferably within the network softirq.
>>
>> Anything relying on userspace (outside of initial configuration) is
>> not acceptable.
>
> So far, nobody mentioned the possibility any sort of user-space daemo=
n
> ;-).
>
> That user-space tool would be used to configure it through genetlink
> outside of netfilter. That's all.
>
> And I think everybody here still think this is useful, what we're
> discussing is the nicer approach.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Jan,

I don't know if it goes to main line kernel eventually, i want this fea=
ture
right now. Right now i have to physically go the office rack to reboot =
in a
case of kernel crash. Office IT people don't provide IPKVM stuffs in de=
velopment
servers, they only give it to "production" severs.

I really think its nice touch. Is it available in xtable-addons, or i
just apply your patch directly?

Cheers.

--=20
-aft
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
