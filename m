Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AF7C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 16:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356073AbiELQsA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 12:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356669AbiELQr6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 12:47:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52FB24F208
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 09:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=61OJLQocLbNJmpma96rxHPDfgZJoPVBQNATvAcxYuAk=; b=eO2MQx3mOkTmZz+lzS9xQUmUUo
        p85CWkvXcUA2bJW03D+dI2QkpoPbia6t8sJYY7pem442BSbMl/4mYS+BxYkM7fZUkoXLk7xDt08fc
        wetAPExl5hMYbV8JP7pxjc9zT0MLQpMxRHiCGg+YsiQKfOG1G3FkUvgBKRdLUy4T52IWNOsWhSxyW
        Cnz1YQEgRak17bzd+6oqudQlEwIbGAizu9bTs/OUS+sRRmMKbb5F+OPM07vCeXm9Kz+QSvNLqil3H
        v3W8+hEcNsYQbF8kJgRtcZOnpBO3FAGuwmhBI15FiIH+k7wbeIDGb9hc6NXDpf5J64mJ4Z1L/HDt3
        krmxaZ3A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1npByl-0004Q9-BS; Thu, 12 May 2022 18:47:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 0/4] nf_tables: Export rule optimizer results to user space
Date:   Thu, 12 May 2022 18:47:37 +0200
Message-Id: <20220512164741.31440-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v2:
- New patches 1 and 2

Changes since v1:
- Fixed two bugs in patch 2.

While transforming rules into binary blob, code checks if certain
expressions may be omitted. Any bugs in this code might lead to very
subtle breakage of firewall rulesets, so a way of asserting optimizer
correctness is highly necessary.

This series achieves this in the most minimal way by annotating omitted
expressions with a flag. Integrated into libnftnl print output,
testsuites in user space may verify optimizer effect and assert
correctness.

First patch prepares for a blob-specific variant of struct nft_expr
which is smaller than the original. Second patch introduces this
variant. Third patch extends structy nft_expr by a new field and finally
fourth patch populates it.

Phil Sutter (4):
  netfilter: nf_tables: Store net size in nft_expr_ops::size
  netfilter: nf_tables: Introduce struct nft_expr_dp
  netfilter: nf_tables: Introduce expression flags
  netfilter: nf_tables: Annotate reduced expressions

 include/net/netfilter/nf_tables.h        | 13 ++++++--
 include/uapi/linux/netfilter/nf_tables.h |  8 +++++
 net/netfilter/nf_tables_api.c            | 42 ++++++++++++++++--------
 3 files changed, 48 insertions(+), 15 deletions(-)

-- 
2.34.1

