Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463401ACDE2
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344616; cv=none; b=ZPVnxyA3RJXbotI6I1gS0/fIEL8pbkkbeI7aH16GYm6UukcjEDfxV4bJ8n1GPINuND2JeEudQhAe1CyjFrKu5UEl5qxTloFdYdXgTdl0h2iE3gICRkOqFpTuouFw54z9c9yg9hCJwV0L/F43dHntJI96hulWEVd0RMisoPPhsKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344616; c=relaxed/simple;
	bh=PyHcQJjd0EsfJMyZEU//rHqgYY4cF+HDatJtbOT5oxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urfX/oqHJ4FohenE+G3lU87xTcVIILSZNxjxIl0XDMZE1p/gfkHF/qfHzTrqnUGEvS15Y60g8h1mtBGdZBl6CicETzoc2RWudXDrT8DKVPw0dN2aO8+UA7sEHJKxnxlPXdrMHwOnjHuzy3EGXg1tG0WdmrEczH6xw+0ffIg6Rh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l6FHrmao; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l6FHrmao"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jEZIvT1obH40X/uvyaQoSVLAVdcmczC1yTaWFnJCCu0=; b=l6FHrmaoy/U7x5s5QhDNCTGbFx
	EXg45v7HvkjWEXiVPvlwJAqZo/8RA47WZ+JdFjrrSSdmev1wrWOLxcPhX2BajEANMI651qC3MXxJe
	t4qog5w0PgGTLySQZcSXH1uHt/kE9DNhhwDvjSFnmasQxyS52gNtFAw5hRGAFq52fvCfYVxYk6/Ir
	HPG3N5DrXT3WdbYuoOMua1pntY/fAvaUojyr+aLNE8pvDGHbwlX+mDH5AaAvfj0yiPIW6Z+LJ9rv1
	1TutGOVHhV/7zCWPycmmzZtbfn1IwmGONxQ52tRw6pakmiRPsAUSUe3T70nVhqhbqIvueca2/jw7/
	dLNpZk/A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEz-000000006G6-2ZzU;
	Thu, 26 Sep 2024 11:56:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 09/18] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
Date: Thu, 26 Sep 2024 11:56:34 +0200
Message-ID: <20240926095643.8801-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Facilitate binding and registering of a flowtable hook via a single
function call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8326395c5752..3721f4636e0a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8581,6 +8581,26 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
 }
 
+static int nft_register_flowtable_ops(struct net *net,
+				      struct nft_flowtable *flowtable,
+				      struct nf_hook_ops *ops)
+{
+	int err;
+
+	err = flowtable->data.type->setup(&flowtable->data,
+					  ops->dev, FLOW_BLOCK_BIND);
+	if (err < 0)
+		return err;
+
+	err = nf_register_net_hook(net, ops);
+	if (!err)
+		return 0;
+
+	flowtable->data.type->setup(&flowtable->data,
+				    ops->dev, FLOW_BLOCK_UNBIND);
+	return err;
+}
+
 static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct nft_table *table,
 					    struct list_head *hook_list,
@@ -8601,20 +8621,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
+		err = nft_register_flowtable_ops(net, flowtable, &hook->ops);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
-		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0) {
-			flowtable->data.type->setup(&flowtable->data,
-						    hook->ops.dev,
-						    FLOW_BLOCK_UNBIND);
-			goto err_unregister_net_hooks;
-		}
-
 		i++;
 	}
 
-- 
2.43.0

