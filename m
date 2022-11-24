Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334A9C4321E
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 16:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKXQ5P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKXQ5C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 11:57:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451AB3D90A
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 08:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C3bXRQSzNCm6bw+uclphXTf+avL2APB4G1Np9hukNww=; b=IyD6ykyhQGkjwoHHFPIhjzw4ih
        IkMm/3MyfR9zEmC9eH/6m71VN1ReFbBUdmza5OWOce5VGBWkl7d5UsrWCWlyId+/Ob6ARdHG919Wf
        xOj6nIoq3GvycFWbkaTlCmqxUgWnRkbKTNTbiQlnN5dMrvkCx7b/xyeGsZb2416/MHZH/xmR71XqT
        ac6GbI/1eUHzPuR/bqW/M5y8Z5bVuziVUDO38mce5jXwDwF0lsz/j3qACNNh0u9kgwL7WXNmFeWcp
        55ZQH0AJGflmVC+td5bb36GhzXPhvmZcPisjCV1oiBFrH95ZOQBQyhfMIluLkpEluh1CoXs/5QSX1
        0lzw5ANg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oyFWx-0000qt-MA; Thu, 24 Nov 2022 17:56:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 0/4] xt: Rewrite unsupported compat expression dumping
Date:   Thu, 24 Nov 2022 17:56:37 +0100
Message-Id: <20221124165641.26921-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alternative approach to my previous dump and restore support of xt
compat expressions:

If translation is not available or not successful, fall back to a
format which allows to be parsed easily.

When parsing, reject these expressions explicitly with a meaningful
error message.

Phil Sutter (4):
  xt: Delay libxtables access until translation
  xt: Purify enum nft_xt_type
  xt: Rewrite unsupported compat expression dumping
  xt: Fall back to generic printing from translation

 doc/libnftables-json.adoc |  18 +++-
 doc/statements.txt        |  17 ++++
 include/json.h            |   2 +
 include/parser.h          |   1 +
 include/statement.h       |  11 +-
 src/json.c                |  19 ++--
 src/parser_bison.y        |  18 ++++
 src/parser_json.c         |   5 +
 src/scanner.l             |   3 +
 src/statement.c           |   1 +
 src/xt.c                  | 207 +++++++++++++++-----------------------
 11 files changed, 163 insertions(+), 139 deletions(-)

-- 
2.38.0

