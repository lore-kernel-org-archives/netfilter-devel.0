From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] better handling for TCP out-of-sync tracking
Date: Sat, 14 Nov 2009 12:09:41 +0100
Message-ID: <20091114110651.7461.84924.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZKNLJe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:09:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here it follows a patch that I've been using in my testbed for
some time to improve the recovery of out-of-sync TCP flows.

You can pull this patch from:
git://1984.lsi.us.es/nf-next-2.6 master

---

Pablo Neira Ayuso (1):
      netfilter: conntrack: improve out-of-sync situation in TCP tracking


 include/linux/netfilter/nf_conntrack_tcp.h |    3 ++
 net/netfilter/nf_conntrack_proto_tcp.c     |   51 +++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 10 deletions(-)

