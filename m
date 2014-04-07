From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Fix printf format warning
Date: Mon, 7 Apr 2014 21:52:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1404072151410.9821@blackhole.kfki.hu>
References: <20140401104452.GA2110@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50412 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaDGTwI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:52:08 -0400
In-Reply-To: <20140401104452.GA2110@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 1 Apr 2014, Neutron Soutmun wrote:

> Using PRIx32 macro is portable across multiple architectures and
> also fix the printf format warning on any architectures that
> "%llx" is not refer to 32 bits size.

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
