From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-1.4.1: ip6tables -L prints network mask instead of prefix
 length
Date: Tue, 10 Jun 2008 15:18:33 +0200
Message-ID: <484E7F29.9050803@trash.net>
References: <slrng4sqhq.6hn.petr.pisar@album.ics.muni.cz> <alpine.LNX.1.10.0806101405300.20733@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Petr Pisar <petr.pisar@atlas.cz>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37567 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYFJNSh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:18:37 -0400
In-Reply-To: <alpine.LNX.1.10.0806101405300.20733@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-06-10 13:49, Petr Pisar wrote:
>> Hello,
>>
>> I found regression between iptables 1.4.0 and 1.4.1-rc1 (also in
>> 1.4.1). The "ip6tables -nL" prints source and destination addresses in
>> NETWORK/NETMASK instead of NETWORK/PREFIXLEN as used in iptables 1.4.0.
>>
>> This doesn't happen if the PREFIXLEN is 0 (i.e. ::/0).
> 
> (It does not happen if PREFIXLEN is a multiple of 32.)
> Fix below.
> 
> commit f52d74a1a83c4fa30fcab8b318d325bb3c9b5535
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jun 10 14:05:21 2008 +0200
> 
> ip6tables: fix printing of ipv6 network masks
>     
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks. I guess I'll release a 1.4.1.1 during the next days.
