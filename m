From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Rejecting non-CIDR conformant masks?
Date: Tue, 20 Jan 2009 09:42:53 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0901200941410.8153@blackhole.kfki.hu>
References: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>    <4974C56D.7020903@trash.net> <21cb99dc3626f9cc34660485967c4425.squirrel@webmail.treenet.co.nz> <alpine.LSU.2.00.0901200810510.15943@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37706 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZATIm5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:42:57 -0500
In-Reply-To: <alpine.LSU.2.00.0901200810510.15943@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 20 Jan 2009, Jan Engelhardt wrote:

> 
> On Monday 2009-01-19 23:08, Amos Jeffries wrote:
> >>> 	-A test -d 0.0.0.123/0.0.0.255
> >>
> >> Its supposed to work, apparently people have been using masks like
> >> /0.0.0.1 for load-balancing with better distribution than /1 :)
> >
> >Should they not be using ipset for that?
> 
> I am not sure ipset provides an appropriate (optimized) set type for that,
> and since /0.0.0.1 is about 2^31 hosts, all the existing types
> including tree and bitmap would seem to take large amounts of memory
> due to this pattern.

Yes, exactly. ipset is not suited to handle such cases.

Best regards,
Jzosef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
