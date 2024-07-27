Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431E818133E
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116222; cv=none; b=bhkhkbau27f7m4i40m7OH5DRItL4T13IGuCDYbvvzygtlqwvHHfe6BVOEosU4RNT/SG9zCEUIZFoBTll1JST1JgiD4NEt7At6A4l5FtFCK6IRaqBWIUf9b/Od0R2OPcT0gqAAXukRk36lan2TwCC2lvGeX9SAlamGSNtCe9fDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116222; c=relaxed/simple;
	bh=9zuGQIG0ATPg7YhBdJwUJjrRz6kPQX7lL89wDq54md0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr9Qof/GlWC0xAU16zqp1Vq3xHYtxMAGi3pWw+d8zz2ZF5+2KM7qFw49AcXoJBjXAItKQG5FWeMRi+TqvnWVJ7oKvksjJsNr3akPWUhNTNzrcPlruUsdyNQILHKGxxCN1dY2sORbCJoyhIPr0kwgyEOAYT0gzanuL9v0ph1H4nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=C6FuemTf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="C6FuemTf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XNfB5N4JqZ/PPgpK9/N7Tz2rmbEdtIVfrXs5vw7uHUs=; b=C6FuemTfjv6SScgm5MgI/N6kYT
	z2CeEgRUoqAf/S6EqOY9h3MVaeTYmA35d50ScXc6/z5pryBOt6P1c9jOp1VSFP+KiCfvyhz7Io6+v
	66ge51v/kCB6ZQOQzILK9JhnUJC0k/6G2VT9txIbErwX82v5yvXol3Sh2s8T9aXsThchBMkYmXXH5
	93/fiXnRqFlDqObKOiOT9nvf+k87WXYtyFOeyEFUurABtotnNwOv/Nwxec+OjlF9/vW/7+eONv+j7
	ojsTi9lz1qs9b7O+K5TskcDr2xYZHKTl/sD4O913TTNQ68kA3oqYfuqByWy1CLjDnV+PzYQ/8oH11
	6Nny2NfQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp63-000000002V7-2lhj
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/14] arptables: Fix conditional opcode/proto-type printing
Date: Sat, 27 Jul 2024 23:36:41 +0200
Message-ID: <20240727213648.28761-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The checks were wrong: nft_arp_init_cs() initializes masks to 65535, not
0. This went on unnoticed because nft_arp_add() does it right and
init_cs callback was not used in e.g. nft_arp_print_rule(). The last
patch adding init_cs() calls in potentially required spots exposed this
though.

Fixes: 84909d171585d ("xtables: bootstrap ARP compatibility layer for nftables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 2784f12ae33a9..c73833270f0e8 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -299,7 +299,8 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		sep = " ";
 	}
 
-	if (fw->arp.arpop_mask != 0) {
+	if (fw->arp.arpop_mask != 65535 || fw->arp.arpop != 0 ||
+	    fw->arp.invflags & IPT_INV_ARPOP) {
 		int tmp = ntohs(fw->arp.arpop);
 
 		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPOP
@@ -329,7 +330,8 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		sep = " ";
 	}
 
-	if (fw->arp.arpro_mask != 0) {
+	if (fw->arp.arpro_mask != 65535 || fw->arp.arpro != 0 ||
+	    fw->arp.invflags & IPT_INV_PROTO) {
 		int tmp = ntohs(fw->arp.arpro);
 
 		printf("%s%s", sep, fw->arp.invflags & IPT_INV_PROTO
-- 
2.43.0

