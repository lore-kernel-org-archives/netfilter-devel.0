From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 1/2] NFQUEUE: Fix bug with order of fanout and bypass
Date: Thu, 14 Apr 2016 20:55:58 +0530
Message-ID: <20160414152557.GA5338@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33251 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbcDNP0f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 11:26:35 -0400
Received: by mail-pa0-f65.google.com with SMTP id vv3so7074939pab.0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 08:26:35 -0700 (PDT)
Received: from shivani ([116.202.32.122])
        by smtp.gmail.com with ESMTPSA id c9sm58683163pfd.24.2016.04.14.08.26.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 14 Apr 2016 08:26:34 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFQUEUE had a bug with the ordering of fanout and bypass options which
was arising due to same and odd values for flags and bypass when used
together. Because of this, during bitwise ANDing of flags and
NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
whenever it was used before bypass because then flags would be 1.

Before this patch,

$ sudo iptables -A FORWARD -j NFQUEUE -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout --queue-bypass

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass

After this patch,

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass cpu-fanout

Closes bugzilla entry: http://bugzilla.netfilter.org/show_bug.cgi?id=939

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFQUEUE.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 8115457..0b5becc 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -99,7 +99,7 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
 	NFQUEUE_parse_v1(cb);
 	switch (cb->entry->id) {
 	case O_QUEUE_BYPASS:
-		info->bypass = 1;
+		info->bypass |= NFQ_FLAG_BYPASS;
 		break;
 	}
 }
-- 
1.9.1

