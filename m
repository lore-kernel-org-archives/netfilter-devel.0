Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666F7C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F3072071B
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="V60YE+P7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBJNG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:13:06 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48278 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgIBJNF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 05:13:05 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BhJBS3C0wzFdxH;
        Wed,  2 Sep 2020 02:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1599037984; bh=HG6PNtQZnusXLALa8a+GzB7dNGQYr0OqIO9EscIOQ9U=;
        h=From:To:Cc:Subject:Date:From;
        b=V60YE+P7nvUkIKqgdTWaMrps3m/OzrgWW0qo0M5zAUxD+S5h2RVWDuabeuq2ONJFa
         JlUsVWu3Z+0l59EF7aZiyRfgtzBAkduB0FjIgX7OiFwzPCRJ3QiFASyFYPaPi1fCf5
         +qQmKOp2PcnWKL8LSJha7HEtT8Tk93cZZ9jcW1mI=
X-Riseup-User-ID: C08B735B781B852FB1D7F937C5EC3E17824168C85CA99F48DFC8D8C594FF55E4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BhJBR2Wv2z8tRn;
        Wed,  2 Sep 2020 02:13:02 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 0/3] add object userdata and comment support
Date:   Wed,  2 Sep 2020 11:12:38 +0200
Message-Id: <20200902091241.1379-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series enables userdata for objects. Initially used to store
comments, can be extended for other use cases in the future.

There is a new API version for libnftnl as it did not export a necessary
function, nftnl_obj_get_data, to support getting object data.

nf-next:
  netfilter: nf_tables: add userdata support for nft_object

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 39 +++++++++++++++++++-----
 3 files changed, 35 insertions(+), 8 deletions(-)

libnftnl:
  object: add userdata and comment support

 include/libnftnl/object.h           |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  2 ++
 include/obj.h                       |  5 +++++
 src/libnftnl.map                    |  4 ++++
 src/object.c                        | 26 ++++++++++++++++++++++++++
 6 files changed, 44 insertions(+)

nftables:
  src: add comment support for objects

 include/rule.h                                |  1 +
 src/mnl.c                                     | 12 +++++
 src/netlink.c                                 | 31 +++++++++++++
 src/parser_bison.y                            | 40 +++++++++++++++++
 src/rule.c                                    | 20 +++++++++
 .../testcases/optionals/comments_objects_0    | 44 +++++++++++++++++++
 .../optionals/dumps/comments_objects_0.nft    | 37 ++++++++++++++++
 7 files changed, 185 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_objects_0
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_objects_0.nft

-- 
2.27.0

