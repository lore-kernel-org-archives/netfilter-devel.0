Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DB0C3DA78
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 23:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjANXKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 18:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjANXKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 18:10:54 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A47599017
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 15:10:53 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sbrivio@redhat.com
Subject: [PATCH nf 0/2] nf_tables rbtree fixes
Date:   Sun, 15 Jan 2023 00:10:45 +0100
Message-Id: <20230114231047.948785-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains two fixes for the rbtree set backend:

1) Switch back to the list walk to detect overlap as proposed by Stefano.
   Use tree descent to locate nearest more than element to speed up
   overlap detection. Perform garbarge collection of expired element
   from the insert path while walking the list to avoid bogus overlap
   reports.

2) Do not interfer with ongoing transaction from garbage collector.
   Skip inactive elements from the garbage collection. Reset annotated
   end element coming before expired start element when it is busy with
   transaction update.

nftables shell test sets/0044interval_overlap_0 passes without errors.
This also passes this test when disabling set_overlap() in userspace nft
which perform overlap detection from userspace for older kernels (< 5.7).

Pablo Neira Ayuso (2):
  netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
  netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

 net/netfilter/nft_set_rbtree.c | 331 ++++++++++++++++++++-------------
 1 file changed, 204 insertions(+), 127 deletions(-)

-- 
2.30.2

