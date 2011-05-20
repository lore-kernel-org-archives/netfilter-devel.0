From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset return value in type_pf_tdel()
Date: Fri, 20 May 2011 09:46:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105200945330.12364@blackhole.kfki.hu>
References: <20110519.190937.1873377377043137868.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50257 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1ETHq7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 03:46:59 -0400
In-Reply-To: <20110519.190937.1873377377043137868.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 May 2011, David Miller wrote:

> Variable 'ret' in this function is set but not used.
> 
> I'm thinking that the "return 0" should perhaps be "return ret"
> but it maybe should not be and 'ret' should simply be deleted
> entirely.
> 
> Please take a look at this.

I'll look at it and send the fix together with my pending patches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
