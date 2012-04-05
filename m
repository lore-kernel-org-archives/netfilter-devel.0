From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipsets and network namespaces
Date: Thu, 5 Apr 2012 13:24:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1204051324190.23192@blackhole.kfki.hu>
References: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gorik Van Steenberge <gorik.vansteenberge@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50701 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2DELY4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:24:56 -0400
In-Reply-To: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Apr 2012, Gorik Van Steenberge wrote:

> I've noticed that when creating a new network namespace (using the lxc
> tools) that ipsets (userspace v6.11 on kernel 3.3.1) are still global,
> i.e. an ipset created in the container is visible in the host and vice
> versa. Iptables rulesets, however, are isolated.
> 
> Is this an as of yet unimplemented feature or a conscious design decision?

It's an unimplemented feature - no one requested it yet ;-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
