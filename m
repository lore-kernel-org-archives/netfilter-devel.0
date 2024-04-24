Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9582C157486
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996052; cv=none; b=bPPk5HYpgj3SbrP9PY/tZ1n06mJyGY+kaRqdqM9mCfpFW7mfHNbX8tdV4BuCt4L2LngGlEVICv5xaLtkafZ0FHMGcgvu4+CZrynogNITHUYhpSJOxI6rg7g7jPWjnq3sCAfGJgU8ga2pkoHqy4/5SZaRNrveNDU9U/llr+Wu28c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996052; c=relaxed/simple;
	bh=Ey7sdEQDLhCzHu8vxnHfjsDgDThSsE5kTji/M1uK4x8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sXLvrfS6kwQiqy5Veh3QM08FXIOxPSZOZTJ8czxBhufCxAkvgKUl+vuiiLmgtDXtjZ/JqlMRtqVhhuwYmYZlwf9dbia9rDkaetHvl1l8U73L94I7YkERbkg3+2D47VOawYzLcVYpvYVsYRUAgbseWhLpav0r2fEfUzSAuaL//NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IUlsFgcK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IUlsFgcK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EFtK4bxWqLmuTmdbv0OvCEBoLtLeGl2hY1efiT2jgl4=; b=IUlsFgcKXGGtxaBMByUia88dlX
	3EiJ1TPWKHTWtzFXy64csL2PoOLtE3zDVNG16R2U7f6mKKCIhgtKmNK2WrueN87Bs7teQa6umdY8h
	YFDd5JsWSuljWdU526+NjfbTtofxKx7tizvY3sg04R+CNVMY3vIqluxYsuO33N3bfhJAg3C2H61tj
	WyNOPT4j5E4skSaaeCCCNNtRCgtpZXO9fOr3aKemXcxkPuyXFGtay2Xt4gwJv3gKcCIdpe8Y8/AYu
	hMQgwXgAQbucSH3NiwJouNGRwk2CcnqxYULznd0HxXX9/+9/+Dd5EIFsdZdPoB/3d1u8PJ9EsZ80x
	GgvR2yiw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzkfY-000000003vF-3XZx
	for netfilter-devel@vger.kernel.org;
	Thu, 25 Apr 2024 00:00:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] doc: nft.8: Fix markup in ct expectation synopsis
Date: Thu, 25 Apr 2024 00:00:47 +0200
Message-ID: <20240424220048.19935-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just a missing asterisk somewhere.

Fixes: 1dd08fcfa07a4 ("src: add ct expectations support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/stateful-objects.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
index 00d3c5f104631..5824d53ad88f3 100644
--- a/doc/stateful-objects.txt
+++ b/doc/stateful-objects.txt
@@ -119,7 +119,7 @@ sport=41360 dport=22
 CT EXPECTATION
 ~~~~~~~~~~~~~~
 [verse]
-*add* *ct expectation*  ['family'] 'table' 'name' *{ protocol* 'protocol' *; dport* 'dport' *; timeout* 'timeout' *; size* 'size' *; [*l3proto* 'family' *;*] *}*
+*add* *ct expectation*  ['family'] 'table' 'name' *{ protocol* 'protocol' *; dport* 'dport' *; timeout* 'timeout' *; size* 'size' *;* [*l3proto* 'family' *;*] *}*
 *delete* *ct expectation*  ['family'] 'table' 'name'
 *list* *ct expectations*
 
-- 
2.43.0

