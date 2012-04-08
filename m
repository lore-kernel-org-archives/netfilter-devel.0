From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nomatch in bitmap:* sets
Date: Sun, 8 Apr 2012 20:08:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu>
References: <4F81A7E5.3040400@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36511 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab2DHSIF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 14:08:05 -0400
In-Reply-To: <4F81A7E5.3040400@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 8 Apr 2012, Mr Dash Four wrote:

> Currently only hash:* sets have the "nomatch" feature. Could this be 
> extended to bitmap:* sets as well?

Actually, hash:*net* types have the "nomatch" feature. How would it make 
sense to add it to the bitmap:* types too?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
