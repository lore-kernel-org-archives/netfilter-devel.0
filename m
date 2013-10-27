From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: Fix library interface version
Date: Sun, 27 Oct 2013 19:14:36 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1310271912590.6494@blackhole.kfki.hu>
References: <20131026080206.GA19266@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:60022 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3J0SOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:14:37 -0400
In-Reply-To: <20131026080206.GA19266@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 26 Oct 2013, Neutron Soutmun wrote:

> * The library interface version should be 5:0:2 which it will create the
>   libipset.so.3.2.0 instead of 4:1:2 which create the libipset.so.2.2.1
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>

Jan Engelhardt already sent a patch to fix the library version, I have 
applied his patch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
