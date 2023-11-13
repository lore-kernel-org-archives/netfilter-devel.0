Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFE2C41535
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjKMKc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKMKcY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:24 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EA3D75
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id A9AB9587270B6; Mon, 13 Nov 2023 11:32:16 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id B155F587264C0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:14 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: iptables manpage updates
Date:   Mon, 13 Nov 2023 11:30:05 +0100
Message-ID: <20231113103156.57745-1-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


The following changes since commit 3be599b62869f2437f499e2386008d73b8c2e71b:

  extensions: libarpt_standard.t: Add a rule with builtin option masks (2023-11-09 15:55:33 +0100)

are available in the Git repository at:

  https://git.inai.de/iptables master

for you to fetch changes up to 4b0c168a7b50032ba64f75565f73340fc447bfab:

  man: more backslash-encoding of characters (2023-11-13 11:28:19 +0100)

----------------------------------------------------------------
Jan Engelhardt (7):
      man: consistent use of \(em in Name sections
      man: remove lone .nh command
      man: repeal manual hyphenation
      man: stop putting non-terminals in italic
      man: copy synopsis markup from iptables.8 to arptables-nft.8
      man: limit targets for -P option synopsis
      man: more backslash-encoding of characters

 extensions/libxt_CONNMARK.man    |   4 +-
 extensions/libxt_NFLOG.man       |   2 +-
 iptables/arptables-nft-restore.8 |   4 +-
 iptables/arptables-nft-save.8    |   2 +-
 iptables/arptables-nft.8         | 154 +++++++++++++++++++++------------------
 iptables/ebtables-nft.8          |   4 +-
 iptables/iptables-apply.8.in     |   4 +-
 iptables/iptables.8.in           |   8 +-
 iptables/xtables-nft.8           |  16 ++--
 iptables/xtables-translate.8     |  32 ++++----
 utils/nfbpf_compile.8.in         |   2 +-
 utils/nfnl_osf.8.in              |   2 +-
 12 files changed, 123 insertions(+), 111 deletions(-)

