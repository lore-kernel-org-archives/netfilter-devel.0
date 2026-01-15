Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3B248F73
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768481013; cv=none; b=YXvJk2kVpGNAV8pqvQBdwR8D9mbY/IF+mJhS6r0FXSz3pRppYfr80dUNqtAfkOvMWUf+bz22P6iGWEx/MUa5nmQl/uv28qtysZRedueakvlXYResTOhyHKuqNMwW7Ug/BEoGK50sZwqM09lQ6j1RMmFvIa2Ocr3fprSBg0mHOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768481013; c=relaxed/simple;
	bh=G9nJeOMJsDY407qQg0Wyttpbh6b+wdPgLz2rqbsz3ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ShmYU2R47VWNfX3NAd8IzxL56b7MABXgXBh2hzd05YWrvlOq/9LhS+LizrRbGoO0i0bpm6C89/30A1YukJV86j2KQc1b6P62cyBvk8hyFWZBMCmJ6uy7OypLGuNI/vtFUdxALHpEozj9gyz/LRETGOhQ29tnW04xTuUXAUK8FSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tx88FRhO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tx88FRhO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 399DB605F0;
	Thu, 15 Jan 2026 13:43:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768481009;
	bh=Cu2l8HA/D9IZOrf/uPXluizz1+iFRuMEyGUYbBq+zMI=;
	h=From:To:Cc:Subject:Date:From;
	b=Tx88FRhOjwl+1UDdv0HLTcndgrkvYcqPdJ0siCGkO+9d9FI63g/nXv4CYMff0LfBM
	 0OTzB3PljPw/Lz8ybGfJX5MtlptZYBBeHKpaV7LaugmuhYEBKdlgNq1YKIqg+DX57V
	 +k3bhf1kDYPkFCCRYTgbU8/DABkU4cX+y0aQQiOw9JNqbUoBL6t21UQrmEbs/tFIg1
	 2LPC0Ch8ybGs67hm/9XUxJNBxkSDXENQsxNhZP0X8yIZRa7X3ssSYhkqGOgphkJhqW
	 E3e26ddgJFAjtaFrwzVgKofRSJggk1Kjdhe84chjqIxGjAvtKMZZwRFIBE5l6fTcFl
	 CqAwktzZiyc+g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v1 0/3] convert rbtree to binary search array
Date: Thu, 15 Jan 2026 13:43:19 +0100
Message-ID: <20260115124322.90712-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Florian reported that there is currently an issue with interval matching
in the rbtree, allowing for false negative lookup during transaction.

This series addresses this issue by translating the rbtree, which keeps
the intervals in order, to binary search. The array is published to
packet path through RCU. The idea is to keep using the rbtree
datastructure for control plane, which needs to deal with updates, then
generating a array using this rbtree for binary search lookups.

There is a corner case worth mention: Anonymous maps result in
consecutive start elements in case of contiguous intervals, this needs
a special handling which is documented in the new .commit function.

With 100k elements, this shows a little more overhead to build this
array, mainly due to the memory allocation.

This approach allows to compact the start and end elements in one single
intervals in the array, which speeds up packet lookups by ~50% according
to the existing performance script in selftests.

This is approach does not require the spinlock anymore, which is only
needed by control plane. Although I think it can be removed if .walk
is translated to dump the set content using the new array.

This also allows to remove the seqcount_t in a later patch.

Patch #1 allows to call .remove in case .abort is defined, which is
needed by this new approach. Only pipapo needs to skip .remove to speed.

Patch #2 add the binary search array approach for interval matching.

Patch #3 updates .get to use the binary search array to find for
(closest or exact) interval matching.

This series passes tests/shell successfully, but more tests on this
would be good to have because this is a bit of new code.

This series is an alternative proposal to Florian's approach.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: add .abort_skip_removal flag for set types
  netfilter: nft_set_rbtree: translate rbtree to array for binary search
  netfilter: nft_set_rbtree: use binary search array in get command

 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     |   2 +-
 net/netfilter/nft_set_pipapo.c    |   2 +
 net/netfilter/nft_set_rbtree.c    | 421 ++++++++++++++++++++----------
 4 files changed, 287 insertions(+), 139 deletions(-)

-- 
2.47.3

