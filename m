From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Thu, 17 Sep 2009 13:22:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu> <4AB2184F.9090208@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:39788 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZIQLWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:22:55 -0400
In-Reply-To: <4AB2184F.9090208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 17 Sep 2009, Patrick McHardy wrote:

> I got one reject in the removal of nf_conntrack_tcp_update() due
> to the use of write_lock() instead of spin_lock() in your patch
> (seems to be based on an old tree), this is the patch I committed:

Uhh, I forgot to forward-port the patch, sorry: I used the 2.6.30.5 tree 
for verifying the bug and testing the fix.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
