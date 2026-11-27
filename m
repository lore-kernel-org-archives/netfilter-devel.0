Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795814137;
	b=ZNAF/8e3gPmX88o+gdO4JOrFaxjXBc/+gc/N8L/H+1btJ4btR14Y/0H9EETW0nCP+87F
	 GB1h8BI8gyjbVw8Hvyha/hVTfyy5S3CZDjZw+U7eGSfC2hVSdJNLfiafbIRYrkhA4z3gc
	 TRftEVi8DJKQXZuuAPlhjFnyMAjQluPOLgZ25SRZ4Cb2fHMaBqNpbh1ySIg02c4jLupFH
	 trYd8wzX7DMB/ePZlNnDeav105lKHTWQR8tj70NBj1wJiXPS3E4KU1HsYJrhPPzLhV+io
	 RPRc7W1m07eIJMXreNw2jfr+0x4tDA3e2VpUnj2y8w+bbgN6jW/rdO89uXuy/I9/uQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814137;
	h=Received:DKIM-Signature:Received:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:From:Date:Subject:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=x2wpoea173Z3woWvUD8H9r8Q5K9J4sZmkoeLs+Fizos=;
	b=CrfmnhsEfdyZTxNHZ+SD+imetXrrOGkpbYxuWh4WUJj3N9Ix2rSAXtfWLu9GTHP3PWn9
	 bIzD4ss2WMCOOb5vuZVTGBYwI8atZf/tw9d8rSe+/fMCTd8WtWo0C7VSu1mXAzJgxy5jD
	 cw6oyCxReVdWZgKCxb4m7JuqAlQFPdITOxDHktb3E49HXQqSW5Jy2ben+are+kuX/6NTW
	 irdpfMd5bsNDdq5YsbyC3noDZYEkfIMTH49izD2exXlUocq7thaGF2nydtADvAmpK3FrF
	 Yv1PRIRH6SAppx0iTGw9Dq5j5o+bgf6UYZAXr1iWu3buedowfyGqkcIT4WPQhPQI0JQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+7e1ORs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C7606A323;
	Fri, 27 Nov 2026 21:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+7e1ORs
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795814136;
	b=3MJUaKgfz9LWyWj3LF7RHc1zBUcB+eX8Up1GcXc3ECRRiWtqE0KYZL6H6LQk3LFBKvJz
	 n+wK4kiNVvXv+bEIggTN6Mb2QYRT2I7scpV4BFR6lSgwZ0cQFiX1YasBYMwyj7y7hG5lj
	 PkEwvi7s/kfZWp1gbz+sqklq6An2NXlDj2vrXWqlRc7WolShExZDoSctQXhtDkZ2HQa1R
	 JMybSO6+pb5ktzt7KzdNvTYyNosTBHEzEZ4ra6O/xj6D1TwU7rjINNTzQWmRXDV3cqkfM
	 J5wHU+V3uznyp3C/tjb2Yzs/o51Db0oRJiZGInvpkIlqorK0amj8ZlwN1fCRgm5CteQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795814136;
	h=DKIM-Signature:Received:MIME-Version:Content-Type:Message-Id:
	 References:In-Reply-To:From:Date:Subject:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=x2wpoea173Z3woWvUD8H9r8Q5K9J4sZmkoeLs+Fizos=;
	b=gOKcFMCHCtTp4EF8eWZ0apR6FA+qSbWcTd5uC2nX4DjrS6TKV+G8v8J+C6RlgxBSfAk0
	 fmCK64wEwlNahUJySDfQiV05X2dBDv2hjBOApcVJA94Sx+cYcRiRm5O1kxKFIMNyjxjPe
	 1WIMeRNjUwYF8N3npYHV+b3/p77DBJX2L59M/e/jLQRT8/fqqxFEmY0McYTdZXcF1TbYu
	 8QiJHGdNvINY0sT43qK2AqTxFhWubb8KIAu21FnS8C0iE+EOHCH5AsBy4XqLPGYs+DaKK
	 VxDYSICY38Gg0A25zm4dISxXh3Mc79xRFBz9ruYYBht6gOuZUWlg4VC2v8zC5RsYmvg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9457F1F008A0;
	Fri, 27 Nov 2026 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814136;
	bh=x2wpoea173Z3woWvUD8H9r8Q5K9J4sZmkoeLs+Fizos=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To;
	b=G+7e1ORsGUOHaTzzM5DQbUAEKe6LNr6SPn4R01fCq8pww9wQjt8X4i5zwLlpG8wvt
	 n3KPkd+QqorTglFkncu3batYxYulZoFPQbAx9b52/jIva5kn24UkOnvVAQ1B9tAhLV
	 dNO0N6prrue3En5wLvkoQ3vVu5ASTWMJsy7qGHHgdx30G78fXPgcItFvLnsD+h4+wb
	 0TXbcvGudq0HyiWgbEKEcAKfL+9GiFQFmcjubGy4jFosc/5vfhSAoFAVvzrNFzZsXr
	 bYd1h1JlaZHMvqZj/wuu+LRrdvdXhr2Ie8wBAZec4n12re8WLUoszqxqrhMR5UCb4o
	 8J3Z4fbhLCj/w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 267054DE0B;
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
Message-Id: <20261127-nf-ctproto2-v1-1-b5383cef8da2@certik.com>
References: <20261127-nf-ctproto2-v1-0-b5383cef8da2@certik.com>
In-Reply-To: <20261127-nf-ctproto2-v1-0-b5383cef8da2@certik.com>
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 18:12:10 +0000
Subject: [PATCH nf 1/2] netfilter: conntrack: reject helper protocol
 mismatch
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 coreteam@netfilter.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795813751; l=1481;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=jRXlWORZ8gC8E+WMyYiUvJoGLip9YtA97KaUH8Z36bk=;
 b=rTMnMZIwMrw8UdUNxCunwpOskTUV0k7xYap6amsggOARMYpTZmG8/pGhiVdgNY8mINFThLr6o
 opmwhs1D20wAvsJPhxBaCCYa1PQsKUSozSe7QjtCSbSK7f6VHn1KjBY
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com
Content-Transfer-Encoding: 7bit

From: Dickson Wu <dickson.wu@certik.com>

Conntrack templates can carry helpers selected from rule metadata instead
of the packet protocol. nft_compat does not enforce its compatibility
protocol when evaluating packets, so xt_CT can attach a UDP helper to a
TCP conntrack. act_ct can likewise attach a helper configured for another
protocol.

Helpers parse transport headers according to helper->l4proto. With the
H.323 RAS helper attached to TCP traffic, NAT mangling in
mangle_contents() crashes. Refuse to copy a template helper unless it
matches the new conntrack protocol. This covers all template users in
the common assignment path.

Fixes: 84f3bb9ae9db ("netfilter: xtables: add CT target")
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
This was found and the fix prepared with AI coding tools (OpenAI Codex
agents, with review by Claude). I went over the analysis and the patch
before signing off.

 net/netfilter/nf_conntrack_helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c30ae3f203..91bd11f01f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -209,6 +209,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	help = nfct_help(tmpl);
 	if (help)
 		helper = rcu_dereference(help->helper);
+	if (helper && helper->l4proto != nf_ct_protonum(ct))
+		helper = NULL;
 
 	help = nfct_help(ct);
 
-- 
2.43.0


