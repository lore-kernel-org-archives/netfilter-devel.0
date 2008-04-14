From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] Remove support for compilation of conditional extensions
Date: Mon, 14 Apr 2008 08:56:46 +0200
Message-ID: <4803002E.9070701@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <2b2e38a1bfc0069830bd5cfe535fa52b7ee8a0da.1208075035.git.jengelh@computergmbh.de> <4802FDD8.301@trash.net> <alpine.LNX.1.10.0804140850240.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63537 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbYDNG4u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:56:50 -0400
In-Reply-To: <alpine.LNX.1.10.0804140850240.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-04-14 08:46, Patrick McHardy wrote:
>> Was there some resolution on the discussion that this
>> is the way to go? I mainly would like to see an ACK
>> from Jozsef for this change before applying it.
>>
> There was some sort of positive agreement:
> 
> http://www.spinics.net/lists/netfilter-devel/msg02729.html (ipset)
> http://www.spinics.net/lists/netfilter-devel/msg02727.html (condition)
> 

Yes, "sort of". So far it seems most convenient to keep ipset in
iptables. What was the exact problem with these extensions again?

