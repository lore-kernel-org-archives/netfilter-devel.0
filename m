From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 4.0 released
Date: Tue, 10 Nov 2009 22:15:58 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911102208000.23130@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce the new ipset release which fixes kernel version 
compatibility and alignment issues:

Userspace changes:
  - New protocol is introduced to handle aligment issues properly
    (bug reported by Georg Chini)
  - Binding support is removed

Kernel part changes:
  - Compilation of ip_set_iptree.c fails with kernel 2.6.20 due to
    missing include of linux/jiffies.h (Jan Engelhardt)
  - Do not use DECLARE_MUTEX (compatibility fix on 2.6.31-rt, Jan
    Engelhardt)
  - Flushing iptreemap type of sets caused high ksoftirqd load due to
    zeroed out gc parameter (bug reported by Georg Chini)
  - New protocol is introduced to handle aligment issues properly
    (bug reported by Georg Chini)
  - Binding support is removed

Except the removed binding support, the new release contains backward 
compatibility support both in userspace (i.e. ipset 4.0 work with kernel 
modules from the 3.x releases) and in kernel space (similarly, kernel 
modules from 4.0 work with ipset binaries from the 3.x releases).

As usual, the source can be download from

	http://ipset.netfilter.org
	git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
