Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CA925B2F4
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055746; cv=none; b=bu/NOhROMCX9IS03c+uJQMNehBIZ/oKOFXywmcrNMScYBOSMt//ln767kPxhXABWUvsYK49nDKqs/FOPhr5VrNsmWwvpghTt5ckKmhxdNEsJgkLKqnWjZB1JYWuSfAZXc0da4wkH8gZqwid/68bLa3KvMjSfbq9OXlo39hIe/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055746; c=relaxed/simple;
	bh=lo9yB/3GeqwpcS4uPjqmwUZN6xgXqm32hGb58wCbYew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rIzS92tlvYQQxd7nEEVCGNjYtEJCn7VivIlOoYISmhsnkLKL7l5UhKtjfrrh0XMHsiJiNjYKSEYdiTgRBxd/+i/MJtWLTfwzjlW3wszC3CCQbT8YSJUDYiZ4EF8oKc1z0umbZomrWjIlHcNJOlhhihPj50vkLm8D7Op1TPdjTq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fBe7xsbY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fBe7xsbY"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3FE0160193;
	Fri,  7 Aug 2026 00:35:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055739;
	bh=C4YHZxu0cCXQwup+ZwUdm1EDAz1GWCrlNf26i3h6utg=;
	h=From:To:Cc:Subject:Date:From;
	b=fBe7xsbYR6BDyfhNG/kY3YTPoyC2soJ1mEPgIDlLYejTu2pddZdklO5EP5Tgh7TxV
	 TkwWSL4HS7gcyTXcoPDLjWT3d+Kv0jLbX+fFWmkoyvXb5EHHfDcDHkaNKBzzf1NjUF
	 GeHBklv4mJEUERASH+BQjUsAzvOnaZubUpkbtJvoYC9fuHXpejXG2rlxTuhpOHkmWJ
	 +JGXnf/MHdU6pTBhlFZ9tOEWBRFPM5tIf5rISYOgkdCrLxSPD7b2T+PmV2AZPadySw
	 exd05CAI37WrBH7UsCCgnesMsvOaKdHs9YWus+qenQpsOaQBS2HsmXDX17ta8+a6HD
	 w7hskGB76J0Kw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 0/7] flowtable preparation for IPv4 over IPv6 and SIT
Date: Fri,  7 Aug 2026 00:35:28 +0200
Message-ID: <20260806223535.523098-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Lorenzo,

After reading your v6 series to add IPv4 over IPv6 and SIT support for
the flowtable, and also considering more recent preparation work that
went into net-next, I made this new series to explore easier integration
of your work.

Patch #1 is your update for dev_fill_forward_path() rebased on top
of nf-next.

Then, patches #2 to #7 revisit and consolidate existing infrastructure
to prepare for the IPv4 over IPv6 and SIT support.

From the flowtable datapath, the idea is to parse initially the layer 2
encapsulation and layer 3 tunnel with nf_flow_skb_encap_protocol().
Then, call the IPv4 or IPv6 flowtable lookup+forward function according
to the (inner, if any) IP header. Finally, there is another check
according on the (outer, if any) IP header to call the nf_flow_queue_xmit{4,6}
function according to the ctx->ether_type, which can be updated by the
forward function.

Let me know if I am missing anything, thanks!

Lorenzo Bianconi (1):
  net: pass net_device_path_ctx to dev_fill_forward_path()

Pablo Neira Ayuso (6):
  net: netfilter: add ether_type to net_device_path_ctx and use it
  netfilter: flowtable: rename tun.l3_proto to tun.inner_proto
  netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
  netfilter: flowtable: store ethertype in flowtable context
  netfilter: flowtable: move ipv4 and ipv6 xmit path to function
  netfilter: flowtable: detach layer 2 encapsulation parser from lookup

 drivers/net/ethernet/airoha/airoha_ppe.c      |   7 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   7 +-
 include/linux/netdevice.h                     |   5 +-
 include/net/netfilter/nf_flow_table.h         |   2 +-
 net/core/dev.c                                |  18 +-
 net/ipv4/ipip.c                               |   5 +-
 net/ipv6/ip6_tunnel.c                         |   5 +-
 net/netfilter/nf_flow_table_ip.c              | 167 ++++++++++--------
 net/netfilter/nf_flow_table_path.c            |  17 +-
 9 files changed, 139 insertions(+), 94 deletions(-)

-- 
2.47.3

