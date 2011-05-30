From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/5] build: fix absence of xml translator in IPv6-only
 builds
Date: Mon, 30 May 2011 13:59:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105301358470.24700@frira.zrqbmnf.qr>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de> <1306750686-11595-4-git-send-email-jengelh@medozas.de> <BANLkTik2r-SqtUMVBRcKFngPTzgMUJruzg@mail.gmail.com> <BANLkTimUtbkVghwChBArxec-UvH5pDfz=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35102 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1E3L7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 07:59:08 -0400
In-Reply-To: <BANLkTimUtbkVghwChBArxec-UvH5pDfz=A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-05-30 13:57, Maciej =C5=BBenczykowski wrote:

>ie. this commit, in xtables-multi.c should probably change:
>
>       {"iptables-xml",        iptables_xml_main},
>       {"xml4",                iptables_xml_main},
>#endif
>
>to
>
>#endif
>       {"iptables-xml",        iptables_xml_main},
>       {"xml",                 iptables_xml_main},
>
>(and maybe add an ip6tables-xml alias as well?)

nope, the xml subcomponent is a nfproto-independent text-to-text=20
translator IIRC.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
