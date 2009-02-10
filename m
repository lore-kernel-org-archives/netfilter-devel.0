From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Tue, 10 Feb 2009 15:03:52 +0100
Message-ID: <49918948.5010103@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net> <4990B910.1050802@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZBJOD5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:03:57 -0500
In-Reply-To: <4990B910.1050802@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> This patch adds the PKTTYPE target which can be used to mangle the
>>> skbuff packet type field. This target is useful in conjunction with
>>> the arptables mcmangle target to TCP working again when a
>>> multicast hardware address is used. An example of its use:
>>>
>>> iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
>>>     -j PKTTYPE --to-pkt-type unicast
>>>
>>> Given the following arptables rule-set:
>>>
>>> arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6
>>>     \ --mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
>>> arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01
>>>     \ -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
>>>
>>> See arptables mcmangle target for further information.
>> That one refers to this patch :) So you're actually communicating
>> using TCP and multicast? Why don't you use UDP, which works fine
>> using multicast without pkttype mangling?
> 
> If the netdevice uses multicast MAC address, the link layer sets skbuff
> pkttype to PACKET_MULTICAST and TCP (among others) doesn't like this.
> This target is required to make TCP work again if a multicast MAC
> address is used.

Yes, I know, I'm just wondering why you're using TCP at all for
synchronizing. Its not for traffic from the Internet I assume
since the node it ends up on is unknown to the outside anyways.

It really seems pretty hackish to add netfilter modules to work
around valid checks in the stack. I'd prefer if we can come up
with a nicer way that offers you the same functionality.

