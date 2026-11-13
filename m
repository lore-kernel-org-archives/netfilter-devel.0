Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532507;
	b=mGXjOozyOYTNEt3CDrNW777POZqDrVL8x69/kZ1P9nffaODrfJQlENqo9NUTZvqGLZ4N
	 nIpqm35XPwqguRqplRikOj9LjSGqhGl96o1Lp4gNO+MjgVo1EscFlCrXF/f9zkIcz4KRm
	 toBllyeI1X83OgaHeTgvrMWIq1ADPPFJ6Ha6o1m/P/tNjgmUCjOm5r8GQRXqZMmb5dBYi
	 17JCirqE6bE7eKa9+KjyUfU3B2lB+1TDrNVQspw5QmO71/dslZdCmvXRDHH0EC0b/yC2L
	 I3MAgAQHZQ3TX31oQ47jZE50Srb9F3FzZNY01hNvoYMmOZ+/OFAzovdyw5dL2zpafHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532507;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=8bhtQHOBI7+X/9nJSN6otowzZoz1vReVnQfpWCOI+kg=;
	b=hWYCHitoKPbLgLWV10+GNIA/rCAVI0eVq+WXY3Bwom7+wfWTsO850xk8rR/NomsVryBZ
	 N2wvS26qshRMKUuic1ra26R6xhy9gTFoHsE15Zva+UOqUhxKdQWLsVab+6RhGURqh94Mj
	 71MnrsUFI+02hydZaT6HyAsRJCnfyW4tArBAw5D/c8bk7xvEJcOiLHxvAgsaLn9xwJB0D
	 Ojv1Ddftr2Xog0YGx+RvhGM3qYuF+BOKuJqKSY6B5oI991GLgEnFbBUev/nOSEfIIDad2
	 UgJN2W2PyG16+vAVl96jmYf73kg1pWf39yq5jv/NZ5s5SUu7luDwT64aSZO/2Fi9wlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KcVmIpQQ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD41606A885;
	Fri, 13 Nov 2026 01:15:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDD41606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KcVmIpQQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532504;
	bh=8bhtQHOBI7+X/9nJSN6otowzZoz1vReVnQfpWCOI+kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcVmIpQQbVaivGvTXFffBso9Zwu7ws+jF9Vn4Ad4vhTxVgmqP3XdWfeaONQJhXDcg
	 aXC+CeO/4NA3CWgICP4D40nX/wUvcDg1C7C/9wFsZTxzz3CoLXf2btfA4HbyIlzv85
	 zUG272pwjusU/8cK6m6FR8ylE0kUOk74Wr97yH0kqlqF90AyYrXKEmuvi4sv3sftAz
	 0U10NbcqjMkAoRX4Ip5CDZ5W/G+QI0Yo0eOF0pLH2DP62c45Nsks5I0TSYsEblWCqo
	 OviroPAohzSaUelZEyilHp8SJphLYku733oeYarMSRYLAgzOzIrDul4SV+9aQiYYXp
	 SgMIT71/Y93Tw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 54FD360074;
	Fri, 13 Nov 2026 02:15:04 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 06/15] ipvs: ftp: skip conntrack templates in ip_vs_ftp_out
Date: Fri, 13 Nov 2026 02:14:38 +0100
Message-ID: <20261113011447.2357709-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

A CT target hooked after conntrack attaches its template to a packet
that conntrack left without an entry. On an IPVS FTP PASV/EPSV reply,
ip_vs_ftp_out() then mangles with the template and creates an
expectation with the template as master. Deleting the CT rule frees
the template and leaves the expectation, so a later expectation flush
reads freed memory:

  BUG: KASAN: slab-use-after-free in nf_ct_unlink_expect_report

Reachable with CAP_NET_ADMIN in a user namespace.

Skip templates, as nft_ct and nfnetlink_queue do.

Fixes: f4bc17cdd205 ("ipvs: netfilter connection tracking changes")
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 4822a1a75212..44de99f4d187 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -383,7 +383,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	buf_len = strlen(buf);
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct) {
+	if (ct && !nf_ct_is_template(ct)) {
 		bool mangled;
 
 		/* If mangling fails this function will return 0
-- 
2.47.3

