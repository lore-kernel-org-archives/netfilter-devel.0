From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-queue PATCH] nlmsg: add lacking attributes validation
Date: Fri, 11 Sep 2015 10:54:53 +0900
Message-ID: <20150911015452.GA6310@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33264 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbIKBy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 21:54:58 -0400
Received: by pacex6 with SMTP id ex6so59571848pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 18:54:57 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id xm9sm14417852pbc.32.2015.09.10.18.54.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2015 18:54:57 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds four (actually two) attributes validation with
comparing to current kernel header.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/nlmsg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index cabd8be..ba28c77 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -140,6 +140,7 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFQA_SECCTX:
 	case NFQA_UID:
 	case NFQA_GID:
+	case NFQA_CT_INFO:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			return MNL_CB_ERROR;
 		break;
@@ -155,7 +156,15 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFQA_PACKET_HDR:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfqnl_msg_packet_hdr)) < 0) {
+			return MNL_CB_ERROR;
+		}
+		break;
 	case NFQA_PAYLOAD:
+	case NFQA_CT:
+	case NFQA_EXP:
 		break;
 	}
 	tb[type] = attr;
-- 
2.1.4

