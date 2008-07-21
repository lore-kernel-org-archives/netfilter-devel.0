From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 03/08: accounting rework: ct_extend + 64bit counters
 (v4)
Date: Mon, 21 Jul 2008 19:07:04 +0200
Message-ID: <4884C238.8070507@trash.net>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>	<20080721161726.28572.67629.sendpatchset@localhost.localdomain> <20080721.100529.79622637.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42767 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYGURHG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:07:06 -0400
In-Reply-To: <20080721.100529.79622637.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 21 Jul 2008 18:17:27 +0200 (MEST)
> 
>> netfilter: accounting rework: ct_extend + 64bit counters (v4)
> 
> This is testing the limits of what I'm willing to apply
> now, but today was your lucky day :-)
> 
> Please don't test me any more for this merge window, thanks.

OK, I guess that means netfilter netns is off the table :)

Alexey, I'll review your patches, but for now I'd prefer
if you carry them yourself until I'll start merging patches
for the next merge window.
