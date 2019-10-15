Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BF8ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE2220650
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbfJOORX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:17:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36894 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJOORX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 10:17:23 -0400
Received: from localhost ([::1]:49984 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKNda-00038L-LA; Tue, 15 Oct 2019 16:17:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 0/6] A series of covscan-indicated fixes
Date:   Tue, 15 Oct 2019 16:16:52 +0200
Message-Id: <20191015141658.11325-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix (potential) issues identified by Coverity tool.

Phil Sutter (6):
  obj: ct_timeout: Check return code of mnl_attr_parse_nested()
  set_elem: Fix return code of nftnl_set_elem_set()
  set_elem: Validate nftnl_set_elem_set() parameters
  set: Don't bypass checks in nftnl_set_set_u{32,64}()
  obj/ct_timeout: Avoid array overrun in timeout_parse_attr_data()
  obj/tunnel: Fix for undefined behaviour

 include/libnftnl/set.h |  2 ++
 include/utils.h        |  8 ++++++++
 src/obj/ct_timeout.c   | 11 +++++++----
 src/obj/tunnel.c       |  6 +++---
 src/set.c              |  5 +++--
 src/set_elem.c         | 12 +++++++++++-
 6 files changed, 34 insertions(+), 10 deletions(-)

-- 
2.23.0

