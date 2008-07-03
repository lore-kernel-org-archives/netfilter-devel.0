From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 03 Jul 2008 20:53:56 +0200
Message-ID: <486D2044.3090108@trash.net>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45547 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYGCSyA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:54:00 -0400
In-Reply-To: <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 3 Jul 2008, Jan Engelhardt wrote:
> 
>>> TODO: add IPv6 support to kernel side
>>>
>>> Examples:
>>>
>>> 	Egress filtering:
>>> 		iptables -A FORWARD -m route ! --route-src-exists -j DROP
>> That's what rp_filter is for.
>>
>>> 	Ingress filtering:
>>> 		iptables -A FORWARD -i $EXTERNAL_IF -m route --route-src-exists -j DROP
>> rp_filter again.
> 
> Quick and not good examples, I'd say. The main problem with rp_filter is 
> that it drops the packets >silently<. The real benefit of such a match is 
> the possibility to log (and drop) faked packets. If the patch had IPv6 
> support, one could add that additionally (as far as I know) there's no 
> rp_filter for IPv6 at all.


I agree. While I find rp_filter highly annoying (Debian has it enabled
by default), this patch at least allows you to notice whats going on
easily. I'm also sure there are people who would like to use rp_filter
like functionality for IPv6.
