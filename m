Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2082D190664
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592547; cv=none; b=ZA903LLONKuP1DfVzDtOmm0X/ddlPhUv3K+ETebFrflu5JZ8rMyAsQGOouIDyH+XmYcFWou1gs3NSRSy0cFa5H1K7OFDqW4JQiSD0Stk7YClMvWpk24F9z4pzYqAElw+DV8MsEGYKzf5F5czKBTFdqYUK/FlRbg7oxBN1oHZ1qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592547; c=relaxed/simple;
	bh=rW/jS1UF5D1SfyRrQAs+dnk0nsruzJQssTxzBP6s4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fypo8ITMUPFVNnAZCrzdrBOooapd5x0/naOOMUVRxVP+zAhQir0B9fXKarocjg2ijadO/GVMPaWpammPwj9/4T4X2VjkMhlP83LmD4ee1IkmGbWn1KpYMkSiFZs2YAfaQ/uLSK/cWRZMu32rIbTcgp4Yqxtsg2F3YHqRgGRPKAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RXJvQezo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RXJvQezo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hFPEI0K3oEGsjipCMzodsITnDBtEpPamT4CvQL2jNdU=; b=RXJvQezoEPpD6uArKKUcMtzNMk
	n/T1aItVYeXcHYIpE6REqh36/5ND60B/4PCjbxN2r7I5rTqGC1D0WaWyGiT9SaA0RRNDq4FWtJNOf
	K9ee4onGNaqdi+ZWXkZpXMcAAGvGfGU0AzkvaGRv9JoGZbOM4+aLktZjYalq3hlhB7thR3sz6bYpv
	8RqhEiBTQIwbaSV4tz09mFr0nMhE7Imhz6z9WkpyWnAWatahwbnODdr+0W1FwxgkVUfMcJvGCLxkv
	Gczr3YOO+nc7MIwpN7dzt3bzPW2UuoDwejeCWdZl5ZZK2hqWTwFojt+aigZtPNskYnLLumf2gw1HE
	Nr8RbR5Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubhNg-000000003BL-1Efb;
	Tue, 15 Jul 2025 17:15:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 1/3] mnl: Support simple wildcards in netdev hooks
Date: Tue, 15 Jul 2025 17:15:36 +0200
Message-ID: <20250715151538.14882-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250715151538.14882-1-phil@nwl.cc>
References: <20250715151538.14882-1-phil@nwl.cc>
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
 src/mnl.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 89bc742af3c5b..5abfd4b677cbd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -799,18 +799,24 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->chain->dev_expr;
 	const struct nft_dev *dev_array;
+	int i, len, num_devs = 0;
 	struct nlattr *nest_dev;
-	int i, num_devs = 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
 		cmd_add_loc(cmd, nlh, dev_array[0].location);
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
+		len = strlen(dev_array[0].ifname) + 1;
+		if (dev_array[0].ifname[len - 2] == '*')
+			len -= 2;
+		mnl_attr_put(nlh, NFTA_HOOK_DEV, len, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh, dev_array[i].location);
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+			len = strlen(dev_array[i].ifname) + 1;
+			if (dev_array[i].ifname[len - 2] == '*')
+				len -= 2;
+			mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
 			mnl_attr_nest_end(nlh, nest_dev);
 		}
 	}
@@ -2084,14 +2090,17 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->flowtable->dev_expr;
 	const struct nft_dev *dev_array;
+	int i, len, num_devs = 0;
 	struct nlattr *nest_dev;
-	int i, num_devs= 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
 		cmd_add_loc(cmd, nlh, dev_array[i].location);
-		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+		len = strlen(dev_array[i].ifname) + 1;
+		if (dev_array[i].ifname[len - 2] == '*')
+			len -= 2;
+		mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
 	}
 
 	mnl_attr_nest_end(nlh, nest_dev);
-- 
2.49.0

