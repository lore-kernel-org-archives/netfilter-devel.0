From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:24:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1506191520530.15886@nerf40.vanv.qr>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org> <20150619125724.GG22946@acer.localdomain> <2024102.ynN6JVsV1M@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33004 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbbFSNYx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:24:53 -0400
In-Reply-To: <2024102.ynN6JVsV1M@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-06-19 15:17, Patrick Schaaf wrote:
>On Friday 19 June 2015 14:57:24 Patrick McHardy wrote:
>>
>> Is tee a name we want to use for userspace syntax? It's not particulary
>> descriptive for people who don't know what "tee" is, which I guess are
>> quite a few.
>
>Naming the thing "tee" was a conscious decision when I invented the it as an 
>option to the ROUTE target back in 2004  - because it is a huge foot gun, and 
>obscurity seemed appropriate.

Well, "clone" is the term that should be used if one really wants to
avoid "tee". But tee is now used for the kernel module and for the
iptables module, so out of consistency, you want the same in nft.

Besides, tee is inspired from /usr/bin/tee and therefore ought to be
rather well-known already: it's what people are usually learning in
the same chapter as cat(1) when they make their first steps in Shell.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
