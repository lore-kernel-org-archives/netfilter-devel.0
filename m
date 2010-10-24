From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-5 build patches
Date: Sun, 24 Oct 2010 23:01:41 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1010242217200.22824@blackhole.kfki.hu>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:59237 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab0JXVBm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:01:42 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Tue, 19 Oct 2010, Jan Engelhardt wrote:

> Jan Engelhardt (8):
>       build: just use autoreconf
>       build: resolve autoreconf/libtoolize suggestions
>       build: add separate option for kernel source directory
>       build: use libmnl's pkgconfig files
>       build: remove manual -fPIC flag
>       build: use subdir-objects and CC_C_O
>       build: run autoupdate
>       Add .gitignore files

All patches are applied, thanks. For the separate kernel source directory 
option I've added a fallback to the kernel build directory.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
