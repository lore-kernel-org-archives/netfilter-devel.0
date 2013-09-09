From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: BUG: kernel 3.10 + ipset + NET_NS
Date: Mon, 9 Sep 2013 12:52:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309091251510.19930@blackhole.kfki.hu>
References: <522D9D78.7080802@guap.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "V. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41443 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3IIKwe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:52:34 -0400
In-Reply-To: <522D9D78.7080802@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 9 Sep 2013, V. Lavrov wrote:

> ipset does not support NET_NS. All containers have a common ipsets.

That's true, because no one requested netns support in ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
