Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFE979F5
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743760120; cv=none; b=VXNt22IMfdRzF+Lh7XRbIW3kkgOWzqJ+kvkj34JJvlT5wgc+sloA/9hjcOSb3usvxHMKlTLAlfbe4gN0bQL221K1jkAYop7ipf3rZPjpZ5/vlbWGa0KjlNOf8JiLQAMgqM/NdKg6enIg5CQ4NGY+BYbRlHRUff5shQijdQozI3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743760120; c=relaxed/simple;
	bh=LmJoLR4+dMF2llMY+pwzOJsehJccWh4EIP5xv1JBeqM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S+5qnUW0PlQ9xmuK09bX4rJkDYNDZMwr+JjEs4XdcDvmHCQWYtOkBZM186kMmxX6bxukjhYxFW4CkXbxDUGDZOZjNnRG8Ws/SrKskhAy0dLbfvG+PB4wTsK00Fp2OAuk300dHsuCFN194CRkhH8RhOq9gkUHTOHILScc+LlvrX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TtZig8hu; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TtZig8hu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743760115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H1WNp8Sdl5Eg21aucGRFDbKdTODSrFapuL8TrvbnCtY=;
	b=TtZig8huxLnqc/iwzI6fI3FBiwUDdGdg6eHFFZ+50GEIX7gHG5sFPXM2ow45W/q0g9sgWP
	njIVkw4FC6n2euNi3ps6p1sNIyjHrfKrfh+jwFsLPlCccffUHEXYxIUKo71DIcAvzJwy36
	KMdnUMUan8hjn3uk0jCRUWAzo+BoRg8=
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net
Cc: Xuanqiang Luo <xuanqiang.luo@linux.dev>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH nf-next] netfilter: Remove redundant NFCT_ALIGN call
Date: Fri,  4 Apr 2025 17:47:51 +0800
Message-Id: <20250404094751.106063-1-xuanqiang.luo@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

The "nf_ct_tmpl_alloc" function had a redundant call to "NFCT_ALIGN" when
aligning the pointer "p". Since "NFCT_ALIGN" always gives the same result
for the same input.

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 net/netfilter/nf_conntrack_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..de8d50af9b5b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -531,10 +531,8 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 
 		p = tmpl;
 		tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
-		if (tmpl != p) {
-			tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
+		if (tmpl != p)
 			tmpl->proto.tmpl_padto = (char *)tmpl - (char *)p;
-		}
 	} else {
 		tmpl = kzalloc(sizeof(*tmpl), flags);
 		if (!tmpl)
-- 
2.27.0

