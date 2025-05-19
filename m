Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A01FF7B3
	for <netfilter-devel@vger.kernel.org>; Mon, 19 May 2025 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697910; cv=none; b=B7UliqJaCds7+wILTG3dAiRS20Eed1ybrSNCa/eqaRloUatL2IohMkFtVJzpl4k2bIAxx8tkuxzOj+vGB7knPkjnCNCM8KfOR9PtVN+6sLx3P25p7FtJcpCSeCqfh528vF7AMWVU8zV0laYG1h8nRgQ35tRUoYyiFM6Ku/3QewU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697910; c=relaxed/simple;
	bh=Addqbmm3ocFXTkQKZteJgI1xvwpisKXQ855S8JPaaAo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=QbGC+A1e14UKkdTGYMQitQe04VUa5J+SGMQS7G+VWv0xV1R+2BXY76S1CLgUzwGBq+FvrUF4TOiuBKD26ecl2CtpojwshgG23Vec/H3Vy1UshuRcMicBkZkdciAxv78Jd8CPvZx4t6vtNGU/v9L+G/eub1k6W5eSkQ9Ngv14zJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nnNZO0k3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nnNZO0k3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nnNZO0k3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nnNZO0k3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9C17C60263; Tue, 20 May 2025 01:38:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697907;
	bh=AXWvdn7XxLwXyMlC2YKu4AHH+ngV6fG4YLAMvGcvJb4=;
	h=From:To:Subject:Date:From;
	b=nnNZO0k3IZVkPCAxHVx2w0cIkopadrUzWe5Rpj0QE7rdDivdSxawy3rVbaRG1vSpu
	 vmWN6C318PQ/J0ZyT4jp8+V6jmxaa1tnW/JoTRlIed3CWJVfhdR8hnUXJyEMvh4NaX
	 vy+4nPKHZQRalmm2mk011MSupq/vbxU2tqPxPTDSR46Z60FCMKdL/PZAN+4zv2KKos
	 fSqulMTbRAd8+cBwi69i+veK8HwjYxK2vccthwHN/VvSuiKKZVdjTYcqXUa/8O0E4k
	 pRiyRu38vHusBpCubn5HFDlZO7qk63qQiFqBF7S9KTerWhCLuv6xesDupfOgviK7pY
	 daWB7rdKzYvdw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3940960251
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 01:38:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697907;
	bh=AXWvdn7XxLwXyMlC2YKu4AHH+ngV6fG4YLAMvGcvJb4=;
	h=From:To:Subject:Date:From;
	b=nnNZO0k3IZVkPCAxHVx2w0cIkopadrUzWe5Rpj0QE7rdDivdSxawy3rVbaRG1vSpu
	 vmWN6C318PQ/J0ZyT4jp8+V6jmxaa1tnW/JoTRlIed3CWJVfhdR8hnUXJyEMvh4NaX
	 vy+4nPKHZQRalmm2mk011MSupq/vbxU2tqPxPTDSR46Z60FCMKdL/PZAN+4zv2KKos
	 fSqulMTbRAd8+cBwi69i+veK8HwjYxK2vccthwHN/VvSuiKKZVdjTYcqXUa/8O0E4k
	 pRiyRu38vHusBpCubn5HFDlZO7qk63qQiFqBF7S9KTerWhCLuv6xesDupfOgviK7pY
	 daWB7rdKzYvdw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: skip egress in netdev chain release path test
Date: Tue, 20 May 2025 01:38:23 +0200
Message-Id: <20250519233823.39775-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update test to skip egress coverage if kernel does not support it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../chains/netdev_chain_dev_addremove          | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tests/shell/testcases/chains/netdev_chain_dev_addremove b/tests/shell/testcases/chains/netdev_chain_dev_addremove
index 14260d54b778..0a1eb1a5f7b6 100755
--- a/tests/shell/testcases/chains/netdev_chain_dev_addremove
+++ b/tests/shell/testcases/chains/netdev_chain_dev_addremove
@@ -11,18 +11,22 @@ trap 'iface_cleanup' EXIT
 
 load_rules()
 {
-$NFT -f - <<EOF
-add table netdev nm-mlag-dummy0
+	if [ "$NFT_TEST_HAVE_netdev_egress" != n ]; then
+		EGRESS="add chain netdev nm-mlag-dummy0 tx-snoop-source-mac { type filter hook egress devices = { dummy0 } priority filter; policy accept; }
+add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-tagged { ether saddr . vlan id timeout 5s } return
+add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-untagged { ether saddr timeout 5s }"
+	fi
+
+RULESET="add table netdev nm-mlag-dummy0
 add set netdev nm-mlag-dummy0 macset-tagged { typeof ether saddr . vlan id; size 65535; flags dynamic,timeout; }
 add set netdev nm-mlag-dummy0 macset-untagged { typeof ether saddr; size 65535; flags dynamic,timeout; }
-add chain netdev nm-mlag-dummy0 tx-snoop-source-mac { type filter hook egress devices = { dummy0 } priority filter; policy accept; }
-add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-tagged { ether saddr . vlan id timeout 5s } return
-add rule netdev nm-mlag-dummy0 tx-snoop-source-mac update @macset-untagged { ether saddr timeout 5s }
+$EGRESS
 add chain netdev nm-mlag-dummy0 rx-drop-looped-packets { type filter hook ingress devices = { dummy0 } priority filter; policy accept; }
 add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether saddr . vlan id @macset-tagged drop
 add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether type 8021q return
-add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether saddr @macset-untagged drop
-EOF
+add rule netdev nm-mlag-dummy0 rx-drop-looped-packets ether saddr @macset-untagged drop"
+
+	$NFT -f - <<< $RULESET
 }
 
 for i in $(seq 1 500);do
-- 
2.30.2

