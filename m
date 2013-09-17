From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 0/2] Add new hash:net,net type to ipset.
Date: Tue, 17 Sep 2013 14:26:56 +0200
Message-ID: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60393 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3IQMeY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:34:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 8D66AA3232
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 13:28:01 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id WmSKvSci3yTX for <netfilter-devel@vger.kernel.org>;
	Tue, 17 Sep 2013 13:26:59 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This is a do-over of my previous patch to be compatible with the new changes to
the ipset codebase. Currently the changes to ip_set_hash_gen.h are part of the
kernel-code commit, if you'd prefer that to be split out into its own commit as
a preparatory operation, let me know.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Oliver Smith (2):
  netfilter: ipset: Add hash:net,net module to kernel.
  ipset: Add userspace code to support hash:net,net kernel module.

 kernel/net/netfilter/ipset/Kbuild               |   1 +
 kernel/net/netfilter/ipset/Kconfig              |   9 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  56 +++
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 473 ++++++++++++++++++++++++
 lib/Makefile.am                                 |   1 +
 lib/ipset_hash_netnet.c                         | 158 ++++++++
 src/ipset.8                                     |  74 ++++
 tests/hash:net,net.t                            | 169 +++++++++
 tests/hash:net,net.t.list0                      |  10 +
 tests/hash:net,net.t.list1                      |   6 +
 tests/hash:net,net.t.list2                      |  22 ++
 tests/hash:net6,net6.t                          | 151 ++++++++
 tests/hash:net6,net6.t.list0                    |  10 +
 tests/hash:net6,net6.t.list1                    |   6 +
 tests/netnetgen.sh                              |   9 +
 tests/resizen.sh                                |  13 +
 tests/resizet.sh                                |   8 +
 tests/runtest.sh                                |   2 +-
 18 files changed, 1177 insertions(+), 1 deletion(-)
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

