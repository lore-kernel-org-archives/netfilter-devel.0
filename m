From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xtables: Combine ipt_TTL and ip6t_HL source
Date: Wed, 21 Jan 2009 09:08:03 +0100
Message-ID: <4976D7E3.7040603@trash.net>
References: <alpine.LSU.2.00.0901201415470.16288@fbirervta.pbzchgretzou.qr> <38bcb3ec0901201437t6ba198c8w83ecea8e3e6d4cde@mail.gmail.com> <alpine.LSU.2.00.0901210747500.14993@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47920 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZAUIIE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:08:04 -0500
In-Reply-To: <alpine.LSU.2.00.0901210747500.14993@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-01-20 23:37, James King wrote:
>>> netfilter: xtables: Combine ipt_TTL and ip6t_HL source
>>>
>>> Similarly to commit c9fd49680954714473d6cbd2546d6ff120f96840, merge
>>> TTL and HL. Since HL does not depend on any IPv6-specific function,
>>> no new module dependencies would arise.
> 
>>> +               .table      = "mangle",
>> Can we drop the mangle restriction at the same time?  Otherwise, looks
>> good to me.
> 
> One thing at a time, I'd say.

Agreed. Both look fine, but I'm not taking patches for 2.6.30 yet.
Please resubmit once Dave starts accepting patches into net-next.git.


