Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD97374E79;
	Mon,  1 Jun 2026 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315180; cv=none; b=in3BDdmUAD3Jv+RbgkvLoPblQBxD2MzU7SXV5uvUDvcsPbqz36XA+wTqlbSy16+id71cboAGpK8eOuOzLPLiwNWc13qW6w0W433bF9vvOPX5h7hlgaZvvGbBzPx2fEOXjK5uTK6cym9jabvXqEaWQrLMLNm+nn4e3/9D1PLCj90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315180; c=relaxed/simple;
	bh=xcUS7vhnjTgZe6GkdCWJVyp9nEJQz4NUMV6fr6E4FZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXskpEA82xGYKA4Z1xCotg5H57RKSdsv6isw0lW3OKRvu8TQevGe0kH1i2MGaJ7OqOiC+F19c5+6qm1lwXAtku0aahsiX+ScT9aIJH5fJv9UG6dfF1qbt49n2sRJFDmehKGRoR89Vi/YWO7BcKzyirgvj2i+VNmRhAsz58GwAhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EKDox3PD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EKDox3PD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CEAA9601A6;
	Mon,  1 Jun 2026 13:59:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315178;
	bh=QmdUE6O0idYZnk/9pOY1/UoYlB2Npce7cHK6eh5zgjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKDox3PDVwO19W/2L5skWDndIJhCIOiK0T93tw758Kyze+XzI5eppLWZUFCe3aQIe
	 1SwIOk8lzXgo0t9jCvbDq672biS3leoOjbtHXAbgsFpco+bUBEpdWijmN9q0BBFjH4
	 8t8lQfK7+F9jf96cs+EJJ631Y2tQIl6bgf21Tgzvmueo23YvF6hLlNCSUhnU2GNNqQ
	 NHa/+JefcRnl+IJj6u3vgBuYxKNrDYFgEcqdpBgxDbLTF5OEH/GpXLnVzqnt+3viit
	 uByPZUl4g1ZeREeLgRpQ/y5z6s29xiuwlqH5BQHoUmoDYUDamOQEBbNDTEtC64LZam
	 OZdNYqlDh3hoA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 8/9] netfilter: bridge: make ebt_snat ARP rewrite writable
Date: Mon,  1 Jun 2026 13:59:22 +0200
Message-ID: <20260601115923.433946-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yiming Qian <yimingqian591@gmail.com>

The ebtables SNAT target keeps the Ethernet source address rewrite
behind skb_ensure_writable(skb, 0).  This is intentional: at the bridge
ebtables hooks the Ethernet header is addressed through
skb_mac_header()/eth_hdr(), while skb->data points at the Ethernet
payload.  Asking skb_ensure_writable() for ETH_HLEN bytes would check
the payload, not the Ethernet header, and would reintroduce the small
packet regression fixed by commit 63137bc5882a.

However, the optional ARP sender hardware address rewrite is different.
It writes through skb_store_bits() at an offset relative to skb->data:

        skb_store_bits(skb, sizeof(struct arphdr), info->mac, ETH_ALEN)

skb_header_pointer() only safely reads the ARP header; it does not make
the later sender hardware address range writable.  If that range is
still held in a nonlinear skb fragment backed by a splice-imported file
page, skb_store_bits() maps the frag page and copies the new MAC address
directly into it.

Ensure the ARP SHA range is writable before reading the ARP header and
before calling skb_store_bits().

Fixes: 63137bc5882a ("netfilter: ebtables: Fixes dropping of small packets in bridge nat")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebt_snat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 7dfbcdfc30e5..c9e229af0366 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -31,6 +31,9 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		const struct arphdr *ap;
 		struct arphdr _ah;
 
+		if (skb_ensure_writable(skb, sizeof(_ah) + ETH_ALEN))
+			return EBT_DROP;
+
 		ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
 		if (ap == NULL)
 			return EBT_DROP;
-- 
2.47.3

