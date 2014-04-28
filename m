From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 10/13] nfct: fix ipfix field_id of flow.end.usec
Date: Mon, 28 Apr 2014 20:53:41 +0900
Message-ID: <20140428115341.GK12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62418 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaD1Lxs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:53:48 -0400
Received: by mail-pd0-f178.google.com with SMTP id fp1so3505012pdb.9
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:53:47 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id nw13sm67078581pab.37.2014.04.28.04.53.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:53:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
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

