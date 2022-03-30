Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73730C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346709AbiC3QAr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiC3QAp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:00:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB6964EC
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MyAh/KaSY9YT9Tz6iDH+KcrTKG52V3F3HzeHVgRR1uE=; b=Dv22Ei6f8nFs9bwolS3MlNaE5T
        HlzEtScu/Wg/YN2TaF6cEUPRXeRQkJ8VuuRC6CsHZapehKX161hhLWnsxjssXNddHlWXKafLDqU0/
        AsY9PQsrXJ341bzfuaI0dkLnlbt5n0s1dT2xt1vguiLLnp3FDQ7wactGgA/LCJhQ682Nyd4HYX9wh
        n9x3Rtswg9lu3YeZIZs2mfBcJaxSg11LQVINfIY4DhBuqOVJ5SUBnCjd8Gv46QGBxShE5guF4KvGR
        8AVpa7Pmfbr4C9Iv6017SoE57N8kwfdllQckfI6Qm5l0g0AAy7I3rWUJW4jS9n2J15LXELy09smuL
        lLX/AGsg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZaio-0004X7-T6; Wed, 30 Mar 2022 17:58:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/9] extensions: Merge *_DNAT and *_REDIRECT
Date:   Wed, 30 Mar 2022 17:58:42 +0200
Message-Id: <20220330155851.13249-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The multitude of data structures for kernel communication aside, code
for parsing/printing of DNAT and REDIRECT targets in both IPv4 and IPv6
are pretty similar. Stick them into a common source file and share as
much code as possible.

The first two patches are basically fallout from initial code-review.
The next three patches optimize and prepare libipt_DNAT.c as it will
serve as the source to merge into. Therefore patch 6 renames it to
libxt_DNAT.c and finally patches 7 and 8 merge the code.

As an extra, patch 9 "fixes" for service names in ranges by searching
the longest match.

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
  extensions: DNAT: Support service names in all spots

 extensions/GNUmakefile.in          |   4 +-
 extensions/libip6t_DNAT.c          | 409 -----------------
 extensions/libip6t_DNAT.txlate     |  11 -
 extensions/libip6t_REDIRECT.c      | 170 -------
 extensions/libip6t_REDIRECT.t      |   6 -
 extensions/libip6t_REDIRECT.txlate |   5 -
 extensions/libip6t_SNAT.c          |   9 +-
 extensions/libipt_DNAT.c           | 507 ---------------------
 extensions/libipt_DNAT.t           |   6 +
 extensions/libipt_DNAT.txlate      |  14 -
 extensions/libipt_REDIRECT.c       | 174 --------
 extensions/libipt_REDIRECT.t       |   6 -
 extensions/libipt_REDIRECT.txlate  |   5 -
 extensions/libipt_SNAT.c           |   3 -
 extensions/libxt_DNAT.c            | 685 +++++++++++++++++++++++++++++
 extensions/libxt_DNAT.man          |   5 +-
 extensions/libxt_DNAT.txlate       |  35 ++
 extensions/libxt_REDIRECT.t        |  11 +
 extensions/libxt_REDIRECT.txlate   |  17 +
 19 files changed, 762 insertions(+), 1320 deletions(-)
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

