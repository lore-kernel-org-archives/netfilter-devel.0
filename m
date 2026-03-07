Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43092310651
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772904193; cv=none; b=b5GZykJCpEJERtr/CL05+/dgYgMoNwyRNvO1b6vDcMhI9xhcwUiQPeREvgVn33Q5yZKEtjbjLw9+lCZnk6cWcjVKLA1Gedno/1WMDN5p4p13t1oyCMGXmBd81a9mYK17q0dWRLqH5mRiD19yBbtT9n0rUlO/FltfZAUVtNP7J6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772904193; c=relaxed/simple;
	bh=BzOM1lldFOAMXywLTI7LATbp2773HuhGfEVLnhYc+Io=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Zx9haocu8OOlcwOx6xZMDIPvl/Hkbp4MyVWpWNFcH+hmXCwhPQAbARIQSbbL/Y8ANWQyMeYwATqLwLMi8Z7zFGS2G+wmTb1kzHulxDxCYKUd69brsEaO6OoARG5IPxgfEqpnGM3UHvdciKhA4yXbKwMXwivUcaO1VP4CXILSlzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVmTxiki; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVmTxiki"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so4048949a12.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 09:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772904191; x=1773508991; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g1RMexYaZxcgHftIV215qI4ewau8GuOaml5QTVuKL44=;
        b=QVmTxiki6Y4k/gqMXm5Am/9Elyvs31EOQ0dhLegniSRMcG3Tqa0eWZuUFfdN7gMWT1
         4jJy2scIbICKgHYvLjTRGOeRkvV2YH32AjiGXIXEZO9f7TzOa8OeTg4q3eDI6BuGCRm0
         1ZqemTHZ//CfBZacHU4KM9h9HtYbDoKSQPezvU/p9oTggEPrLsgPjm8MlxPceha3e8BL
         q/J5TJOspTsYZwCUgSa+WLfFu+WkRPalEvO7EhvIniNEttZ1vmSG0l+gt5g+Cz/xqLTS
         bAkWUDUPgtXafiNkH009Tx102Q58BoeU67Iaaf1ghHs1EZzQ7I5LSRiMZCoY5jtvcapj
         hwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772904191; x=1773508991;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g1RMexYaZxcgHftIV215qI4ewau8GuOaml5QTVuKL44=;
        b=wF3LNdrJKnSQG+yNvPu5rGxYyk2kbdr7G720yKW4nAEU7YyELyiLWHfv1+yWmxQA47
         rZwKaivm+oO9J6xv9Oa8XDxnjZ9qRhVDz0NlUyAZSZAq8A7eE9TlsVTHTJTVAO1OTtJz
         3MQATR2vOgymlMf+IVc5xs9wrz9tikmqKRSAmVsNC4ZMoFGBf2g1yW2XHhIUzXwuZkyH
         dxpXHIOZR7Q8gPXxlt0H9xPPh6H6OJR5b5sZuB44GDaU+cyUhf69XkAioYZiCKmo4HRa
         pVpnJ9/c0z0y70VvejSJa+8JS8ylVIYQR2gGQBXcm9XY9f0Q+QnubByjM+2oSAj3d2D1
         j7aw==
X-Gm-Message-State: AOJu0YwRmLQ/rmGP4MiW9fhHhvMyjg0HrynfmQ/Eq7oLJ3uITNqiU0Be
	Tmr88NF9R54ER/RRFQazb6oYN8/aenkqs6qHIY/duI1Y94jT+OnRaL+8
X-Gm-Gg: ATEYQzy6XjcMDnF6wPinB75fl4jgQ8QVSj67QFagdbfRo5HFhcbcuB288eba8e7rgZa
	jvb8X+fJYGET/tAZ3M16dG/B2rqho3IculykzRxVdKoJ65Cd1Wykb7mBcEgw/n90G2Qni2iWdMR
	/vplDu+x1pLo/OIdWKkVkkYMLk98Bb14pFz9/WbFazq9QkRoLTSgKmGnmpYa0504OOD2ragCieH
	yc4+mKpbeT022b2XcsC+kC18ipwU2KKbPTZJxYuY2u8Saf/ng9HDg839l5F4hQFKbuGMg44DrmE
	lV2JDq2jECrDGo+cTOUJSL2h7qNNc5tqKE/dZ6dcSeqkSgYeN7L+jILvbcxQNpK5qL9mbBtvDm9
	5V+AgzQ8GfIPCHQFqoJRTZLCe+Oii7QeRvv8dCxHn4xbO0/aR6YunCutkF6dIwdKOAi4XS+MC5m
	gGePYMBwqZjwzZl6uaXqtXbP6RrHbVy5G+5qNL6ddk/w==
X-Received: by 2002:a05:6a20:cf85:b0:334:a681:389c with SMTP id adf61e73a8af0-39858fb290dmr5932235637.15.1772904190618;
        Sat, 07 Mar 2026 09:23:10 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739dfbf4fesm4853022a12.0.2026.03.07.09.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:23:10 -0800 (PST)
Date: Sun, 8 Mar 2026 02:23:06 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow in
 flow_action_entry_next()
Message-ID: <aaxe-uH2Qr6qM4E9@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

flow_action_entry_next() increments num_entries and returns a pointer
into the flow_action_entry array without any bounds checking.  The array
is allocated with a fixed size of NF_FLOW_RULE_ACTION_MAX (16) entries,
but certain combinations of IPv6 + SNAT + DNAT + double VLAN (QinQ)
require 17 or more entries, causing a slab-out-of-bounds write in the
kmalloc-4k slab.

The maximum possible entry count is:
  tunnel(2) + eth(4) + VLAN(4) + IPv6_NAT(10) + redirect(1) = 21

Increase NF_FLOW_RULE_ACTION_MAX to 24 (with headroom) to cover the
worst case.

Fixes: efce49dfe6a8 ("netfilter: flowtable: add vlan pop action offload support")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9b677e116487..e843f6d0355e 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -727,7 +727,7 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv6);
 
-#define NF_FLOW_RULE_ACTION_MAX	16
+#define NF_FLOW_RULE_ACTION_MAX	24
 
 static struct nf_flow_rule *
 nf_flow_offload_rule_alloc(struct net *net,
-- 
2.43.0

