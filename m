Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7102F28B519
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195743; cv=none; b=AQNsci8ydRzdNjYHEdcTpLLEyucRZ7KAA6IgE2rCXEP0TfPywdsJJn/ekA1F+sGziTJooAbCwVFFEBqR+wCKzGNg4GEO7paM/ASVHD9pJmmfasdvvwXevSEf56wOlfEV/x1l/gRhprwZ1db5jFjK3A72fZgW7W2kkeyUp1OiAHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195743; c=relaxed/simple;
	bh=hRTszqWt2MnEx4urghHDcrQorhswui5Bt5vlcklPqRU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TaEKIZR638NMdApKUSzkmHXHXECXvAf3USoRwsnzVLbXqkqqmJvIXoMonRWuCddg4D+kIk40Vy+8EdFKDJ1nKF3ZfaADeyz9InorOhDh5OGG/8sjeZ45ptNWzEjZaA0suOX5aSy7r1SvyaN/j/80dRqaHkuOdG7BC/AULczSTcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hFboQroq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hFboQroq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=74HfQITydnNJotAP/bMVql7xxt5BhumXkkJhxb5wOtA=; b=hFboQroq0s9lF52Qj6WYALIJaM
	QL8wSU9nKhIi9DDgAM+S406aaSl0r1C2P3mC1hnvLqmOjZK2vwPMfuPZxYR6KnlQ6Vn2Ge3oO52cK
	dGvQKoThNsMsfcYkg/5Y3RxSQhvqSE2Feh9cVp+siQjx7ufWAL4RU/n3WJqnCLfXM9JK8+iq47eb3
	xwvivwLvzfTiHXeIilPMos+R1vMUCbTKmJxKEboBWEGWzPljubL3/YyownSLGMJtChCln1JGy8EDf
	eCTUt5lybOxHgd7JyYtAbqynU+8Y0y1hmq/YJJPzlhlhuK/gapU/QuBUP9+EXsjJtUt7mumcj9KIs
	N+Q1FuFg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueEIc-0000000044S-1uAm
	for netfilter-devel@vger.kernel.org;
	Tue, 22 Jul 2025 16:48:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] Revert "libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter"
Date: Tue, 22 Jul 2025 16:48:52 +0200
Message-ID: <20250722144853.21022-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 786b75f7c9b9feaa294da097c2e9727747162c79.

The internal routine xtopt_esize_by_type() is *not* just a fancy wrapper
around direct xtop_psize array access, as clearly indicated by the
comment right above it: It will return the single field size for
range-value types (XTTYPE_UINT*RC).

Using it in xtables_option_metavalidate() leads to spurious "memory
block of wrong size" complaints.

Fixes: 786b75f7c9b9f ("libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index ecaea4ec16cc9..64d6599af904b 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -145,11 +145,8 @@ static size_t xtopt_esize_by_type(enum xt_option_type type)
 	case XTTYPE_UINT64RC:
 		return xtopt_psize[XTTYPE_UINT64];
 	default:
-		break;
-	}
-	if (type < ARRAY_SIZE(xtopt_psize))
 		return xtopt_psize[type];
-	return 0;
+	}
 }
 
 static uint64_t htonll(uint64_t val)
@@ -889,8 +886,6 @@ void xtables_option_parse(struct xt_option_call *cb)
 void xtables_option_metavalidate(const char *name,
 				 const struct xt_option_entry *entry)
 {
-	size_t psize;
-
 	for (; entry->name != NULL; ++entry) {
 		if (entry->id >= CHAR_BIT * sizeof(unsigned int) ||
 		    entry->id >= XT_OPTION_OFFSET_SCALE)
@@ -905,18 +900,19 @@ void xtables_option_metavalidate(const char *name,
 					"Oversight?", name, entry->name);
 			continue;
 		}
-
-		psize = xtopt_esize_by_type(entry->type);
-		if (!psize)
+		if (entry->type >= ARRAY_SIZE(xtopt_psize) ||
+		    xtopt_psize[entry->type] == 0)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: entry type of option \"--%s\" cannot be "
 				"combined with XTOPT_PUT\n",
 				name, entry->name);
-		else if (psize != -1 && psize != entry->size)
+		if (xtopt_psize[entry->type] != -1 &&
+		    xtopt_psize[entry->type] != entry->size)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: option \"--%s\" points to a memory block "
 				"of wrong size (expected %zu, got %zu)\n",
-				name, entry->name, psize, entry->size);
+				name, entry->name,
+				xtopt_psize[entry->type], entry->size);
 	}
 }
 
-- 
2.49.0

