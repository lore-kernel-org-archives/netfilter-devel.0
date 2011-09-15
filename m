From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.9.1 released
Date: Thu, 15 Sep 2011 12:55:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109151246320.5790@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1109062143300.9388@blackhole.kfki.hu> <4E713E0F.1050403@googlemail.com> <alpine.DEB.2.00.1109150846290.5001@blackhole.kfki.hu> <4E71CA91.5080402@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:42934 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab1IOK4A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:56:00 -0400
In-Reply-To: <4E71CA91.5080402@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 15 Sep 2011, Mr Dash Four wrote:

> > I suppose you are trying to compile the kernel part of the package directly.
> > What should be done is as follows:
> >   
> No, actually, I am building ipset as part of the kernel built - I patch the
> sources (i.e. "copy" most of the files in kernel/include and kernel/net to the
> kernel tree) and then (trying to) build the kernel itself in the same way as I
> did with 6.8. The difference this time is that I've got the above errors.
> These occur during the kernel built - sorry, I should have made this clear.

The source tree is not supposed to be copied to the kernel tree.

At the moment you have to hand-edit ip_set_core.c: delete
the #ifdef .. #endif part around

#ifdef IPSET_EXTERNAL_MODULE
#include <linux/version.h>
#endif

In the next release I'll invert the logic of the condition and then it'll 
work even when copied into the kernel tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
