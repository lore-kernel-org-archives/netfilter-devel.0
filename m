From: Pete Kay <petedao@gmail.com>
Subject: need help with iptables and iptc
Date: Thu, 24 Jun 2010 00:49:41 +0800
Message-ID: <AANLkTillANcPYzAJiyaisqeoIpNxclSEqHUIIg3UvnRd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49556 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0FWQtn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:49:43 -0400
Received: by pvg2 with SMTP id 2so1797pvg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2010 09:49:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I hope this is the right place to post.  I asked a few times in the
user list but I thought maybe netfilter-devel is the one I should post
on instead.

I am trying to get my test program adopted from the how-to (
http://www.faqs.org/docs/Linux-HOWTO/Querying-libiptc-HOWTO.html#HOWTOP=
RG)
to compile.

This is a very basic iptc sample program.  Does anyone know why I
can't get the gcc to work?  Any suggestion will be greatly
appreciated.

[root@test utils]# iptables --version
iptables v1.4.7
[root@test utils]# uname -a
Linux test 2.6.33.1-24.fc13.x86_64 #1 SMP Tue Mar 30 18:21:22 UTC 2010
x86_64 x86_64 x86_64 GNU/Linux
[root@test utils]# gcc -Wall -Wunused  -I/usr/include
-DNETFILTER_VERSION=3D\"1.4.7\"  -L/usr/lib64 -lip4tc -liptc  -o
test_iptc test_iptc.c  -ldl
test_iptc.c: In function =91main=92:
test_iptc.c:19: error: =91iptc_handle=92 undeclared (first use in this =
function)
test_iptc.c:19: error: (Each undeclared identifier is reported only onc=
e
test_iptc.c:19: error: for each function it appears in.)
test_iptc.c:19: error: expected =91;=92 before =91h=92
test_iptc.c:26: error: =91h=92 undeclared (first use in this function)
[root@test utils]# iptables --version
iptables v1.4.7

# ls /lib64/libip
libip4tc.so        libip4tc.so.0.0.0  libip6tc.so.0      libipq.so
     libipq.so.0.0.0    libiptc.so.0
libip4tc.so.0      libip6tc.so        libip6tc.so.0.0.0  libipq.so.0
     libiptc.so         libiptc.so.0.0.0


Thanks,
P
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
