From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCEMENT] ipset-3.1
Date: Tue, 18 Aug 2009 20:54:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908182049460.3452@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:38925 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZHRSyN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:54:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm happy to announce ipset release 3.1. A few minor bugs were fixed and 
some cleanups added:

- Nonexistent sets were reported as existing sets when testing
  from userspace in setlist type of sets (bug reported by Victor A.
  Safronov)
- When saving sets, setlist type of sets must come last in order
  to satisfy the dependency from the elements (bug reported by Marty B.)
- Sparse insists that the flags argument to kmalloc() is gfp_t
  (Stephen Hemminger)
- Correct format specifiers and change %i to %d (Jan Engelhardt)
- Fix the definition of 'bool' for kernels <= 2.6.18 (Jan Engelhardt)

As usual, you can download it from http://ipset.netfilter.org or from 
git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
