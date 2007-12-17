From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Mon, 17 Dec 2007 13:37:06 +0100
Message-ID: <47666D72.3060406@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56537 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXLQMhx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:37:53 -0500
In-Reply-To: <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 11 2007 11:25, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Introduce the xt_mark match revision 1. It uses fixed types,
>>> with the goal of obsoleting revision 0 some day (uses nonfixed types).
>> I don't know. We already have all this compat crap because
>> we specifically don't want to obsolete old userspace binaries,
>> so the only benefit I see is a minor decrease in overhead
>> when loading rules.
>>
> There are two sorts of compatibility.
> 
> * "Post-breakage fixes" like ->compat_from_user and ->compat_to_user
>   which have to deal with 32-bit user / 64-bit kernel
> 
> * ->revision which is a good architecture to keep older interfaces a
>   little longer.
> 
> The ->revision game is ok IMHO; there will always be revision
> differences between user- and k-space, and it is a nice architecture
> for new-behavior revisions. But the ->compat* fluff is not really
> needed anymore once switched to fixed types everywhere (reasonable
> time needed).


I actually just added compat support for MARK v1 since we
need that for old ip6tables binaries.

> Old revisions should be purged after a "reasonable time" (whatever
> that means for everyone), or perhaps whenever there is a Linux kernel
> version with a trailing .0 (2.7.0, 2.8.0), or when great new things
> appear (pkttables, or whatever is in the works).
> 
> I think the step should better be made now than later, or this cruft
> will be carried for the next 10 instead of 5 years.


Mhh .. well, I guess I would apply patches that fix the types
for all matches and targets and adds the old revisions to 
feature-removal-schedule with a timeframe of maybe two years.
But this should happen for all of them at once, we don't
want 20 different dates for removal.
