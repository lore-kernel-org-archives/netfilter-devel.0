From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] ip6: Add tests for icmpv6 packet types
Date: Tue, 19 Jan 2016 00:44:48 +0530
Message-ID: <20160118191448.GA10814@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33845 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbcARTOy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2016 14:14:54 -0500
Received: by mail-pf0-f178.google.com with SMTP id q63so166714618pfb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 11:14:54 -0800 (PST)
Received: from gmail.com ([106.204.155.198])
        by smtp.gmail.com with ESMTPSA id 16sm35723509pfh.48.2016.01.18.11.14.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 18 Jan 2016 11:14:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add tests for the icmpv6 packet types policy-fail and reject-route to be
used with REJECT target.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 tests/regression/ip6/reject.t             | 2 ++
 tests/regression/ip6/reject.t.payload.ip6 | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/tests/regression/ip6/reject.t b/tests/regression/ip6/reject.t
index 60dec90..925c976 100644
--- a/tests/regression/ip6/reject.t
+++ b/tests/regression/ip6/reject.t
@@ -6,6 +6,8 @@ reject with icmpv6 type no-route;ok
 reject with icmpv6 type admin-prohibited;ok
 reject with icmpv6 type addr-unreachable;ok
 reject with icmpv6 type port-unreachable;ok;reject
+reject with icmpv6 type policy-fail;ok
+reject with icmpv6 type reject-route;ok
 reject with tcp reset;ok;ip6 nexthdr 6 reject with tcp reset
 
 reject with icmpv6 type host-unreachable;fail
diff --git a/tests/regression/ip6/reject.t.payload.ip6 b/tests/regression/ip6/reject.t.payload.ip6
index aa0b9ff..fcae382 100644
--- a/tests/regression/ip6/reject.t.payload.ip6
+++ b/tests/regression/ip6/reject.t.payload.ip6
@@ -18,6 +18,14 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ reject type 0 code 4 ]
 
+# reject with icmpv6 type policy-fail
+ip6 test-ip6 output
+  [ reject type 0 code 5 ]
+
+# reject with icmpv6 type reject-route
+ip6 test-ip6 output
+  [ reject type 0 code 6 ]
+
 # reject with tcp reset
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
-- 
1.9.1

