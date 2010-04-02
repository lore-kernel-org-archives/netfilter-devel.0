From: "Gareth Williams" <gwilliams@ubicom.com>
Subject: RE: br_netfilter post routing hook question...
Date: Fri, 2 Apr 2010 12:15:56 -0700
Message-ID: <CB2DD11991B27C4F99935E6229450D320566ACC5@STORK.scenix.com>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com> <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com> <CB2DD11991B27C4F99935E6229450D320566ACAE@STORK.scenix.com> <4BB63BC9.1050000@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "agashi shipora" <gashipo@gmail.com>,
	<netfilter-devel@vger.kernel.org>
To: "Bart De Schuymer" <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server70b.appriver.com ([74.205.4.150]:3420 "EHLO
	server70.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753601Ab0DBTX1 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:23:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4BB63BC9.1050000@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ahh but I already tried physdev - and it throws warnings that it will
not work on forward or post routing paths when it's not on a bridge
interface.

But I was specifying the rule with "-o br0" which is a bridge so the
physdev rule should have been sane?

Even though it threw this warning it did add into iptables but still
didn't work for me.

I might revisit it and see if I can figure out what was wrong.

Gareth

-----Original Message-----
From: Bart De Schuymer [mailto:bdschuym@pandora.be] 
Sent: 02 April 2010 19:48
To: Gareth Williams
Cc: agashi shipora; netfilter-devel@vger.kernel.org
Subject: Re: br_netfilter post routing hook question...

Gareth Williams schreef:
> The product is a router and the bridge (br0) is connecting the lan to
wlan.  The module only wants to examine packets on the bridge for qos
purposes - to wlan and so I can, at the bridge layer, check for packets
to/from ath0 (the wireless port).  At PF_INET I would only see br0 so my
qos scope would be too wide.
>
>   
The iptables physdev match will probably save your day.


cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

