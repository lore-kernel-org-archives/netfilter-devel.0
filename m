From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 16:33:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51224 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYJEUde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:33:34 -0400
In-Reply-To: <20081005.132850.34376215.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 16:28, David Miller wrote:
>> On Sun, 5 Oct 2008, Jan Engelhardt wrote:
>> 
>> > I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
>> > noone objects.
>> > Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
>> > just mark.c and the issue is all gone.
>> 
>> I think match/target combined in one file is the best way to go. As they 
>> cover the same realm (match some quantity of something and change it), 
>> they do fit together.
>
>This also makes sense to me.

Before I start moving code, would we may want to combine more modules
into one file at this point besides xt_FOO and xt_foo only?
