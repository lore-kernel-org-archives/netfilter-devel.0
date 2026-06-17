Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519C31BCAE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686210; cv=none; b=fywLIhOXTiAOmAObHKHSqdpMoBpflmSbzfJSnQ73Qa8u/jY3iRKVz8TYRpEHEUfFoyTzw3i+nT5YUBmZy+Yy6Yia6K9aNqjwdEJ45s+zkxO2Gp0A5xzVK4/gIidUxqRIv6Tb+vhGT0UE1KsCgpfkZBShuZ0XUgEqhvQ/Gu8kBWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686210; c=relaxed/simple;
	bh=4EvAaYsJg/oBJ5YtDHBFo0YOl+cvijXYBt1avdu/4A4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KMK58A3RixcW6DbdU2da7rOC0xDEo3PMUoAa7Lpfql9yyAcej4UgoBXHu1kuaC0K/FFkcyUySqSKbByRN7cVFwBVIqnr47UnH61PZ78XN71dBDno/mzCI3np2K1aGmuMWE4fJyzxRYWFmDMBfpMuO6mGuXlfiambu42M6BkMvQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=SVVmebUl; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="SVVmebUl"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4ggHQM06s2zGFDCP;
	Wed, 17 Jun 2026 10:41:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1781685689; x=1783500090; bh=ipVIHkcjFn
	QM68PuGJ//klLQD+/YnDOtQHklzNzIk7M=; b=SVVmebUl1UzPR5SBHoyyZyABKu
	2dgHP5KszPYkcE9e95v3q7ChMdvjHdllP7K5RNdJ6wRfyFrvGPnhM3osIqK3JUDi
	wyH1s4i/2AN2h/mkF47qPnGLP9janAvEFaguUde5BELAHZeynzyMREWaRJaU9OIw
	LaP8jS3qtCBgUgHXc=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id KNmmKxX3mB_D; Wed, 17 Jun 2026 10:41:29 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4ggHQK0hKwzGFDCQ;
	Wed, 17 Jun 2026 10:41:29 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id B0FE214078A; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3 6/7] netfilter: ipset: cleanup the add/del backlog when resize failed
Date: Wed, 17 Jun 2026 10:41:27 +0200
Message-Id: <20260617084128.6603-7-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260617084128.6603-1-kadlec@netfilter.org>
References: <20260617084128.6603-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Sashiko pointed out that the add/del backlog was not cleaned up
when resize failed. Fix it in the corresponding error path.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 00f2f4754cb6..b8e011f08381 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -803,8 +803,17 @@ mtype_resize(struct ip_set *set, bool retried)
 cleanup:
 	rcu_read_unlock_bh();
 	spin_unlock_bh(&orig->gc_lock);
+
+	/* We have to exclude add/del */
+	spin_lock_bh(&set->lock);
 	atomic_set(&orig->ref, 0);
 	atomic_dec(&orig->uref);
+	/* Cleanup the backlog of ADD/DEL elements */
+	list_for_each_safe(l, lt, &h->ad) {
+		list_del(l);
+		kfree(l);
+	}
+	spin_unlock_bh(&set->lock);
 	mtype_ahash_destroy(set, t, false);
 	if (ret =3D=3D -EAGAIN)
 		goto retry;
--=20
2.39.5

