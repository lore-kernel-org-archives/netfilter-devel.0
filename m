From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.23 released
Date: Tue, 23 Sep 2014 13:34:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409231328160.30582@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50455 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaIWLdt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:33:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here comes the new version of ipset with small bugfixes, corrections
and manpage updates. The package contains the updated bash utilities as 
well:

Userspace changes:
  - The utils are updated from their sources
  - Order create and add options in manpage so that generic ones
    come first
  - Centralise generic create options (family, hashsize, maxelem)
    on top of man page in the generic options section. (Mart Frauenlob)
  - Support glibc < 2.9 (fixes bugzilla id #891)
  - Add description of hash:mac set type to man page. (Mart Frauenlob)
  - Add missing space for skbinfo option synopsis. (Mart Frauenlob)
  - The library/API versions were forgotten to bump (reported by
    Sergei Zhirikov)
  - Retry printing when sprintf fails (reported by Stig Thormodsrud)

Kernel part changes:
  - Support updating extensions when the set is full
    (fixes bugzilla id #880)

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
