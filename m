From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] ipset: fix timeout data type size
Date: Mon, 11 Nov 2013 21:51:51 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311112151190.8236@blackhole.kfki.hu>
References: <1383194071-25937-1-git-send-email-mar.kolya@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nikolay Martynov <mar.kolya@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:56468 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3KKUvw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:51:52 -0500
In-Reply-To: <1383194071-25937-1-git-send-email-mar.kolya@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 31 Oct 2013, Nikolay Martynov wrote:

> Currently it is impossible to set timeout on some architectures
> (MIPS ar71xx at least) because timeout is parsed into long long data
> type but used as uint32 without proper conversion. This patch fixes
> this issue. Tested on ar71xx router.

Patch is applied, thanks!
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
