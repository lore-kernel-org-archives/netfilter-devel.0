From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BUG?] ip6tables: 32bit userspace doesn't work with 64bit kernel
Date: Wed, 12 Dec 2007 09:36:52 +0100
Message-ID: <475F9DA4.4000502@trash.net>
References: <20071208223737.GA8885@dreamland.darkstar.lan>	 <475C1425.7070608@trash.net> <68676e00712100509q1fcbf42dx6bcb46e95467ac91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Luca Tettamanti <kronos.it@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbXLLIgz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:36:55 -0500
In-Reply-To: <68676e00712100509q1fcbf42dx6bcb46e95467ac91@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Tettamanti wrote:
> On Dec 9, 2007 5:13 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Luca Tettamanti wrote:
>>> Hello,
>>> I just found out that 32bit (x86) ip6tables does not work with a 64bit
>>> kernel. I'm currenly using 2.6.24-rc4-g94545bad, but the structures
>>> involved haven't been touched recently.
>>>
>>> Before you read on: I see that IPv6 code is missing compat* stuff, so is
>>> this configuration supported?
>> Not yet, thanks for pointing this out, I completely forgot
>> about that :) I'll put it on my todo list, with some luck
>> I can still finish it in time for the 2.6.25 merge window.
> 
> Ok, feel free to throw patches this way for testing ;-)


I've completed the compat support, but its about 25 patches -
do you want me to start throwing? :) Otherwise just wait for
a few days, I'll send them upstream as soon as the iptables
compat fix is in net-2.6.25 since they depend on that one.



