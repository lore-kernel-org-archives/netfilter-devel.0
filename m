Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C0235045
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 01:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337695; cv=none; b=UxHCjGoxPkdF6P3fdBXd8YaGtP7ZIo/FN5/zBYlCKyYe6G/nuRsLDIB5sM6i5DJ2k33nx73R6Yihu/iam0Ej2cCw/5sgV/JJTs02n7yNsiZmYMcVwYTtD6eotv0mnpYkzQAA6BrPLRW6M6f5cEpEo3nmLHTg2Uj1IXf2UDnZ71I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337695; c=relaxed/simple;
	bh=f91kVa1SnteaYVPhRYgPS0d0Msq8i52Kp/zORt7FXgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a6YI35BopyvaBHD+byO4HN51co+PcUSimLyLxSL4zBaFzI5Voh/m2AsLHVQpdmlTvS0hfB4AcDUsP9X15rUFR5uzSsVQHL+pPNmsGvaIU3KmT3Sxrusy0TPU6ptPd1/eodiR1dcCaXuvXket3ekrCYTTycrM7KctaGohlsmgpaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Twbw23fF; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Twbw23fF"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so790763a91.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2026 18:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337692; x=1791942492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sG3CdAIWHpBKyehkdlkkQ/ER3qu8k3On1q5+xe+2nI0=;
        b=Twbw23fFXO7VtbsyuIYvBvMhSCBSB4ZFtZooQkBDMR2m04CQW6v8x3YFECZ/pjSOtd
         UKSZrW8Ub8o6tql6x24eUiEX2ZZTU8m3+v6k0405QR7hDLk49V/VuADLbf/rwVi5z/Gt
         wDjCA2LWBOTuynmQCdK6jdtIySAUasGAUi1MU8c6zu3B7wkSFIUdODdQYrZ4cFF23/Vv
         utLrPzXPhDmK5IIUfr1HbcIGb4QV2EY18nwSiadnnzdJ10A3js+de6LQ0QIa5zTZGfoi
         vI29h6xtUJz9RWdNVrl76WKp0PnZKevBTjxvT7pfC/DPYikfLBp2Z6e3KzRaREo2Wd/9
         e0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337692; x=1791942492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sG3CdAIWHpBKyehkdlkkQ/ER3qu8k3On1q5+xe+2nI0=;
        b=MgoDRPsNvdl3g8kamT87xbdp5haPDkryGYa+JKfszZj90DQl89Vm6PXyQeCfSuky33
         pIyhV7B2LeutQNEgf6XUaftt7ngG3e7jn1x4fhaheUY2Hh0MD4hQ9C/4H2jBx9WohIl0
         rrLYNt5UiT2sM/ZOXw7jmI3QgKMieVfPRZ2GrA+V2pZdPAEUx0KOamIZ/o6VAboKh5zO
         kyqE9hk54NLlhgr9KoHeeemcmLuvCI/LJmEfgO0B4Nh2yNbeJRzy1OmXo0pQ6TACseyB
         WcgPicgktmNnls29PAwM6//xF76chzekTsGnEisVRfjSKnK1TQ3sy94DM3HvRWOQAjA/
         4Q1A==
X-Forwarded-Encrypted: i=1; AKwUvBx0JIq/uj2IJzmgRWzu0ar4KJ4/cr0cgdYft7zJIb5IbgMTkifx5LX7xq7AuPeszZaeqPm0/MxP6LZEEZuScJU=@vger.kernel.org
X-Gm-Message-State: AFq9FYIPv1tsPETMKkzP0/FtZMUPFwzjnyk0TaakCmwKjk2Ldu3sCCpt
	Vw3FDAdVpWP+rEak7OwWHK+pQVw/sPqyk54AJoQfDOxKsgl8cfL+a3U4
