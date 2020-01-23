Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77663C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 545D12077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAWOad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:30:33 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39868 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgAWOad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 09:30:33 -0500
Received: from localhost ([::1]:52956 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iudV9-0000mM-Ei; Thu, 23 Jan 2020 15:30:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/4] Covscan-induced review of ei_insert()
Date:   Thu, 23 Jan 2020 15:30:45 +0100
Message-Id: <20200123143049.13888-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

False covscan report led to closer investigation ei_insert() which
identified dead code and some opportunities for improvement due to the
fact that the only caller sorts the new intervals prior to calling said
function.

Note that if we at some point want to support merging of new and old set
elements, we will probably have to revert these patches since we can't
be sure anymore that there aren't any items with bigger values in the
set already.

Phil Sutter (4):
  segtree: Drop needless insertion in ei_insert()
  segtree: Drop dead code in ei_insert()
  segtree: Simplify overlap case in ei_insert()
  segtree: Refactor ei_insert()

 src/segtree.c | 101 +++++++++++++-------------------------------------
 1 file changed, 25 insertions(+), 76 deletions(-)

-- 
2.24.1

