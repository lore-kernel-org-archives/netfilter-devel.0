From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v3] Add hash:net,net ipset for storage of v4/v6 CIDR pairs.
Date: Mon,  2 Sep 2013 04:37:46 +0200
Message-ID: <1378089467-1576-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55999 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3IBCiU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:38:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 8B201A2CE0
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 03:38:12 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id CAkrN3y3g3NM for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 03:37:47 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Re-rolled due to omission in mtype_del() - ip_set_hash_gen.h of the mtype_del_cidr2()
operation that needs to occur when deleting an entry which would of course break the
CIDR tracking.

Oliver Smith (1):
  Add hash:net,net ipset for storage of v4/v6 CIDR pairs.

 kernel/net/netfilter/ipset/Kbuild               |   1 +
 kernel/net/netfilter/ipset/Kconfig              |   9 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  94 +++++
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 531 ++++++++++++++++++++++++
 lib/Makefile.am                                 |   1 +
 lib/ipset_hash_netnet.c                         | 158 +++++++
 src/ipset.8                                     |  74 ++++
 tests/hash:net,net.t                            | 155 +++++++
 tests/hash:net,net.t.list0                      |  10 +
 tests/hash:net,net.t.list1                      |   6 +
 tests/hash:net,net.t.list2                      |  22 +
 tests/hash:net6,net6.t                          | 139 +++++++
 tests/hash:net6,net6.t.list0                    |  10 +
 tests/hash:net6,net6.t.list1                    |   6 +
 tests/netnetgen.sh                              |   9 +
 tests/resizen.sh                                |  13 +
 tests/resizet.sh                                |   8 +
 tests/runtest.sh                                |   2 +-
 18 files changed, 1247 insertions(+), 1 deletion(-)
 create mode 100644 kernel/net/netfilter/ipset/ip_set_hash_netnet.c
 create mode 100644 lib/ipset_hash_netnet.c
 create mode 100644 tests/hash:net,net.t
 create mode 100644 tests/hash:net,net.t.list0
 create mode 100644 tests/hash:net,net.t.list1
 create mode 100644 tests/hash:net,net.t.list2
 create mode 100644 tests/hash:net6,net6.t
 create mode 100644 tests/hash:net6,net6.t.list0
 create mode 100644 tests/hash:net6,net6.t.list1
 create mode 100755 tests/netnetgen.sh

-- 
1.8.3.2

