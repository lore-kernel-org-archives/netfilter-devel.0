Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB1D51DE0F;
	Fri, 18 Sep 2026 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755911; cv=none; b=oE/e3wclN2Ih7LHkMohgHTrMjMmbfiEUCN02fU+jdjxRYwskDubQUhX5BvqKCIOz3Qj8Ny6CxbOOxFfyFiaivQzMM87TbeDrE7WPfOo6ixoz9VubwC7na31gexs3aiGZrvH/OVO/j+E2Y6M7CvOi2/1ARSEU6J/mtjXcrkULaIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755911; c=relaxed/simple;
	bh=VDhkMJnUuOdzALwBnQYd2/1PePxTf7wjQwS6ixEbijg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lAo/kLvJljXlT9s+Bhdfq8iVl+X89hVL/WJPcidGJq2JlwT7y61D+d/lcDzHoHUVbHbxOk+ANvLMY9a8Birk8SBV3/Sg19mOY0+66thz+aqhktrqexLrMS+7BluF1MeV/tkBcmyMu7oQbP8Ln13mFnJnvX8iNk7AwxcjeOrpBqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=y3BHAb1k; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="y3BHAb1k"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id CBFF21A0997;
	Fri, 18 Sep 2026 18:25:08 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A070460649;
	Fri, 18 Sep 2026 18:25:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DC35910328E70;
	Fri, 18 Sep 2026 20:24:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789755903; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=Ta++TkZosJaiAmjfhJhLLNBPGPCULtPoxdA6ItNFrp4=;
	b=y3BHAb1kF+DxJW2OiQwbDUpuF4Hp5ztJJcc9FDblYFlWB0/B5IZzuCS33/UP5Rp9MwIBMj
	KtsbzOcl/c+2sdJgDbbCp233gWvqv3ITSNtMo4b9dZ7AUFf/tXOSdpDXE/wwGEs6/shmx1
	qZr0KjebGyfEjlcWYwnMTTD47ssA1A6IbeAW3JQXTWkc2wbnJ3lrYZId2r7zZeo39ofWQF
	m4mp3uLOPivBfYiNQUBQ+KaAv7qezbOGkBttwuVHLmRkmkio83q5wuR4KGOcVNAVMXqh0+
	Hs6yBCmyJSFCgNnzCM3wamQO6rc9TBikB64r+ipz6inzvTgbuPta+Ham7PkbJA==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.1.y 0/3] netfilter: nf_conntrack_expect: use conntrack GC
 to reap expectations
Date: Fri, 18 Sep 2026 20:24:52 +0200
Message-Id: <20260918-cve-2026-80668-6-1-v1-0-7a8667286d67@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vche3ZJW8hafRXjoZRRlwOYVomG8
 O4WOX6TzL9QRlJkOlcLJcyadRoL7KGi+AjjHax9MTnjxJys5ziDN7A3Ip6FLQc0bY9wdKHpqBy
 fCTf9/KMXktrWX7ruc353A+JrC9K6/gCcGMESfQAAAA==
X-Change-ID: 20260918-cve-2026-80668-6-1-ae34dea72a3b
To: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
 David Ahern <dsahern@kernel.org>
Cc: Benjamin Robin <benjamin.robin@bootlin.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789755899; l=1996;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=VDhkMJnUuOdzALwBnQYd2/1PePxTf7wjQwS6ixEbijg=;
 b=KdACUJ+A7foO3WeUXSgI3206CwaaBsMjN9IuNYqoqMWck4OKhe/IBC0fjW9PYnbeAokGsFz87
 mt1P/vGbClpC0ZK9//DAIHz0JU6GFWBnSeJrNrxCXy4pWBT4swn9hjS
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

Backported two other patches, to make this fix apply cleanly.

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
base-commit: 1a8763b93150b2c8f3992c27a5ce7857fee4ab0f
change-id: 20260918-cve-2026-80668-6-1-ae34dea72a3b

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

