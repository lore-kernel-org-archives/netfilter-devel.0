From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 4.1 released
Date: Wed, 11 Nov 2009 20:35:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911112030200.25564@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:44580 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662AbZKKTfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:35:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

A minor fix and little improvement, but it worths a new release :-):

Kernel part changes:
  - Do not use init_MUTEX either (Jan Engelhardt)
  - Improve listing/saving hash type of sets by not copying empty
    entries unnecessarily to userspace.

Userspace changes:
  - Manpage fixes and corrections (Jan Engelhardt)

As usual, the source code can be download from

        http://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
