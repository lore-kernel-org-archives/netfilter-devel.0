From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-6.1 released
Date: Sat, 19 Mar 2011 11:42:37 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1103191138070.18290@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60538 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1CSKmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:42:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.1 with the following changes compared to the 
previous version:

kernel part:
 - The hash:*port* types ignored the address range with non TCP/UDP, fixed
 - Fix checking the revision number of the set type at create command
 - SCTP, UDPLITE support to hash:*port* types added
 - Fix revision reporting got broken by the revision checking patch

userspace part:
 - Manpage was not installed (reported by Mark A. Ziesemer)
 - SCTP, UDPLITE support to the hash:*port* types added

I'll submit the SCTP, UDPLITE support for net-next-2.6 when the merge 
window will be over.

You can download the source code from:
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
