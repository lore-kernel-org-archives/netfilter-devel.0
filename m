From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 3/5] build: fix absence of xml translator in IPv6-only builds
Date: Mon, 30 May 2011 14:04:43 +0200
Message-ID: <BANLkTikq3Nvxc9W3GkYgMh2cGyUoaB1frw@mail.gmail.com>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
	<1306750686-11595-4-git-send-email-jengelh@medozas.de>
	<BANLkTik2r-SqtUMVBRcKFngPTzgMUJruzg@mail.gmail.com>
	<BANLkTimUtbkVghwChBArxec-UvH5pDfz=A@mail.gmail.com>
	<alpine.LNX.2.01.1105301358470.24700@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53401 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1E3MEo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 08:04:44 -0400
Received: by pvg12 with SMTP id 12so1587888pvg.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2011 05:04:43 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1105301358470.24700@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Uhm, if it's ip proto independent then it shouldn't be defined in
xtables-multi in the #ifdef ENABLE_IPV4 section... right?
Or I'm missing something?  It should be usable if you're creating a
static build of xtables-multi with only ipv6 support, correct?

2011/5/30 Jan Engelhardt <jengelh@medozas.de>:
> On Monday 2011-05-30 13:57, Maciej =C5=BBenczykowski wrote:
>
>>ie. this commit, in xtables-multi.c should probably change:
>>
>> =C2=A0 =C2=A0 =C2=A0 {"iptables-xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0ipt=
ables_xml_main},
>> =C2=A0 =C2=A0 =C2=A0 {"xml4", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0iptables_xml_main},
>>#endif
>>
>>to
>>
>>#endif
>> =C2=A0 =C2=A0 =C2=A0 {"iptables-xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0ipt=
ables_xml_main},
>> =C2=A0 =C2=A0 =C2=A0 {"xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 iptables_xml_main},
>>
>>(and maybe add an ip6tables-xml alias as well?)
>
> nope, the xml subcomponent is a nfproto-independent text-to-text
> translator IIRC.
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
