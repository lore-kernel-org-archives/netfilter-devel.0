Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B380FC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFF6213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfCMTq2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:46:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48576 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfCMTq2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:46:28 -0400
Received: from localhost ([::1]:33434 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h49pa-0001A6-Lb; Wed, 13 Mar 2019 20:46:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/6] Man pages for arptables and ebtables
Date:   Wed, 13 Mar 2019 20:46:11 +0100
Message-Id: <20190313194617.31071-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Take over man pages from legacy ebtables and arptables repositories and
adjust them to nft-variants' limitations/extensions.

Patches 5 and 6 contain two minor fixes found while working on the
above.

Phil Sutter (6):
  doc: Add arptables-nft man pages
  doc: Adjust arptables man pages
  doc: Add ebtables man page
  doc: Adjust ebtables man page
  xtables-legacy.8: Remove stray colon
  xtables-save: Point at existing man page in help text

 iptables/Makefile.am             |    4 +
 iptables/arptables-nft-restore.8 |   39 ++
 iptables/arptables-nft-save.8    |   47 ++
 iptables/arptables-nft.8         |  348 ++++++++++
 iptables/ebtables-nft.8          | 1116 ++++++++++++++++++++++++++++++
 iptables/xtables-legacy.8        |    2 +-
 iptables/xtables-save.c          |    9 +-
 7 files changed, 1561 insertions(+), 4 deletions(-)
 create mode 100644 iptables/arptables-nft-restore.8
 create mode 100644 iptables/arptables-nft-save.8
 create mode 100644 iptables/arptables-nft.8
 create mode 100644 iptables/ebtables-nft.8

-- 
2.21.0

