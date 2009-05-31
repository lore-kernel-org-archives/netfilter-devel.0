From: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Sun, 31 May 2009 16:04:23 -0700
Message-ID: <4ddb24250905311604o8d0f2c2l9ba3984ae296a009@mail.gmail.com>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>
	 <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
Reply-To: saatvik.agarwal@stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:42492 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZEaXEW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 19:04:22 -0400
Received: by gxk10 with SMTP id 10so12403338gxk.13
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2009 16:04:23 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Thanks a lot for the patch. What version of the kernel/netfilter code
is this patch intended for? I'm running debian 2.6.26 (lenny) and I
can't patch my source. 14 out of the 15 hunks fail.

I might do a manual merge for now.

Thanks so much once again for the patch. I will try to test it in the
next few days and let you know how it goes.

Best,
Saatvik

On 5/31/09, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> On Sun, 31 May 2009, Jozsef Kadlecsik wrote:
>
>  > ---
>  >  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>  >  net/netfilter/nf_conntrack_proto_tcp.c     |   97 +++++++++++++++++-----------
>  >  2 files changed, 61 insertions(+), 38 deletions(-)
>
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>
>  Sorry, that line was not added.
>
>  Best regards,
>  Jozseg
>
> -
>  E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
>  PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>  Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>
