From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.2 released
Date: Thu, 23 Dec 2010 20:48:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012232035440.6582@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012231553460.6044@blackhole.kfki.hu> <20101223.113226.102539649.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:33266 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0LWTsv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:48:51 -0500
In-Reply-To: <20101223.113226.102539649.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Dec 2010, David Miller wrote:

> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Thu, 23 Dec 2010 15:57:12 +0100 (CET)
> 
> >         git://git.netfilter.org/ipset.git, ipset-5 branch
> 
> This is way more difficult than it should be.
> 
> People cannot just clone your tree to look at the latest code.  The
> master branch, which should be the latest and greatest, is your 4.x
> stuff.

I *was* thinking on renaming the ipset-5 branch to the master one, but 
then from some reason I refrained from doing so. Should have done.
 
> They have to go through a multi-step non-trivial process to get at the
> latest 5.x code, and this is a serious discouragement.
> 
> It's frankly rediculious.
> 
> I personally did a "rm -rf ipset/" when I discovered how this was
> setup, and I seriously wanted to review your code and look for bugs.

I have just renamed the ipset-5 branch to the master one. I'm sorry for 
wasting time.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