X-Gm-Gg: AYBFou36gz1l2cJoOcoNEzELf669BzFLur0OQmpRl7LxRs3EdIgq7JEXYXtkppPZ1TW
	DC/JVpgkkPpoCZ/HE8Hjj9pHyDSiENRiPrRpugNQPjHsiM+yn0NgebPS1ue2xNcEO0guFwi0hpc
	HJnbMSxoqhIDM14Zm9FKpTPnhxbYXpjw+hlDFbe9AmrY4G4ipIec4DpjAXu9eIBjut3GEsNmDRI
	j8oQEYYcfqTqdxTyV8vOrHKfWvM7g+88tc8GJ5IgY9ruR8cU4yC/dk0wAe1EbGVBrz+MNGNbiNm
	V39aFeRfYFrSx8W0dhfKk3hVaBT71hn0B6hRQkSIKnSb91NDqdwDLwaV6l30E17LFDsFkTLbGEW
	VxhJK+YDrsettxCbczWz8HhJIPr28FsUUgkIk9HA49+fWq5kLjCwYcB0yGAfdMLt8IKyJ4Aosaa
	rVvacDcS57sfDQc3ziRea7vTam7XbR7cDiZgn+rb9vupFVMCCLe8H3oGQpDsvGXeqc905GoQHd/
	C8vtZmclQE=
X-Received: by 2002:a17:90b:134c:b0:3a4:ef4a:4f12 with SMTP id 98e67ed59e1d1-3a8a1c12ec1mr592405a91.61.1791337691999;
        Tue, 06 Oct 2026 18:48:11 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a5f778fasm442161a91.3.2026.10.06.18.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:48:11 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	4ncienth@gmail.com
Subject: [PATCH net v3] netfilter: conntrack: avoid recursive master destruction
Date: Wed,  7 Oct 2026 10:48:02 +0900
Message-ID: <20261007014802.2615503-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A conntrack holds a reference to its master. Userspace can build an
unbounded acyclic chain through ctnetlink. Expectation producers can do the
same: an nft ct expectation can attach its helper to an unconfirmed
expected child and arm the next expectation with that child as master. The
H.323 Q.931 helper can also propagate itself through call-forwarding
expectations.

When only child-held references remain, destroying the leaf calls
nf_ct_put() on its master. If that was the final reference, nf_ct_put()
recurses into nf_ct_destroy(). Repeating this at each level exhausts the
task stack and panics.

Nested expectations are existing helper semantics, and CTA_TUPLE_MASTER
was introduced for conntrackd state replication. Avoid per-producer
restrictions. Decrement the master's refcount directly, then free the
current conntrack. If the refcount reached zero, continue destroying the
master in the same invocation. This preserves existing constructors while
bounding stack use.

Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/179127347858.434549.11821822167265441355@kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
v3:
- restore iterative destruction after Sashiko identified nft expectation
  paths that bypass v2
- document conntrackd compatibility and expectation producers
- do not carry Florian's v2 Reviewed-by to the changed patch
v2: https://patch.msgid.link/20261002165601.1754467-1-4ncienth@gmail.com
- replace v1 with ctnetlink entry-point restrictions
v1: https://patch.msgid.link/20261001180224.1018290-1-4ncienth@gmail.com

The source reproducer remains available privately on request. V3 has the same
code and stable patch-id 033ffbf1094d as v1. Code-identical earlier net and
exact v6.12.105 6,000-entry userns runs reclaimed every conntrack without a
crash marker. On fresh net 0984ebc63179, nf_conntrack_core.o builds W=1 clean.
The patch applies to current net, Torvalds, net-next, linux-next, v7.3-rc5 and
v6.12.105. Strict checkpatch is clean. allyesconfig and allmodconfig W=1 were
not run.

 net/netfilter/nf_conntrack_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a095..0ce6141b3dfd70 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -592,6 +592,10 @@ static void warn_on_keymap_list_leak(const struct net *net)
 void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
+	struct nf_conn *master;
+	bool destroy_master;
+
+again:
 
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
@@ -610,10 +614,17 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	if (ct->master)
-		nf_ct_put(ct->master);
+	master = ct->master;
+	destroy_master = master &&
+		refcount_dec_and_test(&master->ct_general.use);
 
 	nf_conntrack_free(ct);
+
+	if (destroy_master) {
+		ct = master;
+		nfct = &ct->ct_general;
+		goto again;
+	}
 }
 EXPORT_SYMBOL(nf_ct_destroy);
 
-- 
2.55.0

