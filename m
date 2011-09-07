From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/6] ipset patches
Date: Wed, 7 Sep 2011 14:04:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109071402380.12167@blackhole.kfki.hu>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu> <20110907093230.GB9078@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33447 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab1IGQSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:18:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id C4D871F40B8
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2011 18:18:10 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lbmopTuofzWj for <netfilter-devel@vger.kernel.org>;
	Wed,  7 Sep 2011 18:18:10 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id AE85F1F40AE
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2011 18:18:10 +0200 (CEST)
In-Reply-To: <20110907093230.GB9078@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 7 Sep 2011, Pablo Neira Ayuso wrote:

> On Tue, Sep 06, 2011 at 09:59:01PM +0200, Jozsef Kadlecsik wrote:
> > Hi Patrick and Pablo,
> > 
> > Here follows the patches which brings the kernel sync with ipset 6.9.1.
> > The first two are important bugfixes. Please consider applying them.
> 
> AFAIK, all trees are frozen in master.kernel.org due to the security
> issue. It seems we'll have to wait until we can apply these patches.

Yeah, I know. But with the new ipset release it seemed best to send the 
patches anyway and wait for the cleaning up and verifications at 
kernel.org.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
