From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: fix incorrect library versioning
Date: Sun, 27 Oct 2013 19:12:47 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1310271911310.6494@blackhole.kfki.hu>
References: <1382275044-11654-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:54624 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab3J0SMt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:12:49 -0400
In-Reply-To: <1382275044-11654-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 20 Oct 2013, Jan Engelhardt wrote:

> Commit v6.20~12 caused libipset to shift from libipset.so.3 to
> .so.2. That is the wrong thing to do. Set it back to 3+2, as
> intended.
> ---

Patch is applied, thanks. I should have noticed the shift in the library 
version number :-(.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
