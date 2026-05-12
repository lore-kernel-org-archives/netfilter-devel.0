Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69921395AE4
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 10:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582059; cv=none; b=NVmvnvgIEMett3DROPrC5D3quUTloQSvAfIp4H7DdZzsPQsZRWNnZ/RGBw0BI5bDlh835WgEAw82gxgFCK9oeul7nhdbg46l0xtY8B/p3ILnmbQt5JEC3ejk1yTjdcvZtZXNb9VFC6Ga3xTpAqLGLiuOh7vPMbX+EDN/apU2Hbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582059; c=relaxed/simple;
	bh=e9ounumzMsc0PFMj8de38rXvFznFr3brdooDiKsmj28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQI/bmm/LiL92PuV2ZYBmKPOrXL9kV/UDP4feVDs/n37UpMGY8fih39vsC915/q1C4si6yTX9fu9VVjQeusyqZkmgiXHxz9YcegoI+tqJfD13ykGhMag03mQkG2V9GAmv3Jkwkm/WeEY6eMYhhenlbwrnozMNxr5ZCuFYYwHgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TnIDMLix; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnIDMLix"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67c2b4809baso10603780a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 03:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778582053; x=1779186853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOP1vXEoJfnkmimPCpGl1dwzuJKQLFvAXHQhPIbHakY=;
        b=TnIDMLix51gNFOxQ99fs43PCYEQPv7Tm+55edDxp+5X38W1pZASZRpgfRisJiwMvEv
         Ssi+JizkZE2pDOiXMlVMeUBse+dT0tbh+o3nPm6sTqNEEvUWNSUFo0FfK2sTGbRpcqcc
         6ZfPmx0qTdebtoQDtRTIYBvvmc4GYss0ZdcvHIXlOWgoVoX1hensSIltvDAAI1Su09mp
         1hlLBhM51bdsULgXV9ONroYZnYMrjERC5axK0OC9irQweBZafYFfoDvhcxooESH3FA7G
         wB8mM26lzJuib/YoXe05IqckK/XHFqxLYKSQA1yeRbF/PTTuFTCAMU02dhWiQLO6Rz+p
         ZW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778582053; x=1779186853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LOP1vXEoJfnkmimPCpGl1dwzuJKQLFvAXHQhPIbHakY=;
        b=fvEItipCkHIDcQ+WXv26Taqip29LtmO0uYQPZ6py7A9ghf6Kq+gDYrN3KE7S5A8FSZ
         1mDSJGLREjm+6iuJVf44zabRWUgUfrpDh/9n0zgTt+RxHwznTwnCAeTSnZ76r+G5RwN9
         pPuaH3hjzAJtep/mEiF3dRkWzgn5olC39f4wj67MgIBpecdCqOOfy1HZoStbYTFESE0M
         F+QutUiclJiRsxl0LuRvFlcduDxw0vA2Y+v4qaKOOmhhTvnzgyuOGNmCjTK0ST8gvnN5
         Sx909ExIFGID0sMqgoYmdU5s4EwjRfy7xmVJSgBvwfMJ2hOqkXNhDq4/DB21GzomvmSi
         xgaw==
X-Gm-Message-State: AOJu0YxdoAe1vv3luqukRiwFdkwTvHmqBj+sVzLKPzLR7PL9YrHZk97I
	Cu71uqCJm8ImsVUF5tmVhe+ffWRb49U8C5CHXVFTfHJf/5yFfwMLOL5K
X-Gm-Gg: Acq92OEswuQkV5+58HYV9kd8EJ4RF3HmtyIuwoRIXWRoxjh+czowyf2Sp9AJY6OW7uN
	Hs8YkUF/v3wqHqyPDdggLAehtiUP8gXWGrx9ZgJavx4WyxGceisPrCi7dIRuzwE9i5uL1Da2+D6
	xSz0R/lz14YTxx2kS34J+izjNn/BgeNnqiDPbT1FvCuK4VJpQSQ6qDW2haOLOKFwIuCNdHTa67j
	XY+ijFqsmJRzVMtNK6YCU5AXI6nlkTMLdOGRYdW8O021WfsAVz6PbfZYy2hl6ZtkuzHhZ7N6OsK
	FkH0e5Ix8PW9du/2EhwtANW2LEvYke0YJou8LOuhmLEWBKmWWoYHtAL3xwVKhR19xBMQxFV4TtR
	u9B/H8qPKRXIFCgREhR9V6KUEjpDj1p6S7TwH/yfqUinSiwXcP7O9w0PrjKLXUlrwQH55XMbeTf
	8TFmNKOxOOHEHE5SbQ2RLaQVxo5pnY/66wxAXuIUlscfZVgDBn2nQY01BGqzaYBfgS3f4HQGWtB
	DFJbYw+4Uf27noic6fwM87RMecnQ5BxWdVdvYmbMYQRO/yLaD2ecQE=
