From: Tarkan Erimer <tarkan.erimer@f-secure.com>
Subject: Re: 10GbE Connectivity & Netfilter
Date: Wed, 14 Mar 2012 09:22:58 +0200
Message-ID: <4F604752.3020608@f-secure.com>
References: <4F5F49FC.1080207@f-secure.com> <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr> <201203131510.32083.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fsmail-out.f-secure.com ([193.110.108.171]:56601 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2CNHXA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:23:00 -0400
In-Reply-To: <201203131510.32083.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/13/2012 04:10 PM, Thomas Jarosch wrote:
> On Tuesday, 13. March 2012 15:02:13 Jan Engelhardt wrote:
>>> 1- Is netfilter subsystem multi-threaded/multi-core enabled ? So that,
>>> it can spread the loads across the CPUs/Cores.
>> Like most kernel subsystems, it is.
>>
>>> 2- Can it handle such loads consistently (without any
>>> issues/bottlenecks) as I've mentioned above ?
>> Question is more like, can your hardware handle it.
> On that note, Holger Eitzenberger's irqd might be worth a look:
> https://github.com/vaesoo/irqd#readme
>
> http://workshop.netfilter.org/2011/wiki/images/6/69/Nfws2011-multiqueue-and-rps.pdf
>
> Thomas
>
Hmmm... Really interesting documents. Definitely, what I was looking for!
Thanks a lot!


Cheers,

Tarkan
