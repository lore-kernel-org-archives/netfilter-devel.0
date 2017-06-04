From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Fix ipset command replacement in runtest.sh
Date: Sun, 4 Jun 2017 14:00:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1706041359390.5302@blackhole.kfki.hu>
References: <20170530104633.xb3urujnizjkc4n6@hydrogen>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:52225 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdFDMH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 08:07:59 -0400
In-Reply-To: <20170530104633.xb3urujnizjkc4n6@hydrogen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 30 May 2017, Neutron Soutmun wrote:

>   Fix the ipset command replacement.
> 
>   For ipset="/sbin/ipset"
> 
>   Actual:
>     /sbin//sbin/ipset 2>.foo.err | ... | xargs -n1 ipset
>   Expected:
>     /sbin/ipset 2>.foo.err | ... | xargs -n1 /sbin/ipset
> ---
>  tests/runtest.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch is applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
