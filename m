Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B0E1D54B
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 13:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197471; cv=none; b=rezr0V4WQf88jt+69hbDCpfUYB23W3iocXNmRhKBwAHQHjKS7vLQ7ghdN1ntbbhg4kJnTLcybeI0VwcG6jz/Yfw87obBm08S3RWYhfBtZ60h+fosd3K6FmhFfGNrVA3doYCQh2smCMdX1VORfpbJ8R7xd1zeEgiHcdxpIWt1IuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197471; c=relaxed/simple;
	bh=QuJTkKGLKs0HprWi/XK8O7ZVtY8+UwULuUumyyVjb/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VtKq21hL7AZ3C1J6VHzxa/kEjxEL5EdLo8kVf+8UtLOQZekwbWRwBuS3ehTCXO6x6Jsjpm0N5+6syLX56Bk/nFZwTxn0lydEBoODyRa/ebEuAKt/H1I7jH9U3QDHErekX+qWKh72msGxCYvNu9eeb/anf+57WWRml2VP2EbOF0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RiZyv5Ba; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RiZyv5Ba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vrAlztVKOohJ59TYTUItAZOuDtT8wvR8GcBItI11huA=; b=RiZyv5Ba2gdqPNCdrpNLarBmAI
	Wr08/JXAO5BWbh+iEA77uSrteXVHdhCLOENO7+o8wSw00Y+/lJs3154J2GK296QfvNYnzUGA9lbw0
	rygOKa2N9GJdnhnrF42u9oYrLyuOaao7w5E9s9hkiEQbuCyz71IspngAEg9SmdGcL4T5zuZiCoGho
	DGDobpCqA73DaWbdTkTSHKP4KWqvzpCZnS51TWpNGmBGFE13ekkFBfwjBwkE5y6J6s6MYKlrzTBlr
	28kgaqOaDEht83nr5hKZ3Gq5DYjQAf0nDrzLEj6P8dzgdN2UTK5WOf3UQV6JTGFIXim9hguJg6lG7
	am03bphg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHNHm-000000006cd-2uB9;
	Wed, 12 Jun 2024 14:41:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Michael Estner <michaelestner@web.de>
Subject: [iptables PATCH] ebtables: Include 'bitmask' value when comparing rules
Date: Wed, 12 Jun 2024 14:41:09 +0200
Message-ID: <20240612124109.19837-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The former FIXME comment pointed at the fact that struct ebt_entry does
not have a 'flags' field (unlike struct ipt_ip). In fact, ebt_entry's
equivalent is 'bitmask' field. Comparing that instead is the right
thing to do, even though it does not seem to make a difference in
practice: No rule options alter just the bitmask value, nor is it
possible to fill an associated field with default values (e.g. all-zero
MAC and mask).

Since the situation described above might change and there is a slight
performance improvement in some cases (e.g. comparing rules differing
only by specified/omitted source/dest MAC address), add the check
anyway.

Suggested-by: Michael Estner <michaelestner@web.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 922ce98385400..f4a3c69ac1660 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -373,9 +373,9 @@ static bool nft_bridge_is_same(const struct iptables_command_state *cs_a,
 	int i;
 
 	if (a->ethproto != b->ethproto ||
-	    /* FIXME: a->flags != b->flags || */
+	    a->bitmask != b->bitmask ||
 	    a->invflags != b->invflags) {
-		DEBUGP("different proto/flags/invflags\n");
+		DEBUGP("different proto/bitmask/invflags\n");
 		return false;
 	}
 
-- 
2.43.0

