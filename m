Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B22C61DB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbjALSFJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbjALSDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99E5D880
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zf2fjqNNots+alnSG33AHJyBcQRwfg7Av+S/E8xXZvM=; b=NftHWukJ4LNQIl5VpVqreL5YUx
        BdKormfbk28bLJo3d1L0FPPDn9y4V8bxQwnS/9HPXVb5+/6tFzUpPwXExWaFY10wQoN3QW4voKwZX
        oCP9CQylGW9zVQ/Sggb9mEUlfiL6dOv09ERGoN6xp2u/dtCD5HJcYpBIjeRdOn4N88SpwAvxhRMbW
        1dWESOlZ1VcmPTMcZHk9RIHD5/ITMTXS4EVwLjpGkwTewsYTAYpscnLYT6W9ZXOT4IlJEnQPYus9u
        Cq6EwLJRy5IwVE7C7w3vi9BcxMfgipUJpgR5ZJgWtpOXQq/qHaIeMs7MGGOR3kUx3EKjZcMG6r0iS
        UCIW2ezQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1NQ-0000D6-83; Thu, 12 Jan 2023 18:28:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/5] Fix some covscan findings
Date:   Thu, 12 Jan 2023 18:28:18 +0100
Message-Id: <20230112172823.7298-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All these are rather minor issues, no big deal.

Phil Sutter (5):
  optimize: Clarify chain_optimize() array allocations
  optimize: Do not return garbage from stack
  netlink: Fix for potential NULL-pointer deref
  meta: parse_iso_date() returns boolean
  mnl: dump_nf_hooks() leaks memory in error path

 src/meta.c     |  2 +-
 src/mnl.c      | 11 +++++++++--
 src/netlink.c  |  3 ++-
 src/optimize.c |  9 +++++----
 4 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.38.0

