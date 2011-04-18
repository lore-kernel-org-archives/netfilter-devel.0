From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/5] netfilter: ipset patches
Date: Mon, 18 Apr 2011 21:08:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104182107170.9202@blackhole.kfki.hu>
References: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu> <4DAC4BC1.8060208@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:42990 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab1DRTI0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:08:26 -0400
In-Reply-To: <4DAC4BC1.8060208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 18 Apr 2011, Patrick McHardy wrote:

> Am 13.04.2011 21:52, schrieb Jozsef Kadlecsik:
> > Hi Patrick,
> > 
> > Here follows the ipset patches for nf-next-2.6. This batch contains
> > the missing fixes compared to nf-2.6 and one new feature, the ability
> > to modify the timeout value of already existing elements.
> 
> Thanks, but we shouldn't be applying the same patches twice, its better
> to ask Dave to pull in net-2.6.git into net-next-2.6.git if your
> patches depend on fixes in that tree, I can then pull net-next-2.6.git
> into my tree.

Oh, right. I'm going to send one bugfix today or tomorrow morning, then 
just the improvements remains.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
