From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] extensions: add tests for comp match options
Date: Tue,  6 Feb 2018 23:33:30 +0530
Message-ID: <20180206180330.24879-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37470 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbeBFSDr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 13:03:47 -0500
Received: by mail-pl0-f68.google.com with SMTP id ay8so1723063plb.4
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2018 10:03:47 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test for ipcomp flow match specified by its SPI value
and move tests for ipcomp protocol to libxt_policy.t

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 extensions/libxt_ipcomp.t | 8 +++-----
 extensions/libxt_policy.t | 3 +++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_ipcomp.t b/extensions/libxt_ipcomp.t
index ce111142..4b989d4c 100644
--- a/extensions/libxt_ipcomp.t
+++ b/extensions/libxt_ipcomp.t
@@ -1,5 +1,3 @@
-:INPUT,FORWARD
--m policy --dir in --pol ipsec --proto ipcomp;=;OK
--m policy --dir in --pol none --proto ipcomp;;FAIL
--m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp;=;OK
--m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
+:INPUT,OUTPUT
+-p 108 -m ipcomp --ipcompspi 0x12 -j DROP;=;OK
+-p 108 -m ipcomp ! --ipcompspi 0x12 -j ACCEPT;=;OK
diff --git a/extensions/libxt_policy.t b/extensions/libxt_policy.t
index 24a3e2f4..6524122b 100644
--- a/extensions/libxt_policy.t
+++ b/extensions/libxt_policy.t
@@ -1,5 +1,8 @@
 :INPUT,FORWARD
 -m policy --dir in --pol ipsec;=;OK
+-m policy --dir in --pol ipsec --proto ipcomp;=;OK
 -m policy --dir in --pol ipsec --strict;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp;=;OK
 -m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
 -m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 10.0.0.0/8;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
-- 
2.14.1

