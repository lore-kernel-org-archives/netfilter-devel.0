From: Brian G <unixman83@gmail.com>
Subject: Re: How to get access to NAT info from userland
Date: Thu, 14 Apr 2011 02:12:49 -0500
Message-ID: <4DA69E71.4040807@gmail.com>
References: <4D96DD0E.4020404@gmail.com> <AANLkTi=U8KZ_=ckSJ9yrqsTdG=L3tgtzLcDQ58mS=eRM@mail.gmail.com> <4D97BA33.20205@gmail.com> <alpine.LNX.2.01.1104140901331.28694@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab1DNHNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:13:09 -0400
Received: by iyb14 with SMTP id 14so1206131iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2011 00:13:09 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104140901331.28694@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4/14/2011 2:03 AM, Jan Engelhardt wrote:
> On Sunday 2011-04-03 02:07, Brian G wrote:
>> On 4/2/2011 6:55 PM, Sam Roberts wrote:
>>> On Sat, Apr 2, 2011 at 1:23 AM, Brian G<unixman83@gmail.com>   wrote:
>>> Does the conntrack -L output have the info you'd like?
>> Probably. Too bad my distro (CentOS) doesn't seem to provide this binary.
> Ye, enterprise distributions have a bad track record for shipping the
> complete NF suite. Avoid :/

TPROXY will work, it should become commonplace by the time IPv6 gets 
going strong. Someone on stackoverflow answered my question, although he 
called tproxy a 'hack'. It will work fine so long as it doesn't hinder 
performance.

Brian G.
