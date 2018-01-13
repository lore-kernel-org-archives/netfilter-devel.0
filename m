From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: shell: Modify ipv6_maps_ipv4_0 file permission.
Date: Sun, 14 Jan 2018 02:51:28 +0530
Message-ID: <20180113212129.3475-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:32875 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbeAMVVo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jan 2018 16:21:44 -0500
Received: by mail-pl0-f47.google.com with SMTP id 1so1132065plv.0
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jan 2018 13:21:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the file permission of 0027ipv6_maps_ipv4_0
from 100644 to 100755.

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

