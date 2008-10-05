From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 21:06:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
References: <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr>
 <48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net>
 <48E8E736.8060800@trash.net> <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr>
 <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57106 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbYJETiw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:38:52 -0400
In-Reply-To: <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 5 Oct 2008, Jan Engelhardt wrote:

> I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
> noone objects.
> Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
> just mark.c and the issue is all gone.

I think match/target combined in one file is the best way to go. As they 
cover the same realm (match some quantity of something and change it), 
they do fit together.

If there's no match/target counterpart, that's not a big trouble at all 
:-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
