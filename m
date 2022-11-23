Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA6FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiKWQo6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiKWQop (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EA388F82
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xAW6yX0FwMgwDLbP99Iswe/SUYTjVNKzCzzWWlv0eb4=; b=RnCHtz5sDdmFxUi1nPMktsWxf7
        9Ztjeh7kCXVHMBdpTSu0INPyXV2Mat7IfVIxTwXgPEcodh+zs7QPHTWAeghvMxCaZ+ZUXO8pVKtnk
        ipLbxD1f9a7wvuXneTv5M5qVW8kxfkWrDKrpxulB3YQiSbHZafJ8rZd1Ao110ixUlfgYUfbBJVtSx
        KCR408eEDJYJcHgWLIk2/xhCuEQ6exDwUMwI/w4sNsMBp8+eWp4KhdgM/p+c0wbJYgRD5E1jjVoQl
        B1wtJTxXDBEQ3alA1cVlrVOGs8N8OvF4aQE5y3pzih2s9aBkRcwH1bEO4bXrV5YL7y2auN9Cqjt9N
        0ysrTb/g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrZ-0003yM-AJ
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/13] Extensions: Review xlate callbacks
Date:   Wed, 23 Nov 2022 17:43:37 +0100
Message-Id: <20221123164350.10502-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a review of all extensions' xlate callbacks focussing on
correctness of operation and return code.

Patches 1 and 2 address ebtables mark target.
Patches 3, 4, 6 and 9 add 'return 0' calls in more or less unlikely
cases.
Patch 5 fixes multiple problems in CONNMARK target.
Patches 7, 8 and 10 extend some translations.
The last three patches add comments to help future reviewers asserting
code correctness.

Phil Sutter (13):
  extensions: libebt_mark: Fix mark target xlate
  extensions: libebt_mark: Fix xlate test case
  extensions: libebt_redirect: Fix xlate return code
  extensions: libipt_ttl: Sanitize xlate callback
  extensions: CONNMARK: Fix xlate callback
  extensions: MARK: Sanitize MARK_xlate()
  extensions: TCPMSS: Use xlate callback for IPv6, too
  extensions: TOS: Fix v1 xlate callback
  extensions: ecn: Sanitize xlate callback
  extensions: tcp: Translate TCP option match
  extensions: libebt_log: Add comment to clarify xlate callback
  extensions: frag: Add comment to clarify xlate callback
  extensions: ipcomp: Add comment to clarify xlate callback

 extensions/libebt_log.c          |  2 ++
 extensions/libebt_mark.c         |  2 +-
 extensions/libebt_mark.txlate    | 11 +++++++++++
 extensions/libebt_mark.xlate     | 11 -----------
 extensions/libebt_redirect.c     |  2 +-
 extensions/libip6t_frag.c        |  2 ++
 extensions/libipt_ttl.c          |  4 ++--
 extensions/libxt_CONNMARK.c      | 15 ++++++++++-----
 extensions/libxt_CONNMARK.txlate |  3 +++
 extensions/libxt_MARK.c          |  2 ++
 extensions/libxt_TCPMSS.c        |  1 +
 extensions/libxt_TOS.c           | 33 ++++++++++++++++++++++----------
 extensions/libxt_TOS.txlate      |  9 ++++++---
 extensions/libxt_ecn.c           |  2 ++
 extensions/libxt_ipcomp.c        |  2 ++
 extensions/libxt_ipcomp.c.man    |  3 ---
 extensions/libxt_tcp.c           |  9 ++++++---
 extensions/libxt_tcp.txlate      |  6 ++++++
 18 files changed, 80 insertions(+), 39 deletions(-)
 create mode 100644 extensions/libebt_mark.txlate
 delete mode 100644 extensions/libebt_mark.xlate

-- 
2.38.0

