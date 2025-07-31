Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E258C2798FF
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754001001; cv=none; b=NbJdtTeqd6+bKmGuik8JMy13bD4giOk6AKokxErB5w6mClVCQvpdH7+UTsKLwFqXbHIs+dFcdDk+wAZXp1gqKjYs0+OSR0+Z1WW2T6J26AcWz4077BQB0VqnHSBxy2GoECt1SbEhLo2Zx+BOqe2Z4weIEAokS4+o8H4UaUItH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754001001; c=relaxed/simple;
	bh=VZ97hkrSIdy4IMmHVp9/TBCWQfU0VUZXRQDErlJ+Feg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJp0HnDVd1+gEycXQK63Mlrtwb+nvVRtI2JqRX31c7nkBDuZZ58hOgtLwx+nP3m6TTJE9u935b2+ysh9X3sTqiqT/3ZlZTdjnnJ0rWTeD+fKYYZey9dr652AsdQ+Zi3YyMwYQ9qLn2UQG7QqTXxKb3la/PWMAMXL3ssk1LVi3a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UiiwQ0HV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UiiwQ0HV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SvzZbMJFFlCXXr9xTU3FeZkH0eSdszHYuGGV+wfcb/Q=; b=UiiwQ0HVcpPzO7wIiA+4/i8gAe
	mz7ffw5MWNaJ0hzs4QTCev027KGv1ebdaHrhFym5MbTXjUTp9wF8AWu+bGxL3IsQylxhRwFdooFa1
	Z7QXmM0/eMvRk1PCqwoNiq5TSl4H3Lyfr4hiLsnKaZc/lxAKzJv+PB+aJbFRVlWvHPRwErI8tbXp3
	AFdapw0xrBX24ZW84Ob7JK076PRcMVUbISnFka3xvwCTwIdJ5pKvx0z9u1rqkqS1/YAiqet3YviJp
	5kkn7uGHbG9aHUNZMCB8tM2tj9oqDgehoOLQFMDKoR5CK8vwYykBEgvsSuu/UDnrV7cBGhztJAVkg
	LcFhLvKQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhbma-000000003MC-1nCI;
	Fri, 01 Aug 2025 00:29:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v5 1/3] mnl: Support simple wildcards in netdev hooks
Date: Fri,  1 Aug 2025 00:29:43 +0200
Message-ID: <20250731222945.27611-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250731222945.27611-1-phil@nwl.cc>
References: <20250731222945.27611-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building NFTA_{FLOWTABLE_,}HOOK_DEVS attributes, detect trailing
asterisks in interface names and transmit the leading part in a
NFTA_DEVICE_PREFIX attribute.

Deserialization (i.e., appending asterisk to interface prefixes returned
in NFTA_DEVICE_PREFIX atributes happens in libnftnl.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- Introduce and use NFTA_DEVICE_PREFIX which contains a NUL-terminated
  string as well but signals the kernel to interpret it as a prefix to
  match interfaces on.
- Do not send wildcards in NFTA_HOOK_DEV: On one hand, the kernel can't
  detect them anymore since they are NUL-terminated as well. On the
  other, it would defeat the purpose of having NFTA_DEVICE_PREFIX, which
  is to not crash old user space.

Changes since v3:
- Use uint16_t for 'attr' parameter and size_t for 'len' variable
- Use mnl_nft_ prefix for the helper function

Changes since v2:
- Introduce mnl_attr_put_ifname() to perform the conditional
  mnl_attr_put() parameter adjustment
- Sanity-check array index in above function to avoid out-of-bounds
  access
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/mnl.c                           | 26 +++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f57963e89fd16..b38d4780ae8c8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1774,10 +1774,12 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_PREFIX,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/src/mnl.c b/src/mnl.c
index 43229f2498e55..b532b8ff00c1e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -795,6 +795,26 @@ static void nft_dev_array_free(const struct nft_dev *dev_array)
 	free_const(dev_array);
 }
 
+static bool is_wildcard_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	if (len < 1 || str[len - 1] != '*')
+		return false;
+	if (len < 2 || str[len - 2] != '\\')
+		return true;
+	/* XXX: ignore backslash escaping for now */
+	return false;
+}
+
+static void mnl_nft_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
+{
+	uint16_t attr = is_wildcard_str(ifname) ?
+			NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
+
+	mnl_attr_put_strz(nlh, attr, ifname);
+}
+
 static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
 	const struct expr *dev_expr = cmd->chain->dev_expr;
@@ -803,14 +823,14 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	int i, num_devs = 0;
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
-	if (num_devs == 1) {
+	if (num_devs == 1 && !is_wildcard_str(dev_array[0].ifname)) {
 		cmd_add_loc(cmd, nlh, dev_array[0].location);
 		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
 			cmd_add_loc(cmd, nlh, dev_array[i].location);
-			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+			mnl_nft_attr_put_ifname(nlh, dev_array[i].ifname);
 		}
 		mnl_attr_nest_end(nlh, nest_dev);
 	}
@@ -2091,7 +2111,7 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
 		cmd_add_loc(cmd, nlh, dev_array[i].location);
-		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
+		mnl_nft_attr_put_ifname(nlh, dev_array[i].ifname);
 	}
 
 	mnl_attr_nest_end(nlh, nest_dev);
-- 
2.49.0

