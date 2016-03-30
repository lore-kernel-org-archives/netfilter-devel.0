From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] netfilter TCP conntrack option parser fix
Date: Wed, 30 Mar 2016 11:34:34 +0200
Message-ID: <1459330475-2220-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44828 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbcC3Jdn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Mar 2016 05:33:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next patch for the stable branches. It fixes
a one byte read after the buffer issue discovered by Baozeng Ding.

The following changes since commit 29421198c3a860092e27c2ad8499dfe603398817:

  netfilter: ipv4: fix NULL dereference (2016-03-28 17:59:29 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to becfb96a8663e3884d78c23ab747df3fe4e1e50d:

  net: netfilter: Fix stack out of bounds when parsing TCP options (2016-03-29 11:44:13 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      net: netfilter: Fix stack out of bounds when parsing TCP options

 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)
