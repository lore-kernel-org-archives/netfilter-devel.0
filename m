Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07E71B043F
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981628; cv=none; b=X57jX3CKnwggRAx1LT186mGQtO+0FNWNBAQADAcPTbXoqNb1uhhWPKD4u6xeo490Eke1ucLdA1PB0DIHGWi8KOsq3gxXkS95Yp0hEz1oIeJy3QDO0NY4oVomrecxG+ShX8DZSBgJAdMIqZY+zuttpenEZwonkIRU9qSzPgh3JV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981628; c=relaxed/simple;
	bh=/tItMw0W0WbrUUhiD4aoC5641/sQuxbe1x5EvkJlYRM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=JWT2iqq/QfxXIzQFrhGyRJg6OA8QRG3ouAztOqelAojYntJVBkYeL7JhIDa22sq5K/v3VXdOkNjNt5owEPiDseJsdaZNV5sLrlte45NrRlhYq3xNFSBac/LvgIr6hgyysvNQSV7LjW41selNSkQaCSDXjEHLxgPMt2JmXVezrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QAGPJocG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QAGPJocG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QAGPJocG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QAGPJocG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 82F47602BE; Sun, 15 Jun 2025 12:00:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981623;
	bh=MqzQYt0z2KD6Y/MmJ8fknEJnrMBmhvf2Qx6o743SvVQ=;
	h=From:To:Subject:Date:From;
	b=QAGPJocGAW9/C/GMRGQSyLMTxuZdwUgV+sTN3QgTyS4mrDbYZ/2PI+LLnXPDLSIcY
	 YgtIMGxoxkkYL8sM9FNA9/dWu+BE3BSlkpX2X7aW2BMg3XHBUUw70xKprobHK2myzG
	 UWeBRjOwk+g2vUe6f3wUXEXqHNNK3+Cno3dDh1PCRYxNhFHDfJ0pgZ4bBHlYredN92
	 cGD22gK0+fOh7gbqxV4Pig1IL44+8DqFOpoiDSH9xxGpnmngKaqBdDEwNW2s9MMWcc
	 fPJkA7a+iflmVhkLDyqqQ+21psHEnxnW5VUDLVYjoxDgYu3NCTrP85OIcGFtXNbanL
	 B1VRfMCIgK0rw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C925602BC
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981623;
	bh=MqzQYt0z2KD6Y/MmJ8fknEJnrMBmhvf2Qx6o743SvVQ=;
	h=From:To:Subject:Date:From;
	b=QAGPJocGAW9/C/GMRGQSyLMTxuZdwUgV+sTN3QgTyS4mrDbYZ/2PI+LLnXPDLSIcY
	 YgtIMGxoxkkYL8sM9FNA9/dWu+BE3BSlkpX2X7aW2BMg3XHBUUw70xKprobHK2myzG
	 UWeBRjOwk+g2vUe6f3wUXEXqHNNK3+Cno3dDh1PCRYxNhFHDfJ0pgZ4bBHlYredN92
	 cGD22gK0+fOh7gbqxV4Pig1IL44+8DqFOpoiDSH9xxGpnmngKaqBdDEwNW2s9MMWcc
	 fPJkA7a+iflmVhkLDyqqQ+21psHEnxnW5VUDLVYjoxDgYu3NCTrP85OIcGFtXNbanL
	 B1VRfMCIgK0rw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/5] assorted updates and fixes
Date: Sun, 15 Jun 2025 12:00:14 +0200
Message-Id: <20250615100019.2988872-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This batch contains several assorted updates and fixes:

1) Skip lookup for mistyped names if handle is used.
2) Assert of non-nul name when {table,chain,obj,flowtable}_cache_find()
   is used to catch for bugs when handle is used.
3) Consolidate repetitive cache name hash.
4) Restrict reset command to use name only because NFT_MSG_GETSET and
   NFT_MSG_GETSETELEM is missing lookup by handle in the kernel.
5) Allow to delete a map with handle, for consistency with the existing
   command to delete a set.

Pablo Neira Ayuso (5):
  rule: skip fuzzy lookup if object name is not available
  cache: assert name is non-nul when looking up
  cache: pass name to cache_add()
  parser_bison: only reset by name is supported by now
  parser_bison: allow delete command with map via handle

 include/cache.h                               |  2 +-
 src/cache.c                                   | 60 ++++++++-----------
 src/parser_bison.y                            |  6 +-
 src/rule.c                                    | 12 ++++
 .../bogons/nft-f/null_set_name_crash          |  2 +
 .../testcases/cache/0008_delete_by_handle_0   |  4 ++
 .../cache/0009_delete_by_handle_incorrect_0   |  1 +
 7 files changed, 47 insertions(+), 40 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_set_name_crash

-- 
2.30.2

