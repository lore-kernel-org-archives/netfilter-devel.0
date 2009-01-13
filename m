From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_statistic.c - the statistic match
Date: Tue, 13 Jan 2009 08:28:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901130827490.24186@fbirervta.pbzchgretzou.qr>
References: <4967CDCB.3080306@astrocorp.com> <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr> <496B7F66.40900@astrocorp.com> <496C1BD4.2050106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bryan Duff <bduff@astrocorp.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZAMH2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:28:34 -0500
In-Reply-To: <496C1BD4.2050106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-13 05:43, Patrick McHardy wrote:
>>>> [...]
>>
>> How could that happen?  I'm not accepting between the statistic
>> match rules (which would definitely cause the rules to get out of
>> sync).
>
> Are you running on an SMP system? If so, try printing out the value
> of info->master and verify that it always points to the same memory
> (for each single match instance, so you should see exactly three
> different values).

Since info->master is always on CPU0, it's easy:

	taskset -c 0 iptables -nvL
