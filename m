Received: from out-06.smtp.spacemail.com (out-06.smtp.spacemail.com [66.29.159.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C7C273D8D;
	Sun,  3 May 2026 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.29.159.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777797159; cv=none; b=AB15X73zvLxaVcR4Gd6nT4FB1z9lBzgs2Gtd/Xp1uSeL0UWsu7oaAOau/363qcNde/J+YGzT3w+3wWELw+fFrfiS2tbQNWDggtji86W+a9aEzh3Ql7KCm51TcGfYdNu5gAPjC4DwdvsR8nw5qEzsPmEXbe+mJCdgFeTmbnU974k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777797159; c=relaxed/simple;
	bh=S3bdgBPGI79X4uU8E8SKCYpMjmNwlQs0xu68QWji2lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFqnLkDDOc5DrXSzeHLP9CmVJVCGSpjG5tWzsPr4BJTw0vgHzKq5p9CvaXU+sliSFUTdT69iR3k0VyEwZ14fbbgqhcltgsot991tys53a/V8/Zv+Vf1Y7S9BMf9OHiFODqsk4g7aF2ZdKSNDAvwr30ABU9R13Me4iMmbXCrDna0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=j94Khmym reason="key not found in DNS"; arc=none smtp.client-ip=66.29.159.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="j94Khmym"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g7dLh4k4Kz8sc7;
	Sun, 03 May 2026 08:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777797152;
	bh=+2SH8ZXr4rVy0HR2sYavhqA8v3/knTQ2qsNiVVXoX/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j94KhmymVkpe292xwwUtIaInwZteiKw6ZoinBYUhY18MQqhYdsiv0jly0FRGWchg6
	 10+fxaGfR9XTi7HnDyD6LHFf3lvnPI3rCV4kNuwNTi+h/GIrxC6BlON8Koe8GMlg2c
	 deMe5CF+apxclK86kS8jJErPYbD/pBuogwyHKQ11Et68b68/U60mPB1UU3ImF2Lyx/
	 AEoTsLd4G+bMyw5oBlDDMyWNw6aCQyqHmlXEGqZrDOsN/9xjudpeY8RdvwQEW7Lm+B
	 J/bQO8zQwP6dsE3/h6xOnluSOyd7XOtUBAZyaUWUm8l7wcP7b1poFucNKGk9gSWuUv
	 RkxddHBgwKCkA==
From: HACKE-RC <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HACKE-RC <rc@rexion.ai>
Subject: [PATCH net-next v3 0/4] netfilter: conntrack: shared port parser for helpers
Date: Sun,  3 May 2026 14:02:16 +0530
Message-ID: <20260503083220.630655-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Both nf_conntrack_irc and nf_conntrack_amanda parse port numbers from
application-layer data using simple_strtoul(), which requires
NUL-terminated input and returns unsigned long without range validation.

This series introduces two shared helpers in the conntrack core:

  nf_ct_helper_parse_uint() -- generic bounded integer parser that
    operates on a length-delimited buffer without requiring NUL
    termination.

  nf_ct_helper_parse_port() -- calls nf_ct_helper_parse_uint() with
    max=65535 and rejects port zero.

Patches 2 and 3 convert IRC and Amanda to use nf_ct_helper_parse_port().
Patch 4 converts the two port-parsing sites in nf_conntrack_sip to use
nf_ct_helper_parse_port() as well, retaining the SIP-specific minimum
port check (>= 1024).

v3: add nf_ct_helper_parse_uint() as the generic base; nf_ct_helper_parse_port()
    is now a thin wrapper; extend the series with a fourth patch converting
    nf_conntrack_sip (Phil Sutter)
v2: replace simple_strtoul() with a shared nf_ct_helper_parse_port()
    in the conntrack helper core, modelled on 8cf6809cddcb (Florian Westphal)
v1: inline range checks in IRC and Amanda

HACKE-RC (4):
  netfilter: conntrack: add shared port and uint parsers for helpers
  netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
  netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
  netfilter: nf_conntrack_sip: use nf_ct_helper_parse_port()

 include/net/netfilter/nf_conntrack_helper.h |  5 +++
 net/netfilter/nf_conntrack_amanda.c         | 11 +++---
 net/netfilter/nf_conntrack_helper.c         | 39 +++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  4 ++-
 net/netfilter/nf_conntrack_sip.c            | 14 ++++----
 5 files changed, 61 insertions(+), 12 deletions(-)

-- 
2.54.0

