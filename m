Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8351DB1F;
	Fri, 18 Sep 2026 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755856; cv=none; b=AI307cO5vXtSEaNr5RI3MLx89pLq1AJQqHEY2rlZyaORo099GavMaqNom/hLUROk1ZXd/Uzx8KQDhbWrYOgwwcYd/Ae7872JdVi3oLISnbJdTngvXzYTiQbSqBR/ov9+LidOvWaCpbg7hEnAoLlWzVH7b55nn46nVTZmbPa3SJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755856; c=relaxed/simple;
	bh=H8EFMgxctoF+92OiOhX0CtExhg9h2GqfP26+fRiQk0M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UHrhuOo+xDiwIKCKEGnL5RDoUkxUMrTX0zEVa+MVQ4+7+qfGZ7/sNXHAf/pT3fN8TqaBnOyzJtA66aXKkVnLVVCDecJHtUhHtpWLaf7EzJZWnY0cbH+p/fYS6fVH6erKwnCgzfhXpq7MCfZ4MmqVPWOdQtTplz+eYlH+JuRw3D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=lb0wB9J2; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="lb0wB9J2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id E7CBD4E407BD;
	Fri, 18 Sep 2026 18:24:12 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id BCB6D60649;
	Fri, 18 Sep 2026 18:24:12 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 31B73103283A2;
	Fri, 18 Sep 2026 20:24:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789755851; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=wAvEYuC/N0TIo4x7RjLBwRoN+k8vtioGZL2t9QbmA2w=;
	b=lb0wB9J2H8Oxy99m8KKyDm0kl6zhqLL9sOvXRtkYVOVEyzfc5Aa2C8M+1MvnrxOiauaLAn
	jL5NvxAFvfUMn7pJ2kLUqaY+1rgE/DwC9E7wAkWcBsDHUV6RTEMjKEiOwznN6kT7TLwrcp
	LhjGJeBiD710MmMDAdyihlfLnXDdsVhcMbA+KloQM7mSpxCxkM8vNgJpmqwy/wD1NsvhSj
	l5RPPFL4PuUledRLESAaQPQ9w0YIWHezSo/6cN15kCr1gFNaz441yqzHXPi9tAT4CA8WYb
	dsc/nLUNgtway7x/sYsuUejXL++zkwwWYNpokkCNmaJAMK96PKXOECCP+wTkWQ==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.6.y 0/3] netfilter: nf_conntrack_expect: use conntrack GC
 to reap expectations
Date: Fri, 18 Sep 2026 20:23:53 +0200
Message-Id: <20260918-cve-2026-80668-6-6-v1-0-07f89b880b6c@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0L+2iGlkEnlKsYFlCmOCyStEgnh7
 hTNX72fvLchSVRJaIsNURZN+poyVJcC/tFNo5AOmWGNZXOtHPlF6ARyhtkR54XedtJwXZshIIt
 zlKDfX/QGLrlccf/f6dM/xb/PIPb9AAI5Efx9AAAA
X-Change-ID: 20260918-cve-2026-80668-6-6-fb2ae46330df
To: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 David Ahern <dsahern@kernel.org>
Cc: Benjamin Robin <benjamin.robin@bootlin.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789755843; l=1996;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=H8EFMgxctoF+92OiOhX0CtExhg9h2GqfP26+fRiQk0M=;
 b=36g+a2y75/WI+EsDMXcoQJEXfNabUFg4PK0skVXbu2rUQORQygF0MbtlHnLhbBZimHjc4RbmM
 xoKADJDPB6jAkjFhTG15Cc71dK+Ph/Oe1KAN7ewDvCzZEXGwNBUVV1T
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
base-commit: 79643295eba17affbd16ca97f3ef04c90266b28c
change-id: 20260918-cve-2026-80668-6-6-fb2ae46330df

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

