From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 12:35:15 +0100
Message-ID: <4DA58A73.9030308@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com>	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>	<4D9F41BA.1060509@wildgooses.com>	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>	<4D9F98D3.5070802@wildgooses.com>	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>	<4DA0C402.1090809@wildgooses.com>	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:35560 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab1DMLfQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:35:16 -0400
In-Reply-To: <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/04/2011 10:10, Maciej =C5=BBenczykowski wrote:
> I should probably point out that iptables module autoloading behaviou=
r
> is very different for a pre-my commit statically compiled, non-shared
> iptables binary
> vs a post-my commit or non-statically compiled binary.

Aha.  I am using a static (well, --static --shared) iptables

> The modprobe issue would only show up if you had a statically
> compiled, non-shared iptables binary.
> ie. one where all the extensions were already part of the iptables
> binary and would always get initialized at startup (even for iptables
> -h).

Thanks - although my evidence suggests its simply the statically
compiled bit which is enough to trigger this?  My binary is both static
and shared (is that the correct term?)


> The fix would probably be in xtables.c in compatible_revision() to
> change everything starting with:
>   xtables_load_ko(xtables_modprobe_program, true);
> into a for loop:
>=20
> something along the lines of
>=20
> for (int load =3D 0; load <=3D 1; ++load) {
>   if (load) xtables_load_ko(...);
>=20
>   ...
>=20
>   and replace "close(sockfd); return 0;" with "if (load) {
> close(sockfd); return 0; }; continue;"
>=20
> I'll try to write up and maybe even test a real patch tomorrow.

Thanks - although I'm not quite sure that I see that this changes
anything?  There is already a "static int load;" in, I think it's
xtables_load_ko (?) which prevents the module loading more than once pe=
r
call of iptables - I'm not sure I understand how your loop above change=
s
that?


Additionally, as helpfully pointed out by Jan, a chunk of my problem is
my static iptables apparently trying to probe a kernel module which
isn't incorporated into my kernel version.  I can't immediately see a
solution to not uselessly probing for that (without patching iptables)?
 Any ideas?

Thanks

Ed W

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
