Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8601F63F9;
	Fri, 28 Nov 2025 00:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289440; cv=none; b=LO8zU+i7PKknMz/6lyMkW6shq2NxIXn6xT6SNCTvQPQXHh3aR40TL/s/hD+XdvlVzuZREq3P9i/M3DPhBuWcGhxb09znIGjYB+y0ov7uow0lKKc1ETLv7i1MqJCuP+g3GcpS49zK9pEoIfYLIYJTW3GXNozl8Edjg+kfbFziD2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289440; c=relaxed/simple;
	bh=dORjfa6n3C0ENEkBZc/YOMXX2WhysDe6GvMfgTl/41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnELew5XB/4wvJt5eYS8s3DEcwTBsE1d4CjabsqfGUcOiml97nK5Z8rFU+jpcMgRvIcFgSJHA52garJF6+nix2OPib0cXwu/5zBu/SlA4Uamkd5HU+CIdgr/T6TFs95UxZJCSXIuFT1jM1uTP48BRp7mO10EjW7ShucjA5sfbQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J/XEoI0D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J/XEoI0D"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 90DC260254;
	Fri, 28 Nov 2025 01:23:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289430;
	bh=DOu8n5x2jr1joKWSOeCmgzmiwVNDRtVXvHZ6PHKoAiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/XEoI0DRhHiw7c/6HnTOfO3a9aJDQwFIj5vL42vdViru80gXaFlbiQu7NkUeJ47M
	 LtZcl2ohdkJpl+N8Cza1PjgP3U0d4gfwv7fcA235cM3ifT4lU2xgy8Q/PZKY/hy7TK
	 P1TquVvHXnRnQDJRy3xJ2C4576EiYA529F1jlgK9f7zqqRIjhXtnfjzzRrLcH/aTDB
	 QOIU5cVvjbP7HaXgDvTSesTlvWQm7vCWyRqyaMpmOttld2FrYGNOu6CUq+ZIrh2Omn
	 sC6nndi+hLZr92Fx7oQhRe2crRASxxKNJjDHBo44sVwOsrYAGLOtqTTrYjDSxwYjtj
	 4hGEvuhnLdgHg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/17] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Fri, 28 Nov 2025 00:23:28 +0000
Message-ID: <20251128002345.29378-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a sanity check to skip path discovery if the maximum number of
encapsulation is reached. While at it, check for underflow too.

Fixes: 26267bf9bb57 ("netfilter: flowtable: bridge vlan hardware offload and switchdev")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 14dd1c0698c3..e95e5f59a3d6 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -141,12 +141,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.47.3

