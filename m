Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DE93EDE5D
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473096; cv=none; b=B39409k+CCmmBFK+ikUwNfjOokke7ZfWf/DhaajKOaM8go//m48Fou+gdhvt4/vMaGonxIDzPMkVXnC9d3YMD/sz9oVqo6NivrunqMoXGxldATaAXIyLBRdoP3vqeep1JWtE4Z1A6j4SaBYlPv7P/yX6B8j2LuCYRasI/gcrtvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473096; c=relaxed/simple;
	bh=zOpF02azcuyoQAtHJFXA43CFs0vJPjcWisO9ZFR3x2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N96byPCV8P85co9SEi3IiKjukZLo4UgSHS3abKvjWt0gZcYdaSJmcOj52QOh4sW6hmnhp+OZjckQzFC4Zm6dB47+2bK78YAAHYq3gvhk8TBCi15WENo6NCdxkTUHTs7VXgDHh+055ZjYk2FaXKpdLGxxRiR8Aql6iS1yzmgEupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Hh6TXr3D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Hh6TXr3D"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E106160590;
	Fri, 26 Jun 2026 13:24:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782473093;
	bh=5iGrjpRuxAE+UZ9hvc3t6M5NJ5Rz8Q2XwbZ/1OHWNdU=;
	h=From:To:Cc:Subject:Date:From;
	b=Hh6TXr3DB/MnIVKwg0yugjmMsssmViP+vYbTZ2/tDMm05Rfp52HZJauC4tLFoZdwZ
	 yl2L2bUo84/eY+v1iP2CSLfkZymzE9z+cut69Enu5woGLAmKC3abByPy9w8jSMnSPf
	 gGh3MkuSv4yVZQKyyYFKXgZp0Y0nMjfbshavXalm3A6l5nG49DIh5PPXdUQvFoVWL8
	 K1xu6rHysAbD7IyiUZbLeF5VskM1lIGWDwU6rfIKmJHBDp9JoPHq+JFcKpxOA2ZHly
	 Uvg51LhZlUjF5O7tgWGXDGOEKJGa1at/fzQQRupjo+buTjrDhGWvSIFq6qIy0SI8Gm
	 U0NqXw6dHsizw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: n05ec@lzu.edu.cn
Subject: [PATCH nf] netfilter: nf_conntrack_sip: validate skb_dst() before accessing it
Date: Fri, 26 Jun 2026 13:24:49 +0200
Message-ID: <20260626112449.848283-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tc ingress and openvswitch do not guarantee routing information to be
available. These subsystems use the conntrack helper infrastructure, and
the SIP helper relies on the skb_dst() to be present if
sip_external_media is set to 1 (which is disabled by default as a module
parameter).

This effectively disables the sip_external_media toggle for these
subsystems without resulting in a crash.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5ec3a4a4bbd7..f3f90a866338 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -956,7 +956,6 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 			return NF_ACCEPT;
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
-		struct net_device *dev = skb_dst(skb)->dev;
 		struct dst_entry *dst = NULL;
 		struct flowi fl;
 
@@ -978,7 +977,11 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		 * through the same interface as the signalling peer.
 		 */
 		if (dst) {
-			bool external_media = (dst->dev == dev);
+			const struct dst_entry *this_dst = skb_dst(skb);
+			bool external_media = false;
+
+			if (this_dst && dst->dev == this_dst->dev)
+				external_media = true;
 
 			dst_release(dst);
 			if (external_media)
-- 
2.47.3

