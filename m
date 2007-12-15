From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Sat, 15 Dec 2007 16:55:42 +0100
Message-ID: <4763F8FE.5040607@netfilter.org>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34482 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653AbXLOP4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 10:56:02 -0500
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

The revision thing was a hack that I introduced myself to let us add
several improvements that we really needed at that time, actually it is
not something we should abuse IMO.

> Old revisions should be purged after a "reasonable time" (whatever
> that means for everyone), or perhaps whenever there is a Linux kernel
> version with a trailing .0 (2.7.0, 2.8.0), or when great new things
> appear (pkttables, or whatever is in the works).
> 
> I think the step should better be made now than later, or this cruft
> will be carried for the next 10 instead of 5 years.

I hope that we'll get that long-awaited netlink interface for iptables
before those 10 years goes by and we all become museum pieces :)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
