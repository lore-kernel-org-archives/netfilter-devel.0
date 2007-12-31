From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.4.0 and Linux 2.4
Date: Mon, 31 Dec 2007 15:20:21 +0100
Message-ID: <4778FAA5.3030406@trash.net>
References: <x6fxxklbaj@gzp> <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41582 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbXLaOUk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:20:40 -0500
In-Reply-To: <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 30 2007 11:36, Gabor Z. Papp wrote:
>   
>> In file included from include/linux/netfilter/nf_nat.h:4,
>>                 from extensions/libipt_DNAT.c:9:
>> include/linux/netfilter/nf_conntrack_tuple.h:29: error: syntax error before "__be32"
>>     
>
> It is because nf_inet_addr is not known to iptables with your kernel.
>
>
> Question to Patrick: where is netfilter.h in the iptables
> source directory
> gone?

I don't think we ever had one.


