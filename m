From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 5.4 released
Date: Sat, 22 Jan 2011 10:45:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101221041400.11692@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1101212302300.10656@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41080 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1AVJpw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:45:52 -0500
In-Reply-To: <alpine.DEB.2.00.1101212302300.10656@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 21 Jan 2011, Jozsef Kadlecsik wrote:

> I'm happy to announce ipset 5.4! Because there are some important kernel 
> part fixes in this release, please upgrade.

In order to make upgrading as smooth as possible, I have released ipset 
5.4.1, which includes an UPGRADE instructions file with the content:

ipset 5.x upgrade notices

- From ipset 5.0-5.3 to 5.4:

  Due to the source code reorganization, some macros were moved to
  the netlink.patch. Therefore when upgrading, you have two choices:

  a. force the application of the new netlink.patch

     kernel-source-dir # patch -p1 -f < ipset-5.4-dir/netlink.patch

  b. remove the earlier netlink.patch and apply the new one:

     kernel-source-dir # patch -p1 -R < ipset-before-5.4-dir/netlink.patch
     kernel-source-dir # patch -p1 < ipset-5.4-dir/netlink.patch

  You do not need to recompile your kernel.

  Of course the kernel modules in ipset-5.4 must be compiled and installed.

Nothing else is changed between 5.4 and 5.4.1.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
