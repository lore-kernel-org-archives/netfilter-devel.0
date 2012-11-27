From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset restore behavior with newer glibc
Date: Tue, 27 Nov 2012 20:51:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211272048001.17363@blackhole.kfki.hu>
References: <50915160.1090908@akamai.com> <alpine.LNX.2.01.1210311737030.20899@nerf07.vanv.qr> <alpine.DEB.2.00.1210311904120.14824@blackhole.kfki.hu> <alpine.DEB.2.00.1210312005580.14998@blackhole.kfki.hu> <50B511EA.3070203@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@inai.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55120 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab2K0TvO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:51:14 -0500
In-Reply-To: <50B511EA.3070203@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 27 Nov 2012, Josh Hunt wrote:

> On 10/31/2012 02:07 PM, Jozsef Kadlecsik wrote:
> > 
> > It seems to me, the best is to add a stripped down version of
> > "getaddrinfo" to ipset itself. That'll be the first library workaround...
> 
> Is this something that would be an acceptable solution? If so I can try my
> hand at it unless someone else is eager to do it.

In ipset 6.15 getaddrinfo was replaced by gethostbyname2 (where it's 
available in libc).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
