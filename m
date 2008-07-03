From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 03 Jul 2008 18:10:55 +0200
Message-ID: <486CFA0F.7050900@trash.net>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031749501.4958@bizon.gios.gov.pl> <alpine.LNX.1.10.0807031806310.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYGCQWI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:22:08 -0400
In-Reply-To: <alpine.LNX.1.10.0807031806310.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-07-03 17:51, Krzysztof Oledzki wrote:
>   
>>> You know what's been bugging me... why don't we replace the entire
>>> routing infrastructure by an xtables "route" table, with something like
>>>       
>> Because routing in a firewall is slow and too complicated?
>>     
>
> Proof?

Its obvious, routing lookups are optimized for the specific case while
iptables is trying to be generic.
