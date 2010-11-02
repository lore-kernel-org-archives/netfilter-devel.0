From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 0/9] ipset-5 patches
Date: Tue,  2 Nov 2010 15:35:25 +0100
Message-ID: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33593 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 11D131F4141
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T+AUBqPd9GXw for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:34 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id EA0681F4131
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:34 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit

Hi,

I have just added the new v5.0-pre10 tag to the ipset-5 branch
in git, toward the final ipset 5 release. The patches cover one
important fix for listing sets, performance improvement (with
paying the price in restricting hash type resizing) and cleanups.

Best regards,
Jozsef

Jozsef Kadlecsik (9):
  Kernel compile-time files are added to .gitignore
  Listing for hash types fixed
  Test to list large hash sets added.
  Fix gfp_flags at resizing
  Remove to support resizing from kernel context.
  Resizing converted to run under read-locking of the set
  Add parser function to handle IPv4 and IPv6 differently.
  Enforce handling IPv4 and IPv6 differently for hash:ip type.
  Manpage and help text fixes.

 .gitignore                                    |    9 +
 include/libipset/parse.h                      |    2 +
 kernel/include/linux/netfilter/ip_set_chash.h |  206 +++--
 kernel/ip_set.c                               |    9 +-
 kernel/ip_set_hash_ip.c                       |   16 +-
 kernel/ip_set_hash_ipport.c                   |   15 +-
 kernel/ip_set_hash_ipportip.c                 |   15 +-
 kernel/ip_set_hash_ipportnet.c                |   15 +-
 kernel/ip_set_hash_net.c                      |   15 +-
 kernel/ip_set_hash_netport.c                  |   15 +-
 lib/parse.c                                   |   40 +
 src/ipset.8                                   |  145 +++-
 src/ipset_hash_ip.c                           |    5 +-
 tests/iphash.t                                |    8 +
 tests/iphash.t.large                          | 1057 +++++++++++++++++++++++++
 15 files changed, 1404 insertions(+), 168 deletions(-)
 create mode 100644 tests/iphash.t.large

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--------------1.7.0.4--
