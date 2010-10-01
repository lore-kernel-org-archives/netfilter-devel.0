From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-4.4 released
Date: Fri, 1 Oct 2010 23:02:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1010012214250.19669@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60974 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0JAVCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:02:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

ipset-4.4 has just been released with one important fix and some small 
corrections:

Kernel part changes:
  - The ipporthash, ipportiphash and ipportnethash set types did 
    not work with mixed "src" and "dst" direction parameters of the "set" 
    and  "SET" iptables match and target (reported by Dash Four)
  - Errorneous semaphore handling in error path fixed (reported by 
    Jan Engelhardt, bugzilla id 668) 

Userspace changes:
   - Manpage fix to make it clear how ipset works on setlist type 
     of sets (John Brendler, bugzilla id 640) 

Please note, if you use ipporthash, ipportiphash or ipportnethash type of 
sets with mixed direction parameters of the "set" and "SET" iptables match 
and target, then you must upgrade.

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
