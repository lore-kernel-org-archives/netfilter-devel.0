From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: How to get access to NAT info from userland
Date: Thu, 14 Apr 2011 09:03:09 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140901331.28694@obet.zrqbmnf.qr>
References: <4D96DD0E.4020404@gmail.com> <AANLkTi=U8KZ_=ckSJ9yrqsTdG=L3tgtzLcDQ58mS=eRM@mail.gmail.com> <4D97BA33.20205@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Brian G <unixman83@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45125 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab1DNHDK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:03:10 -0400
In-Reply-To: <4D97BA33.20205@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-04-03 02:07, Brian G wrote:

> On 4/2/2011 6:55 PM, Sam Roberts wrote:
>> On Sat, Apr 2, 2011 at 1:23 AM, Brian G<unixman83@gmail.com>  wrote:
>>> If not, I still need to know the TRUE DESTINATION when using a transparent
>>> proxy so I know where to send to request. What needs to added to the kernel
>>> (e.g. like an iptables TARGET) to get this info.
>> Does the conntrack -L output have the info you'd like?
> Probably. Too bad my distro (CentOS) doesn't seem to provide this binary.
Ye, enterprise distributions have a bad track record for shipping the 
complete NF suite. Avoid :/
