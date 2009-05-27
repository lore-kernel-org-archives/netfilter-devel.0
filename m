From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] A couple of netfilter fixes
Date: Wed, 27 May 2009 14:53:35 +0200
Message-ID: <20090527125242.11366.70215.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51199 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759153AbZE0NgN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 09:36:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Are we in time to put these patches into 2.6.30-rc?

---

Pablo Neira Ayuso (2):
      netfilter: conntrack: add support for DCCP handshake sequence to ctnetlink
      netfilter: nfnetlink_log: fix wrong skbuff size calculation


 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_proto_dccp.c       |    7 +++++++
 net/netfilter/nfnetlink_log.c                 |    6 ++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

