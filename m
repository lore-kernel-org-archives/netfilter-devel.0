From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] iptables: xtables-eb: Remove const qualifier from struct option
Date: Thu, 30 Nov 2017 19:18:05 +0530
Message-ID: <20171130134806.21737-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38698 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdK3Nsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 08:48:33 -0500
Received: by mail-pg0-f67.google.com with SMTP id f12so3013292pgo.5
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2017 05:48:32 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As opts is reassigned multiple times, it cannot be made constant.
So remove const qualifier from structure option. This patch fixes the
following warning.

xtables-eb.c: In function ‘ebt_load_match_extensions’:
xtables-eb.c:653:7: warning: assignment discards ‘const’ qualifier
from pointer target type
  opts = ebt_original_options;

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 iptables/xtables-eb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 60ec935c..c8b5d4f3 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -247,7 +247,7 @@ static int get_current_chain(const char *chain)
 
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
-static const struct option ebt_original_options[] =
+static struct option ebt_original_options[] =
 {
 	{ "append"         , required_argument, 0, 'A' },
 	{ "insert"         , required_argument, 0, 'I' },
-- 
2.14.3

