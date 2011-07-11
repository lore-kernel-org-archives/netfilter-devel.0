From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: ipset: hash:net,iface fixed to handle
 overlapping nets behind different interfaces
Date: Mon, 11 Jul 2011 18:49:32 +0200
Message-ID: <4E1B299C.2010401@trash.net>
References: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu> <1310377975-993-2-git-send-email-kadlec@blackhole.kfki.hu> <1310377975-993-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51852 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab1GKQte (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:49:34 -0400
In-Reply-To: <1310377975-993-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 11.07.2011 11:52, schrieb Jozsef Kadlecsik:
> If overlapping networks with different interfaces was added to
> the set, the type did not handle it properly. Example
> 
> 	ipset create test hash:net,iface
> 	ipset add test 192.168.0.0/16,eth0
> 	ipset add test 192.168.0.0/24,eth1
> 
> Now, if a packet was sent from 192.168.0.0/24,eth0, the type returned
> a match.
> 
> In the patch the algorithm is fixed in order to correctly handle
> overlapping networks.
> 
> Limitation: the same network cannot be stored with more than 64 different
> interfaces in a single set.
> 

Applied, thanks.
