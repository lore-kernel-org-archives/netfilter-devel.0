From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.9.1: 3.0.4 kernel tests failure
Date: Mon, 19 Sep 2011 17:08:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109191651440.14210@blackhole.kfki.hu>
References: <1316438977.7764.6.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40023 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab1ISPIv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:08:51 -0400
In-Reply-To: <1316438977.7764.6.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19 Sep 2011, Peter Volkov wrote:

> Hi. I've ran ipset-6.9.1 test suite on 3.0.4 kernel and it failed:
> 
> bitmap:ip: Network: Create a set from a valid network with timeout:
> passed
> bitmap:ip: Network: Add lower boundary: FAILED
> Failed test: ../src/ipset 2>.foo.err add test 2.0.0.0 timeout 0
> ipset v6.9.1: Element is out of the range of the set
> 
> Is this expected? ipset-6.8 has the same problem.

The testsuite always verifies the most recent ipset package (there is no 
version-dependent tests). Unfortunately a lot of fixes were committed in 
the 3.1 tree and are missing from the 3.0 tree :-(, so checking 3.0.x
with the testsuite surely fails.

> BTW, in general is it better to use in-kernel modules or kernel modules
> bundled with ipset? Personally I'd better pushed required patches into
> our kernels and suggested users to use them, but where it's better to
> pull such patches from?

Due to the different merge levels it takes some time when the patches 
finally can land in the mainline kernel.

I always send the patches to netfilter-devel mailing list, so you can pull 
them there. I can even add your address to the list of recipients if you 
think it's better for you.

The ipset git tree can be used as well, however it's meant to carry the 
ipset package with support from 2.6.35 up to the most recent kernels, so 
the source code contains kernel version dependent parts. But that's the 
only difference compared to the source code when it's submitted and merged 
into the kernel.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
