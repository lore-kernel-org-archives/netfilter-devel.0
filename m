Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5033F38B;
	Thu, 22 Jan 2026 17:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769103993; cv=none; b=QLcOIXz3umwcjglaK7Aog3kM3FkmHHvcZ1uOwv/LCIHOe+zYh0Elbcutr7XgOeVBaoQFK6X0Lq9/a0P76YBqfbfVfnl8UMWP+uo31DHjyWFt5XnKVDZr12IsDZLYAXR7qPVAu7r5uCcfV4xy4tqOlQJHpmKG/Dr0JFNBtLh6+3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769103993; c=relaxed/simple;
	bh=J6EE2JV/EP3jDCqUxKjcoNGe9PWk5ovakEfZ60HsXpU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WXSOpcra/TPHsS54Bi5p2Dlx9AaGQMw9XjUQV3jbTVa51HbQbfkU1qzwJkAX+oB4Y5/wPFb9EZ2SXBj9Zov8cyxuypzZpwVKufk/R/KBb/UN+85gMgytl0iW5cQAqJAxclQY2rZeUYAlu6qldvIz3y5KDtuXpnEbK48+jR+96TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sIuK0HKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sIuK0HKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73CAC16AAE;
	Thu, 22 Jan 2026 17:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769103993;
	bh=J6EE2JV/EP3jDCqUxKjcoNGe9PWk5ovakEfZ60HsXpU=;
	h=From:Subject:Date:To:Cc:From;
	b=sIuK0HKNjPaDFeFLGLaIB6HB5ac6aJ3xfuMpKzDfE8DFEERMPLmKcWU4uKHZ2vdKH
	 AE/Ldi4PPeLOKxGsA0kFNEG52gUQSEtxsWBI36yirROATAemw5S01hwpzEF9P3HSnz
	 1cMP5LnpTmjYyUFaH51fO0ZGI1EL894YRuHGINFlVvs3CMwn6peAhKVIXIDQC9iB1R
	 2Vrk6hQclxubXluqvHhaLEsPHwrn5RhB1u7G62DxfTyqeZSjqI+KGzrqLTFd1YBvrj
	 pyzMsS9PIMWxaWrNgFusMvyj9GxhJNCE/Ji1lJ0dwdO8ZeUVUJ64xAtvfYCLcLCHJE
	 NF0JR/Dz6c+0Q==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH nf-next v4 0/5] Add IP6IP6 flowtable SW acceleration
Date: Thu, 22 Jan 2026 18:46:12 +0100
Message-Id: <20260122-b4-flowtable-offload-ip6ip6-v4-0-ea3dd826c23b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NUQuCMBDA8a8Se26xm3ObPfU9ooc5bzYSJ1OsE
 L97UwiKQIJ7uP89/G4iPUaPPTnuJhJx9L0PbQqx3xF7NW2N1FepCWc8B84ULQV1TbgPpmyQBpd
 2U1HfyTRUY2G4lS4zSpEkdBGdf6z6+ZL66vshxOf6bITl+p87AmUUNGamVE4JbU83jC02hxBrs
 sAj/8SKbYwnTAgNykGJuZU/WPbGJAOQ21iWMAvOmkrnpmD5FzbP8wvR56bsYQEAAA==
X-Change-ID: 20251207-b4-flowtable-offload-ip6ip6-8e9a2c6f3a77
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.2

Introduce SW acceleration for IP6IP6 tunnels in the netfilter flowtable
infrastructure.

---
Changes in v4:
- Take into account encap limit option during tunnel MTU calculation
- Take into account ctx->offset to get next-header type in
  nf_flow_ip6_tunnel_proto()
- Link to v3: https://lore.kernel.org/r/20260116-b4-flowtable-offload-ip6ip6-v3-0-c1fcad85a905@kernel.org

Changes in v3:
- Split patch 1/4 in two separated patches 1/4 and 2/4 and improve
  commit logs
- Add more comments in the code
- Rely on skb_header_pointer in patch 2/4
- Link to v2: https://lore.kernel.org/r/20251209-b4-flowtable-offload-ip6ip6-v2-0-44817f1be5c6@kernel.org

Changes in v2:
- Fix compilation when CONFIG_IPV6 is disabled
- Rely on ipv6_skip_exthdr() in nf_flow_ip6_tunnel_proto() to avoid
  use-after-free issues
- Drop patch 2/5 from v1
- Link to v1: https://lore.kernel.org/r/20251207-b4-flowtable-offload-ip6ip6-v1-0-18e3ab7f748c@kernel.org

---
Lorenzo Bianconi (5):
      netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
      netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
      netfilter: flowtable: Add IP6IP6 rx sw acceleration
      netfilter: flowtable: Add IP6IP6 tx sw acceleration
      selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest

 net/ipv6/ip6_tunnel.c                              |  27 +++
 net/netfilter/nf_flow_table_ip.c                   | 243 ++++++++++++++++++---
 .../selftests/net/netfilter/nft_flowtable.sh       |  62 +++++-
 3 files changed, 287 insertions(+), 45 deletions(-)
---
base-commit: f8156ef0fd8232055396ebf1e044fa06fb8bc388
change-id: 20251207-b4-flowtable-offload-ip6ip6-8e9a2c6f3a77

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

