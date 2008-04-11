From: Patrick McHardy <kaber@trash.net>
Subject: Re: Throughput test for kernelspace module vs. userspace daemon with
 strange results
Date: Fri, 11 Apr 2008 15:16:53 +0200
Message-ID: <47FF64C5.9000708@trash.net>
References: <47FF613C.4010701@gmail.com> <alpine.LNX.1.10.0804111509140.21182@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Mader <thezema@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54249 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYDKNQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:16:58 -0400
In-Reply-To: <alpine.LNX.1.10.0804111509140.21182@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-04-11 15:01, Thomas Mader wrote:
>> I thought about explanations for this but I don't come to reasonable
>> explanations for this behaviour. Shouldn't the kernelspace module be faster?
>> Why is it slower?
> 
> You are using a raw socket in userspace, which effectively
> bypasses Netfilter.
> To make a meaningful test of it, the PF_RAW code would need
> an NF_HOOK into iptables to make a more accurate comparison I think.

Packets sockets bypass netfilter, raw sockets don't.
I have no explanation for the values you're seeing
though.
