From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.4.3 released
Date: Sat, 25 Oct 2008 15:10:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810251510350.30759@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:45494 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYJYNK4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Oct 2008 09:10:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 842C21F4435
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Oct 2008 15:10:54 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 27060-02 for <netfilter-devel@vger.kernel.org>;
	Sat, 25 Oct 2008 15:10:54 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6D1221F4434
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Oct 2008 15:10:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

The newest release of the week of ipset releases ;-) contains a small fix 
to compile ipset cleanly in all environments:

  - Include file <limits.h> was missing from userspace set type
    modules, reported by Krzysztof Oledzki and Sven Wegener.

You can download the source of ipset from the webpage or svn:

        http://ipset.netfilter.org/
        svn co https://svn.netfilter.org/netfilter/trunk/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
