From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 7/8] Remove support for compilation of conditional
 extensions
Date: Mon, 14 Apr 2008 15:14:45 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804141414420.9651@fbirervta.pbzchgretzou.qr>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <2b2e38a1bfc0069830bd5cfe535fa52b7ee8a0da.1208075035.git.jengelh@computergmbh.de> <4802FDD8.301@trash.net> <alpine.LNX.1.10.0804140850240.9651@fbirervta.pbzchgretzou.qr>
 <4803002E.9070701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58445 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYDNNOq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:14:46 -0400
In-Reply-To: <4803002E.9070701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-04-14 08:56, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Monday 2008-04-14 08:46, Patrick McHardy wrote:
>> > Was there some resolution on the discussion that this
>> > is the way to go? I mainly would like to see an ACK
>> > from Jozsef for this change before applying it.
>> >
>> There was some sort of positive agreement:
>> 
>> http://www.spinics.net/lists/netfilter-devel/msg02729.html (ipset)
>> http://www.spinics.net/lists/netfilter-devel/msg02727.html (condition)
>
> Yes, "sort of". So far it seems most convenient to keep ipset in
> iptables. What was the exact problem with these extensions again?
>
The problem is not the extensions themselves; but they do not compile
due to a lack of their header files. Should it just be added?

Should ipset instead be added to the kernel?
