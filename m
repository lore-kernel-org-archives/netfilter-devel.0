From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Fri, 13 Jul 2012 18:43:36 -0700
Message-ID: <CAHo-OowA3Tc4DF_OGMOQxiqriqOu-63FM8pbaHwdJx4D0ww7gA@mail.gmail.com>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
	<1341964350-13809-5-git-send-email-jengelh@inai.de>
	<20120712154957.GE18793@1984>
	<alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr>
	<20120713091648.GA20796@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@inai.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63170 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2GNBnh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:43:37 -0400
Received: by obbuo13 with SMTP id uo13so5727734obb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jul 2012 18:43:36 -0700 (PDT)
In-Reply-To: <20120713091648.GA20796@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 13, 2012 at 2:16 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jul 12, 2012 at 06:25:13PM +0200, Jan Engelhardt wrote:
>>
>> On Thursday 2012-07-12 17:49, Pablo Neira Ayuso wrote:
>> >> +config NETFILTER_XT_TARGET_SYSRQ
>> >> +  tristate '"SYSRQ" - remote sysrq invocation'
>> >
>> >I guess this is useful for user, eg. you can reboot your crashed
>> >system from your office in case that cheap comodity hardware without
>> >remote management tools (eg. HP's ILO or Dell's iDRAC).
>> >
>> >Still, I think that including this in Netfilter is a bit of abuse
>> >since this is out of the scope of providing some firewalling feature.
>>
>> David Miller has stated his opinion already last year, and he's
>> for the Netfilter variant:
>> http://markmail.org/message/d7kpczdbtpcxwli6
>
> I think that affirmation is true in the context of:
>
> [PATCH]: Add Network Sysrq Support
>
> but not sure it's out of it.
>
> He probably prefered the Netfilter option because, comparing it to the
> Netfilter approach, it looks nicer. Well, just look at all those sysfs
> and proc interfaces he was proposing for that approach (it seems quite
> ugly to me).
>
> You can use the udp_encap hook (that Florian mentioned) plus some
> genetlink interface and little user-space tool to make it out of
> netfilter. Most of the xt_SYSRQ code can be reused and the genetlink
> interface plus one library can be added with little extra work.
>
> @David: just to put you into context. Jan is proposing to merge
> xt_SYSRQ into mainstream, we are discussing if it would be better to
> make it out of it (so people do not depend on the firewalling
> utilities to get it working) based on a different proposal described
> above.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

For this to be truly useful, it has to work when all of userspace is
dead and unresponsive (oom hell, swap hell, hdd disconnected, etc),
and as such from the moment the magic packet gets received, to the
command (reboot/etc) being executed it has to be a fully kernel based
solution - preferably within the network softirq.

Anything relying on userspace (outside of initial configuration) is
not acceptable.
