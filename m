From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Pkttype match mismatches in OUTPUT chain
Date: Wed, 13 Aug 2008 15:32:24 +0200
Message-ID: <48A2E268.6010808@trash.net>
References: <20080810221835.GA28761@linuxace.com> <20080810225353.GA31138@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYHMNc0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:32:26 -0400
In-Reply-To: <20080810225353.GA31138@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> Minor change to fix compile warning.
> 
> On Sun, Aug 10, 2008 at 03:18:35PM -0700, Phil Oester wrote:
>> Back in 7/2006, we fixed an issue with the pkttype match mismatching
>> on locally generated packets.[1]  At the time, I didn't test the fix
>> in the OUTPUT chain, but only in the INPUT chain, where packets showed
>> up as PACKET_LOOPBACK.  Unfortunately, when packets are output, they
>> aren't tagged as PACKET_LOOPBACK so the fix was incomplete.
>>
>> Below is another attempt at fixing the problem in all cases, and fixes
>> the original netfilter bugzilla #484 as well as a new bug submission (which
>> I can't get the number of since bugzilla is presently down).  
>>
>> The fix is somewhat complicated because when broadcast packets hit the
>> OUTPUT chain they have no destination MAC attached, so the "simple"
>> test for 'all FF' doesn't work for us, and instead we have to consult the
>> routing table.
>>
>> One other note: since IPv6 doesn't have the concept of "broadcast", perhaps
>> the userspace extension shouldn't allow broadcast rules to be added for
>> that family?
>>
>> Phil
>>
>> Signed-off-by: Phil Oester <kernel@linuxace.com>

This is getting more and more kludgy, wouldn't it make more sense
to move the pkt_type initialisation from the device layer to the
protocol layer?
