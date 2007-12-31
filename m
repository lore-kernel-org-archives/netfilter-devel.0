From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables 1.4.0 and Linux 2.4
Date: Mon, 31 Dec 2007 16:51:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712311646250.28123@fbirervta.pbzchgretzou.qr>
References: <x6fxxklbaj@gzp> <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr>
 <4778FAA5.3030406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57120 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLaPv5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2007 10:51:57 -0500
In-Reply-To: <4778FAA5.3030406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 31 2007 15:20, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Dec 30 2007 11:36, Gabor Z. Papp wrote:
>>   
>> > In file included from include/linux/netfilter/nf_nat.h:4,
>> >                 from extensions/libipt_DNAT.c:9:
>> > include/linux/netfilter/nf_conntrack_tuple.h:29: error: syntax error before
>> > "__be32"
>>
>> It is because nf_inet_addr is not known to iptables with your kernel.
>>
>>
>> Question to Patrick: where is netfilter.h in the iptables
>> source directory
>> gone?
>
> I don't think we ever had one.
>
So that means iptables-1.4.0 needs a kernel tree with nf_inet_addr,
and that's currently only in davem-net-2.6.25 and maybe a few other.
