From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Mon, 17 Dec 2007 14:00:39 +0100
Message-ID: <476672F7.4000202@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr> <475E639A.9040501@trash.net> <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr> <47666B52.1050802@trash.net> <Pine.LNX.4.64.0712171344040.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXLQNB0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:01:26 -0500
In-Reply-To: <Pine.LNX.4.64.0712171344040.32270@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 17 2007 13:28, Patrick McHardy wrote:
>> Userspace has to deal with these types, they're already used
>> in many other structures. I've already added the necessary
>> defines or typedefs to the iptables headers some time ago.
> 
> Yeah, but these defines were missing from libiptc, so I copied
> them there (see patch).
> 
>> We should probably just include <linux/types.h> to fix it
>> though. Could you give that a try?
> 
> It works, so please use this one:
> ===
> 
> Remove our own definitions of the Linux types and use <linux/types.h>
> instead. libiptc needs it too, or otherwise will choke on union
> nf_inet_addr.


This one works fine, thanks. Applied.
