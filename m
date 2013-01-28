From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] netfilter: iptables alias support
Date: Mon, 28 Jan 2013 21:44:47 +0100
Message-ID: <1359405888-5090-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:55005 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3A1Uou (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:44:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The next patch just adds the new flags for the "CT" target and the "conntrack"
match to the kernel. Also, for a smooth alias support a new revision is required
for the CT target.

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  netfilter: Add flags and compatibility revision in order to support
    aliases.

 include/uapi/linux/netfilter/xt_CT.h        |    5 ++-
 include/uapi/linux/netfilter/xt_conntrack.h |    1 +
 net/netfilter/xt_CT.c                       |   75 +++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletions(-)

