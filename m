Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26142F5313
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669630; cv=none; b=FZvpDvBHTtwNHiYU2QYjmVb30stFHlBlbJr823LuJmbmssSWuzMbsACJrkq3S7HyJ7AONzlaYlPoGtzBPkGnDVLLd2NnDefMGEP9yEbxDhTWzvszc8wh5B6gdebdH+1xtNrH9wm8OFpDlAnHQxbmvXLa/8Po0csP/vZfs8Hbwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669630; c=relaxed/simple;
	bh=eCYnUuIt7+n6Yu5/pYcYewFhU1L2fOCf9J4ZDp7tz5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlOmsNE8Y65KprcTCY5PQvc6P6d0xifTr33lKZjqEJliJ8m/Avj9tqvcDqOHxHQzSE7lorQ30/dDag3iv/Mc+B/B+064rFIzQjwGepK3DZOHIoOVilV/yoTuo7BdZVobVw1okTrp3xleZw/TaCtGNxyaocpvIxy7P8oM7FsomS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jkE3f7+S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jkE3f7+S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6uH9pQRtMohezTyaWwiSCgAp29GCske8iWBqPNM2dC4=; b=jkE3f7+S1z+fB66B9ZnGtLlhH3
	03B9SEhejaPAMCaDzxXANCedYyc3wQfyvFoH0epDeVNQySsE8bFcXl2uMgHuNt0qc+xVizscYPFjW
	9igk9rz/tA849SB+1oX2lp9N0XB6oPcCDG/10Mt4UtvPHN9RD6TEWQafeZBkE1UNeYObqWYjYy4Kh
	nGOIbT76c+PT7caT6bDCKBvZLMW+at00zGStGLFgdu3n/T9SUpqU1Nn/RftcJaIvq/sP9S5284CBU
	8Yih63g8I7T/dboMJ5lWBXYokVfh0ZDjVOJ9Acnr9mD14h9kd/VqbiMTTGcK/t9qxbzu6SobcAY9J
	1gn32K9w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1Qx-0000000044J-1It1;
	Wed, 16 Jul 2025 14:40:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 2/4] mnl: Support simple wildcards in netdev hooks
Date: Wed, 16 Jul 2025 14:40:18 +0200
Message-ID: <20250716124020.5447-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250716124020.5447-1-phil@nwl.cc>
References: <20250716124020.5447-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building NFTA_FLOWTABLE_HOOK_DEVS, NFTA_HOOK_DEV or NFTA_HOOK_DEVS
attributes, detect trailing asterisks in interface names and reduce
attribute length accordingly. Kernel will use strncmp(), effectively
performing a prefix search this way.

Deserialization (i.e., appending asterisk to interface names which don't
include a trailing nul-char) happens in libnftnl.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Introduce mnl_attr_put_ifname() to perform the conditional
  mnl_attr_put() parameter adjustment
- Sanity-check array index in above function to avoid out-of-bounds
  access
---
 src/mnl.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 43229f2498e55..8ec4ef40d2761 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -795,6 +795,17 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
 	free_const(dev_array);
 }
 
+static void mnl_attr_put_ifname(struct nlmsghdr *nlh,
+				int attr, const char *ifname)
+{
+	int len = strlen(ifname) + 1;
+
+	if (len >= 2 && ifname[len - 2] == '*')
+		len -= 2;
+
+	mnl_attr_put(nlh, attr, len, ifname);
+}
+
 static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->chain->dev_expr;
@@ -805,12 +816,13 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
 		cmd_add_loc(cmd, nlh, dev_array[0].location);
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
+		mnl_attr_put_ifname(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh, dev_array[i].location);
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+			mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME,
+					    dev_array[i].ifname);
 		}
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
@@ -2085,13 +2097,13 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	const struct expr *dev_expr = cmd->flowtable->dev_expr;
 	const struct nft_dev *dev_array;
 	struct nlattr *nest_dev;
-	int i, num_devs= 0;
+	int i, num_devs = 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
 		cmd_add_loc(cmd, nlh, dev_array[i].location);
-		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+		mnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
 	}
 
 	mnl_attr_nest_end(nlh, nest_dev);
-- 
2.49.0

