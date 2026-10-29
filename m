Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295675;
	b=C5d0qdzPyXiYwvpGdLtjeiICnnIrD0g7Lrb8nMDpJxb9vnOC/FHlkcSjAajRBUGyEttg
	 z+SBnlDDx9fQ6xmKWYi9eaTb1Bgs5LLE/6ZtRlNFY9x4LAliiYvrJtPmH3vT/Pn2RLlST
	 2Dq+PRVvSltoIWR/q8zmosfKQab4rClceA9uH4nQv2PoN2Q0XHyVXCM3QcR62RF3wfjH+
	 +y/vRl9PUyhQEyfs5QG3pwV1Fy+Sklzr+EifQcZojp8uUhYaTI0mPgQZTvKQUlainopPN
	 OijA4VrjmS83CjdzqK7T2OtcJNVAhFD+AduUt9N7dGke8cLcb+W66I3m8YZDeGbTuYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295675;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=cONXdkf7U1C4nGjeUmFmu6YEE+mogk4fzyA4ol6qYSc=;
	b=wZgU08Ki81XUShu717DqDCG7WVp03PsFDWJQvTftYbSG0cgtKieZ+NzjY3DoLDq06TG3
	 lH1MlKAr25IlGoQaSktQaajW3Wu3AVuLZc3YZFk2hfUMd9VEelAVnRyeSF6Ayp4G1I8SE
	 lCWGdCzJGiw5scjpyiDIjZvJckF/v/FaP+9UiDKxZU1dgpUSeHQl1mUmCH35hsQMYIxIZ
	 qrCcWnQWBQyfu+Fy7td6h9oP9B1sbDtcBpBVpa9rnqdVZtCP/xqdKCnafQxkFFu5jLzhZ
	 1MiEjfOwTqelvX9qRxb9mQ+2R4qQpMEkdxHY6fXtpiQITDLfg+v4KCYltG1n2SOUdWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FMtAUK3W;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32215606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32215606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FMtAUK3W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793295672;
	bh=cONXdkf7U1C4nGjeUmFmu6YEE+mogk4fzyA4ol6qYSc=;
	h=From:To:Subject:Date:From;
	b=FMtAUK3WAK7kEYUXdEKhH1nEf46ahRRD3KIwjtaUx3nuoILwccqTUjf56zG2RJmER
	 aWCtWW1jJeLkoB80Mh1LTOvhcWRnyp09nD4TcK20ZbRNeyvajk5wsju+/cnkcqGAuK
	 t+4bQtM4GbGtQM1Aj3KuE77VkiG0e1secjAHuFMQEEcGzwpmg01EHfatqfVHfG222Q
	 wfZvFSDT/2dMietUku4yGV68mAZhb/FnDP4LU0VDj0fl8o8pa5PJesr1aVqRIBIKU1
	 KsVtwCWWx08rJbfwdVaCt/2DOSRTMQ8PwpScXuB2UgahYxAgdElZm9udIbG02W51cd
	 IW2LMoyD57Gdw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0F20760055
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 18:41:12 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
Date: Thu, 29 Oct 2026 18:41:09 +0100
Message-ID: <20261029174109.225990-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
instead of 0644, sashiko reports this is exposing a global static branch
to modification by unprivileged users.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebase on top of nf.git

 net/netfilter/nf_hooks_lwtunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 40c6fce14a63..154c33ef257b 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -76,6 +76,8 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 				GFP_KERNEL_ACCOUNT);
 		if (!table)
 			goto err_alloc;
+
+		table->mode = 0444;
 	}
 
 	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
-- 
2.47.3

