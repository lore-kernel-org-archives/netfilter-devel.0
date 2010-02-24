From: Patrick McHardy <kaber@trash.net>
Subject: Re: Inclusion inquiry about remaining patches
Date: Wed, 24 Feb 2010 15:57:51 +0100
Message-ID: <4B853E6F.2060709@trash.net>
References: <alpine.LSU.2.01.1002241115330.2414@obet.zrqbmnf.qr> <4B851E88.1010906@trash.net> <alpine.LSU.2.01.1002241411580.19195@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45280 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab0BXO5x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:57:53 -0500
In-Reply-To: <alpine.LSU.2.01.1002241411580.19195@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-02-24 13:41, Patrick McHardy wrote:
>>> there are about 70 patches left that I intended to submit, but it seems 
>>> Netfilter stagnated again this release. Is there still a chance for 
>>> inclusion in this round?
>> Well, the last batch didn't exactly fill me with confidence that
>> these patches have been sufficiently tested.
>>
>> I'll consider the cleanup batch if you can assure me that it
>> doesn't contain bugs similar to the "lost POSTROUTING chain"
>> problem contained in the last series that should have been
>> noticed with just some basic testing.
> 
> They have had their testing, and the error had been caught too
> by Changli merely by reading the patch:
> 
> http://marc.info/?l=netfilter-devel&m=125732159605634&w=2
> http://marc.info/?l=netfilter-devel&m=125733769630550&w=2
> 
> I still have blob 685400 in my working copy, though it seems unreachable 
> at this time, which means it sometime got lost in a rebase.

OK fair enough, I'll have another look once I'm finished with
my current work.
