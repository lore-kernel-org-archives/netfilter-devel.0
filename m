Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B489EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 13:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388369AbiBGNt1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379142AbiBGN2Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 08:28:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2D8C043181
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:28:22 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nH444-00078o-NW; Mon, 07 Feb 2022 14:28:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] flowtable json fixes
Date:   Mon,  7 Feb 2022 14:28:13 +0100
Message-Id: <20220207132816.21129-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

json doesn't export the flow statement.
First patch resolves this, the other two patches resolve
import problems with flowtable json format.

Florian Westphal (3):
  json: add flow statement json export + parser
  parser_json: fix flowtable device datatype
  parser_json: permit empty device list

 include/json.h    |  2 ++
 src/ct.c          |  1 +
 src/json.c        |  7 ++++++
 src/parser_json.c | 54 ++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 52 insertions(+), 12 deletions(-)

-- 
2.34.1

