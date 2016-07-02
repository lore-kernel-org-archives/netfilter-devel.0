From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 0/3] netfilter: conntrack: fix race condition associated with hash resize
Date: Sat,  2 Jul 2016 18:59:24 +0800
Message-ID: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58572 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbcGBLAI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 07:00:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When user adjust the hash size via /sys/module/nf_conntrack/parameters/hashsize,
something will break because race condition happened.

This patch set aim to fix these bugs.

When we do "cat /proc/net/nf_conntrack", and at the same time do hash resize,
nf_conntrack_htable_size and nf_conntrack_hash may become unrelated if we
read them separately, so oops will happen. Fix this in patch #1.

When we do unlink help or timeout objects, and at the same time do hash resize,
we may miss unlinking some objects, later we will end up with invalid references.
Fix this in patch #2 and #3.

Liping Zhang (3):
  netfilter: conntrack: fix race between nf_conntrack proc read and hash
    resize
  netfilter: cttimeout: unlink timeout obj again when hash resize happen
  netfilter: nf_ct_helper: unlink helper again when hash resize happen

 include/net/netfilter/nf_conntrack_core.h            |  1 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c     | 20 ++++++++++++++++----
 net/netfilter/nf_conntrack_core.c                    |  4 +++-
 net/netfilter/nf_conntrack_helper.c                  | 14 ++++++++++++--
 net/netfilter/nf_conntrack_standalone.c              | 20 +++++++++++++++-----
 net/netfilter/nfnetlink_cttimeout.c                  | 14 ++++++++++++--
 6 files changed, 59 insertions(+), 14 deletions(-)

-- 
2.5.5


