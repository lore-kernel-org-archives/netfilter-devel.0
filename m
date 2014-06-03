From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 09/12] nfct: fix ipfix field_id of flow.end.usec
Date: Tue, 3 Jun 2014 19:13:53 +0900
Message-ID: <20140603101353.GJ24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40015 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaFCKN7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:13:59 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so4512213pde.32
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:13:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/flow/ulogd_inpflow_NFCT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3..0b64a45 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -399,7 +399,7 @@ static struct ulogd_key nfct_okeys[] = {
 		.name	= "flow.end.usec",
 		.ipfix	= {
 			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowEndSeconds,
+			.field_id	= IPFIX_flowEndMicroSeconds,
 		},
 	},
 	{
-- 
1.9.1

