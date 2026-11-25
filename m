Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597489;
	b=low1Yt1YjRW1QOvoxRTzaiNZKDu+VMbbbqKxKix6UrO7HQTOF4cxFkyxnA5bvVl9c/BG
	 p+pRVPG8NblUCFILn7Ui0x+wiJ/uWFDHBjTEmI10m73KDsOluhxLYSHUJ5pOx+URAMxqk
	 HbpjhnavAFSx4M87jSJyPv2/ftgkHN4N79v6BO5YXf3E02W8naKos1Oyh23yrhALNosd2
	 GJtiiRELzDxnPlzw8IUARmxZWz93Y1p9pbhGViXkkpKyV4SgLECDh3TKQVO6AlACZOYDe
	 JpDtUUQKPUUGmZG+UgZlbSh9PpXELz++seFM8bO7AZ4hYpwueu3D+5isd6hLOWziTeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597489;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SK/vQ67Q0GrY1dffuqODb/7WKLfTDGoCFzwmJenCxhU=;
	b=DDsqKOG+a9RkQ+iLXZV4alZHyGDhBsH/G63SGHxmoOHPmQOPh4lzmD3yfACMg+RXG3gB
	 JrSyxmm9x0dZqa2rYsS6IwWuIrtjDdIq4I3QFSaFOXdr46n1ooxEUHdp4oSaSyuqpRgdp
	 xjX5jbiJkZZrAnuRLtCddTWYuEMbvH3abMP8WWcFNMuXFJ5SLIG/rnddJ7tcFtvwKzAYQ
	 rG3eASOQScUJ/a6fDHs7XCWufmtTwSm/xul7tLawQZZvtkroJcFmF7IxcrvoGEKw1YtmD
	 V9tSTUcjausWoxoeV0rsbvq89Lr5TFGpCJz1m66zprbCFmlZ3QIbBSKIlGrg2lmmMuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5CC606A327
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 09:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A5CC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3dc2c1d0e8af11f19a56ed5b684f684d-20261125
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e14a43a4-44b3-4893-820e-1513da1464ca,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:54640c0a0ebecce4409cc2e082cb77ff,BulkI
	D:nil,BulkQuantity:0,SF:102|136|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-
	100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3dc2c1d0e8af11f19a56ed5b684f684d-20261125
X-User: yupeng@kylinos.cn
Received: from send-mail.xgjqo8 [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yupeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1311506640; Wed, 25 Nov 2026 17:04:37 +0800
From: YuPeng <yupeng@kylinos.cn>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,phil@nwl.cc,debianyu@163.com
Subject: [PATCH] ebtablesd: Fix missing arguments for %s in error messages
Date: Wed, 25 Nov 2026 17:04:35 +0800
Message-ID: <1795597475442100152.16763@kylinos.cn>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Five ebt_print_error() calls in ebtablesd.c use a "%s" format
specifier without passing the corresponding argument.  As
__ebt_print_error() is variadic, this is undefined behaviour and what
gets printed depends on leftover register contents.  With current gcc
output on x86-64 the preceding strcmp() happens to leave argv[2] in
the variadic argument register, so the message usually still names the
table; different code generation or a different call site can print
garbage, print "(null)", or crash instead of reporting the error.

Pass argv[2], which holds the table name for the free, open, fopen,
commit and fcommit commands, as the calls just around these already do.

This fix was originally carried in the Kylin Linux SRPM since 2022;
the commit message has been rewritten to describe the behaviour
observed on current master.

Signed-off-by: YuPeng <yupeng@kylinos.cn>
---
 ebtablesd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ebtablesd.c b/ebtablesd.c
index 02d51fa..930fc66 100644
--- a/ebtablesd.c
+++ b/ebtablesd.c
@@ -194,7 +194,7 @@ continue_read:
 			}
 			if (!(replace[i].flags & OPT_KERNELDATA)) {
 				ebt_print_error("ebtablesd: table %s has not "
-				                "been opened");
+				                "been opened", argv[2]);
 				goto write_msg;
 			}
 			ebt_cleanup_replace(&replace[i]);
@@ -219,7 +219,7 @@ continue_read:
 			if (replace[i].flags & OPT_KERNELDATA) {
 				ebt_print_error("ebtablesd: table %s needs to "
 				                "be freed before it can be "
-				                "opened");
+				                "opened", argv[2]);
 				goto write_msg;
 			}
 			if (!ebt_get_kernel_table(&replace[i], 0)) {
@@ -248,7 +248,7 @@ continue_read:
 			if (replace[i].flags & OPT_KERNELDATA) {
 				ebt_print_error("ebtablesd: table %s needs to "
 				                "be freed before it can be "
-				                "opened");
+				                "opened", argv[2]);
 				goto write_msg;
 			}
 			tmp.filename = (char *)malloc(strlen(argv[3]) + 1);
@@ -296,7 +296,7 @@ continue_read:
 			}
 			if (!(replace[i].flags & OPT_KERNELDATA)) {
 				ebt_print_error("ebtablesd: table %s has not "
-				                "been opened");
+				                "been opened", argv[2]);
 				goto write_msg;
 			}
 			/* The counters from the kernel are useless if we 
@@ -324,7 +324,7 @@ continue_read:
 			}
 			if (!(replace[i].flags & OPT_KERNELDATA)) {
 				ebt_print_error("ebtablesd: table %s has not "
-				                "been opened");
+				                "been opened", argv[2]);
 				goto write_msg;
 			}
 			replace[i].filename = (char *)malloc(strlen(argv[3]) + 1);
-- 
2.39.5
