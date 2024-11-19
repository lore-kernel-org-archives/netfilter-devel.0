Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775B119AD8B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732053806; cv=none; b=SYBHcKK2jysmbd5o4rAO6kwDpg+7GiQHgXXnVXYA3uk5NKd/8czKpAzP7Y+tRTgUQy8aWytxWccmirkOi/2ORr6NKCzUWuxWmHtyLL2/t6BaaV2RnJFREUIBn3sNdPEbjK+TJDE0DCvnJG7uGuaMZmLFHFBK7hgtQZoM//dPffE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732053806; c=relaxed/simple;
	bh=vg1749YQ7QkTG8vCSCjBi98oHh4KKGrNL2VaboKH+gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezLP5AXMTWyHRebT23YuiywI4F7lv8jIMRxEBWZdBvVBNvFXOYDOfaD1kSPE6Iyl5OlPOSOalev4Mf6ntoJBi0QN4Y5jkJ3Wkc/tl/3RtcHxPTvnhBXW2Lm4PrvprQiIj4cZAIXoUizVjnK8b7M1mgka8JsVh8KY/mfSQNapwuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kBX3tpNU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kBX3tpNU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RsdrOOTgM9to9je0u0KAQP/KokmjMV1gONkbJTegMoM=; b=kBX3tpNUOJ8tQUGMjbZtdgynAu
	QcielGtPF7vJG6iM3+215JOc14f8bYkYcX3h+K9R0Q5/s/wrgZ+mY9ROqNycSwor/pBygQqzEGg+A
	bkB6n5Pm4GXlHPRqkSkEcwJE8nE675WG23vu4QAK3aUhH2Av2sZv0DI6dV+wuBkDwuEImi5rwVYyZ
	OtnGhw//6XyjI/KSEgDIE5SUhtMf7alnk9epZJuD6ebJI4mfg4iVQS493jJG6KD5SKRtr0b/QQ2Ip
	v+C+FnrqGD5xSAvv1NveQiDdmgdXHaubk6Kopc+UAG++A+ubk3Pm3pv+C9M7pTWkmG7tFtzsc7BI0
	98gugk9w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDWJd-000000001Dl-16k3;
	Tue, 19 Nov 2024 23:03:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [iptables PATCH v2 2/2] nft: Drop interface mask leftovers from post_parse callbacks
Date: Tue, 19 Nov 2024 23:03:25 +0100
Message-ID: <20241119220325.30700-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119220325.30700-1-phil@nwl.cc>
References: <20241119220325.30700-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed commit only adjusted the IPv4-specific callback for unclear
reasons.

Fixes: fe70364b36119 ("xshared: Do not populate interface masks per default")
Cc: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- New patch
---
 iptables/nft-arp.c | 3 ---
 iptables/xshared.c | 5 -----
 iptables/xshared.h | 1 -
 3 files changed, 9 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c11d64c368638..fa2dd558b1f89 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -459,10 +459,7 @@ static void nft_arp_post_parse(int command,
 	cs->arp.arp.invflags = args->invflags;
 
 	memcpy(cs->arp.arp.iniface, args->iniface, IFNAMSIZ);
-	memcpy(cs->arp.arp.iniface_mask, args->iniface_mask, IFNAMSIZ);
-
 	memcpy(cs->arp.arp.outiface, args->outiface, IFNAMSIZ);
-	memcpy(cs->arp.arp.outiface_mask, args->outiface_mask, IFNAMSIZ);
 
 	cs->arp.counters.pcnt = args->pcnt_cnt;
 	cs->arp.counters.bcnt = args->bcnt_cnt;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 2a5eef09c75de..2f663f9762016 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -2104,12 +2104,7 @@ void ipv6_post_parse(int command, struct iptables_command_state *cs,
 	cs->fw6.ipv6.invflags = args->invflags;
 
 	memcpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
-	memcpy(cs->fw6.ipv6.iniface_mask,
-	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
-
 	memcpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
-	memcpy(cs->fw6.ipv6.outiface_mask,
-	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
 
 	if (args->goto_set)
 		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index a111e79793b54..af756738e7c44 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -262,7 +262,6 @@ struct xtables_args {
 	uint8_t		flags;
 	uint16_t	invflags;
 	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
-	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 	char		bri_iniface[IFNAMSIZ], bri_outiface[IFNAMSIZ];
 	bool		goto_set;
 	const char	*shostnetworkmask, *dhostnetworkmask;
-- 
2.47.0

