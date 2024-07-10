Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C036AF8
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625610; cv=none; b=mLDVWlwIzDU3u9PmQAOuKjcWE3vqD85gxF0avdRIvF6liAaqHFdMWY7P9gvTJ3frs89WBsN3PUL6SG5aIw2oehW3XBi95k5Piim5Cx0QVSSFvAoo4rQvScf16nIHNAjdi2GHE+n7bmyNFdGy/B3jU8kw5JSeb9HqUt8d5hykS7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625610; c=relaxed/simple;
	bh=S83wwmXfWn4jk6ObzuKf/wvYEXZVmFJj0YGHYKk+QIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHpbDl8cGmW2FDKopkKGgUiDW9KVBpayc4/lJr4nPzivBXzU97Aisd4AxSTyg9iuhQp49sEmbhHy+YC6nTZwuqWvn5ly4ZQW4bekz+3B1XGnmOhU+WN6ss/RrUlJgtWSDsZOBHxipn5+gLnnPTIffRLvz/cyumUhd6ZdJ164dzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qHxljZ1o; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qHxljZ1o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bOcMhJwlb8SULiY2Vb3aXcgHA2xxXams8ViC8VTvxk8=; b=qHxljZ1ojTN5fkVAcpn6IWLKq0
	PL7EsB2xinvkCUjUxKc0t0niTkXPZwa2Uu3OCqx0dyOxH89WftwvkR1ZedO3Ol7RNs+OMaRPEWATj
	0jSVDh+V/lJT8cszS7V6Z8rUwiRT2xue7DfkkxHcZXqBtS6AZfwYvNPdxtfkI0LcAJ1cw2SzmlHkh
	m0Bi09riwT7xJmMosGFF9mIkpdgd2BjXQziYSl0z7CBhUpPSkJt6xmBnc+y5Fl5bK1ylWraHtqQmO
	MX5NceVk9uxqda8PPaloBXAjyIlEFZvOMoG2377la9RJjOYQPofZfhCgZMb5xKGflzcyDTg/P+5NI
	RtD0fmOw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRZJu-000000001Mj-1lp5;
	Wed, 10 Jul 2024 17:33:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/2] table: Support unsetting NFTNL_TABLE_USERDATA attribute
Date: Wed, 10 Jul 2024 17:33:22 +0200
Message-ID: <20240710153322.18574-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240710153322.18574-1-phil@nwl.cc>
References: <20240710153322.18574-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cosmetics, but support unsetting anything that may be set.

Fixes: 99be0e6d066d7 ("table: add userdata support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/table.c b/src/table.c
index 13f01cfbf1e6f..1a5f6f3bcc507 100644
--- a/src/table.c
+++ b/src/table.c
@@ -74,6 +74,9 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 	case NFTNL_TABLE_NAME:
 		xfree(t->name);
 		break;
+	case NFTNL_TABLE_USERDATA:
+		xfree(t->user.data);
+		break;
 	case NFTNL_TABLE_FLAGS:
 	case NFTNL_TABLE_HANDLE:
 	case NFTNL_TABLE_FAMILY:
-- 
2.43.0

