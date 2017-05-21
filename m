From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 0/3] netfilter: handle hash resize situation in nf_ct_iterate_cleanup
Date: Sun, 21 May 2017 13:39:06 +0800
Message-ID: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:51136 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdEUFjs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 01:39:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

First, when we do nf ct cleanup, we should also handle the hash resize
situation, so we will not miss the related conntracks, this is important
for module removal.

After we accomplish this, we can use nf_ct_iterate_cleanup to remove these
copy & paste codes, which are used to unlink cthelper objects and
cttimeout objects.

Liping Zhang (3):
  netfilter: restart nf ct cleanup if hash resize happen
  netfilter: nf_ct_helper: use nf_ct_iterate_cleanup to unlink helper
    objs
  netfilter: cttimeout: use nf_ct_iterate_cleanup to unlink timeout objs

 net/netfilter/nf_conntrack_core.c   | 35 ++++++++++++++++++----------
 net/netfilter/nf_conntrack_helper.c | 46 ++++---------------------------------
 net/netfilter/nfnetlink_cttimeout.c | 39 ++++---------------------------
 3 files changed, 32 insertions(+), 88 deletions(-)

-- 
2.5.5


