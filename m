Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC663EDAB3
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2026 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332170; cv=none; b=Buw8DkgTo3JIlbR4uYtaI+rx9merQtiC+W3t72gLpZozejP9APjXMsd5ryqmZxWX+Xf9TfDrMvsHz4Q3b8pmwhc+ZD8O/bRy5RL3mlPZo37dNNYe4W5pxm21s9/drq4QG9isiLHOJsJRDUb3JPQYVTNsTDjt4F3o/eK3PgWtt6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332170; c=relaxed/simple;
	bh=W8pkpnWq2gliL9/XOuBSDf7ZSoWhI/j52WWtHSE9Too=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Byxoe4KD0rik6NKi5lZiLPrNYKH43XeDdgDc5WlTQjEv4gSaFmMPyYEojCg8OdbubI+72ku9Y/ZhMC+4pOCY5eKoQkE8vLLwSWsni9JgUU661ImDAls4a4dQJwagpjmePL+u2SZw8NBPsvVquguCMKwHtSzjCtS0P59keN6Z7+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BB86C60491; Mon, 06 Jul 2026 12:02:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ebtables: zero chainstack array
Date: Mon,  6 Jul 2026 12:02:36 +0200
Message-ID: <20260706100239.32725-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko reports:
 looking at ebtables table
 translation, could a sparse cpu_possible_mask lead to an uninitialized pointer
 free?

 If cpu_possible_mask is sparse (for example, CPU 0 and CPU 2 are possible,
 but CPU 1 is not), the allocation loop skips CPU 1. If vmalloc_node() fails at
 CPU 2, the cleanup loop will blindly decrement and call vfree() on
 newinfo->chainstack[1].

Not a real-world bug, such allocation isn't expected to fail
in the first place.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 A case could be made that chain/jumpstack should be
 GFP_KERNEL_ACCOUNT, but such change is not related to
 this one.

 net/bridge/netfilter/ebtables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5b74ff827493..48187598cdd0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -921,8 +921,7 @@ static int translate_table(struct net *net, const char *name,
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc_array(nr_cpu_ids,
-				      sizeof(*(newinfo->chainstack)));
+			vcalloc(nr_cpu_ids, sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
-- 
2.54.0

