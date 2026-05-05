Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B72264A9;
	Tue,  5 May 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777992597; cv=none; b=Pvs1ZAKrz3jGyS+AKpE2iuQvhf7cKc6iuRi3oHxn39diEQblBBvk+TrClF/nBxMI82PeSsQMMh3xpldIuKecDpWQbpOQRo7EMBhe6BeflACI/7xI0fU8jOWgLwbfH+FC3ogH0+ujVPJecDuhAmhvIpFnmYGyvAn//HZHmoR8RGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777992597; c=relaxed/simple;
	bh=dZ/+jnil6Pu/MzChOQY4FGpZ4ETygGepo3YkBb//DOU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=g+fHPTpKgt0dD2kos1a9uNutGcT+Y8EwV+CVnmUZTcqEyLjskhrqcGGHjgA0a1ek+YgMpPvrQ3zot5NolwJjRSeeat6bnRihQihC4ZNuJSCSE5Z1bXlN5Mu8RT/fbhZLo1ufug2vgW+qID4YFN7+7mrtUdLarbdYMU3b/wlGeNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qCdgi/kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCdgi/kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E58C2BCC7;
	Tue,  5 May 2026 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777992597;
	bh=dZ/+jnil6Pu/MzChOQY4FGpZ4ETygGepo3YkBb//DOU=;
	h=From:Subject:Date:To:Cc:From;
	b=qCdgi/kqpOSKIkcN2M2bOppgyEmBdd3gB+Uy93hCkGXWyulcXhIxs69MYZwKoSWA+
	 4bnGly2PdGxR+1M1uAYvBdIZiPRaYND3dZL/XQgxC3YZNfMbXnThkWFIxYn285si6J
	 fsPms9mTVUNo1Ra1F/HawX204kqO0TSDqOegf8UFPlvzMercqjLMnkTmBMZEFvCpMd
	 wgY1Gt3/pfxDWglSfS5ec3X12vpjxeTauazkHCzlT2sI9Wr5b9Uoggjunpml6uY2Az
	 uZHtwdIJkCyF6Xf4Yc8usR7qBBeRViVwk8iLP4m6bxJRkykef5zFF+oYwXLa3vxE9K
	 CF61PbXkLrnxw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH nf-next 0/4] Add IPv4 over IPv6 flowtable SW acceleration
Date: Tue, 05 May 2026 16:49:22 +0200
Message-Id: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqFIBAA0KvErBsY+1bQVaKF2VgDYqLxC6K7J
 y3f5t2QOQlnGKobEv8lyx4KVF2B3UxYGWUphoaajlpqcdbo/H4eZvaM+URjLXuU2EnEXpGin7a
 L0j2UISZ2cn37CMFh4OuA6XlelXqnD3YAAAA=
X-Change-ID: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
IPv6 tunnels in the netfilter flowtable infrastructure.

---
Lorenzo Bianconi (4):
      net: netfilter: Add ether_type to net_device_path_ctx
      net: netfilter: Add encap_proto to flow_offload_tunnel
      net: netfilter: Add IPv4 over IPv6 tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: Add IPv4 over IPv6 flowtable selftest

 drivers/net/ethernet/airoha/airoha_ppe.c           |  14 ++-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  13 ++-
 include/linux/netdevice.h                          |   5 +-
 include/net/netfilter/nf_flow_table.h              |   1 +
 net/core/dev.c                                     |   6 +-
 net/ipv4/ipip.c                                    |   1 +
 net/ipv6/ip6_tunnel.c                              |   6 +-
 net/netfilter/nf_flow_table_core.c                 |  14 ++-
 net/netfilter/nf_flow_table_ip.c                   | 129 ++++++++++++++++-----
 net/netfilter/nf_flow_table_path.c                 |  16 +--
 .../selftests/net/netfilter/nft_flowtable.sh       |  26 +++++
 11 files changed, 174 insertions(+), 57 deletions(-)
---
base-commit: c1e5127b577c6b88fa48e532616932ae978528d5
change-id: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

