From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.5 released
Date: Sun, 22 May 2011 00:31:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105220018010.23769@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105151540340.25248@blackhole.kfki.hu> <4DD83964.5050105@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:50038 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab1EUWby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 May 2011 18:31:54 -0400
In-Reply-To: <4DD83964.5050105@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 21 May 2011, Mr Dash Four wrote:

> > Kernel part changes:
> >  - Support range for IPv4 at adding/deleting elements for hash:*net* types
> >  - Set type support with multiple revisions added
> >  - Fix adding ranges to hash types
> >   
> Forgot one more thing: I was able to compile all ipset 4.5 kernel modules into
> the kernel itself (i.e. all ipset kernel module options set to "y" as oppose
> to "m"). I am, however, not able to do that in ipset 6.5 - I can only compile
> them as modules (i.e. I only have two choices and that is either "m" to
> include them as modules, or not compile them at all). Is there a reason for
> this or is this another bug?

The ipset-4.x packages support patching the kernel source tree, and in the 
kernel tree you can select module or static compiling. The ipset-6.x 
packages support only compiling as external modules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
