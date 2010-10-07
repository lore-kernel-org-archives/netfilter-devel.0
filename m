From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 09:05:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010070904080.28056@obet.zrqbmnf.qr>
References: <201010061842.20142.sven-ola@gmx.de> <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr> <201010062120.36885.sven-ola@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven-Ola Tuecke <sven-ola@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43869 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0JGHFX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:05:23 -0400
In-Reply-To: <201010062120.36885.sven-ola@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-10-06 21:20, Sven-Ola Tuecke wrote:

>> - There are pointless casts from/to void*
>
>That's for kernel-2.4: The target firmware uses that old kernel for Flash space 
>reasons. Only 1.75 Mb Flash and 8 Mb RAM.

Even in 2.4, targinfo/matchinfo was already void*.

>> - You should document what MAP66_lock is protecting.
>
>OK. They lock printk()s on SMP. Unnecessary without #DEBUG

They should not overlap anyway because all of the strings use a
newline already.
