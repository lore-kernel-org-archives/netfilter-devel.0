From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 0/4] netfilter: ctnetlink: fix some bugs related to ct update
Date: Mon, 17 Apr 2017 21:18:54 +0800
Message-ID: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:56529 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbdDQNTt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2017 09:19:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

This patch set aims to fix some bugs related to ctnetlink_change_conntrack.

First, we may invoke request_module with rcu_read_lock held, this is wrong,
as the request_module invocation may sleep. Fixed by PATCH #1.

Second, the unnecessary nf_conntrack_expect_lock will cause dead lock, which
was introduced by commit ca7433df3a67 ("netfilter: conntrack: seperate expect
locking from nf_conntrack_lock"). This is fixed by PATCH #2.

Third, Pablo pointed out that packets may be updating a conntrack at the
same time that we're mangling via ctnetlink, it's better to fix the
possible race together. So I audited the related source codes as follows:
1. CTA_HELP: for the userspace cthelper, no problem; for the inkernel
             cthelper, there's only one user: nf_ct_ftp_from_nlattr,
             but it only sets two flags, so no problem too.
2. CTA_TIMEOUT: only modify the ct->timeout, so no problem
3. CTA_STATUS: possible race will happen, fixed by PATCH #3
4. CTA_PROTOINFO: protected by ct->lock, no problem
5. CTA_MARK: only modify the ct->mark, no problem
6. CTA_SEQ_ADJ_X: should be protectd by ct->lock, fixed by PATCH #4
7. CTA_LABELS: use cmpxchg to update labels, so no problem

Liping Zhang (4):
  netfilter: ctnetlink: drop the incorrect cthelper module request
  netfilter: ctnetlink: fix deadlock due to acquire _expect_lock twice
  netfilter: ctnetlink: make it safer when updating ct->status
  netfilter: ctnetlink: acquire ct->lock before operating nf_ct_seqadj

 include/uapi/linux/netfilter/nf_conntrack_common.h | 13 +++-
 net/netfilter/nf_conntrack_netlink.c               | 89 ++++++++++++----------
 2 files changed, 58 insertions(+), 44 deletions(-)

-- 
2.5.5


