From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 19:12:04 +0700
Message-ID: <CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>
	<alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr>
	<alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>
	<alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>
	<alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61307 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2EJMMF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 08:12:05 -0400
In-Reply-To: <alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, May 10, 2012 at 6:41 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Thu, 10 May 2012, Jan Engelhardt wrote:
>
>> On Thursday 2012-05-10 13:17, Jozsef Kadlecsik wrote:
>>
>> >On Thu, 10 May 2012, Jan Engelhardt wrote:
>> >
>> >> On Thursday 2012-05-10 12:18, Jozsef Kadlecsik wrote:
>> >>
>> >> >I'm happy to announce ipset 6.12. This release contains a few im=
portant
>> >> >bugfixes, dynamic module support in the ipset tool by Neutron So=
utmun
>> >> >and several backports and compatibility fixes.
>> >>
>> >> There is no configure script in the current 6.12 tarball,
>> >> i.e. autogen has not been run before packing up.
>> >
>> >I have updated the tarball at the webpage, thanks for notifying.
>>
>> It does not really build either. The new module split at fault?
>>
>> seven:~/rpmbuild/BUILD/ipset-default-6.12> make
>> make =A0all-recursive
>> make[1]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-defau=
lt-6.12'
>> Making all in include/libipset
>> make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-defau=
lt-6.12/include/libipset'
>> make[2]: Nothing to be done for `all'.
>> make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-defaul=
t-6.12/include/libipset'
>> Making all in lib
>> make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-defau=
lt-6.12/lib'
>> depbase=3D`echo ipset_bitmap_ip.lo | sed 's|[^/]*$|.deps/&|;s|\.lo$|=
|'`; \
>> /bin/sh ../libtool --tag=3DCC =A0 --mode=3Dcompile gcc -DHAVE_CONFIG=
_H -I. -I.. =A0 =A0-I../include -I/usr/local/include =A0-std=3Dgnu99 =A0=
-O2 -DNDEBUG -I/usr/include/libmnl-1.0.2 =A0 =A0-g -O2 -D_INIT=3Dipset_=
bitmap_ip_init \
>> =A0 =A0-DTYPE_INCLUSIVE\
>> =A0 -MT ipset_bitmap_ip.lo -MD -MP -MF $depbase.Tpo -c -o ipset_bitm=
ap_ip.lo ipset_bitmap_ip.c && \
>> mv -f $depbase.Tpo $depbase.Plo
>> libtool: compile: =A0gcc -DHAVE_CONFIG_H -I. -I.. -I../include -I/us=
r/local/include -std=3Dgnu99 -O2 -DNDEBUG -I/usr/include/libmnl-1.0.2 -=
g -O2 -D_INIT=3Dipset_bitmap_ip_init -DTYPE_INCLUSIVE -MT ipset_bitmap_=
ip.lo -MD -MP -MF .deps/ipset_bitmap_ip.Tpo -c ipset_bitmap_ip.c =A0-fP=
IC -DPIC -o .libs/ipset_bitmap_ip.o
>> ipset_bitmap_ip.c:103:1: fatal error: opening dependency file .deps/=
ipset_bitmap_ip.Tpo: No such file or directory
>> compilation terminated.
>> make[2]: *** [ipset_bitmap_ip.lo] Error 1
>> make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-defaul=
t-6.12/lib'
>> make[1]: *** [all-recursive] Error 1
>> make[1]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-defaul=
t-6.12'
>> make: *** [all] Error 2
>>
>> Seems the split plugins was only ever tested while .deps existed
>> from prior the split.
>
> Yes, your're right. I applied the patch, tested it but not with a cle=
an
> tree. I'm not so good in autoconf/automake/... What would be the best
> fix to generate the dependencies?

I found this when I was preparing the debian package for my patch
testing on Monday which the debhelper calls the configure script with
the --disable-dependency-tracking by default. Hence, I just parse the
--enable-dependency-tracking to workaround this.

However, I'll find the solution for the build system when the
--disable-dependency-tracking is being parse.

Any suggestions are welcome.

Best regards,
Neutron Soutmun
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
