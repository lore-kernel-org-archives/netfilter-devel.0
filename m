Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0945309DB5
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777389565; cv=none; b=pjmEBSxeoqW4c1VThOJ5Tq7dnyKufWwI1NjpWapkFjMiV1vfRy+NN0ty3YA4G51m7wX+zONBJsB70XO4Ciij7Lcg6Li7uww+3TeqK37cYVXaNi7IWnW+xHOp6Pk44wRh6wvOVFPCP5YutKorJp3x+lROJTxgAmWktS2utJz4gjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777389565; c=relaxed/simple;
	bh=YMRdv06tjqMZu25GDu9ffERX/S8SHNcfCse75p9+4xE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UDpRzMMhRxaYJ20qC4sOB8v70qybcwD0wtPYO2qieHGi0+uknaZTBt/BnatwafUKkiihVyJlf8V1naa2H0RaRFUKOtDUS/yuTJxvqGAKW2GxHShNPYmVTo5vSyeGuIFKryBwNsWwd96+7uNc2bHSUL5g2gFlZqN4SsFX0LX6AxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=XaBWTjNB; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="XaBWTjNB"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4g4kcM4Dv5zGFDMb;
	Tue, 28 Apr 2026 17:19:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777389553; x=1779203954; bh=0sqpPnatiz
	rNd068vYgtXE27SpHermu69ZnJ7wzsIzA=; b=XaBWTjNB1XbPLrNBSv5wOgswhn
	vN7hBrO1MYQQ8gS0ao+BUaEDJxx7KRoV+b0WI6v1+SuGR5ZBi72ewkzD+C2vKD7B
	l9hGnH2q0LPEr4p9ZJ2yXWSdJQJ7NxJl9IfXnmv9/VRVzxiPerFZkD58bB13iQeu
	awGFlR9A3ypAZrmqk=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 4vnbmP7glSEG; Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4g4kcK5CyRzGFDMp;
	Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 7F4DE1413C9; Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] netfilter: ipset: skip gc when resize is in progress
Date: Tue, 28 Apr 2026 17:19:12 +0200
Message-Id: <20260428151913.584739-5-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260428151913.584739-1-kadlec@netfilter.org>
References: <20260428151913.584739-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Zhengchuan Liang reported that because resize does not copy
the comment extension into the resized set but uses it's pointer,
ongoing gc can free the extension in the original set which then
results stale pointer in the resized one. The proposed patch was
to recreate the extensions for every element in the resized set.
It is both expensive and wastes memory, so better skip gc
when resizing in progress detected: resizing will destroy
the original set anyway, so doing gc on it unnecessary.

Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 04e4627ddfc1..cc490460c52b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -508,6 +508,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 			data =3D ahash_data(n, j, dsize);
 			if (!ip_set_timeout_expired(ext_timeout(data, set)))
 				continue;
+			if (atomic_read(&t->ref))
+				goto resize_in_progress;
 			pr_debug("expired %u/%u\n", i, j);
 			clear_bit(j, n->used);
 			smp_mb__after_atomic();
@@ -552,6 +554,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 			kfree_rcu(n, rcu);
 		}
 	}
+resize_in_progress:
 	spin_unlock_bh(&t->hregion[r].lock);
 }
=20
@@ -672,7 +675,10 @@ mtype_resize(struct ip_set *set, bool retried)
 		spin_lock_init(&t->hregion[i].lock);
=20
 	/* There can't be another parallel resizing,
-	 * but dumping, gc, kernel side add/del are possible
+	 * but dumping, kernel side add/del are possible.
+	 * gc must detect ongoing resize when comments are in use
+	 * in order not to free the comment extension area shared
+	 * between the original and resized sets.
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	atomic_set(&orig->ref, 1);
--=20
2.39.5

