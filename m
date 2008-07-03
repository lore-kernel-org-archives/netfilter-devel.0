From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Thu, 3 Jul 2008 15:15:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031504180.1816@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <200807031044.37410.ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:59612 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYGCNPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:15:54 -0400
In-Reply-To: <200807031044.37410.ludwig.nussel@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 3 Jul 2008, Ludwig Nussel wrote:

> Jozsef Kadlecsik wrote:
> > I'm happy to announce ipset-2.3.2. Besides cosmetic changes and cleanups, 
> 
> Ah, nice. I'd like to suggest to add the following patch. It
> separates building the kernel modules and the user space parts. That
> eases packaging for distributions as the kernel part has to be
> compiled several times for different kernel flavors so the
> integrated way is not really useful there :-)

Please check out ipset-2.3.2a, which has got 'binaries', 
'binaries_install' targets for the userspace part and 'modules', 
'modules_install' for the kernel modules.

> Additionally IP_NF_SET_MAX and IP_NF_SET_HASHSIZE should be moved to
> kernel/Kbuild for that purpose. Atm one has to extract them from the
> Makefile and define them manually for the kernel module build pass.

I wanted one "toplevel" Makefile which makes possible to compile and 
install the whole bunch in one "step". 

The defaults for IP_NF_SET_MAX and IP_NF_SET_HASHSIZE should be moved to 
kernel/Kbuild, yes.
 
> btw is there a reason why the tarball has a date appended to the
> release number? I just wonder whether the package version should be
> 2.3.2_20080702 or whether 2.3.2 suffices.

At the first glace it looks like a redundant information, but there should 
be a version number for the 'ipset' binary and a "version number" for the 
kernel modules. As the second one does not exist, the release date helps 
to distinguis releases where the kernel part changed alone.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
