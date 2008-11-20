From: John Haxby <john.haxby@oracle.com>
Subject: Re: xtables problem
Date: Thu, 20 Nov 2008 15:30:59 +0000
Message-ID: <492582B3.4000001@oracle.com>
References: <49244C11.6080808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:57316 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbYKTPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:31:09 -0500
In-Reply-To: <49244C11.6080808@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
>
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

You can go off a distro, you really can:

* Mon Feb 11 2008 Thomas Woerner <twoerner@redhat.com> 1.4.0-1
- new version 1.4.0
- fixed condrestart (rhbz#428148)
- report the module in rmmod_r if there is an error
- use nf_ext_init instead of my_init for extension constructors


The description is possibly a little wrong because the upshot is that in 
<xtables.h> "_INIT" and the subsequent definition of "_init" are 
replaced with "NF_EXT_INIT" and "nf_ext_init" respectively.  Neither 
Google nor Red Hat's bugzilla offer any readily findable explanation of 
this all I found was quite a few copies of the same comment in various 
different RPMs.

The only thing that springs to mind is that variables and C-preprocessor 
names whose names begin with "_" are reserved by C and you shouldn't use 
them.

If Thomas is listening, can you shed any light?

Would it not be nice, as well, if iptables and xtables could come to an 
agreement over what is the right thing to do.  I'm surely not the first 
person to come unstuck with this. 

Right, back to building an RPM from this thing.

jch
