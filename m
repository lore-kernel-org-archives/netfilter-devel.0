Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A217567D
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 01:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608884; cv=none; b=uMnMMzqpWTmeGNUV5Im41HeHBLZc89rjbuRm0r66ecRoc1fLLd+/HL+i9+fmPXKAkeo5yqrXDOHAVXmvqBSVeUPnaBujC3PXatNCY47mh4fKG4yXmCrKjXto/omyZb1It2G50Mlx++kPbpZOAXeHk9/kKqPDxDZAKAdRT9RPe+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608884; c=relaxed/simple;
	bh=GAceTwH4nOfqGL4LMEIZeuUhIsnQpuFtOkF1ImfTVHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ark1u9TLHtzJqCl+07jE8iMdriGtVyUQtYAqwwEeJAdcfzhhX1l5TlGsfQHtQTtV9eOYz6HXW6xuBd2j20tnuw5gDPXP0cWLoyJQPFX0Lz/kpc5zLyYuko+PHWgF+CiveYxDTQ3XfitbFGiIWF7ulcoFTqe74s1tfZKCXCRZE14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sz48I-0006wL-JA; Fri, 11 Oct 2024 03:07:54 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: fix spurious dump failure in vmap timeout test
Date: Fri, 11 Oct 2024 02:32:08 +0200
Message-ID: <20241011003211.4780-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit can update the timeout to 6s, but last line waits
for 5 seconds and expects that to be enough to have all elements vanish.

Fix the typo to limit update timeout also to 5 seconds and not 6.
This fixes spurious dump failures like this one:

-               elements = { 1.2.3.4 . 22 : jump ssh_input }
+               elements = { 1.2.3.4 . 22 : jump ssh_input,
+                            10.0.95.144 . 38023 timeout 6s expires 545ms : jump other_input }

Fixes: db80037c0279 ("tests: shell: extend vmap test with updates")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/maps/vmap_timeout | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index 3f0563afacac..6d73f3cc9ae2 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -32,7 +32,7 @@ for i in $(seq 1 100) ; do
 		timeout=$((timeout+1))
 		expire=$((RANDOM%timeout))
 		utimeout=$((RANDOM%5))
-		utimeout=$((timeout+1))
+		utimeout=$((utimeout+1))
 
 		timeout_str="timeout ${timeout}s"
 		expire_str=""
-- 
2.45.2

