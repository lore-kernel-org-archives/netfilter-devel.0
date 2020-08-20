Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A619C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04EFB21744
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="nraUZA3u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgHTIU3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 04:20:29 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39080 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgHTIUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 04:20:25 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BXHdY46MLzFmbT;
        Thu, 20 Aug 2020 01:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1597911624; bh=wp2CYAj3g9wTFv1IsncHk/KVW0GHzwFMKdIDIn4GCYM=;
        h=From:To:Cc:Subject:Date:From;
        b=nraUZA3uO5Cyg6F2btNrttYYGCDA2B3onk7+qN+SOOoFH9beSRuZ293jlLmqKu294
         lLlREA4GmKZ+kAMDOrWkIeW7NGwW4HH/ciZMUGILxODI1zXUo9oUNUQ/YTC/qUDrPY
         dVAuh2C6Lpz87EyVGIEfsdN/lt7LWWXtPfEYxszI=
X-Riseup-User-ID: 0D12EF58023A8FAFA00B86D6AA04E57C1D6D86EBF3811DC68E6813448BBAF3A3
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BXHdX5bPvz8v0W;
        Thu, 20 Aug 2020 01:20:16 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 0/3] Add userdata and comment support for tables
Date:   Thu, 20 Aug 2020 10:19:00 +0200
Message-Id: <20200820081903.36781-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series enables storing userdata for tables. In addition,
using this userdata to save an optional comment when declaring new tables. 

 * nf-next
 netfilter: nf_tables: add userdata attributes to nft_table

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 25 ++++++++++++++++++++++++
 3 files changed, 29 insertions(+)
 
 * libnftnlt
 table: add userdata support

 include/libnftnl/table.h            |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  1 +
 src/table.c                         | 33 +++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

 * nftables
 src: add comment support when adding tables

 include/rule.h                                |  1 +
 src/mnl.c                                     | 19 +++++++++--
 src/netlink.c                                 | 32 +++++++++++++++++++
 src/parser_bison.y                            |  4 +++
 src/rule.c                                    |  5 +++
 .../testcases/optionals/comments_table_0      |  0
 .../testcases/optionals/comments_table_1      |  0
 .../optionals/dumps/comments_table_0.nft      |  0
 .../optionals/dumps/comments_table_1.nft      |  0
 9 files changed, 59 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/optionals/comments_table_0
 create mode 100755 tests/shell/testcases/optionals/comments_table_1
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_table_0.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_table_1.nft

-- 
2.27.0

