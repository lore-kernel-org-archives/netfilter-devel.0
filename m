From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 10/12] nfct: fix icmp type and code output key size
Date: Tue, 3 Jun 2014 19:15:26 +0900
Message-ID: <20140603101526.GK24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61249 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFCKPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:15:33 -0400
Received: by mail-pb0-f45.google.com with SMTP id um1so5315836pbc.18
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:15:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/flow/ulogd_inpflow_NFCT.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 0b64a45..81f5bc3 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -542,10 +542,10 @@ static int propagate_ct(struct ulogd_pluginstance *main_upi,
 			     htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST)));
 		break;
 	case IPPROTO_ICMP:
-		okey_set_u16(&ret[NFCT_ICMP_CODE],
-			     nfct_get_attr_u8(ct, ATTR_ICMP_CODE));
-		okey_set_u16(&ret[NFCT_ICMP_TYPE],
-			     nfct_get_attr_u8(ct, ATTR_ICMP_TYPE));
+		okey_set_u8(&ret[NFCT_ICMP_CODE],
+			    nfct_get_attr_u8(ct, ATTR_ICMP_CODE));
+		okey_set_u8(&ret[NFCT_ICMP_TYPE],
+			    nfct_get_attr_u8(ct, ATTR_ICMP_TYPE));
 		break;
 	}
 
-- 
1.9.1

