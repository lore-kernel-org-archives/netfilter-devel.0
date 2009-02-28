From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: new strict host model match
Date: Sat, 28 Feb 2009 02:53:10 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902280253030.20614@fbirervta.pbzchgretzou.qr>
References: <20090226175247.5e56910f@nehalam> <alpine.LSU.2.00.0902270414290.14912@fbirervta.pbzchgretzou.qr> <20090226192353.2b6dea9f@nehalam>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46882 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762148AbZB1BxO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:53:14 -0500
In-Reply-To: <20090226192353.2b6dea9f@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-27 04:23, Stephen Hemminger wrote:
>> >+static struct xt_match strict_mt_reg __read_mostly = {
>> >+	.name		= "strict",
>> >+	.family		= NFPROTO_IPV4,
>> >+	.match		= strict_mt,
>> >+	.matchsize	= 0,
>> >+	.me		= THIS_MODULE,
>> >+};
>> 
>> The match seems to make the most sense where an input device
>> is available, so
>> 
>> 	.hooks = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
>> 	         (1 << NF_INET_FORWARD)
>> 
>> should probably be added.
>
>Then routing wouldn't work...

How so?
