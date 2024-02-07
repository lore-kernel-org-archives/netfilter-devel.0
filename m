Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BF5A10B
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707324527; cv=none; b=jT+tyGxBgUmOrBy5orDFxLYiOJPRUaC5m3LrIZCnvjJ//JVQrj6uoXhnU047TRYQ+qfwr7zf2056cnXOZrL/f99q+tox4E4RF1D1mNdDd2gm+xK+AbNJZSUQ1XDFp2ceSnIVMgO6mfYMCqnbeafbFLiPinHh6ATBTR0QixMV03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707324527; c=relaxed/simple;
	bh=hg8sUJ87N/IJ/CEUmHrsvhxQNgsZQyInycxguhRHXK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TnshxA4RP5nkwTOEMzEZkPK/J7mDHqNLdl43HmljJEuYhtQ4g4/6VJbINAK+ktFurA6NBnH9uFNuAYBQ3cdg56CJED3vFhyg19hkI7lRZEbA2jCHabfbPfG/HgmIt8qltB1jARUwgakQCQqtNrcRu1qaCb6Mxb2AuU5F08OM1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PZDb/Kmb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PZDb/Kmb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ibzeVVuOq8Jt2+tcliT/wnf6JWmHp0CdYFrGiGddEpk=; b=PZDb/Kmb8bkrnAZ1t9MlF9jmp5
	MLdS3L6KX3GqNW//T6RTpLO+qxXa7s5TdQStnA/8xnyYZOzf1iwPVqKqy0hx1eKBOmgbbfQ/4Gmgh
	2esHEg4lSQuC4zDgK6gAIPBXW+5QjTqV3qXh7VYlxrFFq+Ztsb4GUeSLcB0UkECHxi4vTMG8F1Fjk
	aTHpSfeFcg4N8KEDA9o02cZADR0AR0aPAfAUfFcWM4eJagyDoenKDxgelvMDo0S0teKq9w+TVRISu
	qdmEK4SB6lHigy1l25BL6vQxfqHV9RetAniVJfem6ds+nOp3t9RREjxv/1YH+X8o1xVkb/ObqkWkN
	LNG6iXMg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXl6D-000000006VR-0GlP;
	Wed, 07 Feb 2024 17:48:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	anton.khazan@gmail.com
Subject: [nft PATCH] cache: Optimize caching for 'list tables' command
Date: Wed,  7 Feb 2024 17:48:35 +0100
Message-ID: <20240207164835.32723-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No point in fetching anything other than existing tables from kernel:
'list tables' merely prints existing table names, no contents.

Also populate filter's family field to reduce overhead when listing
tables in one family with many tables in another one. It works without
further adjustments because nftnl_nlmsg_build_hdr() will use the value
for nfgen_family.

Reported-by: anton.khazan@gmail.com
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1735
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index b7f46c001d6eb..97f50ccaf6ba1 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -203,8 +203,12 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
-		if (filter && cmd->handle.table.name) {
+		if (filter)
 			filter->list.family = cmd->handle.family;
+		if (!cmd->handle.table.name) {
+			flags |= NFT_CACHE_TABLE;
+			break;
+		} else if (filter) {
 			filter->list.table = cmd->handle.table.name;
 		}
 		flags |= NFT_CACHE_FULL;
-- 
2.43.0

