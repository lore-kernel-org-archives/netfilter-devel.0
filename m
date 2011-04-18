From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Mon, 18 Apr 2011 17:33:55 +0100
Message-ID: <4DAC67F3.3070503@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com>	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>	<4D9F41BA.1060509@wildgooses.com>	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>	<4D9F98D3.5070802@wildgooses.com>	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>	<4DA0C402.1090809@wildgooses.com>	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>	<BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>	<4DA58A73.9030308@wildgooses.com>	<alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>	<4DA59881.1050501@wildgooses.com>	<alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>	<4DA5D346.5030303@wildgooses.com>	<BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com> <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:34819 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1DRQd5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:33:57 -0400
In-Reply-To: <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14/04/2011 08:13, Maciej =C5=BBenczykowski wrote:
> Note that: -M '' is -M followed by a space and two single quotes.
>=20
> Furthermore, note that with -M '', you will want to modprobe ip_table=
s
> or modprobe ip6_tables manually first at system startup (or build the=
m
> into the kernel), since those modules don't autoload (hence why
> iptables tries to load them).
>=20
> I wonder if there's an easy way iptables userspace could detect
> whether these modules are already loaded (or compiled into the
> kernel), and not even try to load them, if so...
>=20

OK, using kernel 2.6.38 (previously on .37) iptables 1.4.10 patched wit=
h
the delayed module loading commit, then I still get something like 20
attempts to "modprobe iptables -q" when I start up a near vanilla
shorewall script (I just entered enough info that it boots up with a
couple of basic zones).

If I just do an iptables restore, or a near equivalent "shorewall
restore" then I get just a single modprobe iptables -q.

This suggests that the shorewall start tickles several iptables calls.
Each call causing one modprobe


Now this seems to be coming from the iptables.c modprobe call.
Annoyingly this didn't seem to be happening when I used kernel 2.6.37.
It's timeconsuming to reload kernel changes to this embedded device, bu=
t
I will check back and confirm this is a change in behaviour between ker=
nels.

However, it seems unexpected that there are any calls from iptables
since it does some kind of test before calling modprobe?  I'm sure I
didn't get any on .37??!  Any insights on why I get even a single
modprobe call given everything built in kernel and a static iptables bi=
nary?

Thanks

Ed W

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
