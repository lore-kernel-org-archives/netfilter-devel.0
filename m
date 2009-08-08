From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Fwd: ipset bug
Date: Sat, 8 Aug 2009 15:25:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908081521520.14631@blackhole.kfki.hu>
References: <alpine.LSU.2.00.0908081104230.29435@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:47873 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZHHNdu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Aug 2009 09:33:50 -0400
In-Reply-To: <alpine.LSU.2.00.0908081104230.29435@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 8 Aug 2009, Jan Engelhardt wrote:

> Maybe you can do something with this:
> 
> When an ipset is created it is appended to the list of ipsets.
> On ipset -S the list is saved in that same order.
> 
> Setlists are dependant on previously declared ipsets so appended
> sets of any type are not included even if they exist.
> 
> Ipsets should be stored and saved in the order of their dependencies,
> not the order of their declarations.
> Currently only manual editing the saved file will restore order.
> 
> Marty B.

Thanks the report, it's a subtle "ipset -S" bug. I'll fix in the next 
days.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
