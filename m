Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360817B400
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725378570; cv=none; b=mlcAGEmk+lrt7zsGgQbzSuPXAxYGzCxmVznSzfG1CD6s0JOfYZ3FuxaNfedKjg3C9+3/gyaKBPumCXXTTfOV07vr5kHxuMNrgzAIYr40pnoW3MkOiadEp65kG5RLHq/1Ail9p/jtbK8xD6GPfd6ygatnXTpEHO+2WOzSext3q6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725378570; c=relaxed/simple;
	bh=gs2zHWtag1mXoBe5GxfEDOmhWRoZhnM/3s3aNFbkas4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sOs9VRptGop7EuQ6bAuCR7ktnuV3yVnA61uF/dH+0+TdSKCVsUxpBKjykCv6xdUrNgXTo0lBn2ufijblImj6KZuYOPwJtIuwtpI3/VgbrVYMUSJ/cCGpoN6qjmxsbCcJz6sdJb/AXgKsLIcxTA8hhhDwcMhk69YqFh5Z1lx8IxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dpf4dHA7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dpf4dHA7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MfNjJux1KInrskdK2oXfDXFPNSBrMQrgxtVC8kmdAhs=; b=dpf4dHA7Ewf6xE1qjLUEgRrigt
	9dkyMRt3ByWAZThp7kitg3Uvw+TdrupPBVNv1OTISq1JrRkcwFjYAZghl2JTDxcExdnpw8kHLU2jR
	UCAHIrLQlSu2zpFwORFqXlcAZ5WQv5WIL/s9S1lfLaarvltWnpdwsyfovzDWZEu1EconXebnXNBUM
	Hj1ImJd/qEH2QfeJePIwsR05mo1niYQU0V5dmTCq1/Y5O0dQVFuuXpLGfL39JvM1z8MiHBzimj2fa
	JfrguzYfB/vkxxALFzuhLpCH/WgOL7DhyvTnK76xs+K8AzxEIkcK46k+sqrQ8JXLbuTL0Cv9UXK5p
	B376DOUA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1slVmU-000000002Uq-0EpD;
	Tue, 03 Sep 2024 17:49:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] libnftables: Zero ctx->vars after freeing it
Date: Tue,  3 Sep 2024 17:49:18 +0200
Message-ID: <20240903154918.17211-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Leaving the invalid pointer value in place will cause a double-free when
users call nft_ctx_clear_vars() first, then nft_ctx_free(). Moreover,
nft_ctx_add_var() passes the pointer to mrealloc() and thus assumes it
to be either NULL or valid.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1772
Fixes: 9edaa6a51eab4 ("src: add --define key=value")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index 7fc81515258d1..2ae215013cb0a 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -160,6 +160,7 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx)
 	}
 	ctx->num_vars = 0;
 	free(ctx->vars);
+	ctx->vars = NULL;
 }
 
 EXPORT_SYMBOL(nft_ctx_add_include_path);
-- 
2.43.0

