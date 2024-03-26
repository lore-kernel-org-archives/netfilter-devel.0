Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAFD5C61F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459619; cv=none; b=tajBBxaI5oKd7S+5e8U3DZeKvMqQZI+w3CU/NbWsaoLc+MgsmiaDo3RyMa0NO0d3hpm8hvgewmRPYJoaVOPgzzaMee4/1zVfOBPWqiB3ioC4pSKoK0Jb6cswLSfqTb6wCTdbUwqc+LegHFzT3l3THQvDkQL+jkCioW21I7qNEjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459619; c=relaxed/simple;
	bh=JGnfGBiVoA0IK8mGlLwJLEEUAih9HLZgKnaFSRjukiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDcugfOQ06d+k4kOFwKRdPcw0beVztFgGVyTu21BorFT+drafOZyfrjHEkDZZCEo2Bd9f+BeuKm28hhALUSY/YQROuCdz1cOZisb/Jas/LDNnwaIf/Ylb8nWB7VZAXbnmODSq1SYhbwqiEynWKQMBE1A3POyvnMcUNKEpjnrZ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FLfsG3LP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FLfsG3LP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CSgf+XRlxespXqm3cbQ953WMWoian1X5qn3dudm7NSs=; b=FLfsG3LPGq/EiGIF54Q6dRQojF
	dlNLefX60jbIz+HynmYzMSD5LTzrDDWQPlqgthkxP9Az16x8vXYh8DpeWCHAn1qWSzQ1LUNtGtZxM
	M0uLWs3ht2f1xR3gZxjaBwwaJ9WjnC2Mi1KS3SMKRb3dE9KjFuA/MdlOthps756zP09l7yjWzdfCT
	FwCdAmR5Ks7L9yPnqKe2MFfYScnT8I5QbFeQ+FU97IJcjSjL5WbB7NssBQ7hioBPucik577FD2ySV
	WYPn6ZbdqwiDHYJ2IwO6SsTaYRh82HXXhaYTvX868wJiQrb30BixHTptNQ1uZViF3M07EOzNVbVry
	22BBNSgQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rp6pL-000000002rv-2FjH;
	Tue, 26 Mar 2024 14:26:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Quentin Deslandes <qde@naccy.de>
Subject: [nft PATCH v2 1/2] doc: nft.8: Two minor synopsis fixups
Date: Tue, 26 Mar 2024 14:26:50 +0100
Message-ID: <20240326132651.21274-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240326132651.21274-1-phil@nwl.cc>
References: <20240326132651.21274-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The curly braces in 'add table' are to be put literally, so need to be
bold. Also, they are optional unless either one (or both) of 'comment'
and 'flags' are specified.

The 'add chain' synopsis contained a stray tick, messing up the
following markup.

Fixes: 7fd67ce121f86 ("doc: fix synopsis of named counter, quota and ct {helper,timeout,expect}")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index b08e32fadcd5c..248b29af369ad 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -321,7 +321,7 @@ Effectively, this is the nft-equivalent of *iptables-save* and
 TABLES
 ------
 [verse]
-{*add* | *create*} *table* ['family'] 'table' [ {*comment* 'comment' *;*'} *{ flags* 'flags' *; }*]
+{*add* | *create*} *table* ['family'] 'table' [*{* [*comment* 'comment' *;*] [*flags* 'flags' *;*] *}*]
 {*delete* | *destroy* | *list* | *flush*} *table* ['family'] 'table'
 *list tables* ['family']
 *delete table* ['family'] *handle* 'handle'
@@ -376,7 +376,7 @@ add table inet mytable
 CHAINS
 ------
 [verse]
-{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*'] *}*]
+{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
 {*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
 *list chains* ['family']
 *delete chain* ['family'] 'table' *handle* 'handle'
-- 
2.43.0

