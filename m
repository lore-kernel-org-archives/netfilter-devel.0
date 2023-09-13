Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58115EDEC53
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 13:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbjIMNvv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjIMNvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 09:51:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582C91BC3;
        Wed, 13 Sep 2023 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QVOu0yAEFxEHqevirQ2tLlFR8+saZPzBa95q0tRyO1g=; b=WzbZfP/t2ms52J4acjlLxE2Ncn
        6Us8Q4B83wa9vFs/pFQAOEXq4VYpDcOtkK1dITlWYIAV0BlUIGRQRIpL+gm+akPKrymsesm5aUGn5
        Golf0ObT9wRaJcTy3wboN+LywrcYCg9Y4WzXzWc9W2uM/mlf+qLsjL3WKucfUiVY2yiZmVP+DoNFz
        ymsdk5ZCVFojXAAwl779JA5or//yLITulazydAyEX64O4cviS/cluQsi9mnjdOelRmUBqJQ+h7L0+
        bh0ZFYZ/D5+G4uykvFEUvRa7KuaEfMIVWxg8uJXKBmoR6F4H1/LeYnB0rjVBvNiwG3CS3Mh6j3CIP
        Q6hiPt6g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qgQHN-0007E3-Bp; Wed, 13 Sep 2023 15:51:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, paul@paul-moore.com, rgb@redhat.com
Subject: [nf PATCH v3 0/2] nf_tables: follow-up on audit fix, add selftest
Date:   Wed, 13 Sep 2023 15:51:35 +0200
Message-ID: <20230913135137.15154-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch f1 fixes/improves Pablo's fix for the bug I built into nf_tables'
audit support code.

Patch 2 adds a selftest for the audit notifications in nf_tables. I
consider it mature enough to submit it as non-RFC now.

Larger changes in both patches, details in each patch.

Phil Sutter (2):
  netfilter: nf_tables: Fix entries val in rule reset audit log
  selftests: netfilter: Test nf_tables audit logging

 net/netfilter/nf_tables_api.c                 |  16 +-
 tools/testing/selftests/netfilter/.gitignore  |   1 +
 tools/testing/selftests/netfilter/Makefile    |   4 +-
 .../selftests/netfilter/audit_logread.c       | 165 ++++++++++++++++++
 tools/testing/selftests/netfilter/config      |   1 +
 .../testing/selftests/netfilter/nft_audit.sh  | 108 ++++++++++++
 6 files changed, 287 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/audit_logread.c
 create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh

-- 
2.41.0

