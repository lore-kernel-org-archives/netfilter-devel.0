From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.4 released
Date: Tue, 19 Apr 2011 13:42:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104191335440.11453@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:47983 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1DSLmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:42:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.4. The list of changes are:

Kernel part changes:
 - Support listing just setnames and headers
 - Fix the order of listing of sets
 - Options and flags support added to the kernel API

Userspace changes:
 - Get rid of the trailing empty line at listing sets
 - Fix XML listing, remove broken unused "elements" tag
 - Support listing just setnames and headers
 - Sorting is dependent on the locale settings, use LC_ALL=C
 - Use unified diff output in tests

With the options and flags support in the kernel, ipset 6.4 supports 
specifying and/or resetting the timeout value of entries by the SET 
target. However it needs the updated SET target too, which is 
available in iptables from git.

You can download the source code of ipset from:
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
