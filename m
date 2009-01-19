From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH iptables] libxt_output: add more spaces to output
Date: Mon, 19 Jan 2009 15:37:19 +0100
Message-ID: <4974901F.6000002@trash.net>
References: <20090117131414.66A2F9D4077@zog.reactivated.net> <alpine.LSU.2.00.0901171431250.2904@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Daniel Drake <dsd@gentoo.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40382 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZASOhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:37:21 -0500
In-Reply-To: <alpine.LSU.2.00.0901171431250.2904@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-01-17 14:14, Daniel Drake wrote:
> 
>> Commit bb9284d1 ("libxt_owner: add spaces to output") moved the printing
>> of spaces away from the owner_mt_print() function family, but forgot to
>> add spaces in all of the print_item() functions that are called.
>>
>> This is likely to be at least the partial cause of
>> https://bugs.gentoo.org/show_bug.cgi?id=254435
> 
> Approves-of-this-patch: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
