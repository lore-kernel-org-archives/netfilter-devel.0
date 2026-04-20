Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6657C3D75AB;
	Mon, 20 Apr 2026 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692382; cv=none; b=dHxwylxrHAcBCfFqCNBr6Gfq1a4o6YR/G9vwlIQy6Qd336aBFbouzRlQuIfyLgshbkFl+27C+fFRINb4n1xvHUjetfHgBGLmyhQvOldECg0xvB9cPgb2nhg64PDeXszx3JHEE0Y7XEuZYmPfn+FeQtaIEzjcNJ4wqTu7cXe2t1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692382; c=relaxed/simple;
	bh=2apI9q1rG+ui2BIKoGC3UZUi3aOcHG39oSwEJgtXR/8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FRWpK/HdytxsWE3V9svvncNHKtnRpGJFpGZxMQnyqJkfXzf3hFkfR2pm0AxKMhHEMPSKOvuOnp/Lq88q6nKTG2Pnq08L2ILLR0NHemFYPoTs5J2rH6R/435kiSMcmZqCpK+ZPpA2pHXZbCxWkYJds2Wm0AtXtYcZ99+7wUzrDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IG7gre5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IG7gre5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8FAC19425;
	Mon, 20 Apr 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692382;
	bh=2apI9q1rG+ui2BIKoGC3UZUi3aOcHG39oSwEJgtXR/8=;
	h=From:Date:Subject:To:Cc:From;
	b=IG7gre5P8zuhyokbHZF5eeCwOnhVF52IH1qPoY+vzbkkuOe72X5r/LtVSWi5CWimJ
	 apA2vR5MBZXTvI4/35GuWdWP124+dOV9F3s/IXNOGEUKN79nDTFcrOCMO92GWnxnox
	 aAKpYm6DEI5KR2RuCE57lYv+pGJMkcq05YDu6JDfrQe4o7voPauEtOtu2AeTzTWmUg
	 P2vVINaKL528yX1SO5bi0cSBdQkqjDTKwB9yxEira7gGXvcNmIZqtPbtIzdogehUXv
	 bzSXK+VsI/l2Kade+EVqKcy8JVik5R9HC25TsCqQ9SJGfqoYINIdZQvntKKKrnrlvV
	 em1nlnxNbvG/A==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 20 Apr 2026 15:39:08 +0200
Subject: [PATCH RFC nf-next] netfilter: flowtable_offload: propagate CT
 mark to hardware offload path
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-nft-flowtable-priority-v1-1-6603fbbf1366@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQrCMAyA4VcpORuowQ30KvgAXoeH6hINjHSkR
 Sdj727x+B3+f4XCrlzgFFZwfmvRbA37XYDHK9mTUcdmoEh9PFBEk4oy5U9N94lxds2u9Ys9sxw
 jjdR1CVo8O4su//EA18s5mKDxUuG2bT9Ch8j+dQAAAA==
X-Change-ID: 20260420-nft-flowtable-priority-6eef902d255a
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

When a user-space process sets the Connection Tracking (CT) mark on a
flow via nft_ct or xt_CONNMARK, that mark should be visible to the
hardware offload path when the flow is accelerated through the flowtable
infrastructure.
Extend the flowtable offload attribute set to include the ct mark field
when it has been explicitly set on the conntrack entry.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..d5fe35b1a647 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,6 +679,22 @@ static int flow_offload_decap_tunnel(const struct flow_offload *flow,
 	return 0;
 }
 
+static void nf_flow_rule_ct_meta_mark(const struct flow_offload *flow,
+				      struct nf_flow_rule *flow_rule)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+	u32 mark = flow->ct ? READ_ONCE(flow->ct->mark) : 0;
+
+	if (mark) {
+		struct flow_action_entry *entry;
+
+		entry = flow_action_entry_next(flow_rule);
+		entry->id = FLOW_ACTION_CT_METADATA;
+		entry->ct_metadata.mark = mark;
+	}
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_MARK) */
+}
+
 static int
 nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			  enum flow_offload_tuple_dir dir,
@@ -747,6 +763,8 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	nf_flow_rule_ct_meta_mark(flow, flow_rule);
+
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
 		if (flow_offload_ipv4_snat(net, flow, dir, flow_rule) < 0 ||
 		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)
@@ -776,6 +794,8 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
 		return -1;
 
+	nf_flow_rule_ct_meta_mark(flow, flow_rule);
+
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
 		if (flow_offload_ipv6_snat(net, flow, dir, flow_rule) < 0 ||
 		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)

---
base-commit: 3f3a2aefbc661b837c8e344f944982d61c2ae037
change-id: 20260420-nft-flowtable-priority-6eef902d255a

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

