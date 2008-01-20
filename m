From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Sun, 20 Jan 2008 14:00:32 +0100
Message-ID: <479345F0.8000009@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr> <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57409 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYATNBe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:01:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 17 2008 14:52, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> +	switch (tuple->dst.protonum) {
>>> +	case IPPROTO_TCP:
>>> +	case IPPROTO_UDP:
>>> +	case IPPROTO_SCTP:
>> Minor nitpick. Add IPPROTO_UDPLITE.
> 
> Yeah that can be easily added.

Another nitpick: we support masks for the addresses, ranges of ports
would be nice to have here as well. I also don't think the protocol
check is very useful in this case since all conntrack entries contain
port numbers or something similar.

> I wonder why Netfilter does not support
> DCCP conntracking? (At least there is no dccp field in struct nf_conn
> and the tuple things.)

I have an old patch for this, but it was missing proper protocol state
tracking. Perhaps I should merge it without it for now since thats
still better than no support at all.
