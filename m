From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.18 released
Date: Sun, 14 Apr 2013 20:40:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304142033480.7793@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50793 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3DNSkc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:40:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The new ipset version is a bugfix release and three kernel part bugs are 
fixed in it. The most important is the hash:*net* patch: if such a set is 
resized and there are elements in the set with the "nomatch" flag, then 
those elements are not matched properly after the resize.

Kernel part changes:
  - bitmap:ip,mac: fix listing with timeout (reported by Yoann JUET)
  - hash:*net*: nomatch flag not excluded on set resize
  - list:set: update reference counter when last element pushed off

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
