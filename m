From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 6 Oct 2008 09:23:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810060916360.18011@blackhole.kfki.hu>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
 <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:60645 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYJFHX0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:23:26 -0400
In-Reply-To: <48E938F6.8080108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 6 Oct 2008, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > If restructuring is on the way, then it should cover all possible parts.
> > Just my quick thoughts, with suggested module names:
> > mark modules, targets in one module (route):
> > 	connmark, mark, realm
> > 	CLASSIFY, CONNMARK, MARK
> 
> CONNMARK and connmark needs to be separated from MARK etc. because
> they depend on the conntrack module.

They can go into a single file and linked to the "route" module iff 
NF_CONNTRACK was selected.

The same may be applied for other cases as well: it is not needed to force 
everything into a huge file. ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
