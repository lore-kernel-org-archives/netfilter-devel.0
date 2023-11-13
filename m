Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91678C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjKMKoG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKMKoG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:44:06 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A784D10CB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:44:03 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 500F9587264C0; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 1AA52587264C0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: ebtables documentation updates
Date:   Mon, 13 Nov 2023 11:43:05 +0100
Message-ID: <20231113104357.59087-1-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


The following changes since commit 916d4205ccc3f67dd0eef7d5240a7e9f816dbc08:

  ebtables: add "allstatic" build target (2022-08-02 15:24:00 +0200)

are available in the Git repository at:

  https://git.inai.de/ebtables master

for you to fetch changes up to 881cb4e8e4a489245367c292940d8975b11b8591:

  ebtables: better error message when -j is missing (2023-11-13 11:41:13 +0100)

----------------------------------------------------------------
Jan Engelhardt (7):
      man: make TH word match Name line
      man: consistent use of \(em in Name sections
      man: layout and colorize synopsis similar to iptables
      man: display number ranges with an en dash
      man: perform backslash-encoding
      man: fix one spello
      ebtables: better error message when -j is missing

 ebtables-legacy.8.in | 477 ++++++++++++++++++++++++++-------------------------
 ebtables.c           |   2 +-
 2 files changed, 243 insertions(+), 236 deletions(-)

