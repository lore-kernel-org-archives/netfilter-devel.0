From: David Miller <davem@davemloft.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 13:28:50 -0700 (PDT)
Message-ID: <20081005.132850.34376215.davem@davemloft.net>
References: <48E8E984.8090807@trash.net>
	<alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39287
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbYJEU3O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:29:14 -0400
In-Reply-To: <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Sun, 5 Oct 2008 21:06:34 +0200 (CEST)

> On Sun, 5 Oct 2008, Jan Engelhardt wrote:
> 
> > I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
> > noone objects.
> > Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
> > just mark.c and the issue is all gone.
> 
> I think match/target combined in one file is the best way to go. As they 
> cover the same realm (match some quantity of something and change it), 
> they do fit together.

This also makes sense to me.
