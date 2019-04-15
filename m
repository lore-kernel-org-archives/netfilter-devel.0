Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40D0C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2458205F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfDOUoA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:44:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:57655 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfDOUoA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 16:44:00 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.1) with ESMTPS id x3FKhY7t028161
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 15 Apr 2019 13:43:35 -0700 (PDT)
Received: from yow-cube1.wrs.com (128.224.56.98) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Apr 2019
 13:43:34 -0700
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     <netdev@vger.kernel.org>
CC:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: [PATCH -next 0/3] netfilter: header cleanup
Date:   Mon, 15 Apr 2019 16:43:13 -0400
Message-ID: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Having core header files in include/linux that in turn include other
headers with a high number of includes implicitly degenerates into
a formalism that hides what amounts to #include <linux/everything.h>

Some headers, like module.h and device.h are good examples that will
essentially drag in almost everything.

There is nothing module specific about netfilter, but before we try
and stop nf_tables.h from including module.h, we have to fix two
instances of code which are implicitly relying on that module.h
inclusion, so as to not introduce build regressions.

---

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org

Paul Gortmaker (3):
  netfilter: nf_tables: relocate header content to consumer
  netfilter: nf_tables: fix implicit include of module.h
  netfilter: nf_tables: drop include of module.h from nf_tables.h

 include/net/netfilter/nf_tables.h  | 20 ++------------------
 net/netfilter/nf_tables_set_core.c |  1 +
 net/netfilter/nft_dynset.c         | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 18 deletions(-)

-- 
2.7.4

