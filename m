From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] src: proto: Add missing packet type
Date: Tue, 1 Mar 2016 18:09:12 +0530
Message-ID: <20160301123912.GA6905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33789 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbcCAMjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 07:39:20 -0500
Received: by mail-pf0-f182.google.com with SMTP id 124so50627015pfg.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 04:39:20 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id l62sm45463328pfj.7.2016.03.01.04.39.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 04:39:18 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing packet type "invalid" for DCCP.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 src/proto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/proto.c b/src/proto.c
index 0ed98ed..4d049f5 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -443,6 +443,7 @@ static const struct symbol_table dccp_pkttype_tbl = {
 		SYMBOL("reset",		DCCP_PKT_RESET),
 		SYMBOL("sync",		DCCP_PKT_SYNC),
 		SYMBOL("syncack",	DCCP_PKT_SYNCACK),
+		SYMBOL("invalid",	DCCP_PKT_INVALID),
 		SYMBOL_LIST_END
 	},
 };
-- 
1.9.1

