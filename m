Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C33424D65
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236996; cv=none; b=Ag2qBSo3fMiTmWGu4e+1jwstnZmWng0HkVXF62xY57t6zxBmG7pnjjDirELE9ACGSpjS/IBARB9SMyyFtzM83OBsO7kAOJRi+VzOsYZ+1oo+ACNhI4Kz+lvCRu3W4iXLdEVbN4THy3OAK3LCUZJjI0bXbSxBkx6h8Oz0x+RqRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236996; c=relaxed/simple;
	bh=H3vnarmL/Lj/GYl/WZtn49xDLvOoUE3cvwmG0UuGwYE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYX9rvhegCmzCprXcKcL8yfubDXW/9L+CQ2i/onJdWckuiSLIq5qDdpTHbPyPMMuhR0YDLcQJSnR+0+mUBxt7WEI7HZqYSclcDqnLANZTnSOzOj4xtjwi5nxwFVF39uRUjk8uXhn4aUXI5vC8NBnJEqkHcvN8slMmemdbZXVz7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IlSamZXF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IlSamZXF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 71A4E6019C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:09:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785236992;
	bh=8ct9CeXdfJPRJ6VmRnitORxLHVsuz9RTjBrqUo8JRUE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IlSamZXF4ttKGtkyjAdP5PArbfPcXdT/VCPRu/lV535VIp0Yh3vlATwXcV1y3z1dA
	 7WE7xZ53EvRGWMOFOHwc5ohITW/tfP1jMOgPzLYInktdY0KLHkMdnSQC6YAQnrbrL3
	 uIB2KusUUExVb3WX0N0tS3saztSH/RONiYCi//Jtg05E2m4VJkpbXDW1er6cFr7nph
	 arrRbsAnht0GJErn/gVrL+I7fca9F9R2VfjYFYVxI/JDMgaznw0tc1pADbtN/HyBjH
	 jb3fjI717hMCi9tsklRwnQ/NU1oKWW5GXwBFhGwo6acGcrdeQF7VbCfrLiJraNh5YD
	 J0hID64fHRkcA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 4/5] net: pass dst via net_device_path in dev_fill_forward_path()
Date: Tue, 28 Jul 2026 13:09:41 +0200
Message-ID: <20260728110943.124900-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728110943.124900-1-pablo@netfilter.org>
References: <20260728110943.124900-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dst_entry to tunnel device path, this will allow us to remove
a duplicated route lookup.

This is a preparation patch to retrieve the tunnel route directly
from the .fill_forward_path. This new dst_entry in the tunnel will be
used by a follow up patch.

Since dst_release() works fine on NULL interface, this is still
noop until the flowtable starts using this.

Add a new dev_fill_forward_path_release() function to drop the refcount
on the tunnel device route, in case of error out. Export it so it can be
use in case of error out, to drop the refcount on the tunnel route at a
later stage.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 36 +++++++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8db25b79573e..62cfad7e6b79 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -892,6 +892,7 @@ struct net_device_path {
 			u8		h_dest[ETH_ALEN];
 		} encap;
 		struct {
+			struct dst_entry *dst;
 			union {
 				struct in_addr	src_v4;
 				struct in6_addr	src_v6;
@@ -3427,6 +3428,7 @@ int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
+void dev_fill_forward_path_release(struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 96c01f6e9dea..e0c132db15b2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -748,6 +748,27 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[stack->num_paths];
 }
 
+void dev_fill_forward_path_release(struct net_device_path_stack *stack)
+{
+	struct net_device_path *path;
+	int k;
+
+	if (stack->num_paths == 0)
+		return;
+
+	for (k = stack->num_paths - 1; k >= 0; k--) {
+		path = &stack->path[k];
+		switch (path->type) {
+		case DEV_PATH_TUN:
+			dst_release(path->tun.dst);
+			break;
+		default:
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(dev_fill_forward_path_release);
+
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack)
 {
@@ -764,16 +785,16 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		last_dev = ctx.dev;
 		path = dev_fwd_path(stack);
 		if (!path)
-			return -1;
+			goto err_out;
 
 		memset(path, 0, sizeof(struct net_device_path));
 		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
 		if (ret < 0)
-			return -1;
+			goto err_out;
 
 		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
-			return -1;
+			goto err_out;
 	}
 
 	if (!ctx.dev)
@@ -781,12 +802,17 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 
 	path = dev_fwd_path(stack);
 	if (!path)
-		return -1;
+		goto err_out;
+
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
 	stack->num_paths++;
 
-	return ret;
+	return 0;
+err_out:
+	dev_fill_forward_path_release(stack);
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
-- 
2.47.3

