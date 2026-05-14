Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862F3B19A0
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748935; cv=none; b=hItW3Oc7ebz4tsd0m2eW/y2cklG6pxRYBc7JjOL4I4JLKDmWH3uet6X3ra9mP3CeeolLVuT683dGrXvN30I8XF8zJG5oueOL3kzDiPys3S2VkVUuQC1OpTi3erz7WevNesHdVD/k+C5r4lTb56WAL4vderX/YhTyX53i72UQ5Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748935; c=relaxed/simple;
	bh=PweMeeNiWetmI1IlqZYsffCOo6DRZfNO60rlsv7kr9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RAG1qBlNQZoFQSGe0wzVu2xyrydvJqw6ixKdUaGkp/htRx2pb0AyXN0di6/3yzVhQmmTq5m5CbyT87vBb6dKIHA2UnSv4iv1Iy9HaK37y5kHvGABhbYZNlrZZaZbSEnFsoxNDvjoWI60ctLp3ck49ik+Nj5C1ZS1Dat7Zg1NLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Qb5kakAU; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Qb5kakAU"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gGPL315KCzGFDNP;
	Thu, 14 May 2026 10:55:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748921; x=1780563322; bh=iOqXsFHMy7
	Y7qcmN400r3PykLdkYw5JCX7S3PYF8nD0=; b=Qb5kakAUV1UN3EpUTf/GClCzE0
	eRzwpS+Wot38ngwoZ17BkZRgZcdhjff6vgBZTvmcGC4uxV/fy1ooR+HasUcPBfgM
	jplgUwgY+xmrLW/p7L4D/mDZoeCpAhMCGuDeF5eMqc8rJiGl3KUj3BFTeoEXtsaF
	ML7WF7+VBKrzZlgHw=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id xewHBs3ga6Mj; Thu, 14 May 2026 10:55:21 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gGPKz1m8kzGFDNJ;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 01B171401DF; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 01/10] netfilter: ipset: fix a potential dump-destroy race
Date: Thu, 14 May 2026 10:55:10 +0200
Message-Id: <20260514085519.12729-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260514085519.12729-1-kadlec@netfilter.org>
References: <20260514085519.12729-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When dumping sets in order to create the proper order for restore,
the list type of sets dumped last. Therefore internally we run the
dumping loop twice: first with all non-list type of sets and skipping
the list type ones and then secondly for the list type of sets.

Sashiko noticed that there's a potential race between dump and destroy
if in the first loop the last set was a list type of set: its pointer
remains unreferenced and a concurrent destroy can free it.

Fix the issue by resetting the variable holding the pointer.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index c5a26236a0bb..0874029cb0f2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1613,6 +1613,7 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_=
callback *cb)
 		    ((dump_type =3D=3D DUMP_ALL) =3D=3D
 		     !!(set->type->features & IPSET_DUMP_LAST))) {
 			write_unlock_bh(&ip_set_ref_lock);
+			set =3D NULL;
 			continue;
 		}
 		pr_debug("List set: %s\n", set->name);
--=20
2.39.5

