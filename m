Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D376C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiCaKON (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 06:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiCaKOM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 06:14:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC31EECC
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 03:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aVQajcebSY7nfGHP5e44P0EilFAR9OHJ6ZMHjysFkYA=; b=cUmCim+HRu5CPSXP2xlYRnYoUy
        MolmGkn3LcWAKIj0WKcNBZx086LCkqgUrdpNsLSkb7B6QTuUaBH1COiFD01gKWOZ8LSma1mgClKUm
        y2LGS2VZ15SALgzanRqTUEN8NpI7TQjPk7SdzK8ZJwwNu7zzayCP/rUEx+e7Chh3+VvoVmrToMW6U
        UoAEv1ke6VtJKjesAEenYTKBY2aZMQ5avCU+dgs7M1qVxq+rDBY6Uz8UWLGKW8G+y/OejjbRgBpR3
        +ixBgwlLXSAhrr4zP93r3GmWVOWDJQg1Zhp3hhK/GokDY9KW7W7NzRfUvx6w6rgVuMQTY7OqzW0UJ
        RmkN/KDQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZrmy-00066T-Cp; Thu, 31 Mar 2022 12:12:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 0/9] extensions: Merge *_DNAT and *_REDIRECT
Date:   Thu, 31 Mar 2022 12:12:02 +0200
Message-Id: <20220331101211.10099-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Second try, without fancy service name parsing in ranges this time.
Instead, mention support for names outside of ranges in extensions man
page.

Other changes since v1:
- Fixed for garbage in output when listing multiple DNAT rules (due to
  missing reinit of a static buffer.
- Drop of last patch revealed a crash bug in service name parser.
- Do not allow service names in ranges' upper boundary.
- More test cases.

Phil Sutter (9):
  man: DNAT: Describe shifted port range feature
  Revert "libipt_[SD]NAT: avoid false error about multiple destinations
    specified"
  extensions: ipt_DNAT: Merge v1 and v2 parsers
  extensions: ipt_DNAT: Merge v1/v2 print/save code
  extensions: ipt_DNAT: Combine xlate functions also
  extensions: DNAT: Rename from libipt to libxt
  extensions: Merge IPv4 and IPv6 DNAT targets
  extensions: Merge REDIRECT into DNAT
  extensions: man: Document service name support in DNAT and REDIRECT

 extensions/GNUmakefile.in          |   4 +-
 extensions/libip6t_DNAT.c          | 409 ------------------
 extensions/libip6t_DNAT.t          |   4 +
 extensions/libip6t_DNAT.txlate     |  11 -
 extensions/libip6t_REDIRECT.c      | 170 --------
 extensions/libip6t_REDIRECT.t      |   6 -
 extensions/libip6t_REDIRECT.txlate |   5 -
 extensions/libip6t_SNAT.c          |   9 +-
 extensions/libipt_DNAT.c           | 507 ----------------------
 extensions/libipt_DNAT.t           |   4 +
 extensions/libipt_DNAT.txlate      |  14 -
 extensions/libipt_REDIRECT.c       | 174 --------
 extensions/libipt_REDIRECT.t       |   6 -
 extensions/libipt_REDIRECT.txlate  |   5 -
 extensions/libipt_SNAT.c           |   3 -
 extensions/libxt_DNAT.c            | 650 +++++++++++++++++++++++++++++
 extensions/libxt_DNAT.man          |   7 +-
 extensions/libxt_DNAT.txlate       |  35 ++
 extensions/libxt_REDIRECT.man      |   1 +
 extensions/libxt_REDIRECT.t        |  16 +
 extensions/libxt_REDIRECT.txlate   |  26 ++
 21 files changed, 746 insertions(+), 1320 deletions(-)
 delete mode 100644 extensions/libip6t_DNAT.c
 delete mode 100644 extensions/libip6t_DNAT.txlate
 delete mode 100644 extensions/libip6t_REDIRECT.c
 delete mode 100644 extensions/libip6t_REDIRECT.t
 delete mode 100644 extensions/libip6t_REDIRECT.txlate
 delete mode 100644 extensions/libipt_DNAT.c
 delete mode 100644 extensions/libipt_DNAT.txlate
 delete mode 100644 extensions/libipt_REDIRECT.c
 delete mode 100644 extensions/libipt_REDIRECT.t
 delete mode 100644 extensions/libipt_REDIRECT.txlate
 create mode 100644 extensions/libxt_DNAT.c
 create mode 100644 extensions/libxt_DNAT.txlate
 create mode 100644 extensions/libxt_REDIRECT.t
 create mode 100644 extensions/libxt_REDIRECT.txlate

-- 
2.34.1

