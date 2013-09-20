From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 0/2] Add new hash:net,net type to ipset.
Date: Fri, 20 Sep 2013 10:13:52 +0200
Message-ID: <1379664834-41326-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:44979 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3ITIPH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:15:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id C678BA3418
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:15:02 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id xo2aWXMIhv-v for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:13:55 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This is a re-roll of the previous patch, with the requested changes
incorporated. For those of you just joining us; it provides a new ipset type
that allows you to match on two separate subnets.

Signed-off-by: Oliver Smith <<oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Oliver Smith (2):
  netfilter: ipset: Add hash:net,net module to kernel.
  ipset: Add userspace code to support hash:net,net kernel module.

 kernel/net/netfilter/ipset/Kbuild               |   1 +
 kernel/net/netfilter/ipset/Kconfig              |   9 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  58 ++-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 482 ++++++++++++++++++++++++
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
 tests/resizen.sh                                |  14 +
 tests/resizet.sh                                |   8 +
 tests/runtest.sh                                |   2 +-
 18 files changed, 1180 insertions(+), 10 deletions(-)
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

