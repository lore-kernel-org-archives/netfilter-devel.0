From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] [BRIDGE-NETFILTER] make IP DNAT work on bridged vlan/pppoe
 packets
Date: Tue, 09 Mar 2010 17:22:31 +0100
Message-ID: <4B9675C7.1090200@pandora.be>
References: <4AE2E8E5.3040605@pandora.be> <4AE8682B.4070807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:49431 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0CIQWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:22:33 -0500
In-Reply-To: <4AE8682B.4070807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Hi,
>>
>> The attached patch makes IP DNAT work on bridged IP packets encapsulated
>> in a VLAN/PPoE packet. I only tested that it works for VLAN, but the
>> PPoE case should be fixed too.
>> This bug was introduced by commit
>> 2948d2ebbb98747b912ac6d0c864b4d02be8a6f5 on January 12, 2008.
>> The patch also makes IP DNATing more transparent on a bridge: for
>> bridged-and-dnated traffic, the source MAC address is no longer changed
>> to the MAC address of the bridge port. If one wants, ebtables snat can
>> be used to change the source MAC address in the POSTROUTING chain.
> 
> Applied, thanks Bart.

Hello Patrick,

I just noticed the above mentioned patch isn't yet in the standard
kernel. It was sent on October 24, 2009. Was there a problem with the patch?


cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
