Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2F22421A
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 09:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940843; cv=none; b=Yy7FmUXzXnfd3KFtgTs1RAJ7LrsB6BsDx1iCYLa5G4adm9IY1fcthKLeo2NSIvFKWirtFAzM+QjTU4W2FU9MoCysEompPzJr7GD5bsfuoc11mAmmFXrcf8X7HXD9NvXtm6xDg8AZbsq7gcarwiS40/3aSgike0WH88PAsS8k6U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940843; c=relaxed/simple;
	bh=sCwGjpqNBmnpkWo/kdkAlhOOqPgkqLqrwDGM9B/pLy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GGhCiSi6+QNLE9xHYCIylreeru6DbzluI42WG1w6rcTwciDK3uF4jy22+hwWdwcPWV1VB3ssHk3GdReU+Kpl1kNIgISqClHaOuNcjfe44Gklqjd1zzERDnwfHI4Ltunfxb9JMUMDHLpuhT75MYqO7ghqN06HW9LatJYbjU2fZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1reXZq-0000TL-34; Mon, 26 Feb 2024 10:47:14 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_json: allow 0 offsets again
Date: Mon, 26 Feb 2024 10:34:59 +0100
Message-ID: <20240226093503.5142-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its valid in case of tcp option removal:

[ {
   "reset": {
     "tcp option": {
       "base": 123,
       "len": 0,
       "offset": 0
   }

This makes nft-test.py -j pass again.

Fixes: e08627257ecf ("parser: reject raw payload expressions with 0 length")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 970ae8cb2692..ff52423af4d7 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -670,7 +670,7 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 		if (kind < 0 || kind > 255)
 			return NULL;
 
-		if (len <= 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
+		if (len < 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
 			json_error(ctx, "option length must be between 0 and %lu, got %d",
 				   NFT_MAX_EXPR_LEN_BITS, len);
 			return NULL;
-- 
2.43.2

