Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EA7C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBEC2081B
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBUTJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:09:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60386 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfBUTJb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 14:09:31 -0500
Received: from localhost ([::1]:45244 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gwtis-0007oU-Dl; Thu, 21 Feb 2019 20:09:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] extensions: Add testcase for libxt_ipvs
Date:   Thu, 21 Feb 2019 20:09:32 +0100
Message-Id: <20190221190932.16281-3-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221190932.16281-1-phil@nwl.cc>
References: <20190221190932.16281-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Given that it is fixed now, make it stay.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ipvs.t | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 extensions/libxt_ipvs.t

diff --git a/extensions/libxt_ipvs.t b/extensions/libxt_ipvs.t
new file mode 100644
index 0000000000000..c2acc6668d1b2
--- /dev/null
+++ b/extensions/libxt_ipvs.t
@@ -0,0 +1,20 @@
+:INPUT,FORWARD,OUTPUT
+-m ipvs --ipvs;=;OK
+-m ipvs ! --ipvs;=;OK
+-m ipvs --vproto tcp;-m ipvs --vproto 6;OK
+-m ipvs ! --vproto TCP;-m ipvs ! --vproto 6;OK
+-m ipvs --vproto 23;=;OK
+-m ipvs --vaddr 1.2.3.4;=;OK
+-m ipvs ! --vaddr 1.2.3.4/255.255.255.0;-m ipvs ! --vaddr 1.2.3.4/24;OK
+-m ipvs --vport http;-m ipvs --vport 80;OK
+-m ipvs ! --vport ssh;-m ipvs ! --vport 22;OK
+-m ipvs --vport 22;=;OK
+-m ipvs ! --vport 443;=;OK
+-m ipvs --vdir ORIGINAL;=;OK
+-m ipvs --vdir REPLY;=;OK
+-m ipvs --vmethod GATE;=;OK
+-m ipvs ! --vmethod IPIP;=;OK
+-m ipvs --vmethod MASQ;=;OK
+-m ipvs --vportctl 21;=;OK
+-m ipvs ! --vportctl 21;=;OK
+-m ipvs --vproto 6 --vaddr 1.2.3.4/16 --vport 22 --vdir ORIGINAL --vmethod GATE;=;OK
-- 
2.20.1

