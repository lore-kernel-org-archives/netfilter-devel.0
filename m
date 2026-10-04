Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752044A9D65
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791149087; cv=none; b=odsJRaKlkSI2iHt8/NbpI2hj7ecIiBD7xsgUH4xruya/9ef1CNh9X/ZPyBsi0nXLxfwwqanRDht4vpQBLakgspPyQI4NHNFK9F/G0q7jTo8O7EtLvcpwrAgoKK3bopAj68ddzP+Y5Hlb4fNlxBkE+DV/Iy1rRVltFpsTK6CD4cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791149087; c=relaxed/simple;
	bh=9hCcjqOT46xAP7xaIdc0Z4fk9Wd1Z9HkTA12fTdiRn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAIt62bG0S8T5JPIRj+nAIP8O16am7Ymd/02qVgxGZqZJpVjSCEFU6of9ODtzUDl89b0WhXuP6GyKlEyhWANKLnVdYDapQdUcdjlPVcf384cNlzyy1DGqqHzmX+sjdiAhptjb5r+t6A8407y0uJ6TlAE5xx/VV89Xs8G6opPHXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BhxsxrQs; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhxsxrQs"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso916631f8f.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 14:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791149083; x=1791753883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1iTQTid8V/cmqf8L65z4iELp7ouOSYsaWQ30R10Lt58=;
        b=BhxsxrQsyF4jlJd29+D9OP1vZV4eqt4xrC5NiT82mwg1NvMuLWC6eS0hVRDVaSEglJ
         QEHBHBiZMp5wkb8uFSPAFWvmp7sfGqX0TTkQZ4tet4NJwSbTLfTliPaELg6mi7P00ooZ
         j+oSddjMc89E99LIQ2Yw0iyS+rCPUEepVC6jz3p0BOdvP8LRsXdoNWyyxUURn01G11dp
         7QehuLQdK24uNWctiTSHCCjtO5VRheqjdgMVMdUp/ZKRCKOYRHd9FTCrx7YQV9pfiSO2
         odhSm1m00N8spa3Afz8vELj5O3f4+4cHXRQHv2fXG+iThZRzBzc7VUv7M92Trs/JdwNn
         Hs/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791149083; x=1791753883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1iTQTid8V/cmqf8L65z4iELp7ouOSYsaWQ30R10Lt58=;
        b=DaQqFEke/VWyW9BwYYv+zN7Kho8rkaoYngb+FxE2P/G9xgJyWrZLipSPydIMEN62iz
         1spIjlytRlj7v4Fr8Q5EP8iX+g/afGqnfaMZbSIEDIIHntXk3olj4vbT2oKGiTYt3JUR
         RKkGKL72r9uArvc2nP+oCa8Fiuj8AKpgCUOQ8ClO342I9yB8w808aOyILPEcD/u4DML+
         eo0VPIqLYUJl40JWghhkBbZUQen83HfKS6xZCvuA9Arlshhy1GQBuICacpaZpqq6g6PL
         vVR9CUzKty0tGxchTKrn9/b6zJoQXjFimLNy3g1h57x+mHL7Bicc3qwxTjwiGp9wm/4q
         C13Q==
X-Forwarded-Encrypted: i=1; AKwUvBwiXFLGlG9KS00kDxEsw4FVXQa3qyDOKqLs+FkywDjM6nRkFotC7vbklxcp05eVVPnNw9297TaVhvad10ow+dA=@vger.kernel.org
X-Gm-Message-State: AFq9FYIu0Vhg5EOaj3PxerG1+Azrwo8JT/sGkGHZ74YeWuztoPKYsCak
	8xA6jC+HxdOTFGu24RRGGlptNbxmxG+DPu4y2I9Zv4qKafGZ6DYYstuP
