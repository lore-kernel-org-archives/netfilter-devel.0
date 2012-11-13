From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] [RFC] Get MASQUERADE target to handle routing changes
Date: Tue, 13 Nov 2012 21:17:35 +0100
Message-ID: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41700 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab2KMURk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:17:40 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6BA821F40C5
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O7Qo-bSZNo6L for <netfilter-devel@vger.kernel.org>;
	Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 539061F40C2
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The MASQUERADE target does not handle the cases when the routing changes.
(See thread "UDP packets sent with wrong source address after routing change
[AV#3431]").

The first patch introduces a new in-kernel notification chain for the
routing changes.  The second one registers the MASQUERADE target to this
events and adds the new "--route-dependent" flag (actually, the value of the
flag) and conntrack flag to mark conntrack entries which may be affected by
routing changes.  As the first step, when routing changes, marked entries
are simply deleted.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  Introduce notification chain for routing changes
  Handle the routing changes in the MASQUERADE target

 include/linux/inetdevice.h                         |    2 +
 include/linux/netdevice.h                          |    1 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |    4 ++
 include/uapi/linux/netfilter/nf_nat.h              |    1 +
 net/ipv4/fib_trie.c                                |   18 +++++++++
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   40 ++++++++++++++++++++
 6 files changed, 66 insertions(+), 0 deletions(-)

