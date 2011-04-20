From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Tue, 19 Apr 2011 18:26:40 -0700
Message-ID: <BANLkTi=PqPkDpKu8ej1tCkVNugpecbLHyg@mail.gmail.com>
References: <4D9E45C2.7030805@wildgooses.com>
	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
	<4D9F41BA.1060509@wildgooses.com>
	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
	<4D9F98D3.5070802@wildgooses.com>
	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
	<4DA0C402.1090809@wildgooses.com>
	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
	<BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
	<4DA58A73.9030308@wildgooses.com>
	<alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
	<4DA59881.1050501@wildgooses.com>
	<alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
	<4DA5D346.5030303@wildgooses.com>
	<BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com>
	<BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
	<4DAC67F3.3070503@wildgooses.com>
	<BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com>
	<BANLkTikyT1VOH9aBJ4=LmM5raL2L8Y+46w@mail.gmail.com>
	<4DADB406.1040606@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DTB0l convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:26:41 -0400
Received: by wwa36 with SMTP id 36so291978wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 18:26:40 -0700 (PDT)
In-Reply-To: <4DADB406.1040606@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Yep, now I just see an attempt to modprobe "ip_set" (under limited
> circumstances), which seems reasonable given that I am on 2.6.38 and
> this isn't compiled in (nor is it a module)

> That said, I'm also slightly baffled where it's getting probed since =
I
> patched out xtables.c/xtables_load_ko(). =C2=A0The modprobe call does=
n't have
> a -q on it, so I suspect somehow it might be the kernel or something
> else calling it?

Yeah, that's getting modprobe'd by the kernel.
But that shouldn't happen (after both my patches are applied) unless
you actually try to use it, so what are you doing to cause that to
happen? ie. there should not be any attempted loads of ip_set without
"iptables -m set" being called (or equivalent).

- Maciej
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
