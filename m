Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA982580F2
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 12:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856411; cv=none; b=ozj/WPpIBmO0Zt5DKgEaVneCR74Mew1PHx/5SMu9TYmA5vJ9FdLAx/P/6iFXX++ELsG+0Fnh0N2FzTuW30aluRzdWIzIyNBSBvjgLxCeivClRepyER1BR9HF/Qw9HT45W9AxBDNRYdXmJEOLu+NwtF35PDLmiLOPhJQU1sk1MFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856411; c=relaxed/simple;
	bh=sv7aYapYqv9Ag+qppi04M3VU6NPfuTkWEXfBwdD9oK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pPQD4D65/U1bvLUkYdfRgTeZtz4hqJnjcOvbHeUJZJCJzWS0tThLH8xTh33NGg2KyHJ05+F9zP+1ri02l+omH1L6WoBFPiSXKybck2wiEmixyDnGgN8NvL0Z8LvDqw9LoqKxAPEIz0TDrgx/yndpkSjv5irrGzuAcHmGlXcqTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AF7DD60640; Thu, 01 Oct 2026 14:06:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: do not assume skb->sk is inet sk
Date: Thu,  1 Oct 2026 14:06:19 +0200
Message-ID: <20261001120625.29659-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLM reported that packet socket could be handed off to an ip tunnel,
where the now tunneled skb retains skb->sk as packet socket.

There are spots where we assume skb->sk is inet socket.  Add helpers
for this and use them where needed.  Not reproducible (no crash / out
of bound access, nft_socket just provides a 'random' result instead of
'no match').

There are more skb->sk users but I could not find bad-access scenarios
for those, they fetch valid sk fields or are restricted to input hooks.

Florian Westphal (2):
  netfilter: add nf_skb_sk helper and use it
  netfilter: add nf_sk_to_full_sk helper and use it

 include/net/netfilter/nf_socket.h | 35 +++++++++++++++++++++++++++++++
 net/ipv4/netfilter.c              |  3 ++-
 net/ipv6/netfilter.c              |  3 ++-
 net/netfilter/nft_socket.c        | 16 +++++++-------
 net/netfilter/xt_socket.c         | 26 ++++++++++++-----------
 5 files changed, 62 insertions(+), 21 deletions(-)

-- 
2.55.0

