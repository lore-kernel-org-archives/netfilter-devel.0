From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 00/11] conntrackd with libevent
Date: Fri, 25 Jan 2008 19:03:32 +0100
Message-ID: <479A2474.9020607@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <47972E11.5040602@netfilter.org> <20080123122639.GA17074@swift.blarg.de> <4797381C.5060307@netfilter.org> <479A2414.8090009@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55144 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759280AbYAYSDq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:03:46 -0500
In-Reply-To: <479A2414.8090009@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> BTW, there's an implementation of the RB-trees in the kernel under lib/
>> that seems to be quite stable and which has several clients. We may use
>> it to implement the alarm scheduler. Moreover it is GPLv2 or any later.
>> Although I have not investigate it further yet.
> 
> JFYI: I have uploaded to my netfilter place a rbtree-based alarm
> implementation but I haven't commit it to SVN since I want to give it
> some extra spins.

http://people.netfilter.org/pablo/

Maybe you don't know where it is.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
