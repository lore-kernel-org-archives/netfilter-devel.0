From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] netfilter updates for nf_ct_tcp
Date: Wed, 02 Feb 2011 15:03:07 +0100
Message-ID: <20110202140007.12173.41157.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56782 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1BBODM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:03:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This patchset contain a couple of updates for the TCP tracking
and the TCP flow pickup facility.

The first patch changes the current behaviour that allows to
pickup a flow from the middle if we see an ACK packet by default.
The second patch adds the TCP protocol information in events for
flows that have been picked up from the middle.

I think that these can also be qualified as bugfix, please apply
them to nf-2.6 (2.6.38-rc).

CC'ing Jozsef to ask for his ACK.

Thanks!

---

Pablo Neira Ayuso (2):
      netfilter: nf_ct_tcp: disable pick by default for first ACK packet seen
      netfilter: nf_ct_tcp: fix missing TCP protocol information during pickup


 net/netfilter/nf_conntrack_proto_tcp.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

-- 
1+1=2
