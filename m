From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Mon, 18 Apr 2011 18:12:46 -0700
Message-ID: <BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40907 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1DSBMs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:12:48 -0400
Received: by wya21 with SMTP id 21so4413119wya.19
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2011 18:12:47 -0700 (PDT)
In-Reply-To: <4DAC67F3.3070503@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You didn't actually reply to my email: you were asked to try -M ''.

Anyway, the 'maze' branch of git://github.com/zenczykowski/iptables.git

has the following commits:
e39f367d905670e39e6f08d2b73c715a6d0b4bfb   [upstream iptables master]
SET target revision 2 added
590e3e8653057385ce503ac037783bbb9f5584d4   Don't load ip6?_tables
module when already loaded.
8a4efee1bd7e6137a6b4faa08c49dbb9722af1c8   Add --ipv4/-4 and --ipv6/-6
support to ip6?tables{,-restore}.
3436427a9757705ad471f1b77c56b9afd6b2e40c   Move common parts of
libext{4,6}.a into libext.a
a9e4c0909bec8424b6166cc1662958d66edc15e7   combine ip6?tables-multi
into xtables-multi
f75e8347925b9ffd5b01c677e86acc16c7554821   add xtables-multi{32,64} recognition

You may want to cherrypick 590e3e86... and try again.

Maciej
