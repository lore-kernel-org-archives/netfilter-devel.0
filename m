From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Mon, 08 Jun 2009 15:50:22 +0200
Message-ID: <4A2D171E.9060401@trash.net>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36114 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbZFHNuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:50:21 -0400
In-Reply-To: <4A2A1260.7050207@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Jan,
> 
> Jan Engelhardt wrote:
>> From: Michael Granzow <mgranzow@zeus.com>
>>
>> libiptc already supports adding and deleting multiple rules with
>> different addresses, so it only needs to be wired up to the options.
>>
>> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>>
>> References: http://marc.info/?l=netfilter-devel&m=123929790719202&w=2
> 
> I think this is handy for users so I can find it useful.
> 
> The only concern that I have with this is that it changes the existing
> 1:1 mapping between commands and iptables rules. I mean, people may get
> confused because of this "rule expansion" feature, they may think that
> we natively support layer 3 address sets? Probably it's a matter of
> documenting this.
> 
> I'd like to know what Patrick thinks about this anyway.

No objections besides that its too large for this late in the cycle.
