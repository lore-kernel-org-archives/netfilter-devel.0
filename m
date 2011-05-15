From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.5 released
Date: Sun, 15 May 2011 15:50:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105151540340.25248@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37117 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1EONu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 May 2011 09:50:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.5. The list of changes are:

Kernel part changes:
 - Support range for IPv4 at adding/deleting elements for hash:*net* types
 - Set type support with multiple revisions added
 - Fix adding ranges to hash types

Userspace changes:
 - Support range for IPv4 at adding/deleting elements for hash:*net* types
 - Disable type revisions which are not supported both by the kernel and
   ipset
 - Update ipset help text to reflect SCTP and UDPLITE support
 - Ignore -n flag (list just setnames) when sets are to be saved

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
