Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763912;
	b=Rf6UUIS8fEZjHaX476pHP5GFtYeKLgX1LGdKXZV/Ha21TPtNnf4cfsR+hiXNxbx/y5e5
	 eizN/xlNqb20VmJVacj+NX1u6Xq4+VNIpc3t8p9XX62fCHtuSOHIYwycZgOPRI7GOgY+b
	 MekYHr5pKEs2z3kb8sIDRgeTb7BN4zi/e+NETGErGNgvVwOvNkRsWOT+KCfWAYHIl8+AK
	 KrywB4wIo5Xbg3dI1SJkJE4W3FjZ/h+t1gmzhVTBhQCAz/y2KgARJsj2d/nVzX5tm/YlX
	 knzEMTqMyxR1kvAg+T5ORP1VhoW+WHwVi8xfuHdgZI9+9S7QFDsG2yKrVKS1+tuZdGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763912;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qlxsrS26P4SfKN6rxYXPb49qB9/nUPJmFDEGzivHKhg=;
	b=fo5v2om5so819aC8BoyJlKi9VQuyQMj2fhefvNpQdrwauR0SAdkPgefbvZv8nDgYkuXN
	 iavXYFC5rBAllwSSj5PLg+w30EmuoWm4HTc+GVGQZQBQ3Dx1bVrQSVYDfa2pzZ5vLIX0Z
	 z0+E4f2auisU6+oWifkukumYDC9derbT8Yw17NpMD1Dj/yMajo/XX6ZRZsqsZCJlKbJEd
	 53h4pIkCuWqT8+9OE6vpauVTTJ2oI5xapLFFFWBSXoZO05X5TRlZf7T4F0WYy64G59qyc
	 Aruq0P1Gc/C4dg/Ugv1O+2KVMgnvlaj70TwCe8yAwPUOigwUjBxd04dPL5bZEipuTWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633A606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6633A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CA37160796; Fri, 23 Oct 2026 15:58:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 3/7] src: common: fix fd leak in nftnl_batch_is_supported
Date: Fri, 23 Oct 2026 15:58:02 +0200
Message-ID: <20261023135806.7259-4-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
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

If mnl_socket_bind() fails, the already-open socket `nl` is never closed.
LLM finding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/common.c b/src/common.c
index e661227c6d43..c92448393b20 100644
--- a/src/common.c
+++ b/src/common.c
@@ -114,8 +114,10 @@ int nftnl_batch_is_supported(void)
 	if (nl == NULL)
 		return -1;
 
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		mnl_socket_close(nl);
 		return -1;
+	}
 
 	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
@@ -156,5 +158,6 @@ int nftnl_batch_is_supported(void)
 	return (ret == -1 && errno == EINVAL) ? 1 : 0;
 err:
 	mnl_nlmsg_batch_stop(b);
+	mnl_socket_close(nl);
 	return -1;
 }
-- 
2.55.0

