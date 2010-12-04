From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-4.5 released
Date: Sat, 4 Dec 2010 14:38:31 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012041435270.3210@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52783 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab0LDNid (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Dec 2010 08:38:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

ipset-4.5 has been released, with the following fixes:

userspace:
    - Take into account the compile time setting of the default hash size
      (reported by Dash Four)
kernel:
    - The iptreemap type used wrong gfp flags when deleting entries
      (bug reported by Dash Four)

You can download the new version from the usual places:
        http://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
