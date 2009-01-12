From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Mon, 12 Jan 2009 08:18:08 +0100
Message-ID: <496AEEB0.3080905@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57535 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZALHSK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:18:10 -0500
In-Reply-To: <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-01-12 08:08, Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> Does this patch fix it?
>> Jan, display of NFPROTO_UNSPEC targets and matches in
>> /proc/net/ip_tables_targets etc. is also broken.
> 
> I can tell it is not (more like a missing feature if you will),
> because /proc/net/ip_t* is for IPv4 only, and /proc/net/ip6_t*
> is for IPv6 only. I had a patch somewhere that added a better
> overview, let's see where in my git realms that disappeared...

Its supposed to show the targets and matches *available* for
a family. This includes NFPROTO_UNSPEC. This is the way people
are using it, so please fix this up.

