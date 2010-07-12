From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] A couple of netfilter fixes
Date: Mon, 12 Jul 2010 18:59:28 +0200
Message-ID: <20100712165241.4026.83949.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41120 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab0GLQ7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:59:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

You can find two patches here. The former fixes flow recovery with
TCP window tracking enabled, it's been tested with the current snapshot
of conntrackd and the libnetfilter_* libraries. The latter defines
aligned_be64 to allow to compile user-space Netlink code without
adding an ad-hoc definition of that type.

Let me know if you consider that they can be qualified as fixes for
the -stable branch.

Thanks!

---

Pablo Neira Ayuso (2):
      netfilter: nf_ct_tcp: fix flow recovery with TCP window tracking enabled
      netfilter: nfnetlink_queue: add definition of aligned_be64 for user-space apps


 include/linux/netfilter/nfnetlink_queue.h |    6 ++++++
 net/netfilter/nf_conntrack_proto_tcp.c    |   10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

--
Under the asphalt, there's the orchard!
