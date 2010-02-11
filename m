From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 05/08: nf_conntrack_sip: add TCP support
Date: Thu, 11 Feb 2010 17:03:51 +0100
Message-ID: <4B742A67.6040400@trash.net>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet> <20100211073938.7894.59585.sendpatchset@x2.localnet> <alpine.LSU.2.01.1002111400310.30927@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0BKQDw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:03:52 -0500
In-Reply-To: <alpine.LSU.2.01.1002111400310.30927@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-02-11 08:39, Patrick McHardy wrote:
> 
>>    netfilter: nf_conntrack_sip: add TCP support
>>    
>>    Add TCP support, which is mandated by RFC3261 for all SIP elements.
>>    
>>    SIP over TCP is similar to UDP, except that messages are delimited
>>    by Content-Length: headers and multiple messages may appear in one
>>    packet.
> 
> Does it cope with TCP segmentation?

No, messages split over multiple packets can't be handled, similar
to other helpers.

