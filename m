Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCBA3C278A;
	Sat,  6 Jun 2026 20:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777646; cv=none; b=FcFiGx/j7xRUkj/DBJkOv7PFNk1MFnaU7En6F4s7HR5lzzP5A4vaQY8ayeQwVk59vNfksZwmG67TUR+HF+DTUXlmg7J1P8UPCF6Otgkh4rKr3Vf/Mgj+rvfKFVTyDGndamcmEMRMm3mEjwvLH9jkfIER6cDbqzMWe9rz4bNduD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777646; c=relaxed/simple;
	bh=qyBfosr0+qpatC192/Bu3vOwJwINpiuk9z+PGatui7M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nk0dbcg8y2Ni7gbgU7aL1v9CITSlkCeQSz6k3/TzPjptc9uKe5lRGR1gBCuhsvOOTTvfe9y1Jyso+70dt0hCn1HHtIpEUrya/gBarJ9QJ3SOxdsDIiCDbLqlhqGBRLMRlgu42CT+rV9+hA8lZ2Ul8uvX1HpxSp9D9XBy5eY8fZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=UeXdlcDU; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="UeXdlcDU"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbu-007NR5-D2; Sat, 06 Jun 2026 22:27:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=Hw6A0AUF6f2IKiQ/0woPvVgVmVP/JwV+jLZ3gu4O9Zg=; b=UeXdlc
	DU9b8Q1zX6IJl4SD4NNLI/yIFY4vLTpx/GdDwySPQkuEFfIvCea5SnKeIL4LGcupTbLFwZzGpc3ZF
	2S6dafhR+xljnu0eilkpUoQE9KjXWOuPBHoVEobSwesYW8l2cIVhCeBIQ7GzDAd+90KLr8CeNJtX4
	VHvasnB6H1XL1S5fmSaKOKZp3EsoYSPq7mzQc1F+uNjKasXvWre+gwBhlVTbySryaKUQ7cROYB6iK
	U4ITGkgue8zCukSqQHo+j8G+EN/oiTf4qx82RRyZWdq2RaK/uSZBBqHdVwRgoZW9SXxIcHIJW856Q
	eBUvrdNbNYLySNHUgkuFWXj+hIMg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbt-0000tq-Mf; Sat, 06 Jun 2026 22:27:13 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbl-006V18-Md;
	Sat, 06 Jun 2026 22:27:05 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH net-next] net/netfilter/xt_recent: Use strscpy() to copy device name
Date: Sat,  6 Jun 2026 21:26:24 +0100
Message-Id: <20260606202633.5018-30-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index f72752fa4374..d34831ce3adf 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -400,7 +400,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	t->nstamps_max_mask = nstamp_mask;
 
 	memcpy(&t->mask, &info->mask, sizeof(t->mask));
-	strcpy(t->name, info->name);
+	strscpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
-- 
2.39.5

