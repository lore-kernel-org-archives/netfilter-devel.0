From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: do install libipset/args.h
Date: Tue, 23 Jan 2018 20:23:25 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1801232022370.10338@blackhole.kfki.hu>
References: <20180122215033.28643-1-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53759 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752285AbeAWTX3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 14:23:29 -0500
In-Reply-To: <20180122215033.28643-1-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Mon, 22 Jan 2018, Jan Engelhardt wrote:

> libipset/types.h includes args.h, therefore args.h must be installed
> too.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  include/libipset/Makefile.am | 1 +
>  1 file changed, 1 insertion(+)

Yes, it's required. Thanks, patch is applied.

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
