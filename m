From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: x_tables: eb_tables: limit.0 match: invalid size 32 (kernel) !=
 (user) 24
Date: Thu, 20 Nov 2014 15:42:26 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411201532210.3094@nerf08.vanv.qr>
References: <CAJsRc6i_vEWAOEUJVrx5t0DtNHZdMg5jj3N726YSOs7zX_pCcg@mail.gmail.com> <alpine.LSU.2.11.1411131608030.26202@nerf08.vanv.qr> <CAJsRc6iObZoNLiJtCu5UvUtrBUf7e-ERWFjM7D1EcB6rdnTJ0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ronny Janssen <ronny.janssen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43540 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbaKTOm2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:42:28 -0500
In-Reply-To: <CAJsRc6iObZoNLiJtCu5UvUtrBUf7e-ERWFjM7D1EcB6rdnTJ0w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2014-11-13 17:43, Ronny Janssen wrote:

>forgive my ignorance, but I don't think that's the problem here.. is it ?
>
>~ # file ./iptables-1.4.21/xtables-multi
>./iptables/xtables-multi: ELF 32-bit MSB executable, MIPS, N32 MIPS64
>rel2 version 1, dynamically linked (uses shared libs), for GNU/Linux
>2.6.32, with unknown capability 0x41000000 = 0xf676e75, with unknown
>capability 0x10000 = 0x70403, not stripped

There are two causes.

One is that people sometimes try to run an O32 iptables/ebtables.
IIRC, alignof(long) is different between O32 and N32. ip/ebtables
kernel modules are capable of recognizing at most two formats, which
on a MIPS64 kernel are N32 and N64.

The second issue is that some extensions only know _one_ format, and
that one format happens to use sizeof(long), which is different
between N32 and N64, causing problems. This is what I suppose might
be occurring on your system -- ebtables has not received as much ABI
strengthening as iptables did.
