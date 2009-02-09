From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Tue, 10 Feb 2009 00:15:28 +0100
Message-ID: <4990B910.1050802@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35327 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753099AbZBIXPk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:15:40 -0500
In-Reply-To: <4990480D.9060900@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch adds the PKTTYPE target which can be used to mangle the
>> skbuff packet type field. This target is useful in conjunction with
>> the arptables mcmangle target to TCP working again when a
>> multicast hardware address is used. An example of its use:
>>
>> iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
>>     -j PKTTYPE --to-pkt-type unicast
>>
>> Given the following arptables rule-set:
>>
>> arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6
>>     \ --mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
>> arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01
>>     \ -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
>>
>> See arptables mcmangle target for further information.
> 
> That one refers to this patch :) So you're actually communicating
> using TCP and multicast? Why don't you use UDP, which works fine
> using multicast without pkttype mangling?

If the netdevice uses multicast MAC address, the link layer sets skbuff
pkttype to PACKET_MULTICAST and TCP (among others) doesn't like this.
This target is required to make TCP work again if a multicast MAC
address is used.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
