From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug: ipset-6.22 broken with dynamic modules
Date: Sat, 20 Sep 2014 19:55:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409201949550.13749@blackhole.kfki.hu>
References: <loom.20140920T161855-163@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:46074 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbaITRyx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:54:53 -0400
In-Reply-To: <loom.20140920T161855-163@post.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 20 Sep 2014, Sergei Zhirikov wrote:

> I have just tried building ipset-6.22 and encountered this issue. When
> configured with --enable-settype-modules --with-settype-modules-list=all the
> build succeeds, but what it produces is unusable, because the modules
> require several symbols that are not exported from libipset.so. As far as I
> can tell, those missing symbols are the five functions introduced with the
> commit c1dd8442aac6cadb29110f763f23cafc63135a79 (libipset: Add userspace
> code for the skbinfo extension support).

Yes, that's right - I have forgotten to update the library map file and 
bump the library number. I'm going to fix it at the weekend. Thanks for 
the reporting!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
