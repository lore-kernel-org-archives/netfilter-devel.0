From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_statistic.c - the statistic match
Date: Tue, 13 Jan 2009 05:43:00 +0100
Message-ID: <496C1BD4.2050106@trash.net>
References: <4967CDCB.3080306@astrocorp.com> <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr> <496B7F66.40900@astrocorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47139 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZAMEnC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:43:02 -0500
In-Reply-To: <496B7F66.40900@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bryan Duff wrote:
> Jan Engelhardt wrote:
>> On Friday 2009-01-09 23:20, Bryan Duff wrote:
>>
>>  
>>> ... gets out of sync in nth mode.  The count seems to be off 
>>> somehow.  At some
>>> point the count is off - in my case I have 3 rules that are consecutive:
>>>
>>> [...]
> How could that happen?  I'm not accepting between the statistic match 
> rules (which would definitely cause the rules to get out of sync).

Are you running on an SMP system? If so, try printing out the value
of info->master and verify that it always points to the same memory
(for each single match instance, so you should see exactly three
different values).
