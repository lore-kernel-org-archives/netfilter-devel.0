Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5B2BE02C;
	Fri, 21 Aug 2026 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319252; cv=none; b=OYxKdfmYTNjbFaYaAsbee3jR5CHl+pCG1ptn7/nYncAqMLTafsL0nF/pEykc2tlD8DGjpQgDGMmW1+XAHQVPW4lwo4fMJ1nuedRMPAlJEssnlvz1GoHTsQfNpxtldnNAud+mBKT6FI0ZTsZe1m7coqlnXAWYEgdxIPb1ULYWi7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319252; c=relaxed/simple;
	bh=bAdbSU41Z/vBmC+QsvGL2nnUK1uHasaCpMfmR5D0HMk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AMr9oXBzbvSHDQjjR/yuN5GfhhYqdEcv7rGoeu5E0HkJvVqhMNvXDl3Y8PbLVzzRczd2uHgitcsaLs41hE3F2UefVaIbKUDbgVhtToM8sozUYVlMeSYGhp8Z/eLfJgJADayPbgRFbPNWM6YwmHwvh388bl890wTPwelhMUCfpT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=r7kCHm7F; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="r7kCHm7F"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 9EF681A168D;
	Fri, 21 Aug 2026 13:34:06 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6FB8D604AA;
	Fri, 21 Aug 2026 13:34:06 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AB14C11C7714B;
	Fri, 21 Aug 2026 15:33:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787319241; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=zW+S1lFLlEZ8r/53t/D9PI+ul66jA+3Kp+sHgvAr+/w=;
	b=r7kCHm7FWgieHBMibFsZedfMtdS736rojrERN7LviZCgayDbUyYjDVyCc3aQq725kI+1by
	yAnf4w2NK2zH+U6epwNMvNqvsMfjCFwSMC5nk/2U05WkJebnfjer2ZSJmX7mFS0i1U6kF4
	HCiYcp8nGKnhHqhUfGuk+TNxQl0VXq2GwA2/PbXuks8p/uI2PnS/Go44lhgdmb/tFzX/i+
	JZL4ipXEdmwsCxCQZE0/4ZBkRaMJ9qvWN9wAno8e9Tot9q063I8nvXdyVu3T23jlMM+ISU
	S1Eu7Woy6pDLK7wBvQ/DfORBIkSJZykkSZAzJGTaHiqCaycs1I6DNuSf9OU95w==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 0/4] ipv4: start using dst_dev_rcu()
Date: Fri, 21 Aug 2026 15:33:34 +0200
Message-Id: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3bJttIqvIrhAHXR9YCm1UZCe
 HerHr9J5l+RJKokdNWKKFmT3ucCs6sQrsN8EdJzMSxbz0fLFLJQgaOG+dCQJ0OtC47Fj+0w7VG
 OjyiTvn/RE7KvTb2g/+/pNd4kPL9FbNsHx3Hk9H4AAAA=
X-Change-ID: 20260820-cve-2025-40074-6-1-95c50e6b9af3
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>, 
 Martin KaFai Lau <kafai@fb.com>, 
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
 David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, Miguel Gazquez <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787319234; l=1466;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=bAdbSU41Z/vBmC+QsvGL2nnUK1uHasaCpMfmR5D0HMk=;
 b=olU9DwrBVWSMkioHfKwGPrq0oLqinw/QYpzOKDRXs31MmmfhIOU7GTNoh+QXx0L6SzUhHm7Q6
 +R710KwyYW9AKQuBYQWMKHfixeWGrYDririy8MNXii/4khh3/61IRWx
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

Three other patches are required to be able to apply cleanly the final patch.

Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>

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
 net/core/sock.c               |  6 +++---
 net/ipv4/icmp.c               | 28 +++++++++++++++-------------
 net/ipv4/igmp.c               |  2 +-
 net/ipv4/ip_fragment.c        |  9 +++++++--
 net/ipv4/ip_output.c          |  4 ++--
 net/ipv4/ip_vti.c             |  4 ++--
 net/ipv4/ipmr.c               |  2 +-
 net/ipv4/netfilter.c          |  4 ++--
 net/ipv4/route.c              | 10 +++++-----
 net/ipv4/tcp_fastopen.c       |  4 +++-
 net/ipv4/tcp_ipv4.c           |  3 ++-
 net/ipv4/tcp_metrics.c        |  8 ++++----
 net/ipv4/xfrm4_output.c       |  2 +-
 18 files changed, 88 insertions(+), 51 deletions(-)
---
base-commit: 7e6e670547210424443261b2d54d2acfff85a37c
change-id: 20260820-cve-2025-40074-6-1-95c50e6b9af3

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

