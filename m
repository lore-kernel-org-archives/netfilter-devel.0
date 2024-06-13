Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494BA145336;
	Thu, 13 Jun 2024 11:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279160; cv=none; b=oHrpIHdHMs4NGxv1b0dNhwUYONpbUkPYoHfvnX4j1zjaXn8tIakubeFsxz6MmOFUSe8qh6HO2fiyCzUbCOtMJcyx6CDDMhxD1dH4dum0Wf4zKrSLKhuenysq+POKVBYraVDyF5zs1MLoz5CvuSTgL2Y7p1P/PIzQ7cOmn2Qumtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279160; c=relaxed/simple;
	bh=lw49iaZ3UOjMrq7BeyboyZT+Lt+ky4bkGkCXg/wXgnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnj8ZTzOVfR39KkNlG74VjhIEJoy9H4MpOEZXYSC2tz2YV8ryflR9DxsKEtkSdMaGDWLwul90z+k2wl/9P00cHpoXxY2wtq8tgzM2YL4WkTDiTN6TYX5U+9z8m270bzyT9BmvVcFmlNcuma62aDY4GVEb/ABqAVtS8P2GXGmmuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+WszX7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+WszX7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F0C2BBFC;
	Thu, 13 Jun 2024 11:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279160;
	bh=lw49iaZ3UOjMrq7BeyboyZT+Lt+ky4bkGkCXg/wXgnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+WszX7ELg7XwvzVnjxuosarB+XdUi/nfNmqcvPqsobpc9Y7dFfLVulyNJlbhnULr
	 DlmivN5hBIsCZjpTcnLRC3o/ohGeOHrxre+mKI+KGwxuBjcPRbqmWL7NdA1DhKcPre
	 jIrs5WG2qnfeYVE1M45oh9kfsHY/v8JwGWHS68VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 196/213] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Thu, 13 Jun 2024 13:34:04 +0200
Message-ID: <20240613113235.537849113@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 552705a3650bbf46a22b1adedc1b04181490fc36 upstream.

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets with timeouts while it is being
released from the commit path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to skip async gc
in this case.

According to 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on
transaction abort"), Florian plans to accelerate abort path by releasing
objects via workqueue, therefore, this sets on the dead flag for abort
path too.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3943,6 +3943,7 @@ void nf_tables_unbind_set(const struct n
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


