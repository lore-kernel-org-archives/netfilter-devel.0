From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.4.0 and Linux 2.4
Date: Mon, 31 Dec 2007 17:09:36 +0100
Message-ID: <47791440.8020706@trash.net>
References: <x6fxxklbaj@gzp> <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr> <4778FAA5.3030406@trash.net> <Pine.LNX.4.64.0712311646250.28123@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXLaQJ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:09:59 -0500
In-Reply-To: <Pine.LNX.4.64.0712311646250.28123@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 31 2007 15:20, Patrick McHardy wrote:
>   
>>> Question to Patrick: where is netfilter.h in the iptables
>>> source directory
>>> gone?
>>>       
>> I don't think we ever had one.
>>
>>     
> So that means iptables-1.4.0 needs a kernel tree with nf_inet_addr,
> and that's currently only in davem-net-2.6.25 and maybe a few other.

Yes, seems like we need to release a bugfix release for 1.4.0. Not a big
deal, I'll take care of that once I'm back home.

