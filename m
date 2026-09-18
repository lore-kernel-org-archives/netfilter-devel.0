Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE646F48F
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755797; cv=none; b=VXhZmSM/+u29GybzP25S6CDx+DlmJa/Tte9NPvSXB/28a4mQ1Ekr3v3xwkwQkwAYcHJThiB5kRAt+MUoBI8BSTrAhfjrZXGzmNoZ7f8sxcbu68B2zwQ8OGhX98pum5Mq4+up75ODk7/I8st8Y7RkfXJS7miZ3lYweUVhWsTaJt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755797; c=relaxed/simple;
	bh=gHCFHvvzJ7jCE2Tto2KlkqyHoiE7Gu0jWU2dsqDsJ4c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=A7OrOrlkqdaEGBbc7VpNdG56z7yOQiSuUm6K3eazsycpzsJjGv+GTHl6ui/rsilDhHZBL/i39i3nMy2B+nsudxqE+oSv3X3lMnx7KPAfuemEF8QyASWwFY+I3ceZKCyyEXEMQn+fgK2rSDhLMqyJuMyViLRGXbDRmSOdpFdG6Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=xcQBp/jA; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="xcQBp/jA"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 99D2F1A0997;
	Fri, 18 Sep 2026 18:23:12 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5F7D960649;
	Fri, 18 Sep 2026 18:23:12 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B903710328E70;
	Fri, 18 Sep 2026 20:23:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789755787; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=tjjf402bMYV3OnGzbLEejRpkhzJwKU92sgnZVC1BoGE=;
	b=xcQBp/jAcXU+bO9GSL2uT3RXfvwq5q5aRcpN1arlBzvv3gLgVe2jEHyGh8C0z25G+JOt7N
	K8muqP3KBsKKN7QzVN8Ok8b7gvPI/OYKd7+RLwR4YUcxvPu/fld5X1KuFV1zqZo4UnJou/
	kFAk5iPF72RNleMH3XE40qoJCicFUNtrHQts8zNu97/g/O+bRtd743euIfEE8mOPpe9yao
	SwjlRF1R/ixifkU2iAmkfnxc13DljrMWThZ3uxUvrycfhBSJrsSeJbYyj+X8mt7hrRosUX
	EYQs0S/bLcremMMvRqgezfuFOjREm0opkfOQJZpRE6v+ieIhV2ucQhBbi24LGA==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.12.y 0/3] netfilter: nf_conntrack_expect: use conntrack
 GC to reap expectations
Date: Fri, 18 Sep 2026 20:22:56 +0200
Message-Id: <20260918-cve-2026-80668-v2-v1-0-fcefceb49144@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3ZJ28Sm9VWMB1gXWA5gWm00h
 He36PGbZP4NWZJKxqXZkKRo1nWpsKcGPHXLKKT3ajjjvIk2EBehAxSM94GKI+7OcTDM0seI+ns
 kGfT9a17hW+vaD27/Pb/6Wfh5BLHvX7yiLPZ9AAAA
X-Change-ID: 20260918-cve-2026-80668-v2-ca59f0cceb99
To: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Florian Westphal <fw@strlen.de>
Cc: Benjamin Robin <benjamin.robin@bootlin.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789755780; l=2001;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=gHCFHvvzJ7jCE2Tto2KlkqyHoiE7Gu0jWU2dsqDsJ4c=;
 b=QtOiqeKIY0rK0wNdxwHIPfs7TOn0R7klIJCI3dEF5C2z8hetPFAy/CkrWu5bItyW2qO5dwpX6
 wtAMAEgGFpFD0DTaCdmSmflQDF75x9n6OpagQAZpl895ubFcj54uD1M
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

Backported two other patches in order for the fix to apply cleanly.

Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
Pablo Neira Ayuso (3):
      netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker
      netfilter: conntrack: check NULL when retrieving ct extension
      netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |   4 +
 include/net/netfilter/nf_conntrack_expect.h        |  16 +-
 include/net/netfilter/nf_conntrack_helper.h        |   2 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   1 +
 net/ipv4/netfilter/nf_nat_h323.c                   |  12 ++
 net/ipv4/netfilter/nf_nat_pptp.c                   |  14 +-
 net/netfilter/nf_conntrack_broadcast.c             |   3 +
 net/netfilter/nf_conntrack_core.c                  |  33 +++-
 net/netfilter/nf_conntrack_expect.c                | 174 ++++++++++-----------
 net/netfilter/nf_conntrack_ftp.c                   |   6 +
 net/netfilter/nf_conntrack_h323_main.c             |  22 ++-
 net/netfilter/nf_conntrack_helper.c                |  10 +-
 net/netfilter/nf_conntrack_netlink.c               |  22 ++-
 net/netfilter/nf_conntrack_pptp.c                  |  72 ++-------
 net/netfilter/nf_conntrack_proto_gre.c             |  71 +++++++++
 net/netfilter/nf_conntrack_sane.c                  |   3 +
 net/netfilter/nf_conntrack_seqadj.c                |  17 +-
 net/netfilter/nf_conntrack_sip.c                   |  54 +++++--
 net/netfilter/nf_nat_sip.c                         |  12 ++
 net/netfilter/nfnetlink_cthelper.c                 |   6 +
 net/netfilter/nft_ct.c                             |   3 +-
 21 files changed, 363 insertions(+), 194 deletions(-)
---
base-commit: fa5b06866b643cce7072a4e7c6be7ee3f0f1b95c
change-id: 20260918-cve-2026-80668-v2-ca59f0cceb99

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

