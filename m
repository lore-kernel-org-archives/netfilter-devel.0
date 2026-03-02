Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE99D311973;
	Mon,  2 Mar 2026 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772486813; cv=none; b=DoH4s9EwFm62NErJMWgMAvb9/CxTAHOGCFfOXrNl34tdJjiFHD4kzFcnMruJfuEg8f0rGOONMZHTbPbOkGMbZMYkQBVSye53XChhVJ7lAvJC7F4ptxtR+IaMYi4GrGK0CfxCyv0QWGX3e4DWe36fVWj+gTxneAaymv/b5k8nmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772486813; c=relaxed/simple;
	bh=wCbiKpSuM+Y2Tev+vgu0NocaBsr9LObSpGSJZxBalas=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Hsy4J92yWNBHVSZ66yz/KsfC1gwSDB88XQ5I/gW1qIuaGruzV/4Ks0gkn3yQva3DXtlCPiap1Ch4Rc+CEIUXb1Z/o7iMV0aFkgXRIJzpzLoV9QCcdSGpUTcHSd7yM4fWQtOQzOdxlsBnrvjygbleEmdKqiNMl1M5ppyJG3c91u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=FENQnDM2; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="FENQnDM2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HIY0/QhmjXMLqc/7+DI6IQB27NYnFLrMfhd++B8Q+yo=; b=FENQnDM20xwRKTgS5hHaA+4n1r
	D+dD1r90GcuvnIv+zwPJndL/vGdV7ZJrytujvuw0H9G3e2QuOTOu7epVmvltkk0mm466f4h9otnai
	g9qmNIyxjk6R2QrADCu8gQcTb9EZuDQvfdWqB+8iDsJRW6r3qMSZeDrtghxNCJS5/JMkio+/tP6A5
	TR2PYL9CG+Us6F0PRQp67YgPM95xJMICqPhKS/OvjB/DQOGpscJlbjfjRTntonTT0f8ljUwq+1e2P
	UowXuV3slvqUDPXUSRTuhddmUGZ5IE9mnB92DW/oMnKsA9WsLk5QOArLE3sZE4fjwoCG9HA8AD/x/
	aARwXSwg==;
Received: from [179.221.50.217] (helo=toolbx)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vxAmp-0089NM-Fk; Mon, 02 Mar 2026 22:26:43 +0100
From: Helen Koike <koike@igalia.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	koike@igalia.com
Subject: [PATCH] netfilter: nf_tables: fix use-after-free on ops->dev
Date: Mon,  2 Mar 2026 18:26:05 -0300
Message-ID: <20260302212605.689909-1-koike@igalia.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nf_hook_ops has a pointer to dev, which can be used by
__nf_unregister_net_hook() after it has been freed by tun_chr_close().

Fix it  by calling dev_hold() when saving dev to ops struct.

Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
Signed-off-by: Helen Koike <koike@igalia.com>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd7f7e4e2a43..00b5f900a51d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -352,6 +352,7 @@ static void nft_netdev_hook_free_ops(struct nft_hook *hook)
 
 	list_for_each_entry_safe(ops, next, &hook->ops_list, list) {
 		list_del(&ops->list);
+		dev_put(ops->dev);
 		kfree(ops);
 	}
 }
@@ -2374,6 +2375,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 			err = -ENOMEM;
 			goto err_hook_free;
 		}
+		dev_hold(dev);
 		ops->dev = dev;
 		list_add_tail(&ops->list, &hook->ops_list);
 	}
-- 
2.53.0

