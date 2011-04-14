From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: How to get access to NAT info from userland
Date: Thu, 14 Apr 2011 09:18:48 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140918270.28694@obet.zrqbmnf.qr>
References: <4D96DD0E.4020404@gmail.com> <AANLkTi=U8KZ_=ckSJ9yrqsTdG=L3tgtzLcDQ58mS=eRM@mail.gmail.com> <4D97BA33.20205@gmail.com> <alpine.LNX.2.01.1104140901331.28694@obet.zrqbmnf.qr> <4DA69E71.4040807@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Brian G <unixman83@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40929 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757917Ab1DNHSt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:18:49 -0400
In-Reply-To: <4DA69E71.4040807@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-04-14 09:12, Brian G wrote:

> On 4/14/2011 2:03 AM, Jan Engelhardt wrote:
>> On Sunday 2011-04-03 02:07, Brian G wrote:
>>> On 4/2/2011 6:55 PM, Sam Roberts wrote:
>>>> On Sat, Apr 2, 2011 at 1:23 AM, Brian G<unixman83@gmail.com>   wrote:
>>>> Does the conntrack -L output have the info you'd like?
>>> Probably. Too bad my distro (CentOS) doesn't seem to provide this binary.
>> Ye, enterprise distributions have a bad track record for shipping the
>> complete NF suite. Avoid :/
>
> TPROXY will work, it should become commonplace by the time IPv6 gets going
> strong. Someone on stackoverflow answered my question, although he called
> tproxy a 'hack'. It will work fine so long as it doesn't hinder performance.

Hey, if TPROXY is a hack, so is the entire NAT business in itself! :)
