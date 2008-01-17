From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Thu, 17 Jan 2008 16:00:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
 <478F5D92.3040404@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYAQPA3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:00:29 -0500
In-Reply-To: <478F5D92.3040404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 17 2008 14:52, Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> +	switch (tuple->dst.protonum) {
>> +	case IPPROTO_TCP:
>> +	case IPPROTO_UDP:
>> +	case IPPROTO_SCTP:
>
> Minor nitpick. Add IPPROTO_UDPLITE.

Yeah that can be easily added. I wonder why Netfilter does not support
DCCP conntracking? (At least there is no dccp field in struct nf_conn
and the tuple things.)
