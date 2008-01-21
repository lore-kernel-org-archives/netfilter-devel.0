From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Mon, 21 Jan 2008 02:18:53 +0100
Message-ID: <4793F2FD.7040500@netfilter.org>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr> <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr> <479345F0.8000009@trash.net> <4793F1F0.2080403@netfilter.org> <Pine.LNX.4.64.0801210215100.22430@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33779 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756272AbYAUBTF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:19:05 -0500
In-Reply-To: <Pine.LNX.4.64.0801210215100.22430@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 21 2008 02:14, Pablo Neira Ayuso wrote:
>> BTW, it would be great if we add support for layer 4 protocol state
>> matching, e.g. match TCP established. We can use this together with the
>> target that would mark certain events as volatile, e.g.
>>
>> iptables -A 192.168.0.0/24 -m conntrack ! --tcp-state ESTABLISHED -j
>> VOLATILE
> 
> And what's xt_VOLATILE do? (Was it hidden in your recent
> xt_CONNTRACK submission?)

Indeed. Just set the IPCT_VOLATILE flag to tell ctnetlink to skip that
event. It would be a very simple target. I don't know if VOLATILE would
be a nice name, perhaps CTNETLINK.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
