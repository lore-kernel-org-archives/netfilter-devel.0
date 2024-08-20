Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522CC18952F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 08:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724141214; cv=none; b=KMa6VbWlq/sinOICR4Ti7kWKW6vU95crY1TeE6i0ySdVX1+5eylAy8fAU5YKsPHDJD9Y/M7eFg1RvXMJnlQxxhRW+SBmcmERs9f807xinqdMt4aXTeCPvIFbjOnuL/yEkUxyTfH8iLQ3cSI6/aNq6e1W89gZIV3yWVBiWcOabCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724141214; c=relaxed/simple;
	bh=yfjRpTsxEWS+++tERPoAw/urstNxqquT5AnayrExxto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=si/hmTWvyOc2XgiQ8HDSVjel9LGzvAB5eSCM5W/U/vx7i8eTycRaOML8HP09MXVVYbV+9S018qN/hXEJ4q41MNkn1+zjluS4NIntxz1GMxkKRtI8anlKfnEAbUeYXnx+bO5eLNgpWUDW7kB1vk5uvJ42fSuOUkhgFu6Dh7ApE9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sY2KwUrA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1HoFQXXT; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sY2KwUrA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1HoFQXXT"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9s3upuQ57lCTz6JBjNkW/EibUw7QvchxIEXA3z4iqaQ=;
	b=sY2KwUrADMbePM2aGbwCVIEcHLeUVzr5hOPP+eSxYk0EdQPAcHJ9EPuVTJ+mPUozgGbSds
	JFZVyN5d+xdTYsdiK/xVxGMj7uiXq6IqQh5QMEpvmeq67QMDjgW34yzDNs3WH8arbbIP97
	98B5euV8NbacCup97KbMuywYy2KoybvlD0CGaye64MaPKUBJp7u8OF9RSURFPRY4EvcBIs
	CsWGxL14qOhjYpG5lO+KV2uvEMrORYj6P9X+qSvmMtbx8MYH50av74xhZZ66E7Roc0JTrH
	3ThGe2Kqei6dsLxgfsS5mCJV4t8ey8W9GrQnpVOrus3v2vZDxOZq7OMt3J2DvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9s3upuQ57lCTz6JBjNkW/EibUw7QvchxIEXA3z4iqaQ=;
	b=1HoFQXXTVYK9u9FugVItBARwEifDrKq2n6F/jaWnN7Y0/1Xk7WBVLALCt58BPjROabUafv
	44xhyF0grq92XmAg==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net 2/3] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Tue, 20 Aug 2024 09:54:31 +0200
Message-ID: <20240820080644.2642759-3-bigeasy@linutronix.de>
In-Reply-To: <20240820080644.2642759-1-bigeasy@linutronix.de>
References: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

nft_counter_reset() resets the counter by subtracting the previously
retrieved value from the counter. This is a write operation on the
counter and as such it requires to be performed with a write sequence of
nft_counter_seq to serialize against its possible reader.

Update the packets/ bytes within write-sequence of nft_counter_seq.

Fixes: d84701ecbcd6a ("netfilter: nft_counter: rework atomic dump and reset=
")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_counter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 16f40b503d379..eab0dc66bee6b 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -107,11 +107,16 @@ static void nft_counter_reset(struct nft_counter_perc=
pu_priv *priv,
 			      struct nft_counter *total)
 {
 	struct nft_counter *this_cpu;
+	seqcount_t *myseq;
=20
 	local_bh_disable();
 	this_cpu =3D this_cpu_ptr(priv->counter);
+	myseq =3D this_cpu_ptr(&nft_counter_seq);
+
+	write_seqcount_begin(myseq);
 	this_cpu->packets -=3D total->packets;
 	this_cpu->bytes -=3D total->bytes;
+	write_seqcount_end(myseq);
 	local_bh_enable();
 }
=20
--=20
2.45.2

