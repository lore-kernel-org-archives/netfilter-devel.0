From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-5.0 released
Date: Fri, 17 Dec 2010 23:26:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:48846 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab0LQW0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:26:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce the new branch of ipset and release it's first 
element, ipset-5.0.

Just the most important improvements and changes compared to the 4.x tree:

- The hash types support both IPv4 and IPv6.
- The limitation that the elements of the ipporthash, ipportiphash and 
  ipportnethash types had to come from a max /16 netblock is removed.
- The limitation that the ipporthash and ipportnethash types could
  not store host IP addresses is removed.
- The hash set types with port sub-element are extended and the protocol
  of the port is also stored. Now you can store in a single set
  IP(v4/v6) IP address and TCP or UDP port number pairs, or even IP 
  address and ICMP(v4/v6) type/code pairs, etc.
- All set types in the 5.0 branch supports timeouts.
- Addition or deletion of multiple elements (where applicable)
  in one step is supported.
- Netlink based kernel-userspace communication protocol.
- Faster hashing method behind the hash types, which at the same time
  uses less memory.
- New, improved syntax.
- Backward compatibility layer in syntax: old 4.x commands, saved
  sets are accepted.

Please note, due to the new protocol, the ipset 5.x utility cannot talk
to the kernel modules from ipset 4.x and similarly, the ipset 4.x utility
cannot communicate with the kernel part of ipset 5.x.
Read the README file in the source tree and the new manpage of ipset.

You can download the source code from:
	http://ipset.netfilter.org
	ftp://ftp.netfilter.org/pub/ipset/
	git://git.netfilter.org/ipset.git, ipset-5 branch

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
