From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.13 released
Date: Fri, 29 Jun 2012 22:04:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37682 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2F2UET (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:04:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have just released ipset 6.13 with a few bugfixes and some new features.

Userspace changes:
 - Explain in more detail src/dst for hash:net,iface
 - ipset help lists set types multiple times, fixed 
   (reported by Mr Dash Four)
 - The commandline parser was too permissive, make it more strict
 - Allow saving to/restoring from a file without shell redirection
 - Fix typo of word "unkown" to "unknown" (Neutron Soutmun)

Kernel part changes:
 - ipset: Handle properly an IPSET_CMD_NONE (Tomasz Bursztyka)
 - netfilter: ipset: hash:net,iface: fix interface comparison (Florian
   Westphal)
 - Timeout fixing bug broke SET target special timeout value, fixed
 - Use MSEC_PER_SEC instead of harcoded value

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
