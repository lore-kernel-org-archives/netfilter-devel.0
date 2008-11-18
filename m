From: John Haxby <john.haxby@oracle.com>
Subject: Re: Problem compiling
Date: Tue, 18 Nov 2008 18:14:05 +0000
Message-ID: <492305ED.8010207@oracle.com>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr> <4921F222.7020809@oracle.com> <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:42227 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYKRSOV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:14:21 -0500
In-Reply-To: <alpine.LNX.1.10.0811172342170.17946@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>
> Blame the Fedora packager for that.
> libiptc.h is installed with the raw iptables tarball since 1.4.0+git61.
>   

I'd love to, but:

$ tar xf iptables-1.4.1.1.tar.bz2
$ cd iptables-1.4.1.1
$ ./configure --preifx=/var/tmp/iptables-test --enable-devel --enable-libipq
(the --enable's are just in case)
$ make
$ make install
$ find /var/tmp/iptables-test -name '*.h'
/var/tmp/iptables-test/include/xtables.h
/var/tmp/iptables-test/include/libipq.h
/var/tmp/iptables-test/include/ip6tables.h
/var/tmp/iptables-test/include/libiptc/ipt_kernel_headers.h
/var/tmp/iptables-test/include/libiptc/libxtc.h
/var/tmp/iptables-test/include/iptables.h

The same thing with iptables-1.4.2 gives these header files:

/var/tmp/iptables-test/include/xtables.h
/var/tmp/iptables-test/include/libipq.h

Clearly I'm doing something wrong.   Could you enlighten me?

jch
