Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285D1AD25A
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145125; cv=none; b=IMFNqaNHkDk5XkDTGBt8c3QTCU9BgXXM7bQbMC3CAWneq+H5QbPVbJ19jVj/KpmNlrNlGYl9w0Wf82O84+IZzFygqtoIpiBKJfjz8l6Vk27tvEKqK+En2EWQAHrNVlm2uGa6+7dtQv0CmVV0f2aPwWe2NejCJz4GV08TNMP2fCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145125; c=relaxed/simple;
	bh=0puWWswfQyBnVAslnGRxLC5fjU/ezCWSwUx4qopOd5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKA2QshqpxTs7kAqSQ2nyvN9E86/NsgpnBYB95JksrfXmphW1ccze11tIHTny7fyzkXIREvruZwE3Q0l9jqfulBWqpx6QAdF/SnpeoxAgykrh4IG6MoMmeDCd24BnBI3sEhtSirnxbsr4gdUUQHM5kf9HOrrZWnKVerN1JPA5qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=acj2FVFe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="acj2FVFe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o0vTq19QD4O8qYBAc3dTrNX6SCLLRDQjiWJSeIjjWO8=; b=acj2FVFeQuOJot0Z4mITEpAml4
	VXcGLSfTQldVzvodrkfA7bIbpXe3TK9KiHj6vUuTFkxSrm2F5ofGLTg+K4b1jr9OKQKVZm/Zgx2gN
	IH1ZTs+O36eLZQ0bvc2fyMLaEOd5NE+zYQuuDsPdjHaxtdf62dTJA2piJ3gx6ooUTwNSi+ftNDHSk
	VdVujtD5hqbqLo3trpX8K8TrWwm0AvgohLYtZZfw5yNK6/iiKA9NTUjdkuVbRHVMGJKd24ROR+WO0
	Ukig6DTFAHjbOl/Dt2cPpBdjib8k63YF4Kb/QexswIzW/Oale60G60G52YKIJMiyguzS5tW3eR5lp
	4D9/5L2Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipe-000000004DT-22T0;
	Thu, 12 Sep 2024 14:21:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 05/16] netfilter: nf_tables: Compare netdev hooks based on stored name
Date: Thu, 12 Sep 2024 14:21:37 +0200
Message-ID: <20240912122148.12159-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 1:1 relationship between nft_hook and nf_hook_ops is about to break,
so choose the stored ifname to uniquely identify hooks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4fb230e4afe3..457696f55003 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2210,7 +2210,7 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (this->ops.dev == hook->ops.dev)
+		if (!strcmp(hook->ifname, this->ifname))
 			return hook;
 	}
 
-- 
2.43.0

