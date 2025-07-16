Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035DE288530
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752692052; cv=none; b=F2w97maGy+16btMcWZ7z8xKoeCPyFu3LO7k6hjtyiaJtyPzr++DyW8NRRrTYhqgL7dlXR1Rcm1GeWuANUeSC5x48rgCzYJhXlVI3gPujlPjpwT+oQ3YBw8ftIg0idaUo5fqRbRmjmzt/sapAUFklIrYlSTO0n1bWCj1reiKDiKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752692052; c=relaxed/simple;
	bh=bmfzQfZzXDruG7sXoqSNScBNe+TOctQ2X6sAvl5cOPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nws+yo4IINK44K85Uokr6cJ3jI8cxrIAPWIRbNj+oi9yYafwdnrbuKre9aa2oCis2vX2Kc/VdKAVG7PbDV1pqrlvlyl9IMxjBNzKkZWD3MC1kCsayiAyWfGKR/qu5Qw7sPO8YkfB7Az8cqt7ijGLQ/c7IDMxaVJJoq+rALlLGjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SKptQ75r; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SKptQ75r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sWp2L/ziBBqSscAgwa2H3nddxr3kzvIQsofJDx7b40g=; b=SKptQ75rOaEZsIUuADy5S81Ccq
	3UwwHlukjHUhPaHuVc6Zk5ieVSzitndZ7BLUYfB0XgmLLse0bp7VCVPWP9l6Fx/ZAnqUjww9MO+n1
	bab6GLj8jvmh+celzswutOtgT6Q+OriODfAJwaXOx8HY6hNO3a2lcpZNCqgpL37VyJzoINb0aAL2u
	zvlhOjbal+E689lZ59V8+lZlTcjokJvVreK8t13cNCukHnHOzdnPupPkdU7n2Dbknt8BrdFftJZRR
	66vzpeCmeovSPeXI4yagqxmdozaBoMF8jElyRj6UYya38qyYk4gfatHpJQd+L5WZMvK1Co40GodPc
	PXRyuQtw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc7Ga-0000000082f-2FfU;
	Wed, 16 Jul 2025 20:54:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 1/3] mnl: Support simple wildcards in netdev hooks
Date: Wed, 16 Jul 2025 20:54:00 +0200
Message-ID: <20250716185402.32532-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250716185402.32532-1-phil@nwl.cc>
References: <20250716185402.32532-1-phil@nwl.cc>
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
Changes since v3:
- Use uint16_t for 'attr' parameter and size_t for 'len' variable
- Use mnl_nft_ prefix for the helper function

Changes since v2:
- Introduce mnl_attr_put_ifname() to perform the conditional
  mnl_attr_put() parameter adjustment
- Sanity-check array index in above function to avoid out-of-bounds
  access
---
 src/mnl.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 43229f2498e55..736e2eeada263 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -795,6 +795,17 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
 	free_const(dev_array);
 }
 
+static void mnl_nft_attr_put_ifname(struct nlmsghdr *nlh,
+				    uint16_t attr, const char *ifname)
+{
+	size_t len = strlen(ifname) + 1;
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
@@ -805,12 +816,14 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
 		cmd_add_loc(cmd, nlh, dev_array[0].location);
-		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
+		mnl_nft_attr_put_ifname(nlh, NFTA_HOOK_DEV,
+					dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh, dev_array[i].location);
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+			mnl_nft_attr_put_ifname(nlh, NFTA_DEVICE_NAME,
+						dev_array[i].ifname);
 		}
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
@@ -2091,7 +2104,8 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
 		cmd_add_loc(cmd, nlh, dev_array[i].location);
-		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+		mnl_nft_attr_put_ifname(nlh, NFTA_DEVICE_NAME,
+					dev_array[i].ifname);
 	}
 
 	mnl_attr_nest_end(nlh, nest_dev);
-- 
2.49.0

