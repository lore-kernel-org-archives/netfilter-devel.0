From: <remoteshaman.com@gmail.com>
Subject: [xtables-addons-1.47.1] compilation failed - compat_xtables.c:633: error: too few arguments to function ipv6_find_hdr
Date: Tue, 24 Dec 2013 07:35:47 +0200
Message-ID: <41F4D5ABA9054FE4A2A4ED721C046297@torbaf407ff5ef>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35382 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3LXFf5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Dec 2013 00:35:57 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so2708843ead.10
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Dec 2013 21:35:56 -0800 (PST)
Received: from torbaf407ff5ef ([195.5.1.100])
        by mx.google.com with ESMTPSA id e43sm51715736eep.7.2013.12.23.21.35.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 23 Dec 2013 21:35:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

compilation failed in CentOS: 2.6.32-431.1.2.0.1.el6.x86_64 - 
compat_xtables.c:633: error: too few arguments to function ipv6_find_hdr
```
# ./configure
# make
make  all-recursive
make[1]: Entering directory `/usr/local/src/xtables-addons-1.47.1'
Making all in extensions
make[2]: Entering directory
`/usr/local/src/xtables-addons-1.47.1/extensions'
Xtables-addons 1.47.1 - Linux 2.6.32-431.1.2.0.1.el6.x86_64
if [ -n "/lib/modules/2.6.32-431.1.2.0.1.el6.x86_64/build" ]; then make -C
/lib/
modules/2.6.32-431.1.2.0.1.el6.x86_64/build
M=/usr/local/src/xtables-addons-1.47
.1/extensions modules; fi;
make[3]: Entering directory `/usr/src/kernels/2.6.32-431.1.2.0.1.el6.x86_64'
  CC [M]  /usr/local/src/xtables-addons-1.47.1/extensions/compat_xtables.o
/usr/local/src/xtables-addons-1.47.1/extensions/compat_xtables.c: In
function 'x
tnu_ipv6_find_hdr':
/usr/local/src/xtables-addons-1.47.1/extensions/compat_xtables.c:633: error:
too
 few arguments to function 'ipv6_find_hdr'
make[4]: ***
[/usr/local/src/xtables-addons-1.47.1/extensions/compat_xtables.o]
Error 1
make[3]: *** [_module_/usr/local/src/xtables-addons-1.47.1/extensions] Error
2
make[3]: Leaving directory `/usr/src/kernels/2.6.32-431.1.2.0.1.el6.x86_64'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/usr/local/src/xtables-addons-1.47.1/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/usr/local/src/xtables-addons-1.47.1'
make: *** [all] Error 2
```
# diff /usr/src/kernels/2.6.32-358.23.2.el6.x86_64/include/li
nux/netfilter_ipv6/ip6_tables.h
/usr/src/kernels/2.6.32-431.1.2.0.1.el6.x86_64/i
nclude/linux/netfilter_ipv6/ip6_tables.h
320,322d319
< /* find specified header and get offset to it */
< extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
<                        int target, unsigned short *fragoff);
```
[PATCH] netfilter: move ipv6_find_hdr to net/ipv6/netfilter.c and rename it 
www.spinics.net/lists/netfilter-devel/msg24187.html

how to compile xtables-addons-1.47.1?;(

Thanks!

