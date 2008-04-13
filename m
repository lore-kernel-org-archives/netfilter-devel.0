From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/13] Add all necessary header files - compilation fix
 for various cases
Date: Sun, 13 Apr 2008 11:35:58 +0200
Message-ID: <4801D3FE.3080807@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <0b061f76d73e268a7dd95d036235812728b9c120.1207813085.git.jengelh@computergmbh.de> <4801986E.9070500@trash.net> <alpine.LNX.1.10.0804130808320.30942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38522 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYDMJjY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:39:24 -0400
In-Reply-To: <alpine.LNX.1.10.0804130808320.30942@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Whoops, left this in "Drafts" :)
>
>
> On Sunday 2008-04-13 07:21, Patrick McHardy wrote:
>
>   
>> Jan Engelhardt wrote:
>>     
>>> Allow iptables to compile without a kernel source tree. This
>>> implies fixing build for older kernels, such as 2.6.17 which
>>> lack xt_SECMARK.h.
>>>       
>> Which version are these headers based on?
>>     
>
> There is just one version. The file never changed since it
> was initially added as v2.6.17-69-g5e6874c.
>   

The question referred to all those headers.
