Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFB95FBB1
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711122550; cv=none; b=XGUPPS+0pMXndfKHfa6Nd7Nx1YA/l/OVWuUPZMAFWnzrNqclHLzjdDsi8klZergJ8aL+Z1o0Gv1bN4BGrQreYbrWDsm3U81RpdVY1XuXOsCDgjN6bq7GKtdlfINdYFMeUogy8g3a089HTf5YhNg6qHDeh0jen3cyqV8Lijp92vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711122550; c=relaxed/simple;
	bh=JGnfGBiVoA0IK8mGlLwJLEEUAih9HLZgKnaFSRjukiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijy4qiWzkZlCzccB2y0XWLT3M9LVPxT0kRN1gCpPtKC/SYB7nDo1PLlRJTy/XMcZ3Zw9RUeNWQYyH1m9p1UyI6fEDgIdBCEnOSUc8Xt1eev7MLh3md6Pdb29mK38w3sJQB4Ou4ceJjkLXWsN809NjzYLo7O/jAqzRjHq9AZzpcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h25fdC4T; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h25fdC4T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CSgf+XRlxespXqm3cbQ953WMWoian1X5qn3dudm7NSs=; b=h25fdC4Ti7yMnnBYc03kFkI5SE
	Xxb9q0prUfTHf5QtHpKASQpxgO3G/g5Gwt3gPMGSRzoRT5DKB0uiWKebjmwC9M+ZOS/ACKlqUE01h
	1u+pPlN3Pp+s7yQNj0ooDjviq7ZwBdqKyktzIj7suf+yRsqKRgMtjXfbfuWYKog6R8qo0ZNEOXC1P
	GNgAP6zPwZ0J5EzdVylkoh5e0wtQIoN0Wp90pxhvAHfNN4F/wkwueEjls5d7PhGG3wYGhvV9FK2+G
	zIC11GFtuuWoL6JAsM1RB/MmkbaiKp1bMB7nf1B45vb8ZectnZV/6/jhXJsM3076eEYXZAHE+OeDz
	42L59DEQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnh8e-000000000nj-0XDi;
	Fri, 22 Mar 2024 16:49:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] doc: nft.8: Two minor synopsis fixups
Date: Fri, 22 Mar 2024 16:48:54 +0100
Message-ID: <20240322154855.13857-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322154855.13857-1-phil@nwl.cc>
References: <20240322154855.13857-1-phil@nwl.cc>
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

