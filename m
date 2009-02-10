From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: arptables: add mcmangle target
Date: Tue, 10 Feb 2009 12:16:45 +0100
Message-ID: <4991621D.9090300@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <499047A3.9000505@trash.net> <4990B87C.5040001@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48738 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750759AbZBJLQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:16:58 -0500
In-Reply-To: <4990B87C.5040001@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Great name. Took me a bit to realize the connection to "multicast" :)
> 
> I thought about mcnugget target, but it seems to be already copyrighted ;)
> 
>> Continuing the idea of a generic ARP address mangling target,
>> this would have to be done in userspace using SIOCADDMULTI.
>>
>> I would also prefer that approach because the multicast mangling
>> seems a bit like a hack which only works when the requesting
>> host accepts a multicast MAC address in the ARP reply.
> 
> Indeed, I didn't know about SIOCADDMULTI, great. I'll do it like you
> have proposed. Thanks.

Hey, just to let you know ;). The 'ip' tool already allows adding static
multicast MAC addresses via SIOCADDMULTI. The following commands do the
trick:

ip maddr add 01:00:5e:00:01:01 dev eth1
arptables -I OUTPUT -o eth1 --h-length 6 \
-j mangle --mangle-mac-s 01:00:5e:00:01:01
arptables -I INPUT -i eth1 --h-length 6 --destination-mac \
01:00:5e:00:01:01 -j mangle --mangle-mac-d $REAL_HWADDR1

Still the PKTTYPE iptables target that I posted is needed to make TCP
and friends work in a devide that uses a multicast MAC.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
