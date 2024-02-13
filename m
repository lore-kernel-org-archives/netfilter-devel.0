Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783B31E529
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707835343; cv=none; b=lN9mcTtGYtmU2z8KYT7AzCoeP6CFMqCEN0VpJEIcPj4+m72bJle0zehn7WtpHcU48MkNMXf+q3+7sjmp1FTzA8innV52CpKzUUHyCL7vZaxxnkRnJQANoMH1zpLzEzjhBhp7CnXcIZOGVvh4BJ6SPMgjQ9Fm72XqohHNAFwNtak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707835343; c=relaxed/simple;
	bh=wpqvjfVs8TkRl8Yb3W3fqljWCnpE8oUxIA/7oY6bSaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZCfi2CftRGWy/7k1nSQ0S0j0pLzTsl1b58XAPjKkkJiK7tAlKYOS3qae6pADoSaklI5E+Zfrb13CsTvgBbRP0osf03jiiAMx1lx28Icu8SeNgcHiBfXGmyk+oh8lRItqSehaVs2raGXr6Q5423ijGBH1291xSXB9TDG0MFB2R0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZtzH-0000Kw-0o; Tue, 13 Feb 2024 15:42:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/4] netfilter: nft_set_pipapo: speed up bulk element insertions
Date: Tue, 13 Feb 2024 16:23:36 +0100
Message-ID: <20240213152345.10590-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: addressed comments from Stefano, see patches for details.

Bulk insertions into pipapo set type take a very long time, each new
element allocates space for elem+1 elements, then copies all existing
elements and appends the new element.

Alloc extra slack space to reduce the realloc overhead to speed this up.

While at it, shrink a few data structures, in may cases a much smaller
type can be used.

Florian Westphal (4):
  netfilter: nft_set_pipapo: constify lookup fn args where possible
  netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
  netfilter: nft_set_pipapo: shrink data structures
  netfilter: nft_set_pipapo: speed up bulk element insertions

 net/netfilter/nft_set_pipapo.c      | 178 ++++++++++++++++++++--------
 net/netfilter/nft_set_pipapo.h      |  37 +++---
 net/netfilter/nft_set_pipapo_avx2.c |  59 +++++----
 3 files changed, 179 insertions(+), 95 deletions(-)

-- 
2.43.0

