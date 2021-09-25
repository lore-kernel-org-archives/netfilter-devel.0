Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D834C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 20:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8DB460FC1
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 20:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhIYUrn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 16:47:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51736 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhIYUrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 16:47:42 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 96BC363EB9
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 22:44:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/3] tests: monitor: update insert and replace commands
Date:   Sat, 25 Sep 2021 22:45:59 +0200
Message-Id: <20210925204559.22699-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210925204559.22699-1-pablo@netfilter.org>
References: <20210925204559.22699-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust test after these two kernel fixes:

("netfilter: nf_tables: reverse order in rule replacement expansion")
("netfilter: nf_tables: add position handle in event notification")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/monitor/testcases/simple.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/testcases/simple.t b/tests/monitor/testcases/simple.t
index 78fd6616eb07..2d9c92de25dd 100644
--- a/tests/monitor/testcases/simple.t
+++ b/tests/monitor/testcases/simple.t
@@ -14,12 +14,12 @@ O -
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": {"set": [22, 80, 443]}}}, {"accept": null}]}}}
 
 I insert rule ip t c counter accept
-O add rule ip t c counter packets 0 bytes 0 accept
+O insert rule ip t c counter packets 0 bytes 0 accept
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"counter": {"packets": 0, "bytes": 0}}, {"accept": null}]}}}
 
 I replace rule ip t c handle 2 accept comment "foo bar"
-O add rule ip t c accept comment "foo bar"
 O delete rule ip t c handle 2
+O add rule ip t c handle 5 accept comment "foo bar"
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "comment": "foo bar", "expr": [{"accept": null}]}}}
 J {"delete": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"accept": null}]}}}
 
-- 
2.30.2

