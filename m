Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795814135;
	b=ty7SEJ0exG3TqSEcMHM4HFmMqLofsTMq7jB8pn3mhOzkU1iJhgY+EjdjMCH+7fzrTQ3D
	 aUw1wIkRcGN+iOq8GJMttyHb95UQ/5Nrjpl1mYng0QCTGckrudPDDXgTOO0NFDxuA6MTe
	 yYH/cOXEGtN0RmEKfXYLrCgkaAQGAQuq+kE/xeTHJP2oyPf4wi/QKmNhTDqXBPmK1Wi6c
	 Ixqqwq6D13N/CD4jWL4Hmlk/3FvrGRHDnXoeHat6ttikk+vXZKJ7p0ToLpZwOU1dM2Vfi
	 UzVCx3OoMhupdqxvEUCpkK05khchqGjv+W3ZtKFGGfePkJGsJrDMnTDMSRd5Bf6p1KQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814135;
	h=Received:DKIM-Signature:Received:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:From:Date:Subject:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JLs9HwFSOAho+YgrEjdhAUoTXtZO82g7017gQ2hZFS4=;
	b=A/jkvWwDUpR+mUcG3tx7ckeUI2OqaY0MtivLojr70sBNWJRjUQAyaM5kp+uTSTCrPFQf
	 AtjSZlslFGy+x0LDYBTfQFI4gSbPeuZ6EWSk54ZeAjBlmNxQw7Z++Rfi+ZyhwM2VeGo9p
	 iZV4uCUZvXq8axN7Hev1d2L+Ws0e7L39SmWu+ODCd69DdwvCpWTAWnxwb46Nz/TI8jB3z
	 Vkk5PM/ibR9PmAueS+MXGuQHhwST2pK/8SGtwXyJyfNDD0hLS4D67JfDNInItxJL8B8F0
	 Zmuz5htqq2A+BobGvwhVcIB3LC+c6vyaw5O9Nc8bFDn3IGWIQlSkBBToPl3yYWh3QAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JX7R1d09;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517F606A31C;
	Fri, 27 Nov 2026 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JX7R1d09
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795814134;
	b=uiZNxKlPVK+WuwSN+Tdio/qM2f9l2qPj+mLOGI7SVnqNkppJ5S8FEaFzZQjKA6IR4zoO
	 liPhPVvt8JFKcdz9Zdbn6W6TxqiF6woxAuFtoLjeoIhuo4/l3YE6QTBeccqkbAyzO9tEv
	 rXkzCaO/qkYSKxbyQV/01SWxm/cFCkEnKqjLBYdcfm0jA9ZA5WkweZ3cg5NVVorAMmoGv
	 uox5QYxsV+lUanU3c//66gFo0O353gDv2u/wl+dDYBnN58hW9xzBL0ryp3rDk7ZzTjDSg
	 Cnl7VtghgKu5m2gWmPqea6YnXYFU6yz+G8597AW1vhN8E/Z4Ecjmb5W2NI3W5ip220w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795814134;
	h=DKIM-Signature:Received:MIME-Version:Content-Type:Message-Id:
	 References:In-Reply-To:From:Date:Subject:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JLs9HwFSOAho+YgrEjdhAUoTXtZO82g7017gQ2hZFS4=;
	b=pDzLbrgpPnmOWU2iyZ5Dx3gmxX2gaETOb8j1LEptEOwfRxZW74HI/a2hTDgo/M71VvCh
	 3/HWbroEFG9GsnGwnL/F4596b7WKDDdesbx3w6IpCUrN+Y9FLjTxyPKNNWkaUjxK7lvIx
	 dQ7iiM/bs6vvMwRjsJGgBM8PcXNaIKBbXCqtxpwwqU49yhfgvQkUaszNqfUYx3fdVuym3
	 Rf97fY+WnjBkycc9+QavJ4bttPb5T0pD6TbA76Rq70DfBkfdZuOJ2wgmoTLtB2bGXsVIj
	 hzVWo+7trNNx9HQJkiDtfghQ9wS8WQNkhPepSLG035w4Mu0sul7+dHEqd7RxvWTjpPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B55671F0089B;
	Fri, 27 Nov 2026 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814134;
	bh=JLs9HwFSOAho+YgrEjdhAUoTXtZO82g7017gQ2hZFS4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To;
	b=JX7R1d09yimczwNtxDrungNznOWLVqNsdmMrOa41+q/vbOcERxKJPw/BFWC3IOCW+
	 ttCAtEJKlbkYGdgM2Ka0G4SE/6XVqg7ZiognMwaxKVnMNKtLxjmp0WbhBGVr6Cacam
	 Olb5SUfYDhKsK6pgmWBOt0bpEeqF3X59K28KtzcC/XReLXd1edLGMX5oBEScLbYhb2
	 nq+1N0RvtDqVhvQneKq/2v/+H2cLC8gMUw8cHJ/8ybdpvNdrphNWLdh7vYQy/IWCHb
	 btRZP7PrKGMyxLM8z8S0ydwGOLxeQZW+YfJ756QIQeXyLVJ7M6OsqUDHRPUsAk5s//
	 Ez8pbl2jDYyaQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 480084DE0F;
	Fri, 27 Nov 2026 21:15:32 +0000 (UTC)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261127-nf-ctproto2-v1-2-b5383cef8da2@certik.com>
References: <20261127-nf-ctproto2-v1-0-b5383cef8da2@certik.com>
In-Reply-To: <20261127-nf-ctproto2-v1-0-b5383cef8da2@certik.com>
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 18:12:11 +0000
Subject: [PATCH nf 2/2] netfilter: conntrack: reject timeout protocol
 mismatch
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 coreteam@netfilter.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795813751; l=1700;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=Eg6xkj+hY1owkOvEJ4GABU50fLTvmFKF8elU28QXiLA=;
 b=oQJEjG8SDM1uaAltfSS+4Av6J+vYRwdh8fP+1R0NWtMt83wZiynX6hdaYU8esYS0JtxHzbwPh
 sjPFjR4/HUQB5ywmvoPiXxV7QYsnSFqcmp01yLeNqVMtWjhPtE3bltD
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com
Content-Transfer-Encoding: 7bit

From: Dickson Wu <dickson.wu@certik.com>

A conntrack template can carry a timeout policy selected from rule
metadata instead of the packet protocol. nft_compat does not enforce its
compatibility protocol when evaluating packets, so an ICMP or UDP policy
can be copied to a TCP conntrack.

Timeout data is laid out for one protocol tracker, so an ICMP policy on
a TCP conntrack makes nf_conntrack_tcp_packet() read past the end of the
timeout object. Copy a template timeout only when its protocol matches
the new conntrack.

Fixes: 24de58f46516 ("netfilter: xt_CT: allow to attach timeout policy + glue code")
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
This was found and the fix prepared with AI coding tools (OpenAI Codex
agents, with review by Claude). I went over the analysis and the patch
before signing off.

 net/netfilter/nf_conntrack_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 931b76aacd..eaae27bf09 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1782,9 +1782,13 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
 
-	if (timeout_ext)
-		nf_ct_timeout_ext_add(ct, rcu_dereference(timeout_ext->timeout),
-				      GFP_ATOMIC);
+	if (timeout_ext) {
+		struct nf_ct_timeout *timeout;
+
+		timeout = rcu_dereference(timeout_ext->timeout);
+		if (timeout && timeout->l4proto->l4proto == nf_ct_protonum(ct))
+			nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
+	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
-- 
2.43.0


