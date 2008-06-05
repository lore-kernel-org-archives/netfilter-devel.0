From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 05 Jun 2008 19:56:14 +0200
Message-ID: <484828BE.7050209@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp> <483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp> <483C088E.4020405@trash.net> <x67idfq6d8@gzp> <483CFF21.40608@trash.net> <4847F64C.2040902@trash.net> <x663snremo@gzp> <4848200A.3060600@trash.net> <alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYFER43 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:56:29 -0400
In-Reply-To: <alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-06-05 19:19, Patrick McHardy wrote:
>   
>>>   CC       libxt_dccp.oo
>>> libxt_dccp.c:16:24: warning: linux/dccp.h: No such file or directory
>>>       
>> Mhh .. I don't really want to add that file to iptables.
>> Jan, I'm not familiar with auto*, could you send a patch
>> to make compilation of libxt_dccp dependand on the presence
>> of linux/dccp.h? Thanks.
>>     
>
> Is dccp.h too ugly?
I'd prefer to limit the included files to netfilter-related ones.

>  Either way, please pull from
> 	git://dev.medozas.de/xtables master
> to get
> commit 1ebc55e29f220082814a97e541427be7746400e0
> parent 324651944e03072cde144d41896b2e207672d0f2
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Jun 5 19:48:31 2008 +0200
>
>     build: check for missing feature files
>
>     linux/dccp.h is unlikely to be installed before 2.6.18 (which was
>     when headers_install was introduced), and does not exist at all
>     before 2.6.14. Add a compile-time check to skip compilation of
>     libxt_dccp in case this was detected.
>   

Done, thanks.

Gabor, could you try again using the latest git version?


