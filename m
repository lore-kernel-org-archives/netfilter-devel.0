Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FFA3D4107
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 13:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773927168; cv=none; b=nZxZc95e0/g6zHNrjmSohHjRuECIOtt/xyUUqQeaTimZpdgJrEZHCIz+J8DToVLZ95JU1Gni4AjfT5V+FGRqMdTMxl1U+aTz2/1QzQ9Oj2F25Ubrs85gRBdy784wRZ9Vqi/2R6of+XZqZFSBQd6f1RcFJJLzvZej7w7G5GBbOZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773927168; c=relaxed/simple;
	bh=pG8OiauXxB5luu3ivObKkKwQ1y8QwA4Qidu+KSXh8jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XxF0L/YWkgWOuDc8Pq5DZSG+JHIJFZXDn1cAdtQs+cO7VKV4xZg0yCx5EOsnjCHN1qfSrszKvHN1+3ZI/ecNUlb3hRfTrhszADHiCT+GUMuKVYYC1f5omNgZdATBxy6DWiybShRV/tOPLGUPD5KTTMieshuYma82mbMFPVyEYjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DJ96k0yh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DJ96k0yh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KFUH9xmsijtfXD3BELLRhk5+H0NIENiSzhnAjQxj0z0=; b=DJ96k0yha5hdjBvSepwaaHOMK9
	zTlZyrQAq2JyY9EvBufwin11O9oJePRifEe9hGveFS5ldml60ef5I5SN+9FBnRLl7O/nAns0Qqa9b
	OXuF0g9A0LxQ13bLJ+e4QzrOqnbSLiBrEuvD3TWgm6lLA9Ksg6z96ZaumeLtWpTuR+PeTg0eFC2v0
	R9RZZzXAUbWxR0GrdszzEES2QgnusUNSNs1+DDCbqeGVaqb/meoltucIjsdGj2EUwSEHv/7keKB7D
	3SUnAFKJNBa3ZmfTz9Qd8twQwujjyT2TXyPrKerYQiSRqoXZi4pEAo9o20UzszShYzVhi7sTxqoEe
	b3uCUpqA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3DUT-000000004Aw-0upO;
	Thu, 19 Mar 2026 14:32:45 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Winship <danw@redhat.com>
Subject: [nft PATCH] parser: Support table spec in 'list chains' command
Date: Thu, 19 Mar 2026 14:32:40 +0100
Message-ID: <20260319133240.20143-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it possible for users to list all chains in a given table.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt        | 2 +-
 src/parser_bison.y | 2 +-
 src/parser_json.c  | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index b1f7a83aeb78a..cee92c2bc8303 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -390,7 +390,7 @@ CHAINS
 ____
 {*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' ['DEVICE'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
 {*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
-*list chains* ['family']
+*list chains* ['family'] ['table']
 *delete chain* ['family'] 'table' *handle* 'handle'
 *destroy chain* ['family'] 'table' *handle* 'handle'
 *rename chain* ['family'] 'table' 'chain' 'newname'
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8a470bda942e7..5a334bf0c4997 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1669,7 +1669,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
-			|	CHAINS		ruleset_spec
+			|	CHAINS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAINS, &$2, &@$, NULL);
 			}
diff --git a/src/parser_json.c b/src/parser_json.c
index f444b8a0f52f9..2f70b9877c6ed 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4140,6 +4140,7 @@ static struct cmd *json_parse_cmd_list_multiple(struct json_ctx *ctx,
 		}
 	}
 	switch (obj) {
+	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_CT_HELPERS:
-- 
2.51.0

