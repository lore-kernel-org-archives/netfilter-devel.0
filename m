From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: a possible bug in netfilter
Date: Fri, 6 Apr 2012 15:10:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204061444170.19371@frira.zrqbmnf.qr>
References: <4F7E6D32.9060109@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Serge Leschinsky <serge.leschinsky@gmail.com>
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56807 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810Ab2DFNKg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:10:36 -0400
In-Reply-To: <4F7E6D32.9060109@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-04-06 06:12, Serge Leschinsky wrote:
>
> Hello,
>
> Sometimes my system panics and below you can find the information I was able to
> catch via netconsole.
>
> LFS-based system, kernel 3.3.1, xtables-addons 1.41
>
> If I can do something to help you with debug/troubleshooting please let me
> know.

Adding Florian to Cc who, I think, is with Astaro which created this
monstrous main function.

> BUG: unable to handle kernel paging request at 00003800 00000000
> IP: [<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
> 80 00 00 00 00 48 39 f8 0f 84 57 03 00 00 48 89 45 c8
><48>8b 00 48 85 c0 75 eb 48 8d 04 92 83 c1 01 89 0d 56 b7 00 00

Two asm candidates pop up here:

 168:   48 8b 3f                mov    rdi,QWORD PTR [rdi]

 372:   48 8b 00                mov    rax,QWORD PTR [rax]
 375:   48 85 c0                test   rax,rax

This maps to lines lines similar to  (curr = curr->next) != NULL.
