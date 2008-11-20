From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons problem
Date: Thu, 20 Nov 2008 17:36:14 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811201655430.7635@fbirervta.pbzchgretzou.qr>
References: <49244C11.6080808@oracle.com> <492582B3.4000001@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, twoerner@redhat.com
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41264 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYKTQgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:36:16 -0500
In-Reply-To: <492582B3.4000001@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-20 16:30, John Haxby wrote:

> John Haxby wrote:
>>
>> $ ./configure --with-kbuild=/lib/modules/2.6.27.6/build
>> $ make
>> ...
>>  CC       libxt_CHAOS.oo
>>  CCLD     libxt_CHAOS.so
>> libxt_CHAOS.oo: In function `_init':
>> /home/jch/rpmbuild/BUILD/xtables-addons-1.6/extensions/libxt_CHAOS.c:112:
>> multiple definition of `_init'
>> /usr/lib/gcc/x86_64-redhat-linux/4.3.0/../../../../lib64/crti.o:(.init+0x0):
>> first defined here
>> collect2: ld returned 1 exit status
>
> You can go off a distro, you really can:

(It took a while to get this... it's supposed to say)
	You can go off _on_ a distro, you really can.
Yes indeed.

> The only thing that springs to mind is that variables and 
> C-preprocessor names whose names begin with "_" are reserved by C and 
> you shouldn't use them.
>
> If Thomas is listening, can you shed any light?
>
> Would it not be nice, as well, if iptables and xtables could come to 
> an agreement over what is the right thing to do.

(a) the iptables userspace package uses _init

(b) xtables is a generic term for protocol-independent code/components

(c) xtables-addons's kernel parts are based on an unmodified kernel 
source.

(d) xtables-addons's userspace parts are based on an unmodified iptables 
source.

> * Mon Feb 11 2008 Thomas Woerner <twoerner@redhat.com> 1.4.0-1
> - new version 1.4.0
> - fixed condrestart (rhbz#428148)
> - report the module in rmmod_r if there is an error
> - use nf_ext_init instead of my_init for extension constructors

Not only did RedHat manage to blow up on (c) for RHEL5/CentOS because of 
excessive backporting, but now they also crippled their iptables 
package with that nf_ext_init, breaking ALL extensions out there.

I wonder how they managed to not break the compilation of the
extensions inside the iptables package -- because these continue to
use _init and its substitution was just nuked by that patch.
