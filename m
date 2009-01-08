From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset and iptables problem.
Date: Thu, 8 Jan 2009 23:10:20 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0901082309170.23337@blackhole.kfki.hu>
References: <49660570.70501@metu.edu.tr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Husnu Demir <hdemir@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44142 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZAHWKW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:10:22 -0500
In-Reply-To: <49660570.70501@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 8 Jan 2009, Husnu Demir wrote:

> I have problems with iptables and ipset. Is new iptables compatible with ipset?
> The details are below?

> Linux hai 2.6.28 #2 SMP Wed Jan 7 13:15:14 EET 2009 x86_64 GNU/Linux

>  ipset -V
> ipset v2.4.5 Protocol version 2.

That's an incompatibility with kernel release 2.6.28, I think. There'll be 
a new release of ipset to fix that before the weekend.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
