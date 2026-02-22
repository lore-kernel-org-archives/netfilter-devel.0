Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16B2356A4
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771775578; cv=none; b=og7la6Qz0ev+Otb1mXvVl8uheaQwzpngczMetc8cWfYE9mpaA48c9To6+grfGC4MsS5r7dG+RwzLfxh9tqhuYB2RrOeenlUQv/j6/KMJB8iwva+okNTZorub5W0oO1arixcoBt38/lDVwT2n8n+3urA9sHFzvSV4sN/5153EFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771775578; c=relaxed/simple;
	bh=A3FVTaY3gTdk4/I4tDNDGEa2Hhq6PqSLRqaRlb/FPlg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ojyXQToXLXwyHmJZk08hKJRVTRI87lwGJOjQg6UA4uB0C4Ev/xxbB3xK9D5yc9yppJ1m2lTAeSrQ75aIN1wEQ27khjSsylIeP7dCtMBzAfTqUO6vMmxxFuJlPI0hR84YjLQcZBiGhvdT7w5qPLIQ28BgTt7+fkpZ9+pwepWwnsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q9klw3P+; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9klw3P+"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c0e2cbde1so5986054a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 07:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771775575; x=1772380375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1NVM2G3MvWYR9rREQPgIPKKWATWW6NZZLQEjl5ilZu8=;
        b=Q9klw3P+qB6Wp5NKJatrfhBOT+pCQLkrV8HCbvghP/xTICLWpJoxmduqSTX5yDFXTp
         8EvvVf0w4MFYhInE8L0C8t0INb1i1gkS19ITOKyrCpKVywLIjsmk7i/k1GIMrfMfjts/
         evSx8hUMwlwjRLrLHD2ouD3NhOi5YT8BJd9MN4GKmrRD/rGDEeqN7hvlQRP/1jsqmk5s
         h7O8O1uqKGWedjNVDJBLRy+YVP0a8AEIZ7IaPPVw2uYz1B3baR5YIgvF5bkcgW2liRtw
         fkwsMyHi9RvnjQRGQOLfzv7Pb8T6FFOyiX0NnADGzW5dWi6LCFWnPxsw/ebyqNVYTvET
         kZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771775575; x=1772380375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NVM2G3MvWYR9rREQPgIPKKWATWW6NZZLQEjl5ilZu8=;
        b=EEfeKeDLEn18JKMcVYY+h05+9Sf3ceYkBZtfAJpk4CTJml9195ScffTGjC53II4/QW
         HIQilmkn4Dn5eW6uaKitM4F3if+fZgSHCagLjE7w6SfbXa7cregOysRqKBazvEo0SFF8
         RA7ZCydeOy/OkmtCQ+i8V89DjhWb9keVd79sWJrh/E+8opyg9K6bqFwPBwlK1aA9Esjc
         8IiBeu7oNGu53EXUbG4DaEA1rFvvuSARgfdxYJHi516GmL6LKf+jonfFmcG+laVQPtJY
         f1Hk7TCdzHiuXVf0fhDflPtcJ/iixlSJwLCrO9yN/iXEIp8771nF3hredv1DkdGfS7Ys
         LUtg==
X-Gm-Message-State: AOJu0YxMXto5Bvs59UwJzabd/i9twuJ6+1t0rMhQZVpoPL/OSzsulUYQ
	riamiDBtZ6i6Q1ymTqFG3ycw265kqGzq4jFfPyjdRb3Dz7VtInSKbBaVJPZfMg==
X-Gm-Gg: AZuq6aJk+z/g8E8C/awT0pqz1lyeDPiDSApAeABmAqECbNXTCf0k4FXb0tgFSsbSNrL
	FO50XR5PvJt12vo1G0tvVfcan+toepq5lSjlpWqwNC8grt9MpMQ76K596VG6GgqzHdnaOwdhJF9
	ZnQPktNZ1hwU186SQizYqcDFS+lJzyI8GzA5AmwPFgW8uuFLHdRxCMAd9yOClk5dhHh7X5z2dME
	IGjNcEP1xvKtnJW1Y4Dx0CUnKPxzz0UYIHGoaLPFDVBg7qYgHY6TCXfwF8zSNsJYx7136aIx9wE
	7vW0gOrkoiLuDATQ847cN7Xzq3gLIBzWQfB/18jXYxZTJFJ/W3bK2wev7+bbKdltp4xLky7hUFx
	mqo/aHCZoaqHeov6tM8TaM/2p10i7OYOXs64z/XfCigYfOdaQYa96fdI5H1m9JA9RU1G//CekRA
	GzmE7vlV1Pax14NbnmvUWdvaQJdHec2p/mPLCKbPriEp1YX2QwJ4Bmk5C7IPEg1b1TJmnQ1ujfG
	H8MyY9HL1/hxZ+ZJKbs5Lxbfe+eZiK8/zww5H3FjsWOQw9um5b4oK4=
X-Received: by 2002:a17:906:c10f:b0:b86:fa17:4cf5 with SMTP id a640c23a62f3a-b9081994619mr406955466b.13.1771775575119;
        Sun, 22 Feb 2026 07:52:55 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084f028a3sm235371666b.64.2026.02.22.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 07:52:54 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v1 nf-next] netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
Date: Sun, 22 Feb 2026 16:52:51 +0100
Message-ID: <20260222155251.76886-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With double vlan tagged packets in the fastpath, getting the error:

skb_vlan_push got skb with skb->data not at mac header (offset 18)

Introduce nf_flow_vlan_push, that can push the inner vlan in the
fastpath.

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..e65c8148688e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -544,6 +544,27 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	if (skb_vlan_tag_present(skb)) {
+		struct vlan_hdr *vhdr;
+
+		if (skb_cow_head(skb, VLAN_HLEN))
+			return -1;
+
+		__skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+
+		vhdr = (struct vlan_hdr *)(skb->data);
+		vhdr->h_vlan_TCI = htons(id);
+		vhdr->h_vlan_encapsulated_proto = skb->protocol;
+		skb->protocol = proto;
+	} else {
+		__vlan_hwaccel_put_tag(skb, proto, id);
+	}
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -738,8 +759,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-- 
2.53.0

