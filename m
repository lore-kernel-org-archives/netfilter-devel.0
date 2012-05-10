From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 13:41:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu> <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr> <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu> <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Neutron Soutmun <neo.neutron@gmail.com>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39078 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab2EJLlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 07:41:24 -0400
In-Reply-To: <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 10 May 2012, Jan Engelhardt wrote:

> On Thursday 2012-05-10 13:17, Jozsef Kadlecsik wrote:
> 
> >On Thu, 10 May 2012, Jan Engelhardt wrote:
> >
> >> On Thursday 2012-05-10 12:18, Jozsef Kadlecsik wrote:
> >> 
> >> >I'm happy to announce ipset 6.12. This release contains a few important 
> >> >bugfixes, dynamic module support in the ipset tool by Neutron Soutmun
> >> >and several backports and compatibility fixes.
> >> 
> >> There is no configure script in the current 6.12 tarball,
> >> i.e. autogen has not been run before packing up.
> >
> >I have updated the tarball at the webpage, thanks for notifying.
> 
> It does not really build either. The new module split at fault?
> 
> seven:~/rpmbuild/BUILD/ipset-default-6.12> make
> make  all-recursive
> make[1]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12'
> Making all in include/libipset
> make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/include/libipset'
> make[2]: Nothing to be done for `all'.
> make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/include/libipset'
> Making all in lib
> make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/lib'
> depbase=`echo ipset_bitmap_ip.lo | sed 's|[^/]*$|.deps/&|;s|\.lo$||'`; \
> /bin/sh ../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I..    -I../include -I/usr/local/include  -std=gnu99  -O2 -DNDEBUG -I/usr/include/libmnl-1.0.2    -g -O2 -D_INIT=ipset_bitmap_ip_init \
>    -DTYPE_INCLUSIVE\
>   -MT ipset_bitmap_ip.lo -MD -MP -MF $depbase.Tpo -c -o ipset_bitmap_ip.lo ipset_bitmap_ip.c && \
> mv -f $depbase.Tpo $depbase.Plo
> libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -I../include -I/usr/local/include -std=gnu99 -O2 -DNDEBUG -I/usr/include/libmnl-1.0.2 -g -O2 -D_INIT=ipset_bitmap_ip_init -DTYPE_INCLUSIVE -MT ipset_bitmap_ip.lo -MD -MP -MF .deps/ipset_bitmap_ip.Tpo -c ipset_bitmap_ip.c  -fPIC -DPIC -o .libs/ipset_bitmap_ip.o
> ipset_bitmap_ip.c:103:1: fatal error: opening dependency file .deps/ipset_bitmap_ip.Tpo: No such file or directory
> compilation terminated.
> make[2]: *** [ipset_bitmap_ip.lo] Error 1
> make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/lib'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12'
> make: *** [all] Error 2
> 
> Seems the split plugins was only ever tested while .deps existed
> from prior the split.

Yes, your're right. I applied the patch, tested it but not with a clean 
tree. I'm not so good in autoconf/automake/... What would be the best 
fix to generate the dependencies?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
