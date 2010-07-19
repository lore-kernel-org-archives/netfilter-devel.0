From: Bas van Sisseren <bas@quarantainenet.nl>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Mon, 19 Jul 2010 10:02:57 +0200
Message-ID: <4C4406B1.5070807@quarantainenet.nl>
References: <4C402DBD.3010007@quarantainenet.nl> <4C404EAC.7050509@trash.net> <4C4053AB.8050300@quarantainenet.nl> <4C405572.7050106@trash.net> <alpine.LSU.2.01.1007161654030.32253@obet.zrqbmnf.qr> <4C40774D.7070004@quarantainenet.nl> <alpine.LSU.2.01.1007162116020.22666@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.quarantaine.net ([217.114.102.88]:60222 "EHLO
	main.qone.quarantainenet.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758329Ab0GSIDG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:03:06 -0400
In-Reply-To: <alpine.LSU.2.01.1007162116020.22666@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/07/10 21:18, Jan Engelhardt wrote:
> On Friday 2010-07-16 17:14, Bas van Sisseren wrote:
>>>>
>>>> OK, so basically you just want to rewrite the port number. An easier
>>>> way to do this without iterating through all addresses would be to
>>>> change userspace and the kernel so you can create REDIRECT rules
>>>> without the IP_NAT_RANGE_MAP_IPS flag. That won't work for forwarded
>>>> packets, but its the simplest solution for the case you describe.
>>>
>>> Isn't TPROXY the right thing here if all you want is changing the port 
>>> of delivery? :-)
>>
>> I could use TPROXY.. But then I still need to patch the kernel. Even Debian
>> unstable kernels do not yet have the ipt_TPROXY module. Besides that,
>> TPROXY looks promising.
> 
> Squeeze should have xt_TPROXY.ko, which was added for 2.6.28.

Hmm, my mistake. Even the backports kernels have TPROXY. I guess I made a
typo when checking the /boot/config-* files.

I will have a look at it, thx! :-)

-- 
Bas van Sisseren <bas@quarantainenet.nl>
Quarantainenet
