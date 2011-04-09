From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Sat, 09 Apr 2011 21:39:30 +0100
Message-ID: <4DA0C402.1090809@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:41325 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab1DIUjc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:39:32 -0400
In-Reply-To: <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/04/2011 00:42, Jan Engelhardt wrote:
> 
> You said `iptables -h` itself would take a long time due to modprobe, 
> however, I can spot no invocation of it using `strace -fe execve 
> iptables -h` when the desired codes are already loaded into the kernel 
> one way or another.


Maciej pointed out this is the case for git as of around 4 days ago, and
in my last email I confirmed I saw the same.  I don't expect you to
observe what you say if you use last released 1.4.10?

However, if you use an xtables match then I would expect you to see a
module loaded? (For example running up a fairly vanilla "shorewall"
script manages to cause some 20 odd modules to load).  My specific
problem is that on my hardware, invoking modprobe takes some good few ms
(whether something is loaded or not), all modules are compiled into the
kernel, so this time is dead time.  In the case of shorewall (which for
sure is a beefy firewall script), this amounts to some several seconds
of wasted time (since nothing is loaded)

I appear to be able to eliminate this delay by modifying
/proc/sys/kernel/modprobe, but I not (apparently) by using "iptables -M
blah"? No one else is commenting on this, so either it's resolved in
current git, or ...?


No one has suggested anything, but basically, is there some way to avoid
running modprobe when the kernel has all the xtables modules compiled
in? ie can we detect that the code is already loaded and avoid trying to
probe for it?

However, many thanks to Maciej - that commit massively improves the
performance of the simple cases!

Cheers

Ed W
