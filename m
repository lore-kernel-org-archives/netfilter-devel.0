From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 2/4] Add support for --set-counters to iptables -P
Date: Mon, 12 May 2008 20:40:45 +0200
Message-ID: <48288F2D.8040904@trash.net>
References: <1210616702.3442.33.camel@henriknordstrom.net> <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <henrik@henriknordstrom.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbYELSlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:41:22 -0400
In-Reply-To: <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-05-12 20:25, Henrik Nordstrom wrote:
> 
>> Adds support for setting the policy counters
>>
>> iptables -P INPUT -J DROP -c 10 20
> 
> Could this perhaps be changed so that -c only takes one argument?
> Like -c 10,20. This would ease integration with passthrough
> argument parsing in 3rd party applications.

I already applied it, in case you want to change anything, please
send a patch on top.
