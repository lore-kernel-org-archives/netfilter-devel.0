Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9A0C04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjHBQJf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjHBQJf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:09:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF54E1
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xlFp3NkupNg6dQDAryeH/S2eboapjKJ4NEFlQOosb88=; b=pLz798bKZy63xOKw9BcX+/IjtV
        2mySe7sA5htcxWcQGZS9+hd8NEbNLQ7thqChk7gX236qIusSzM5KRNta4P59YdeL6kEVg56VMn1GL
        Rf6E7VMy8TZwK3S/wU1w9CNF6ieGEQBEhZtF5qfSFPDxunXSzK3qJmb4hp19KUboSS8Unk+Y4CVUb
        E5/yXsPYirvihvL+CHRzsrjD5nAx894+KtDb75fwJKdcr5lRPSRitTPeuq6UzLvwuOJCyYlS0cOAV
        E0M3VsBuyUgB+v8L4yFTIKmOrZ0/180AU9CnKIYbhZUkfBemSaMcBq2MZGh+T9DR4cpgEzQEdRlST
        VY1WhUzA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREPj-0004tj-Np
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:09:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 00/15] Man pages review
Date:   Wed,  2 Aug 2023 18:09:08 +0200
Message-Id: <20230802160923.17949-1-phil@nwl.cc>
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

Changes since v1:
- Adjusted patches 6, 7 and 14 as per Jan's feedback.
- Folded the two trivial "missing space after comma" patches into one,
  they even fixed the same commit.

Phil Sutter (15):
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
  man: Trivial: Missing space after comma
  man: iptables-save.8: Clarify 'available tables'
  man: iptables-save.8: Fix --modprobe description
  man: iptables-save.8: Start paragraphs in upper-case

 extensions/libxt_nfacct.man    |  2 +-
 iptables/iptables-restore.8.in | 25 ++++++++++++------------
 iptables/iptables-save.8.in    | 18 ++++++++++-------
 iptables/iptables.8.in         | 35 ++++++++++++++++++----------------
 4 files changed, 44 insertions(+), 36 deletions(-)

-- 
2.40.0

