From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Tue, 10 Feb 2009 15:22:09 +0100
Message-ID: <49918D91.60801@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net> <4990B910.1050802@netfilter.org> <49918948.5010103@trash.net> <alpine.DEB.2.00.0902101512500.9244@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZBJOWN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:22:13 -0500
In-Reply-To: <alpine.DEB.2.00.0902101512500.9244@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 10 Feb 2009, Patrick McHardy wrote:
> 
>> Yes, I know, I'm just wondering why you're using TCP at all for
>> synchronizing. Its not for traffic from the Internet I assume
>> since the node it ends up on is unknown to the outside anyways.
> 
> No, that's not the syncronizing traffic, but the "normal" TCP traffic to 
> be filtered by the firewalls, which have got multicast MAC addresses on 
> their interfaces.

Multicast traffic is accepted for forwarding just fine, its just
local TCP delivery thats refusing it. So it can't be forwarded
traffic.
