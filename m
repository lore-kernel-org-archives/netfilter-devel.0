From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 2.4 released
Date: Mon, 20 Oct 2008 13:05:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55310 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYJTLFH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:05:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm happy to announce ipset 2.4. The new release contains some bugfixes, 
a compatibility fix for kernels >= 2.6.27 and three new set types:

- ipportiphash: you can store and match IP address, port number and
  IP address triples in it, where the first IP address must come from
  a /16 sized network or range.
- ipportnethash: you can store and match IP address, port number
  and network address triples in it, where the first IP address
  must come from a /16 sized network or range.
- setlist: other sets can be stored in a setlist type of set, it's like 
  an ordered union of sets.

Check out the manpage for the full description of the new set types.

The binding feature is scheduled for removal in the next ipset release: 
the functionality can be replaced by the new set types.

You can download the new version from the ipset homepage:

	http://ipset.netfilter.org/

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
