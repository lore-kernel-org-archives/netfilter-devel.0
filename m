From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Thu, 15 Jan 2009 14:57:48 +0100
Message-ID: <496F40DC.2000605@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net> <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZAON5u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:57:50 -0500
In-Reply-To: <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-01-12 08:18, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> I can tell it is not (more like a missing feature if you will),
>>> because /proc/net/ip_t* is for IPv4 only, and /proc/net/ip6_t*
>>> is for IPv6 only. I had a patch somewhere that added a better
>>> overview, let's see where in my git realms that disappeared...
 >>
>> Its supposed to show the targets and matches *available* for
>> a family.
> 
> Possibly - I found no comment in the source.

It is older than xtables and has always worked that way. It doesn't
make sense to have the contents dependant on implementation details.
I also know that some UIs rely on having available modules shown,
IIRC one of them was shorewall. This needs to be fixed.

> But the spartanic output of those proc files barely helps (especially
> in light of multiple revisions), so here is the patch I spoke about,
> refreshed and rebased, that solves the worries.

That seems a bit overkill. Text-based representation also doesn't seem
ideal, iptables already has this information and a cmdline user will
simply use "iptables ... -h" to get the supported option. For other
programs a binary representation would probably be easier to handle.
