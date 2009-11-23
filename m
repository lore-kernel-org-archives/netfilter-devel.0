From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: improve out-of-sync situation in
 TCP tracking
Date: Mon, 23 Nov 2009 10:38:07 +0100
Message-ID: <4B0A57FF.4020901@trash.net>
References: <20091114110651.7461.84924.stgit@decadence> <20091114111004.7461.37215.stgit@decadence> <4B0560CF.9000400@trash.net> <alpine.DEB.2.00.0911202038280.10259@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35689 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZKWJiD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:38:03 -0500
In-Reply-To: <alpine.DEB.2.00.0911202038280.10259@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 19 Nov 2009, Patrick McHardy wrote:
> 
>> Pablo Neira Ayuso wrote:
>>> Without this patch, if we receive a SYN packet from the client while
>>> the firewall is out-of-sync, we let it go through. Then, if we see
>>> the SYN/ACK reply coming from the server, we destroy the conntrack
>>> entry and drop the packet to trigger a new retransmission. Then,
>>> the retransmision from the client is used to start a new clean
>>> session.
>>>
>>> This patch improves the current handling. Basically, if we see an
>>> unexpected SYN packet, we annotate the TCP options. Then, if we
>>> see the reply SYN/ACK, this means that the firewall was indeed
>>> out-of-sync. Therefore, we set a clean new session from the existing
>>> entry based on the annotated values.
>>>
>>> This patch adds two new 8-bits fields that fit in a 16-bits gap of
>>> the ip_ct_tcp structure.
>>>
>>> This patch is particularly useful for conntrackd since the
>>> asynchronous nature of the state-synchronization allows to have
>>> backup nodes that are not perfect copies of the master. This helps
>>> to improve the recovery under some worst-case scenarios.
>> This seems like a good idea to me. I'd like to get an ACK from
>> Jozsef before I apply this though since he knows this code way
>> better than I do :)
> 
> Yes, it's a good idea and looks fine to me:
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks everyone.
