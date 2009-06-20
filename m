From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Needs to fix in userspace
Date: Sun, 21 Jun 2009 00:20:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210018560.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60711 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbZFTWUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:20:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 9C63588175
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:20:39 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DzSp-I6rX+1U for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:20:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id 8600188170
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:20:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While working on netfilter/iptables in parallel, I discovered a couple of 
elements which are missing from userspace, compared to the recent kernel:

- libxt_LED and libxt_osf are missing: the kernel supports the LED
  target and the osf match, but the userspace doesn't
- libxt_NFQUEUE and libxt_socket: the kernel parts support revision 0
  and 1 while the userspace support only revision 0
- libxt_realm is missing: the kernel supports both IPv4/IPv6, in
  userspace we have got libipt_realm only
- libxt_tcpudp: as far as I see, udplite support is missing

I think we should remove libipt_unclean and libipt_MIRROR. What about 
libipt_SAME?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
