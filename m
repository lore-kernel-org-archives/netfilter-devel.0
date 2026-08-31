Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB99433E7C;
	Mon, 31 Aug 2026 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192399; cv=none; b=nR2wj8b2aP9LluRTego921sUp/aUt2dxynNi3p0OwGFVuhIpwuL0LRQDJdF8l6qBFBbWFLvHFLLd2D2NbUSJXuY8KCuGrczcYAsBwuFwuQod1TslPCBNJ0wUVa7MzokUNFOQPqeaEPtE/K/4IHeuk6KJZyu3rI41Mcg74ejNJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192399; c=relaxed/simple;
	bh=dInqbBwUod+Sa+lEygi1HhCFJ31GmSpVykqCR05UGjY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MJmTYj2z0E5f8duXQ3Ly50/fvQ/ZBLxvBrF6yRhNDhgEImzHSie7thdB+x93FhTagNhplqXkqJJdrheURq90y4KL7B8MH1tRGJNHxNNyXF87SnaMBiMgmPeeXInJh7gDyXTBHPu4fp6D4z7W2hrO9pngrnVqjbkCdG+mFLW8Hew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=LP6Vpi6K; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="LP6Vpi6K"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id AA4461A1906;
	Mon, 31 Aug 2026 16:06:35 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7CDA460231;
	Mon, 31 Aug 2026 16:06:35 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6B18A11C78AC8;
	Mon, 31 Aug 2026 18:06:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192394; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=Iu8DxQ3dzl8wZqpvD364DVvQYiKdo2ESja+zACmBA7Q=;
	b=LP6Vpi6K8cpGr0XmcFffIH8q5sJEkFlVjmad6wamz9RvpKEIsg2ouUm1Pn2LEDPqjW3VuW
	EEDhaKKWOCPkAPez2zLN/n7fdDEC+JArgq5sc5ak8bil4UVk8htAqqVVYBSxOQlEtUDo8R
	NeZFQRBWON8LKGcMGm+xhzg5UxzIMedPtLDT1JLbPl3NKDc5DWDZQSDIX/K14aUNf5lgSh
	sGVza5M6ePqgTsolTzJIzP+s4P1BrPfhaI6Nninl4r3Xx/QHEkx716yDranwNs0KfudY5Z
	ISlU71RT2r58TNAWCg6GJIsqi7vuCBYI21KGwKo1bauJEztiyVpvKP/hohEEZg==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.6.y 0/4] ipv4: start using dst_dev_rcu()
Date: Mon, 31 Aug 2026 18:06:19 +0200
Message-Id: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CQAxFr0K6tqQDTFGuYlwMQ9G6QDOjREO4u
 xXyV+8n7y2QJalk6IoFksya9TEZuEMB8Ramq6AOxlBRxXSsHcZZ0MBjQ9Q2yLYQgm/rnk7sHZj
 4TDLqZ4uegUsuv3DZ7/zu7xJf/yCs6w8nlO8bfQAAAA==
X-Change-ID: 20260831-cve-2025-40074-6-6-aaa573b09651
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Martin KaFai Lau <kafai@fb.com>, 
 Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788192387; l=1484;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=dInqbBwUod+Sa+lEygi1HhCFJ31GmSpVykqCR05UGjY=;
 b=giRQwpY7Cb5C1FPQqhu+P9zUWdAfSfC3qeQGOhiwoW1C0DnP/0cAhGJ52t9VSaBQs9U38wNUr
 fynR1Tazx+yC6o53qu2nAbb0Zo5Ipql2Lmiik2XZXlw/h3EUzmaz9h1
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

Three other patches are required to be able to apply cleanly the final patch.

Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
Eric Dumazet (4):
      net: dst: add four helpers to annotate data-races around dst->dev
      ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]
      net: dst: introduce dst->dev_rcu
      ipv4: start using dst_dev_rcu()

 include/net/dst.h             | 34 ++++++++++++++++++++++++++++++----
 include/net/inet_hashtables.h |  2 +-
 include/net/ip.h              | 11 ++++++-----
 include/net/route.h           |  2 +-
 net/core/dst.c                |  4 ++--
 net/core/sock.c               |  8 ++++----
 net/ipv4/icmp.c               | 28 +++++++++++++++-------------
 net/ipv4/igmp.c               |  2 +-
 net/ipv4/ip_fragment.c        |  6 ++++--
 net/ipv4/ip_output.c          |  4 ++--
 net/ipv4/ip_vti.c             |  4 ++--
 net/ipv4/ipmr.c               |  2 +-
 net/ipv4/netfilter.c          |  4 ++--
 net/ipv4/route.c              | 10 +++++-----
 net/ipv4/tcp_fastopen.c       |  4 +++-
 net/ipv4/tcp_ipv4.c           |  3 ++-
 net/ipv4/tcp_metrics.c        |  8 ++++----
 net/ipv4/xfrm4_output.c       |  2 +-
 18 files changed, 86 insertions(+), 52 deletions(-)
---
base-commit: a4a971135a2ff64382ae4235b3ae60503bb1036a
change-id: 20260831-cve-2025-40074-6-6-aaa573b09651

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

