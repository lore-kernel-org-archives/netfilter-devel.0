Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739629C328
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236086; cv=none; b=DZxflIjJyuf9W7CFRnZoFI5pgWlrLHNpE94vSWfM9/IOUqQtTEO6322nEvfooLH5p1A8tzSKg6i9PbOScrksHz6Dp3oRxAYj3zRfGsRlFkqpokm6j9TQDCLCBnqtDcbeggELVdk3kYH8Xlcp1rmWTt13ZN7ujC28W+mvXMCsazQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236086; c=relaxed/simple;
	bh=fDz8lciUizmJH7Kzu7DZ/pL+Ycuj4097bpv1ShyxM7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWcx6zHJZTh4J+qZbZimb+YwWdaht6ZVdlHChEDKRBeNQruft6ukweXlZzqtZ19XtzYBdJBVrSaEQ0mcYiLeVHFDd+jeOkGsLb6NHvQW8s/C2/lT/VFZuHT5dA3tRLhRAWcFWRea/7SJ8ZDJynISmsdBw3m5mmoYEkCnBiPlMAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l7iObTI+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l7iObTI+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sF4AXOYGKqAffjFsQ1XGzQT10jPtXjS2MjKEhgCYsc8=; b=l7iObTI+T9uDhJWuXO/j4TzrE0
	C70e3lQsyfG5WF5a/MsW16COmDECG5FoZzqQ9GLQyZIx37Hn7iOHK89D+OIAV7XaCWb2F8UbxUcWw
	VQOWP30XHMc2CtIKBUAzecjYeJ2rIWOdeAkY68xLYcdL45dAU30vYN2HTw+LHvvca0A5s7wIqkgHG
	HQwLn7D+fs1q74yImfpGQlcV2CQKZSya8j1Vnay327UGt8kgBU4wuz9U5mHgUts7cIQKiDUFYZYUi
	qhcdFes9pJYtqKbvgp6+NtudetmSt2VWxkH9RrSdLhDDdb6TXAS0DBmQqRDD2rvUt6v8Dzh+xwSzJ
	ECwq8TOw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxa-0000000006P-0iRJ;
	Thu, 23 Oct 2025 18:14:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 18/28] segtree: Drop problematic constant expr len adjustment
Date: Thu, 23 Oct 2025 18:14:07 +0200
Message-ID: <20251023161417.13228-19-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changing a string-based expression's length will break listing on Big
Endian hosts as the exported data is padded "on the wrong end".

Since not adjusting the length seems not to cause any problems, just
drop it instead of trying to fix it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index ab107493ea97b..7d4c50f499ef7 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -413,7 +413,6 @@ void concat_range_aggregate(struct expr *set)
 				tmp = constant_expr_alloc(&r1->location, r1->dtype,
 							  BYTEORDER_BIG_ENDIAN,
 							  (str_len + 1) * BITS_PER_BYTE, data);
-				tmp->len = r2->len;
 				list_replace(&r2->list, &tmp->list);
 				r2_next = tmp->list.next;
 				expr_free(r2);
-- 
2.51.0

