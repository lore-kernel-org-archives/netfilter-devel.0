Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592A7216E05
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=lMn/JN4Y7E6umlidthUrqEyp+G73mgGhQAM+on2Om0xUuN0FcvhoJJoLkLf41cXn59SI3KKcSw9VgrYZc5MvhsclFZW8UppJY45YwZusdIsF1f35k225uaZxm6/ANhP0NdCe1dEqXVfhFveOCKrF66YcsADZPBLFCtfV6Q8ez2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=smlRrKd8+i+IisLwf+F0UZiu5ALQZ8ZKa+0wufdCwWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ann5vCQr4/5P6YHVvDPHf9clp5zOJe8l6kPiY5ZcsXHWn8MYNGEzbUd6pJyvCzSbV5AkRcJwz+0W0jvA3k1YMW8fDP0/HEVAPjSL6aLvjYu1M3Xwu85CZBoy/3DxhHNQIbrLIwJAjzcgmIfNzYCmrL89Ncb1/HaXL5yYKsBDerA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EksvKkZJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EksvKkZJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JtZS1sD4hE5TA471wSFLZeoORl0p5wDkwk8SSOxNTjk=; b=EksvKkZJrjIUXHtGisBQ1q1Hqx
	oDgvhQ3qfvIVPphFDUq3e1jpZPYGdQY4tfj/8I6DgTW5uiHBz+ZXyShTgIkQPLfJlAQ5o9HS0dMv9
	NeeS+zlRYIKtKuzuCAQpY8m4pvhBP+U0BHXXRWe203RXLk4+B7tjvS6vg1ewvWO7IE/9EDkP+lcyc
	t8C1OSSch1kRStKrYnm/RTAFE2yssIRaXpIofQWLqnZ5ByOpaFrx5I99GLD8RhO+7VOo0IqkeThRv
	OWD4dMPbii9046iy4++A87yNbzb03nU0nDmf7QpK+AeJ134V7fn43o9sZGpsU9mNEXz8ntf5Gaf/w
	DdBUEyaA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95V-000000000my-1nqw;
	Thu, 08 May 2025 23:47:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/6] doc: Fix typo in nat statement 'prefix' description
Date: Thu,  8 May 2025 23:47:17 +0200
Message-ID: <20250508214722.20808-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No point in repeating 'to map' here.

Fixes: 19d73ccdd39fa ("doc: add nat examples")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/statements.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 74af1d1a54e9a..79a01384660f6 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -438,7 +438,7 @@ Before kernel 4.18 nat statements require both prerouting and postrouting base c
 to be present since otherwise packets on the return path won't be seen by
 netfilter and therefore no reverse translation will take place.
 
-The optional *prefix* keyword allows to map to map *n* source addresses to *n*
+The optional *prefix* keyword allows to map *n* source addresses to *n*
 destination addresses.  See 'Advanced NAT examples' below.
 
 .NAT statement values
-- 
2.49.0

