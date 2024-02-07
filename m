Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456FD127B52
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 20:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707339543; cv=none; b=E88kev91vIWh5XzrE8QI4QRrtTGnof0RjkVfnvaHEDHUtDxkFDeX0zKtWE/COaDgFi3P3ympl/yenIvgyQ9P7nsWbFXfyI/hJfd1dlFvYWW3wSswOsFnwt55iQgPoVWcWppqmHnKmV3QVzNI3mJLsMhVWAk6t9/DYEVJWWulX9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707339543; c=relaxed/simple;
	bh=ogkGdFImr3Fnjk675oRbgbhURLTbARCg6EerXyG1iH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SVT3YCwBOlGfWeY6DCdKUwScW9dpCCuRwGBKF26ICyFGxut+3dy/LTd/ktBvHjTyG5tIEyK6uzmMmY9dZ3tRa9hfRfDrfgzMVdz6Di3ojZLenU1nvd5Cl+beI8lFEOiGWkl1bVVcorCD7ldQvuvsH+STCC1UoltjKj/wduR6qOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXp0V-0005i1-Dz; Wed, 07 Feb 2024 21:58:59 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2 0/3] netfilter: nft_set_pipapo: nft_set_pipapo: map_index must be per set
Date: Wed,  7 Feb 2024 21:52:45 +0100
Message-ID: <20240207205252.19751-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No code changes in v2.

Only changes are:
Patch 1: add comment wrt. alignment
Patch 2: add kdoc comment
Patch 3: add Reviewed-by-tag from Stefano (also for 1+2).

Florian Westphal (3):
  netfilter: nft_set_pipapo: store index in scratch maps
  netfilter: nft_set_pipapo: add helper to release pcpu scratch area
  netfilter: nft_set_pipapo: remove scratch_aligned pointer

 net/netfilter/nft_set_pipapo.c      | 108 ++++++++++++++--------------
 net/netfilter/nft_set_pipapo.h      |  18 +++--
 net/netfilter/nft_set_pipapo_avx2.c |  17 +++--
 3 files changed, 75 insertions(+), 68 deletions(-)

-- 
2.43.0

