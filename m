From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 02:10:13 -0700
Message-ID: <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
References: <4D9E45C2.7030805@wildgooses.com>
	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
	<4D9F41BA.1060509@wildgooses.com>
	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
	<4D9F98D3.5070802@wildgooses.com>
	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
	<4DA0C402.1090809@wildgooses.com>
	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ed W <lists@wildgooses.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39345 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab1DMJKP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:10:15 -0400
Received: by wya21 with SMTP id 21so309732wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2011 02:10:14 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I should probably point out that iptables module autoloading behaviour
is very different for a pre-my commit statically compiled, non-shared
iptables binary
vs a post-my commit or non-statically compiled binary.

The modprobe issue would only show up if you had a statically
compiled, non-shared iptables binary.
ie. one where all the extensions were already part of the iptables
binary and would always get initialized at startup (even for iptables
-h).

Basically the problem is when we're doing revision compatibility
testing as part of an extensions init sequence we will modprobe from
userspace.
I believe we always attempt a module load there instead of first
checking for api existence, and modprobing if the API is missing.

The fix would probably be in xtables.c in compatible_revision() to
change everything starting with:
  xtables_load_ko(xtables_modprobe_program, true);
into a for loop:

something along the lines of

for (int load = 0; load <= 1; ++load) {
  if (load) xtables_load_ko(...);

  ...

  and replace "close(sockfd); return 0;" with "if (load) {
close(sockfd); return 0; }; continue;"

I'll try to write up and maybe even test a real patch tomorrow.

- Maciej
