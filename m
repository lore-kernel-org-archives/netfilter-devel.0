From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 11:40:54 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012181133360.11002@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <alpine.LNX.2.01.1012180019381.29421@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48263 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0LRKk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 05:40:57 -0500
In-Reply-To: <alpine.LNX.2.01.1012180019381.29421@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sat, 18 Dec 2010, Jan Engelhardt wrote:

> On Friday 2010-12-17 23:26, Jozsef Kadlecsik wrote:
> 
> >I'm happy to announce the new branch of ipset and release it's first 
> >element, ipset-5.0.
> 
> That is great to hear. There is a compile error with gcc 4.5
> and the latest ipset git snapshot:
> 
>   CC     ipset.o
> cc1: warnings being treated as errors
> ipset.c: In function ?check_allowed?:
> ipset.c:344:26: error: comparison between ?enum ipset_cmd? and ?enum ipset_adt?

I have fixed it in the git tree, thanks! 
  
> The kernel/ directory is not compilable at all:

I assume you tried to compile the source in the kernel/ directory itself. 
You should have used the toplevel Makefile, as it's stated in the README file.
 
> make -C /lib/modules/`uname -r`/build M=`pwd` all
> make[1]: Entering directory `/usr/src/linux-2.6.36-rc8-34-obj/x86_64/default'
> make -C /usr/src/linux-2.6.36-rc8-34 O=/usr/src/linux-2.6.36-rc8-34-obj/x86_64/default/. 
>   CC [M]  /home/jengelh/code/ipset/kernel/ip_set.o
> kernel/ip_set.c:31:50: error: expected expression before ?;? token
> 
> ^ CONFIG_IP_SET_MAX not defined

It's set in the toplevel Makefile and propagated into the EXTRA_CFLAGS of 
kernel/Kbuild.
  
> kernel/ip_set.c: In function ?start_msg?:
> kernel/ip_set.c:735:40: error: ?NFNL_SUBSYS_IPSET? undeclared (first use in this function)
> 
> ^ Neither is this, but this was to be expected. We should really
> make this constant available in the Linux kernel so that people
> are able to compile the out-of-tree ipset until it gets in.
> 
> (I hear this issue would not have happened would we have used genetlink!
> *nudges pablo* ;-)

It's all right, the kernel was not patched.

> kernel/ip_set.c: At top level:
> kernel/ip_set.c:1633:3: warning: initialization from incompatible pointer type
> 
> ^ This is due to NFNL_CB_CONST not being set.

Again, it's set in the toplevel directory.

After checking out the git tree and working in the toplevel directory, you 
should be able to compile the code without any error.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
