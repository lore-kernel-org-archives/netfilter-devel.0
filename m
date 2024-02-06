Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3A12A163
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707222575; cv=none; b=LTZD9WMTsrYZk0iDcqlrZbG72edcVGuFV2+oedKVSmD33z0guVPXGlKP6DYH34ONVMIwgpbmztd7bqcTGwD4E8v8QQ+gp9ZAEd43ThB1Cv1tzTs7oZsrOSY0nNYdbARB5YqemXH5pLUbPTZN97D3JIALm8wSozAF3j45RDkji2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707222575; c=relaxed/simple;
	bh=RuzIOHaojC46vQBaccqSzKSsyjthnkXZ90l3HD3ZCXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YSFrx4HRdheYWe+FoeF2XXj709E0TmQ+lFqWaycnGv/KT1QvP9ElXQz4MFBlIuRW+yjwPVy6vowoPlRZCS8o0n63HQ/Cq4broLAQuYvC/WK63vsYjc4JO1Hf9LcaMtpDeodTH/uOUqoV/atx5LBj7il55VeMUtzyH3PrzwbM8Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXKZu-0002AA-Nr; Tue, 06 Feb 2024 13:29:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/3] netfilter: nft_set_pipapo: map_index must be per set
Date: Tue,  6 Feb 2024 13:23:05 +0100
Message-ID: <20240206122531.21972-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While working on speeding up pipapo rule insertions I found that the
map_index needs to be percpu and per-set, not just percpu.

At this time its possible for a pipapo set to fill the all-zero part
with ones and take the 'might have bits set' as 'start-from-zero' area.

First patch changes scratchpad area to a structure that provides
space for a per-set-and-cpu toggle and uses it of the percpu one.

Second patch prepares for patch 3, adds a new free helper.

Third patch removes the scratch_aligned pointer and makes AVX2
implementation use the exact same memory addresses for read/store of
the matching state.

Florian Westphal (3):
  netfilter: nft_set_pipapo: store index in scratch maps
  netfilter: nft_set_pipapo: add helper to release pcpu scratch area
  netfilter: nft_set_pipapo: remove scratch_aligned pointer

 net/netfilter/nft_set_pipapo.c      | 96 +++++++++++++----------------
 net/netfilter/nft_set_pipapo.h      | 18 ++++--
 net/netfilter/nft_set_pipapo_avx2.c | 17 +++--
 3 files changed, 63 insertions(+), 68 deletions(-)

-- 
2.43.0

