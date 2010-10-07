From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 07 Oct 2010 00:13:58 +0000
Message-ID: <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz>
References: <201010061842.20142.sven-ola@gmx.de> <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr> <201010062120.36885.sven-ola@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <netfilter-devel@vger.kernel.org>
To: Sven-Ola Tuecke <sven-ola@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:34356
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0JGAXC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:23:02 -0400
In-Reply-To: <201010062120.36885.sven-ola@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 6 Oct 2010 21:20:36 +0200, "Sven-Ola Tuecke" <sven-ola@gmx.de>
wrote:
> Hi Jan,
> 
> Am Mittwoch, 6. Oktober 2010, um 20:01:11 schrieb Jan Engelhardt:
> 
> [...snip...]
> 
>> And.. I take it you want a review?
> 
> No - I'm only interested in a working solution. Of course, I take what I
> can 
> get to make it better if required.
> 
>> - NAT, even if NAT66, still interferes with ETE connectivity. Think
>> FTP-SSL connections. That may not be your problem, but it's the Working
>> Group's and the Draft's.
> 
> Yes - there are protocols that rely on addresses such as SIP, active FTP
> etc. 
> I don't plan to add NAT helpers for them, thats pointless somehow. 

FWIW: FTP EPSV/EPRT extensions remove the need for layer-7 IPs and work
with NAT44 and NAT66 nicely where the firewall supports them.

>> - There are pointless casts from/to void*
> 
> That's for kernel-2.4: The target firmware uses that old kernel for
Flash
> space 
> reasons. Only 1.75 Mb Flash and 8 Mb RAM.
> 

Are there really working IPv6-enabled 2.4 kernels in use?

>> - You should document what MAP66_lock is protecting.
> 
> OK. They lock printk()s on SMP. Unnecessary without #DEBUG
> 
> Again, thank you very much,
> // Sven-Ola

NAT66 is designed to work stateless AFAICT. As such the mapping likely
does not need conntrack at all.

Is there perhapse some way to only configure the map once but have it
apply to both src and dst depending on the packet direction?

Why is /128 not allowed? that would be extremely useful for roaming
devices internal firewalls and high-security setups with multi-homing.

AYJ
