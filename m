From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_NFQUEUE: Add missing tests
Date: Fri, 29 Apr 2016 14:38:42 +0530
Message-ID: <20160429090842.GA26959@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33494 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbcD2JJH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:09:07 -0400
Received: by mail-pf0-f174.google.com with SMTP id 206so45702085pfu.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 02:09:07 -0700 (PDT)
Received: from shivani ([124.124.47.116])
        by smtp.gmail.com with ESMTPSA id vu5sm21630601pab.43.2016.04.29.02.09.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 29 Apr 2016 02:09:06 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing tests for NFQUEUE.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFQUEUE.t | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libxt_NFQUEUE.t b/extensions/libxt_NFQUEUE.t
index d4e4274..b51b19f 100644
--- a/extensions/libxt_NFQUEUE.t
+++ b/extensions/libxt_NFQUEUE.t
@@ -10,3 +10,7 @@
 -j NFQUEUE --queue-balance 0:65536;;FAIL
 -j NFQUEUE --queue-balance -1:65535;;FAIL
 -j NFQUEUE --queue-num 10 --queue-bypass;=;OK
+-j NFQUEUE --queue-balance 0:6 --queue-cpu-fanout --queue-bypass;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
+-j NFQUEUE --queue-bypass --queue-balance 0:6 --queue-cpu-fanout;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
+-j NFQUEUE --queue-balance 0:6 --queue-bypass;=;OK
+-j NFQUEUE --queue-bypass;-j NFQUEUE --queue-num 0 --queue-bypass;OK
-- 
1.9.1

