From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Thu, 14 Apr 2011 09:19:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140919000.28694@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr> <4DA59881.1050501@wildgooses.com>
 <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr> <4DA5D346.5030303@wildgooses.com> <BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com> <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ed W <lists@wildgooses.com>, netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47049 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757917Ab1DNHTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:19:22 -0400
In-Reply-To: <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-04-14 09:13, Maciej =C5=BBenczykowski wrote:

>Note that: -M '' is -M followed by a space and two single quotes.
>
>Furthermore, note that with -M '', you will want to modprobe ip_tables
>or modprobe ip6_tables manually first at system startup (or build them
>into the kernel), since those modules don't autoload (hence why
>iptables tries to load them).
>
>I wonder if there's an easy way iptables userspace could detect
>whether these modules are already loaded (or compiled into the
>kernel), and not even try to load them, if so...

Not with the socket interface, but it's on the plate for netlink-based=20
Xtables.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
