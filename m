From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Sat, 09 Apr 2011 00:22:59 +0100
Message-ID: <4D9F98D3.5070802@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:33457 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1DHXXB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:23:01 -0400
In-Reply-To: <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/04/2011 20:54, Jan Engelhardt wrote:
> 
> On Friday 2011-04-08 19:11, Ed W wrote:
>> Starting "shorewall"
>> - using busybox modprobe + released iptables = several minutes...
>> - module-init-tools + released iptables = 12s
>> - module-init-tools + your commit = 7.7s
>> - module-init-tools + patching out modprobe completely = 4.9s
>>
>> So, whilst your patch has a huge positive benefit, I'm still seeing a
>> substantial amount of cpu going to useless modprobing.
> 
> Which is only natural, because the kernel loads stuff. If you have
> a problem with time (why so?) you should <*> the xtables modules,
> and just leave iptables in its origin state.

I'm sorry that I haven't managed to explain my situation clearly.
However, I'm trying very hard to explain that I *have* got <*> in my
kernel. There are no modules.

Stated another way.  I don't have any kernel modules - everything is
compiled into the kernel

Just to try another tack: iptables is calling modprobe even though there
is *no* module to load (it's already compiled into the kernel)


So, to restate my original problem:
With a latest released busybox/iptables system it takes 1.5 secs to run
a simple "iptables -h", ie no action actually performed and no modules
on the system to even load.... Staggering...

(Part of that problem is that the busybox modprobe call is very slow.
However, even switching to a "fatter" modprobe takes nearly 5ms to run
"iptables -h" - that really starts to stack up...)


Apologies if I now over laboured the point, but do you see my issue?

Thanks for any thoughts on reducing the number of calls to modprobe
(given that there are no modules to load on my system)

Ed W

