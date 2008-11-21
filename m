From: John Haxby <john.haxby@oracle.com>
Subject: Re: xtables problem
Date: Fri, 21 Nov 2008 17:39:31 +0000
Message-ID: <4926F253.90802@oracle.com>
References: <49244C11.6080808@oracle.com> <492582B3.4000001@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:22600 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbYKURjl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:39:41 -0500
In-Reply-To: <492582B3.4000001@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> $ ./configure --with-kbuild=/lib/modules/2.6.27.6/build
> $ make
> ...
>  CC       libxt_CHAOS.oo
>  CCLD     libxt_CHAOS.so
> libxt_CHAOS.oo: In function `_init':
> /home/jch/rpmbuild/BUILD/xtables-addons-1.6/extensions/libxt_CHAOS.c:112: 
> multiple definition of `_init'
> /usr/lib/gcc/x86_64-redhat-linux/4.3.0/../../../../lib64/crti.o:(.init+0x0): 
> first defined here
> collect2: ld returned 1 exit status

I've submitted a bug report for this: 
https://bugzilla.redhat.com/show_bug.cgi?id=472548

Looking through this history of changes, it seems that this was a 
well-intentioned fix as part of moving from "ld -shared" to "gcc 
-shared" a while back (1.3.4 time) that accidentally got carried forward 
even though it wasn't needed due to changes in iptables.

jch
