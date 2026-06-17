Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4DC3B9927
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781685703; cv=none; b=skHhTCjnbTxZdwd5ATJcruMdq/15bSMM1RDnN5jsb7Xw/p/Tg22O1azsjuDPEN4HvQW6lcmdNvJWziYtEtBG3EyhVlTfrzyBe079UFrD++o6UezczP1knkZIOhGcN8Y1pFSPpHPaJIg66stmckTLlVTkBqHxHbKfTF/V/ob9sc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781685703; c=relaxed/simple;
	bh=Qfl+tP/vYiGHsR2CWqbEFO5xQ+czn3fTJKSpMv/DHwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tMi85aFUkyQDW0f0ze09SGYhePV4jW7kJCD+96RjKmTpc/fr0CXR3FmOR7zotgm0sFCHAa0mxcHMwNp3TGKYHikvCPbeMPRgrG4m9nh2+AYYWtB9k8fPK2Xh/CZHQbve4KzajcvB23p1VQkbbXUWIBpGZIuSgQyokWaLDd+97no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=mFl7zZfG; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="mFl7zZfG"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4ggHQM0Hmhz7s7wV;
	Wed, 17 Jun 2026 10:41:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1781685689; x=1783500090; bh=k8abddCHIw
	l2F1ODdCUlUPN9Lwa34OyypU3+wAGZ968=; b=mFl7zZfGhXOm52nNeGCR66RJyD
	/L/ymn9ekED/fYPd2s/Cg7nT8E9/ZTVJpl8w0PzJC+7ik7ZpqRFtGI/+IbKVgsQr
	2acGuObiK7k7mtxueGXNjw5Xkbg5gbg7i39D7AoV3LzYg4jkWoUsZ+Yhfcl+Ca19
	IUebRtSG/ILNveebY=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id wv7r7JLCNC9G; Wed, 17 Jun 2026 10:41:29 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4ggHQK0rV9z7s7wT;
	Wed, 17 Jun 2026 10:41:29 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id AE8DF1406E1; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3 5/7] netfilter: ipset: make sure gc is properly stopped
Date: Wed, 17 Jun 2026 10:41:26 +0200
Message-Id: <20260617084128.6603-6-kadlec@netfilter.org>
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

Sashiko noticed that when destroying a set,
cancel_delayed_work_sync() was called while gc
calls queue_delayed_work() unconditionally which
can lead not to properly shutting down the gc.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 662942101200..00f2f4754cb6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -609,7 +609,7 @@ mtype_cancel_gc(struct ip_set *set)
 	struct htype *h =3D set->data;
=20
 	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
+		disable_delayed_work_sync(&h->gc.dwork);
 }
=20
 static int
--=20
2.39.5

