Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA33FADE4;
	Wed,  6 May 2026 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778088507; cv=none; b=FYKzMqk/FgT5E5l4iKYsnSVOPXqfnWUdYORWowJ55XRNNMnwGQ1QqGK2hBkL39PNJ5yUCkaXXy5sUPkbTi+tW70zrTVhQl/gjc0uRxpkgTmdmqyIHNQ661ntlDBfWl6dJt8YE9fGCXJdwmJqG6RpgLWmUNreZYhiZ2QENSAHMNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778088507; c=relaxed/simple;
	bh=uuxr4GBoi0HWmp+BmOao9Djtoy1CtJ8ix1066oLK6tE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=i3V/5oMDl8//G4hB6CvbtvC6Ltp/Bc/nP8yD5Wwp+74M4tb2xpM2f/g6tXLBz1mnUSDRtiCJiLZ+RVqUPX4fjv3zhba4y8CP6NhFgZZwY6hnA0XGh5657wqf3VYd/XiOal/3gmIr7q18k/nnriC7WlcVKO7x1wCG6l2gmuP5KW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XC70NEBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XC70NEBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63289C2BCB0;
	Wed,  6 May 2026 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778088506;
	bh=uuxr4GBoi0HWmp+BmOao9Djtoy1CtJ8ix1066oLK6tE=;
	h=From:Subject:Date:To:Cc:From;
	b=XC70NEBp/ts7waDtWSLkQvU+sYZjSyh6hCX3Q4pe7E+UR3Em2rprQNs8jBxF05EnS
	 VxwwtqFm5d+Jf4eQt9TXNbtsbJdptnOspTsuAzK7YGdJXK1E7icyLsiLrvn6NRbjHr
	 fsj27qfssUagGK13L98mQdj8H0JmChqycKgmNAKmN0nmooh4w0wQFWq7TR/n7o2NRC
	 Kx0P6ScHxNLzAsnRFTqe2y4AZaZkHA+mKTnMRskZax9ZZVEYaz150Q0o4o4hPxtgJG
	 HfOnA5Lpu/qDuh/ypnNuR1QKx5xn8BBj023FZIYT1fNuqlBZQTpjQLT9cPkiYw3af/
	 LW10Bt/B7t0Bg==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH nf-next v2 0/6] Add IPv4 over IPv6 and SIT flowtable SW
 acceleration
Date: Wed, 06 May 2026 19:27:31 +0200
Message-Id: <20260506-b4-flowtable-sw-accel-ip6ip-v2-0-439fd427726e@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NSwqDMBBAr1Jm3SmJX9JV71FcxHHUoSFKImoR7
 97gCbp8PHjvgMhBOMLzdkDgVaJMPkF2vwGN1g+M0iWGTGWVKlWJbYG9m7bFto4xbmiJ2KHMlcx
 Ya6VVXlCnixpSYQ7cy37V3+B79Lwv0CQxSlym8L2uq770X4NVo0JjKTdEZNia14eDZ/eYwgDNe
 Z4/LPLH6NAAAAA=
X-Change-ID: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
IPv6 and SIT tunnels in the netfilter flowtable infrastructure.

---
Changes in v2:
- Fix MTU check in nf_flow_offload_forward() and in
  nf_flow_offload_ipv6_forward()
- Add SIT sw acceleration support
- Link to v1: https://lore.kernel.org/r/20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org

---
Lorenzo Bianconi (6):
      net: netfilter: Add ether_type to net_device_path_ctx
      net: netfilter: Add encap_proto to flow_offload_tunnel
      net: netfilter: Add IPv4 over IPv6 tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: Add IPv4 over IPv6 flowtable selftest
      net: netfilter: Add SIT tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: Add SIT flowtable selftest

 drivers/net/ethernet/airoha/airoha_ppe.c           |  14 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  13 +-
 include/linux/netdevice.h                          |   5 +-
 include/net/netfilter/nf_flow_table.h              |   1 +
 net/core/dev.c                                     |   6 +-
 net/ipv4/ipip.c                                    |   1 +
 net/ipv6/ip6_tunnel.c                              |   6 +-
 net/ipv6/sit.c                                     |  26 ++
 net/netfilter/nf_flow_table_core.c                 |  14 +-
 net/netfilter/nf_flow_table_ip.c                   | 386 +++++++++++++--------
 net/netfilter/nf_flow_table_path.c                 |  16 +-
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh       |  78 ++++-
 13 files changed, 402 insertions(+), 165 deletions(-)
---
base-commit: c1e5127b577c6b88fa48e532616932ae978528d5
change-id: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

