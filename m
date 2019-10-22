Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608A4CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DCEF20684
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfJVRB6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 13:01:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52288 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727885AbfJVRB6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 13:01:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iMxXg-00059N-MY; Tue, 22 Oct 2019 19:01:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com,
        syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ecache: don't look for ecache extension on dying/unconfirmed conntracks
Date:   Tue, 22 Oct 2019 18:56:42 +0200
Message-Id: <20191022165642.29698-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reported following splat:
BUG: KASAN: use-after-free in __nf_ct_ext_exist
include/net/netfilter/nf_conntrack_extend.h:53 [inline]
BUG: KASAN: use-after-free in nf_ct_deliver_cached_events+0x5c3/0x6d0
net/netfilter/nf_conntrack_ecache.c:205
nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:65 [inline]
nf_confirm+0x3d8/0x4d0 net/netfilter/nf_conntrack_proto.c:154
[..]

While there is no reproducer yet, the syzbot report contains one
interesting bit of information:

Freed by task 27585:
[..]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 nf_ct_ext_destroy+0x2ab/0x2e0 net/netfilter/nf_conntrack_extend.c:38
 nf_conntrack_free+0x8f/0xe0 net/netfilter/nf_conntrack_core.c:1418
 destroy_conntrack+0x1a2/0x270 net/netfilter/nf_conntrack_core.c:626
 nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:31 [inline]
 nf_ct_resolve_clash net/netfilter/nf_conntrack_core.c:915 [inline]
 ^^^^^^^^^^^^^^^^^^^
 __nf_conntrack_confirm+0x21ca/0x2830 net/netfilter/nf_conntrack_core.c:1038
 nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
 nf_confirm+0x3e7/0x4d0 net/netfilter/nf_conntrack_proto.c:154

This is whats happening:

1. a conntrack entry is about to be confirmed (added to hash table).
2. a clash with existing entry is detected.
3. nf_ct_resolve_clash() puts skb->nfct (the "losing" entry).
4. this entry now has a refcount of 0 and is freed to SLAB_TYPESAFE_BY_RCU
   kmem cache.

skb->nfct has been replaced by the one found in the hash.
Problem is that nf_conntrack_confirm() uses the old ct:

static inline int nf_conntrack_confirm(struct sk_buff *skb)
{
 struct nf_conn *ct = (struct nf_conn *)skb_nfct(skb);
 int ret = NF_ACCEPT;

  if (ct) {
    if (!nf_ct_is_confirmed(ct))
       ret = __nf_conntrack_confirm(skb);
    if (likely(ret == NF_ACCEPT))
	nf_ct_deliver_cached_events(ct); /* This ct has refcount 0! */
  }
  return ret;
}

As of "netfilter: conntrack: free extension area immediately", we can't
access conntrack extensions in this case.

To fix this, make sure we check the dying bit presence before attempting
to get the eache extension.

Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Fixes: 2ad9d7747c10d1 ("netfilter: conntrack: free extension area immediately")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I plan to send a patch for nf tree to alter nf_conntrack_confirm()
 to not cache the ct -- I think its a bug too, we should call
 nf_ct_deliver_cached_events() on the ct that is assigned to skb *now*,
 not the old one.

 net/netfilter/nf_conntrack_ecache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0d83c159671c..7956c9f19899 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -202,15 +202,15 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 	if (notify == NULL)
 		goto out_unlock;
 
+	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
+		goto out_unlock;
+
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
 		goto out_unlock;
 
 	events = xchg(&e->cache, 0);
 
-	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
-		goto out_unlock;
-
 	/* We make a copy of the missed event cache without taking
 	 * the lock, thus we may send missed events twice. However,
 	 * this does not harm and it happens very rarely. */
-- 
2.21.0

