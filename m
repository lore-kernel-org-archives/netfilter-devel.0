From: Linmujia <linmujia@huawei.com>
Subject: [PATCH nft] null pointer exception
Date: Sat, 28 Nov 2015 01:55:13 +0000
Message-ID: <0A900C78B9F2324AB7F4F7A51D1A2F857797855C@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "pablo@netfilter.org" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47277 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbbK1Bzn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 20:55:43 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,I think I find out why my last patch stoped the execution of the tool,
If "stmt_reject_gen_dependency" do not get any payload (payload=null) , it can not call "payload_gen_dependency ",it will cause null pointer exception.

Thanks.



Signed-off-by: linmujia <linmujia@huawei.com>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7aab6aa..bcc2670 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1428,7 +1428,7 @@ static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
 	default:
 		BUG("unknown reject family");
 	}
-	return 1;
+	return -1;
 }
 
 static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
@@ -1446,6 +1446,7 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 		ret = reject_payload_gen_dependency_family(ctx, stmt, &payload);
 		break;
 	default:
+		ret = -1;
 		BUG("cannot generate reject dependency for type %d",
 		    stmt->reject.type);
 	}
-- 
2.5.1.windows.1
