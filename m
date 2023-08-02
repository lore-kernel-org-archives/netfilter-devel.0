Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D582FEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjHBCFK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHBCFK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F83212D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VzrReA6btN13dEB6YGhN4VGigQbZCrQJhrwzFG9b094=; b=BsilEd/neMB+G5E35PXe+pf3UN
        Y7i03eC3CIRmovJpUTyDUVlpp2CQUJD/s7UivvSwoh/aoPt7vV/jtRnuvf+bLckvAog/mxi2kUP/p
        lwxp7DF1kcAsVqdFIaWGoL+z997MO3BDyL+xnZYf4jfBcS0a2kj+fJUSTeC6XobQd1jQizAVZFFSY
        vr67VMdszrrqfQ+MMpbEZ/h40kJDA2pIpqNuowBcPr/tQ6QoBCrjTu3TbH0Oq36ZOpmTCkygdL6/4
        Q6/BBdjoFvXSqMhN3xwvoNAhVSAO6o7642Ve6JxQcXJy+54bMG2JLnCygHtbIsqfJHFVuT9O8ozaQ
        4oGYiPzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1EZ-0002ss-CO
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 04:05:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/16] Man pages review
Date:   Wed,  2 Aug 2023 04:03:44 +0200
Message-Id: <20230802020400.28220-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks to the manpage-l10n project, we received several tickets listing
a number of corrections and improvements to the different iptables man
pages. This series implements what I considered valid and worth keeping.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1682
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1683
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1684

Phil Sutter (16):
  man: iptables.8: Extend exit code description
  man: iptables.8: Trivial spelling fixes
  man: iptables.8: Fix intra page reference
  man: iptables.8: Clarify --goto description
  man: Use HTTPS for links to netfilter.org
  man: iptables.8: Trivial font fixes
  man: iptables-restore.8: Fix --modprobe description
  man: iptables-restore.8: Consistently document -w option
  man: iptables-restore.8: Drop -W option from synopsis
  man: iptables-restore.8: Put 'file' in italics in synopsis
  man: iptables-restore.8: Start paragraphs in upper-case
  man: iptables-restore.8: Trivial: Missing space after comma
  man: iptables-save.8: Clarify 'available tables'
  man: iptables-save.8: Fix --modprobe description
  man: iptables-save.8: Start paragraphs in upper-case
  man: iptables-save.8: Trivial: Missing space in enumeration

 extensions/libxt_nfacct.man    |  2 +-
 iptables/iptables-restore.8.in | 25 ++++++++--------
 iptables/iptables-save.8.in    | 18 +++++++-----
 iptables/iptables.8.in         | 53 ++++++++++++++++++----------------
 4 files changed, 53 insertions(+), 45 deletions(-)

-- 
2.40.0

