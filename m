From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 11:33:45 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:38070 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbcCMKdC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 06:33:02 -0400
In-Reply-To: <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 12 Mar 2016, Jan Engelhardt wrote:

> >I'm happy to announce ipset 6.28 with a couple of important fixes, some 
> >compatibility improvements and corrections.
> >  - Support older pkg-config packages
> 
> Whatever you did, it broke.
> 
> [   51s] checking for libmnl... no
> [   51s] configure: error: in `/home/abuild/rpmbuild/BUILD/ipset-default-6.28':
> [   51s] configure: error: The pkg-config script could not be found or is too
> old.  Make sure it
> [   51s] is in your PATH or set the PKG_CONFIG environment variable to the full
> [   51s] path to pkg-config.

Does this patch help to solve the problem?

diff --git a/configure.ac b/configure.ac
index 1988836..b05646b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,6 +12,8 @@ LT_INIT([dlopen])
 LT_CONFIG_LTDL_DIR([libltdl])
 LTDL_INIT([nonrecursive])
 
+PKG_PROG_PKG_CONFIG
+
 dnl Shortcut: Linux supported alone
 case "$host" in
 *-*-linux* | *-*-uclinux*) ;;


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
