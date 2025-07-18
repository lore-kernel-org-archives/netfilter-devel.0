Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DA812E7E
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Jul 2025 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854447; cv=none; b=f4PVmnTiaeu/kuVPKEY/zh5xj05L/moCsM3qkdna0j+lFdudfnTNI2m3HC6bxO4+8dOmU7oRXB44GZ3gut3Djvlar6gVF3rANrIe/pS82jfPUpUAnVY3raz0gW8yNBXDnNoJU49/sjWZV4kwu8X5Fmfj2/gKpPT201Q9VRMS4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854447; c=relaxed/simple;
	bh=wZcPPd0gXpr5901EJWgmc2Tn2ykHvcxZQFz9jaCkHtY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ONcwTX4SWXtvaqKuxUI3LZmV36U05Zuh0RZLtgSsIPQiJgGE+29sBGq1gLEiv6o+0JQnqUqcIkDE618EKb0a3OpBTJQJTbtRVtBH4yqAvkkXbWEZTmHbsf9ReDh5ow3OUvXmqSAlJJbrHnRLPu8gZGYecWXNZUe3VzAkXSg+DCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y58Izgix; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y58Izgix"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FRbUbiP1crv4chKQVi+guCswKb23FP9C4i1OEutq1ng=; b=Y58Izgixi2ETVwu1eS28/2XoUU
	PT8+WKhi2SGD8MA/OXq0vWHOiV4Ay8Z83uxpIvF+YpZt6Afcq4swvdGPgEobd3TdCC/+8gsGyYnrE
	FEGBXEdTmV31KBPyWW5zmHc9RjoL5tY47O7ldNHLBTwrNhW0Lxp7ynJuHCJgUA6zWO6m7KK7EUVsb
	hN0oWK643vlSo6S9lSNgO9yV5A6cc4AMqykxP4ySGKJa/StFYhvocuPP7O89+9y1m6hPuMIXllwfU
	/56e/cOGFeat9kX7DiDT+B4gcdbgd8ZwBU0WA6ZLP2ryP2BMNqQwtxgpn4JZmfGfiGe+aqe7BiUSE
	XHDnQycQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ucnVl-0000000085T-2JKR
	for netfilter-devel@vger.kernel.org;
	Fri, 18 Jul 2025 18:00:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter
Date: Fri, 18 Jul 2025 18:00:32 +0200
Message-ID: <20250718160032.30444-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apart from supporting range-types, this getter is convenient to sanitize
array out of bounds access. Use it in xtables_option_metavalidate() to
simplify the code a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 64d6599af904b..ecaea4ec16cc9 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -145,8 +145,11 @@ static size_t xtopt_esize_by_type(enum xt_option_type type)
 	case XTTYPE_UINT64RC:
 		return xtopt_psize[XTTYPE_UINT64];
 	default:
-		return xtopt_psize[type];
+		break;
 	}
+	if (type < ARRAY_SIZE(xtopt_psize))
+		return xtopt_psize[type];
+	return 0;
 }
 
 static uint64_t htonll(uint64_t val)
@@ -886,6 +889,8 @@ void xtables_option_parse(struct xt_option_call *cb)
 void xtables_option_metavalidate(const char *name,
 				 const struct xt_option_entry *entry)
 {
+	size_t psize;
+
 	for (; entry->name != NULL; ++entry) {
 		if (entry->id >= CHAR_BIT * sizeof(unsigned int) ||
 		    entry->id >= XT_OPTION_OFFSET_SCALE)
@@ -900,19 +905,18 @@ void xtables_option_metavalidate(const char *name,
 					"Oversight?", name, entry->name);
 			continue;
 		}
-		if (entry->type >= ARRAY_SIZE(xtopt_psize) ||
-		    xtopt_psize[entry->type] == 0)
+
+		psize = xtopt_esize_by_type(entry->type);
+		if (!psize)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: entry type of option \"--%s\" cannot be "
 				"combined with XTOPT_PUT\n",
 				name, entry->name);
-		if (xtopt_psize[entry->type] != -1 &&
-		    xtopt_psize[entry->type] != entry->size)
+		else if (psize != -1 && psize != entry->size)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: option \"--%s\" points to a memory block "
 				"of wrong size (expected %zu, got %zu)\n",
-				name, entry->name,
-				xtopt_psize[entry->type], entry->size);
+				name, entry->name, psize, entry->size);
 	}
 }
 
-- 
2.49.0