X-Received: by 2002:a05:6402:324e:b0:679:223c:d191 with SMTP id 4fb4d7f45d1cf-67d642b24b8mr11741995a12.13.1778582053043;
        Tue, 12 May 2026 03:34:13 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0e1c044sm4629218a12.27.2026.05.12.03.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:34:11 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v20 nf-next 1/2] netfilter: utils: nf_ip(6)_checksum(_partial) correct data!=networkheader
Date: Tue, 12 May 2026 12:33:46 +0200
Message-ID: <20260512103347.102746-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512103347.102746-1-ericwouds@gmail.com>
References: <20260512103347.102746-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the conntrack hook it may not always be the case that:
skb_network_header(skb) == skb->data, i.e. skb_network_offset(skb)
is zero.

This is problematic when L4 function nf_conntrack_handle_packet(),
nf_conntrack_icmpv4/6_error() and other functions alike are accessing L3
data. These functions also calculate the checksum using
nf_ip(6)_checksum() and nf_ip(6)_checksum_partial().

They in turn use lower skb-checksum functions that are based on using
skb->data and will fail when skb_network_offset(skb) is not zero.

Adjust for skb_network_offset(skb), so that the checksum is calculated
correctly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/utils.c | 52 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 29c4dcc362c74..b738444c9cb6f 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -10,9 +10,18 @@
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u8 protocol)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* pull/push because the lower csum functions assume that
+	 * skb_network_offset(skb) is zero.
+	 */
+	dataoff -= nhpull;
+	__skb_pull(skb, nhpull);
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
@@ -35,6 +44,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 						       protocol, 0);
 		csum = __skb_checksum_complete(skb);
 	}
+	__skb_push(skb, nhpull);
 	return csum;
 }
 EXPORT_SYMBOL(nf_ip_checksum);
@@ -44,29 +54,47 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				      unsigned int dataoff, unsigned int len,
 				      u8 protocol)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_ip_checksum() */
+	dataoff -= nhpull;
+	__skb_pull(skb, nhpull);
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
-		if (len == skb->len - dataoff)
-			return nf_ip_checksum(skb, hook, dataoff, protocol);
+		if (len == skb->len - dataoff) {
+			csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+			break;
+		}
 		fallthrough;
 	case CHECKSUM_NONE:
 		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
 					       skb->len - dataoff, 0);
 		skb->ip_summed = CHECKSUM_NONE;
-		return __skb_checksum_complete_head(skb, dataoff + len);
+		csum = __skb_checksum_complete_head(skb, dataoff + len);
+		break;
 	}
+	__skb_push(skb, nhpull);
 	return csum;
 }
 
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u8 protocol)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_ip_checksum() */
+	dataoff -= nhpull;
+	__skb_pull(skb, nhpull);
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
@@ -89,7 +117,9 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 						      skb_checksum(skb, 0,
 								   dataoff, 0))));
 		csum = __skb_checksum_complete(skb);
+		break;
 	}
+	__skb_push(skb, nhpull);
 	return csum;
 }
 EXPORT_SYMBOL(nf_ip6_checksum);
@@ -98,14 +128,23 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				       unsigned int dataoff, unsigned int len,
 				       u8 protocol)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	__wsum hsum;
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_ip_checksum() */
+	dataoff -= nhpull;
+	__skb_pull(skb, nhpull);
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
-		if (len == skb->len - dataoff)
-			return nf_ip6_checksum(skb, hook, dataoff, protocol);
+		if (len == skb->len - dataoff) {
+			csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
+			break;
+		}
 		fallthrough;
 	case CHECKSUM_NONE:
 		hsum = skb_checksum(skb, 0, dataoff, 0);
@@ -115,8 +154,9 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 							 protocol,
 							 csum_sub(0, hsum)));
 		skb->ip_summed = CHECKSUM_NONE;
-		return __skb_checksum_complete_head(skb, dataoff + len);
+		csum = __skb_checksum_complete_head(skb, dataoff + len);
 	}
+	__skb_push(skb, nhpull);
 	return csum;
 };
 
-- 
2.53.0

