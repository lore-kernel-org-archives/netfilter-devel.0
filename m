Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888A3DE45D;
	Sat, 16 May 2026 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932604; cv=none; b=F4fq8EmQh4o6IvmhPPsDu5BtLf8oxvS/697lUujzrdomEZmoHjy7fsnQ7QR9jFY81atBZnD1/qzGqI/KaVfHa8c4QjRcdyzdWGox2T/qfR2ow4sqNetxrg7K4Ls7hKCe1izKSeVxDIl+9cutph1Rkh8m3dTJU1lKMxvgY7sVfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932604; c=relaxed/simple;
	bh=fsxan8zgwYIs3Q5Hyc42Pt4XxvxvVSmna2oXTZy04qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=splOb/6JSGa5xIQ0vqeF9+BkX144742Mk81WGuCvmjLN1SY619hIEI7wfPCEpBjd+ssWv70vLIJy4b8V3Fh7KBT+cZZtY1wQYDvvHwvs9pV4LSlrGGmaegATJ2zYZpbcRF1pnMYnLdajp9DCMnj5pORNKfUSuOaV+n+dHS3sE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kOHMiEvB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kOHMiEvB"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97F74601A8;
	Sat, 16 May 2026 13:56:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932596;
	bh=+gS/EVPkuIyUXsz8n4Ns1Itk49TUuSCq2khAAi9l1Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOHMiEvB4yaS7CTH2TfdRRtzWVzYqwdhMbEu1YL+rgxpxl4oi2q34NjZ3WfgnliNZ
	 1Sg/J91slLNR6yk8DufhC9C2qfBO7Cq/wIaBbHnh2ulJhxjTorucA+fUz7vm5qzSF/
	 i2Pwt/p1QtonejymYFBRCw/JpdbHBawt8+q3VoIYkEAxLDoxtA4bIVeeXylOTG4t2T
	 4txGJa3WfvH7Z3S3oiS3TEvlp9eLD1/Lohd+l8vi3ZEvWhfi7NNK4r9RLCLH1x/+62
	 KBMGyYlu3cRLVaR0bsb/eDL4Zwj0F6AEMhfbtnRNpCi2QSPt1nRVf4egQTzJIHJC6X
	 TTuAf3SJfqpBA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/12] netfilter: ipset: fix a potential dump-destroy race
Date: Sat, 16 May 2026 13:56:18 +0200
Message-ID: <20260516115627.967773-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

When dumping sets in order to create the proper order for restore,
the list type of sets dumped last. Therefore internally we run the
dumping loop twice: first with all non-list type of sets and skipping
the list type ones and then secondly for the list type of sets.

Sashiko noticed that there's a potential race between dump and destroy
if in the first loop the last set was a list type of set: its pointer
remains unreferenced and a concurrent destroy can free it.

Fix the issue by resetting the variable holding the pointer.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c5a26236a0bb..0874029cb0f2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1613,6 +1613,7 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 		    ((dump_type == DUMP_ALL) ==
 		     !!(set->type->features & IPSET_DUMP_LAST))) {
 			write_unlock_bh(&ip_set_ref_lock);
+			set = NULL;
 			continue;
 		}
 		pr_debug("List set: %s\n", set->name);
-- 
2.47.3

