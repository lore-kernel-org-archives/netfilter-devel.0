Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783182765F1;
	Mon, 18 Aug 2025 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755516150; cv=none; b=QOtBLYT/vVjAz7M4F1YFqoQLub3+oGW4A0goSdA1CcunYKSdXQA0hBEbwFNeTDXFUa7fmtM75nReNe14ZzmirWWDOb8OQ7c8XcM50mI8CVcKyQ9wGECFzgs03UIqPaELrNbyPK/KU6tOhNv3F2pBZ+I8+b7e2HfejtUpvBhmFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755516150; c=relaxed/simple;
	bh=1gbiQY/r9J8++5jEQ3UILKJfZPk6cI6zE5J0Rn9VyGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hxdsWPEyOj5/EZLWE+8H9FHnC+prvtp2SqMtiAxDof7ASCaelmXGCWRZ7WkIriqWiTjQdnzMjG/r5RyhhceZtghlUefkP8p2xYTA2fixDchYDNhbTCwZE6OwgoiS6Mh3TaexSXn6jTqEel5SO6lhAH7fWj+jpbf/8Xdx5KWKjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ehmc9dPZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ehmc9dPZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rbZ9DHkVW4OtrX4voktvrmKijnsuPEqk2pjb3fx2uYk=; b=Ehmc9dPZpnjHTXMRzJt1Zkbgao
	1CRJ2FjxDxgmARjAWaj/81Ko8Z2UA8YBCVa1Ecm9gozNhoW3I/+YPndqSZgBFr7JbT0VNchBzznmo
	9feqVT5N0ucfVmlhQTUES8n6p7mBnUfWYJr24n9lt6rtC6+V0GA2lMnbQfCZ3bcovy4utE+OlKcRv
	2SDF53cfsv2EXQu4EUOgyBk6X/n744cecjM9V3Z116BIsjkfsqN6531fUc0UE9ZmBrXYH+aZbkdkq
	sapxhE0SUqcLmtXBj9yk0X1+FhNEQ+uueuJaC6qvbHOT+JwjUKK7kyryxorbGJGCq8KH5NNj/1xJ0
	IrRsUi8w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1unxwX-000000006sa-46v5;
	Mon, 18 Aug 2025 13:22:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>,
	linux-modules@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [nf PATCH] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
Date: Mon, 18 Aug 2025 13:22:20 +0200
Message-ID: <20250818112220.26641-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The helper registration return value is passed-through by module_init
callbacks which modprobe confuses with the harmless -EEXIST returned
when trying to load an already loaded module.

Make sure modprobe fails so users notice their helper has not been
registered and won't work.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 4ed5878cb25b..ceb48c3ca0a4 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -368,7 +368,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
 			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -379,7 +379,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
 						     &mask)) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
-- 
2.49.0

