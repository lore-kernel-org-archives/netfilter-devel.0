Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789859;
	b=RlQ/G4JHUqQ3dn6VVCFFiwOYHBRIN/ys6AZv5P/q6OjOwZ5NSRM6kOKgMmQyQsSjoqJy
	 7xictud2wLHZTDXtDu2ebxfmWwr/eW2t2PhAgxbF/O6Q6DE6YLOywuls4tUz9sU+L/fjI
	 rmsg/Crwg/OxkpiCSFgnHFuz3MgYpo6uHvxQVZ8+GKFve3uNlNcPxxRp0E9JsYzH2yavd
	 Ooq12a0FmK30VQtJl8Mxh+e+Jrqd98PFbS7cXvWdph6SPnxnBK0FChKautxnKf8a5KHX+
	 exCc/oAPqcB+IN8+b9n6eBwSNmdkb242paLNLu0UeMgGCThC5aYUPzXFe2J9RJzXbeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789859;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=8bhtQHOBI7+X/9nJSN6otowzZoz1vReVnQfpWCOI+kg=;
	b=gqTH2P3+lbm/ECMdg4TymCvd0L3UeTRAnjySQ/pKVMdVW9IZ5gXPySt8XNfqccBj4CBH
	 fzS2uNW6ROraOgdOXYjzRGf/TO3ftN/SDLNaDcGFnH23JqMGM75+MXl6tb8o52gI9lw5d
	 8Iu1WWimmkGXXQfYyGcN+teg6HT8c/5uXeW91pnVHnQgw7IH11aiMfXpFnUV9lG1Het8P
	 O3CFoMCLTnWFqef48MqduftLUg5zm02pQ/JcF4WsxggYvpFwYvIlWLR97Me8l5pciioDp
	 aVniIXVCNIbKMz2yeO7N3zSVMLtZCaVuYhax5BEAB1fwTlBtbAAzuiUryGL9v4u/UGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kuP9Ubhx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12808606A89C;
	Mon, 16 Nov 2026 00:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12808606A89C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kuP9Ubhx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789857;
	bh=8bhtQHOBI7+X/9nJSN6otowzZoz1vReVnQfpWCOI+kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuP9UbhxWFgJZkUYJgnpdnp03tSDMfnYT8IzPpAS0NutPQfF+/4daCQ/jFAlDM9SC
	 2X5DQzUr5Vw/ofcm2BJX7k5mqiwbNrxc2V268EVXsbUbdlQRrYxGz59uCJqjN+mqjd
	 6MtSRjOB2NS8LG+Ll38RyhlCO7mVZRTxXDOsaxFbcjQNSmTcAGkjZujDxf1ZR6/QAr
	 1PFa6OOrKNFWjbZu2CPSRNB53EOI+O85lXJqRfUhNBkMUGy4SL3aGF4i/+8zDJNcyG
	 s8s2ucZFvyqy5wxelmqjlVyJWL18EwKtthjH9kjED2rh2efn5WAPUu+0aEvx2MMdQr
	 l40tdcX+7ypug==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18E886005C;
	Mon, 16 Nov 2026 01:44:17 +0100 (CET)
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
Subject: [PATCH net 04/11] ipvs: ftp: skip conntrack templates in ip_vs_ftp_out
Date: Mon, 16 Nov 2026 01:43:57 +0100
Message-ID: <20261116004404.2821183-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
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