X-Gm-Gg: AYBFou3oVCx/n8OHb6PS0pR/wL9pGmVyX+OD86BLjFLa6QxXAZLJTisPDfbuK7L8ceF
	lgjPAG7fWQGZiuH9ITApaa+IB7Uu3vbEA1nqOYptXGu/cOtSUtTkcXlP+FqIcVbxqI+rKhIcu9x
	EAxhygp0B/dFSencKfMKb950+xVVkdHFh0IdXjLb/YW1PRtS6ligSaU52FysRnicrKgdf2iW+G/
	KR3p/fkar3+lfS6TXJGXT0d6LoTfvh+zbjQHZ8wmHh5E+TZ1u5MeU4QU9kjPzKZ2cIyM8mKbqY9
	eg0c5qLNByG6AY9qGGbKnJjX0KW3MwkAOkTDgn8RAN7LLrJ+isBsf7MbO032AKxIPUsZ9ATadJH
	+dL54HXrwtHpg68VXbuMU4GnjyCsp29ci83npdWZkl8T1RsOPlzK2u9iWScQm1Y3gZKA0b0i/A1
	1fTlduCXR/qNoD3pY84irE02JQOxRBrfHhVnLNRlc+4/+AyIVpiWzhXMOmpt5FHVUmclvdF9SZ6
	nx0eg2Bnooz0UFh1HHKxD9ju2TKu1+5rJTn4xXPYQNBA9/nQg==
X-Received: by 2002:a05:6000:2912:b0:48b:ec8:b0d8 with SMTP id ffacd0b85a97d-48c47fe556dmr8699999f8f.32.1791149083490;
        Sun, 04 Oct 2026 14:24:43 -0700 (PDT)
Received: from andreayoga.localdomain ([195.122.200.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b38104417sm20407354f8f.27.2026.10.04.14.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:24:43 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Bernhard Thaler <bernhard.thaler@wvnet.at>,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH nf v2 2/2] netfilter: br_netfilter: clear stale VLAN tag on refragmented packets
Date: Sun,  4 Oct 2026 23:24:28 +0200
Message-ID: <20261004212429.3648-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004212429.3648-1-parri.andrea@gmail.com>
References: <20261004212429.3648-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bridged packets that conntrack reassembles and br_netfilter refragments
can leave a port that is an untagged member of their VLAN with all but
the first fragment still carrying the ingress VLAN tag.

With bridge-nf-filter-vlan-tagged enabled, conntrack defrag keeps the
original fragments on the frag_list of the reassembled skb, and each of
them keeps the tag it had on ingress. br_handle_vlan() only strips the
tag of the head skb. When that skb is not cloned, ip_do_fragment() and
ip6_fragment() send the frag_list skbs as the fragments, and
br_nf_push_frag_xmit() only ever sets a tag.

This was triggered with a reproducer that sends fragmented IPv4 and
IPv6 packets in VLAN 10 to a port that is untagged in VLAN 10, through
a static FDB entry. The first fragment of each packet left untagged and
the others left tagged:

  ... ethertype 802.1Q (0x8100), length 1514: vlan 10, p 0,
      ethertype IPv6 (0x86dd), fd00:10::1 > fd00:10::4:
      frag (1448|1448)

IPv6 became affected when commit efb6de9b4ba0 ("netfilter: bridge:
forward IPv6 fragmented packets") added IPv6 refragmentation.

IPv4 has been affected since commit 7885198861fc ("bridge: Implement
vlan ingress/egress policy with PVID.") made the bridge strip the tag on
untagged egress, when IPv4 defragmentation retained fragments on
frag_list. Commit 14fe22e33462 ("Revert "ipv4: use skb coalescing in
defragmentation"") later restored unconditional frag_list reuse.

Clear the tag when no tag was saved, as nf_ct_bridge_frag_restore()
does on the nf_conntrack_bridge path.

Fixes: efb6de9b4ba0 ("netfilter: bridge: forward IPv6 fragmented packets")
Fixes: 7885198861fc ("bridge: Implement vlan ingress/egress policy with PVID.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 net/bridge/br_netfilter_hooks.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index fe8d2910dae21..2519c3820fb00 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -795,8 +795,12 @@ static int br_nf_push_frag_xmit(struct net *net, struct sock *sk, struct sk_buff
 		return 0;
 	}
 
-	if (data->vlan_proto)
+	if (data->vlan_proto) {
 		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
+	} else if (skb_vlan_tag_present(skb)) {
+		/* Fragments reused from frag_list keep their ingress tag. */
+		__vlan_hwaccel_clear_tag(skb);
+	}
 
 	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
 	__skb_push(skb, data->encap_size);
-- 
2.53.0

