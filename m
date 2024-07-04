Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD8E49651
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720131096; cv=none; b=kC5V0j4xa/oXb+L/xNyLPmNyWr55EzSmt8bsiZk7P84aWBAyeOb5AY8rhM8GUocJ2saZOeGiz8u/9KcQRTwZ734Et7Z4o0r6HEjCovSs3HT0izMikLoMDJcfvjul3QFJNF8Xm7Y3BvFeY5/mhKQ7WeTohCUP87fW6Q+9QoP3QCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720131096; c=relaxed/simple;
	bh=2O2PDQkq56zY3pRKGdSLOfGBgU9RUO3Mu8h3IsVglCg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=q4AoWkNmDqzDGXZo4oPIQS5qG5DlUY24Q09okG9F9F1Zj+gYJB6yTfLDjy/SXuw2remm4IGGJiAQPdBcz6S06BWBOy7D3z/eng6j+m334NmKFH5I/MTNbIMdsgF2Y6T+hS6QVKCZp8G4LoPPeOyl+5k5dy04ZUU7eNssuEzcbTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: recursive table declaration in deprecated meter statement
Date: Fri,  5 Jul 2024 00:11:29 +0200
Message-Id: <20240704221129.357335-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is allowing for recursive table NAME declarations such as:

 ... table xyz1 table xyz2 { ... }

remove it.

Fixes: 3ed5e31f4a32 ("src: add flow statement")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
To be applied before:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240704220554.277702-1-pablo@netfilter.org/

 src/parser_bison.y | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f3f71801643d..6b167080cd93 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4212,10 +4212,11 @@ map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_
 			}
 			;
 
-meter_stmt		:	flow_stmt_legacy_alloc		flow_stmt_opts	'{' meter_key_expr stmt '}'
+meter_stmt		:	flow_stmt_legacy_alloc		TABLE identifier	'{' meter_key_expr stmt '}'
 			{
-				$1->meter.key  = $4;
-				$1->meter.stmt = $5;
+				$1->meter.name = $3;
+				$1->meter.key  = $5;
+				$1->meter.stmt = $6;
 				$$->location  = @$;
 				$$ = $1;
 			}
@@ -4228,19 +4229,6 @@ flow_stmt_legacy_alloc	:	FLOW
 			}
 			;
 
-flow_stmt_opts		:	flow_stmt_opt
-			{
-				$<stmt>$	= $<stmt>0;
-			}
-			|	flow_stmt_opts		flow_stmt_opt
-			;
-
-flow_stmt_opt		:	TABLE			identifier
-			{
-				$<stmt>0->meter.name = $2;
-			}
-			;
-
 meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
 			{
 				$$ = meter_stmt_alloc(&@$);
-- 
2.30.2

