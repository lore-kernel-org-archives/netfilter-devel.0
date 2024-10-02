Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A48F1D173A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897940; cv=none; b=tNlbb/IkdMOMuilHSmA0q6jpSLlBqbkd79LCsO8s8KWwJ5wLQgLN8p1gUiGrsCMXeTEsao/wl7zQqAPwuwxtdQ8xBtQ+jA6iS762aUIxmbgJv5M3oQtAI4gdWyNfCl4HwpgV50gr/KzWqLttmpkTP37Fq6YeZoaiBfw4EB13/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897940; c=relaxed/simple;
	bh=tkITBLXaBNCmUlQG1kOlkhIw8JVZpPiXeIE8QafDVok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYRWKc4FllaDrzrG+APU5WZp25L6P3vw8foAgESBJzdV1KPGVS8akap7n5Trmtxj5Udk3lwFXr/2GgGziRimLEtDL1eeTRQt6FDXR1wvmvramettK3kAlprlmMpJq0Iop6ENewUNcdT3iLp09Y0sXXlYWJhQTsQXdNNhMWMgac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=e28bWNfj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="e28bWNfj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Iv0viVwM4zRZjTBOd8ED+p0XahLKdgVU0tvc17PtuQ4=; b=e28bWNfjcgwARLF5nkGN9E7E1n
	8xsfbCcidiBz3Odnm2IrYt2sauUYXoQnbRMtOJ9T5ckXpDbs0c5ehBtNWnZqxqjamxVZR3kaFYFA/
	on/8aldKHlDRJGdqE9RHeIyM1PFS4jbRuMcw+5xXV1NqO6ccgfFmzMHeaYA8jkHlH57X6ONXqVa1b
	zcWIyrBOLaC+vX9QFjUqumG5pVLnU91/4fSoayypvziUJ/UdgK6TFwj12hFBXVYc/2k8ohpbhGJWr
	PxfnUwyUozSItfL+eZPbLXLrSRH9Ud4a0I3qSd/yHbra/yys70rstZSbs7igUHHvPGbTgArHr/poI
	YzRVtpmA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5BZ-0000000030Z-3dzP;
	Wed, 02 Oct 2024 21:38:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/9] mnl: Support simple wildcards in netdev hooks
Date: Wed,  2 Oct 2024 21:38:49 +0200
Message-ID: <20241002193853.13818-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
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
index db53a60b43cb9..4faf027ce1027 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -787,18 +787,24 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->chain->dev_expr;
 	const struct nft_dev *dev_array;
+	int i, len, num_devs = 0;
 	struct nlattr *nest_dev;
-	int i, num_devs = 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
 		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[0].location);
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
+		len = strlen(dev_array[0].ifname) + 1;
+		if (dev_array[0].ifname[len - 2] == '*')
+			len -= 2;
+		mnl_attr_put(nlh, NFTA_HOOK_DEV, len, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[i].location);
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+			len = strlen(dev_array[i].ifname) + 1;
+			if (dev_array[i].ifname[len - 2] == '*')
+				len -= 2;
+			mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
 			mnl_attr_nest_end(nlh, nest_dev);
 		}
 	}
@@ -1999,14 +2005,17 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->flowtable->dev_expr;
 	const struct nft_dev *dev_array;
+	int i, len, num_devs = 0;
 	struct nlattr *nest_dev;
-	int i, num_devs= 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
 		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[i].location);
-		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+		len = strlen(dev_array[i].ifname) + 1;
+		if (dev_array[i].ifname[len - 2] == '*')
+			len -= 2;
+		mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
 	}
 
 	mnl_attr_nest_end(nlh, nest_dev);
-- 
2.43.0

