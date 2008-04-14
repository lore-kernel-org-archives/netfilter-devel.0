From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: AW: Add new target in mangle table
Date: Mon, 14 Apr 2008 18:58:41 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de> <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr> <20080414163449.293250@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: manuprivat@gmx.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39254 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYDNQ6m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:58:42 -0400
In-Reply-To: <20080414163449.293250@gmx.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-04-14 18:34, manu wrote:
>> >>
>> >># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
>> >>--to-source 10.0.19.2
>> >
>> One question this throws up... how do you know the address is
>> 192.168.0.168?
>
>Actually, I dont know that! It is only an example to show the different
>IP-ranges. Excuse my improper representation.

The question is more of a technical one-- if you do not know the
source address the client will be using, how can you reliably
mangle the address?
