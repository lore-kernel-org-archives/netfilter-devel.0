Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539580;
	b=LQatqFT/Xugg1DYQrzaiQrOWOlSkbRW2Bp5UcWNTS4KwPczKoALUG5muydf0GVqclzK6
	 yKAToxWpGaJeEA1+yHAXLhalEwPdwJPwV6httlqg9pcZL0caesXKR5LJ0/K8WYq35y8uW
	 beIYzIVUz23N4P7BZiEpM8ZM88GGUGpUcFUcbQ7k06lg7xGIRgvAniCqm0i5UV3NZ5l5I
	 vhiXpSlN/7hu3fm06BmPAzDxZ5CznIE6Eiak4yMU5Z37+gGyfBn6nKSyrmYM2G5DJKFB8
	 m8Toi4cMA1MXeMhrJf2rZuCWRW8y+tGBhyafNkHZNgO3qkAuAgvR1vgb437gcqX9s9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539580;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=9zmDEpfpsyhkPdf0R7bMz9mubrw4ivGSdNjMo6UTJw0=;
	b=SlugcWiJpulS1zrGX0QnLDqrclkrsou4Sknpj2I4NnXV3N9WmSE4wMLrk3raM7gaZnQP
	 giMCFBsvz4MBRtFrjE8jUKG6qUFA5mi+s+9p5s3Ai/QYr229UrboKVoTus3IjGdrsnNaN
	 2VF7XNYotqBBe5C1e0JZkdSFkM89hJ/OLzj5PJJo3+MWxrIRsR1PaEHziSg/jhwCSI4Ra
	 Wsb65OIzoiP+DALN1oza675wH75Z6e/UavxwmCcoHo77wtnbwB7XUSbpgcgOFu/aVGJIG
	 KYsjBbdAfGZvGWqMIfxO1whaLBPfgEc98TNWxZfk+iL0za0vLCpLIaZnIardRt8V3lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Gnx5s4dr;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98188606A32D;
	Fri, 13 Nov 2026 03:12:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98188606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Gnx5s4dr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539577;
	bh=9zmDEpfpsyhkPdf0R7bMz9mubrw4ivGSdNjMo6UTJw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gnx5s4drwlhbCVwESVbxhXJl4rC07FkJXnQPVxdIjGZ+w6cHQmiJgCpkMZPnLl3VT
	 krStAFlcpR6clBRUrxnz1pyE4eGpvpmqX7b3fmKNxstNj5xr8xobhL4C/UeByB+az9
	 49bQc85IFGjEJMKJur12BbaE8KXkOFTUKAzYSeOW3w5R25pEeKoT+xl/cBF4sK2pWH
	 UD5CzYH+MoONxkzMd6o/mzChvri72YFAPCTGCh4FYdXbz1zoKwquml6Yb3zsvby2vL
	 toVYLZb0v2oe9CHEfoHhvihpPLXrTQjWz19A5jqLOyK0LeQYSw0sht67u9zuXlDEej
	 k9TnASh92q4gg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 508C1602A5;
	Fri, 13 Nov 2026 04:12:57 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 01/15] netfilter: flowtable: do not hw offload flows in teardown state
Date: Fri, 13 Nov 2026 04:12:37 +0100
Message-ID: <20261113031251.2437074-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that refreshing hw offload from packet path is racy
since the flow might be already going away.

Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
status bit"), GC skips flow entries that are still pending to be
offloaded. Let's just check for the teardown status bit after the
pending bit is set on to address this race.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..3a18fa48cadb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1120,6 +1120,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		kfree(offload);
+		return;
+	}
+
 	flow_offload_queue_work(offload);
 }
 
-- 
2.47.3

