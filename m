From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while data
 in unacknowledged
Date: Mon, 29 Jun 2009 14:20:08 +0200
Message-ID: <4A48B178.7050701@trash.net>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain> <20080731063313.18150.27237.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0906261627500.2240@bizon.gios.gov.pl> <4A44E5DB.8000304@trash.net> <alpine.LNX.1.10.0906261827540.2240@bizon.gios.gov.pl> <4A44FF44.5030006@trash.net> <alpine.LNX.1.10.0906261921480.19267@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35662 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZF2MUO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:20:14 -0400
In-Reply-To: <alpine.LNX.1.10.0906261921480.19267@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>> This patch changes TCP conntrack to update the highest sequence
>> number when the old number matches the new one + the size offset,
>> so it should effectively update it after NAT whenever the packet
>> caused an update before NAT.
>>
>> Please test whether this patch fixes the problem.
> 
> The patch fixes my problem. Thank you.
> 
> Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Thanks, I've queued the patch for upstream.
