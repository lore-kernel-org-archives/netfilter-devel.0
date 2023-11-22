Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BD0C27C40
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbjKVVpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344352AbjKVVpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF611B5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d4Q17K+vahQjqAj3ho45SMc0e/vMhfzm/6G7pJ3kmUY=; b=p4H/IgaF3WEpMyPnmcT5F9JUm9
        SPYVAug7g8/GCXnUS9As75glmj+dV9DfMAJpnOCzcvFZBb3a/nrKNgfdd4NKdTwcL5QdAlWLVl3RP
        A56SwBRGarCum90Vl/RlnfbOV6HSs8KY2hw6FoyLA4+yS7saGXT6sRt3tK9+t4LjC8vpR/nUUyVSe
        ypKs3vP7nXfEcCiWkYyWxPJZd1URtOmydvZSNJVPbWDITMvuDuyHhh1HMfvbwa5aEAUeVcQvdf2BT
        KAYeEmuvxkLjGxD4NGSNd0huCRSZuuK7bXduXZku0GABUerQbtLS4x1jjzCBc3k2JocQvKp6iZMwN
        Xnw5ftVw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1k-0003hp-SQ
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/6] Extend guided option parser for use by arptables
Date:   Wed, 22 Nov 2023 22:52:55 +0100
Message-ID: <20231122215301.15725-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 is unrelated to the remaining ones, but fits into a series about
libxtables option parser.

Patch 2 fixes for parsing of IP addresses with arptables, patches 3 and
4 enable users to parse integers in a fixed base.

Patches 5 and 6 then migrate more extensions over to using the guided
option parser.

Phil Sutter (6):
  libxtables: Combine the two extension option mergers
  libxtables: Fix guided option parser for use with arptables
  libxtables: Introduce xtables_strtoul_base()
  libxtables: Introduce struct xt_option_entry::base
  extensions: libarpt_mangle: Use guided option parser
  extensions: MARK: arptables: Use guided option parser

 extensions/libarpt_mangle.c | 128 +++++++++++++-----------------------
 extensions/libarpt_mangle.t |   4 ++
 extensions/libxt_MARK.c     |  82 +++++------------------
 include/xtables.h           |   5 +-
 libxtables/xtables.c        |  16 +++--
 libxtables/xtoptions.c      |  77 ++++++++--------------
 6 files changed, 106 insertions(+), 206 deletions(-)

-- 
2.41.0

