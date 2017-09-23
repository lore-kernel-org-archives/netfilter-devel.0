From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [HEADS UP] ipset git tree is rebased
Date: Sat, 23 Sep 2017 13:56:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709231351140.10223@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44580 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdIWL4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2017 07:56:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6CB7167400ED
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2017 13:56:09 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 62RLWX58eZpe for <netfilter-devel@vger.kernel.org>;
        Sat, 23 Sep 2017 13:56:07 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 74C2867400BB
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2017 13:56:07 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I messed up and created duplicates in the public ipset git repo:

942de32 Merge branch 'master' of git.netfilter.org:ipset
a029bc6 Reset state after a command failed, when multiple ones are issued.
2a98659 Handle padding attribute properly in userspace.
5128db6 Add test file missing from patch previous patch.
dc1c8aa Test to check the fix to add an IPv4 range containing more than 2^31 addresses
d242f8b Fix adding an IPv4 range containing more than 2^31 addresses
b36834c Fix the include guards on the include/libipset/linux_ip_set*.h
7b500b2 Test to check the fix to add an IPv4 range containing more than 2^31 addresses
ae810f5 Fix adding an IPv4 range containing more than 2^31 addresses

In order to cleanup the duplicates, the repository had to be rebased. 
Sorry for the inconvenience!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
