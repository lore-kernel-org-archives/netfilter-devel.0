From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5][IPTABLES]: Import netfilter.h
Date: Tue, 29 Jan 2008 15:34:06 +0100
Message-ID: <479F395E.2000305@trash.net>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr> <479F25DF.6080204@trash.net> <Pine.LNX.4.64.0801291528180.1185@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56182 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbYA2OeI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:34:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801291528180.1185@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 29 2008 14:10, Patrick McHardy wrote:
>> Subject: Re: [PATCH 1/5][IPTABLES]: Import netfilter.h
>>
>> Jan Engelhardt wrote:
>>> Import netfilter.h from kernel to get hold of union nf_inet_addr
>>> and fix a compile error in current iptable tarball releases when
>>> used with non-development kernels.
>> We already have this exact file in the current sources, without
>> the #ifdef __KERNEL__ parts.
>>
> 
> Where? If you mean the sanitized headers in 
> /usr/include/linux/netfilter.h -- this file is outdated and does not 
> ship the nf_inet_addr definition.

You're right, I only added it locally, but forgot "svn add" :)
Committed now.

> Since we copy all xt_{match,target}*.h header files too, I thought doing 
> the same for netfilter.h is ok.
> 
> I do believe it is, because the sanitized headers in 
> /usr/include/linux/netfilter/ are _also_ out-of-date.
> BTW, could we, perhaps, remove headers-y for 
> /usr/include/linux/netfilter/, since iptables ships it anyway?

No, there are other users of these files. I recall there is
some perl interface for iptables for example.

