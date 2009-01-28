From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Wed, 28 Jan 2009 17:51:56 +0100
Message-ID: <49808D2C.8080009@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <alpine.LSU.2.00.0901281707460.20921@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44800 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656AbZA1QwH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:52:07 -0500
In-Reply-To: <alpine.LSU.2.00.0901281707460.20921@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-01-28 15:58, Pablo Neira Ayuso wrote:
> 
>> This patch adds the PKTTYPE target which can be used to mangle the
>> skbuff packet type field. This target is useful in conjunction with
>> the arptables mcmangle target to TCP working again when a
>> multicast hardware address is used. An example of its use:
>>
>> iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
>> 	-j PKTTYPE --to-pkt-type unicast
> 
> Are not packets not destined for 224/4 - assuming standard route setups -
> unicast anyway?

Not if you use the mcmangle arptables target to use a multicast hardware
address instead of the normal unicast, in that case, the link layer set
them to PACKET_MULTICAST. Indeed, the only use that I can find for this
target at the moment is to combine it with mcmangle.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
