From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 00/03: netfilter -stable fixes
Date: Fri, 24 Oct 2008 05:40:00 +0200
Message-ID: <49014390.7080909@trash.net>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet> <alpine.LNX.1.10.0810240229550.4386@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35620 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYJXDkE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:40:04 -0400
In-Reply-To: <alpine.LNX.1.10.0810240229550.4386@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Wed, 22 Oct 2008, Patrick McHardy wrote:
> 
>> The following three patches for -stable fix some netfilter issues:
>>
>> - a regression in the iprange match, causing mismatches with inversion
>> - a memory leak in the SNMP NAT helper
>> - a lost #ifdef, allowing user-triggerable WARN_ONs with NETFILTER_DEBUG
>>  (and some minor runtime misbehaviour)
> 
> Which kernels need above patches? Only 2.6.27 or also 2.6.25/2.6.26?

I think all three patches are also needed for 2.6.25 and 2.6.26.
