From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: shell: Modify ipv6_maps_ipv4_0 file permission.
Date: Thu, 30 Nov 2017 19:06:21 +0530
Message-ID: <20171130133621.21628-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33374 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdK3Ngo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 08:36:44 -0500
Received: by mail-pg0-f68.google.com with SMTP id g7so3008923pgs.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 05:36:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the file permission of 0027ipv6_maps_ipv4_0 from
100644 to 100755.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/sets/0027ipv6_maps_ipv4_0 | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tests/shell/testcases/sets/0027ipv6_maps_ipv4_0

diff --git a/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0 b/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0
old mode 100644
new mode 100755
-- 
2.14.3

