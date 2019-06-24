Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7DCC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B42F20657
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 17:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbfFXRKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:10:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51480 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732326AbfFXRKo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 13:10:44 -0400
Received: from localhost ([::1]:36338 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hfSUN-0003ZP-PM; Mon, 24 Jun 2019 19:10:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/2] Improve a few minor JSON glitches
Date:   Mon, 24 Jun 2019 19:10:36 +0200
Message-Id: <20190624171038.24672-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As suggested offline, print newline at end of JSON output (patch 1) and
don't ignore -j flag if JSON support is not compiled-in - bail instead
(patch 2).

Phil Sutter (2):
  json: Print newline at end of list output
  main: Bail if non-available JSON was requested

 src/json.c | 2 ++
 src/main.c | 3 +++
 2 files changed, 5 insertions(+)

-- 
2.21.0

