From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.31 released
Date: Sun, 19 Feb 2017 19:29:41 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1702191924300.22013@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:45188 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdBSS3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 13:29:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

ipset 6.31 has just been released with two important bugfixes. So please 
upgrade your ipset package.

Userspace changes:
  - Update manpage about the size parameter of list:set types.
  - New test to verify that only the intended entries are deleted at hash
    types.
Kernel part changes:
  - netfilter: ipset: Null pointer exception in ipset list:set
    (Vishwanath Pai)
    When someone wants to add an entry to an empty list type of set and 
    specifies and add before/after option, null pointer exception is 
    triggered.
  - Fix bug: sometimes valid entries in hash:* types of sets were evicted
    (reported by Eric Ewanco)
    The wrong evictions happen when entries are deleted from the set and 
    the hash bucket is shrinked.
  - Correct copyright owner
  - Revert patch "Correct rcu_dereference_bh_nfnl() usage"

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
