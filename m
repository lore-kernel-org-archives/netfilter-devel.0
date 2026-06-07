Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627973890F1;
	Sun,  7 Jun 2026 09:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825830; cv=none; b=VwpKKKI/GPjBDjuX+eBBUUoaQ92HDe+TQnF2qQHrhIsAksQdwIsmi5M3TGNIKsuA6Nmuy9/owE7vNc2VwWyiuZos18Wqpg65F63xQGuTLl/AsgpripZxvsq+SzOASnTJJtB3tMg9ZXkokzA07E2nScGZ2Mr68JH0VLrst3YEtlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825830; c=relaxed/simple;
	bh=Sx2XMX5br1FTrHl94dIg5otgCnWQVCgSbniwgQKWUdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH5Lwq9XW9IzI1AVpn3fN+U58fNvOTgRD3TMCbBUMWycsa3ACDPfgTG95Hm7jWmQN8+Ps5Tdomh+J/chWudJf0vPpfBj9W5gjEmZtx1+g8reaPYsd0MthI3ltxnp6SS+bU/hqUtHOrTrJXs1BtDVLU0dOU27txNNC4v+7W+hukA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=veE6YVVv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="veE6YVVv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6063C601A6;
	Sun,  7 Jun 2026 11:50:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825825;
	bh=gqj8dZNHAiSRTKStO58THMHlzhrsU6JkHahtwWbJUbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veE6YVVvGvi8BpLfSnuKj9DS7+KMuHrutj8tI4uKifT/o4qZGxC4ZevxbkOPioIOX
	 cB1DEoScGQ3WwiTzY8s4O/CyuS4/Zwd3SGgvmZJdGjy6lcP66XFUpWOEkh9rBeUyko
	 ufD+d3a98MsE6qOysjdnNsVwhC+lJ6dqJaNQwCe394bVghPyG1JDKBy4R+8Y4CGJtm
	 vHErR6ThuGjHHfJeTT3YfywZzP+MOhp2Wx0FuhbwEojuojmzj2w3ZGd6Ljf1uy89oI
	 HXZe1bOcUyVRC+mDJcOIhnIt5+lxrLXHyAEuhmRYLU99lOnDjfM9cWyEdFeq2cSalE
	 STzxwVIVUtdfA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 14/15] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Sun,  7 Jun 2026 11:49:53 +0200
Message-ID: <20260607094954.48892-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Carlier <devnexen@gmail.com>

The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
decrement still happens and wraps it to 255. The break only leaves
the inner switch -- a later path entry can set info->indev back to
a real device, and we end up returning with num_encaps == 255.

nft_dev_forward_path() then walks info.encap[] (size 2) up to
num_encaps, which means an OOB stack read and a bogus count copied
into the route descriptor.

Should only happen on a malformed bridge path stack, hence the WARN,
but worth handling sanely. Move the decrement out of the WARN.

[ While at this, remove the WARN_ON_ONCE since this can only happen
  with a buggy bridge path stack --pablo ].

Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_path.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 9e88ea6a2eef..a3e6b82f2f8e 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -163,10 +163,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+				if (info->num_encaps == 0) {
 					info->indev = NULL;
 					break;
 				}
+				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.47.3

