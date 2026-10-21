Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605935;
	b=EFbwxY3PgE4BuFaUuQqT7GWVX7RUld0radykQCbvy1Ms1q3ByMnfYnK+qRFfYQd8FquN
	 Cn62Cqx/m0tNGd/iI/Lvd7vsPjUtyud6+flE9PStnFOF/wElpPTK845isQUrYZZNJwWjC
	 CbaStwELetJvdNJSCbqFnwc+4N3LzBR+JKc0qx1Tk/WvuEqFdwU0R6dF9HsXJsf9bpqNC
	 +k7vKRQ/BX0qqKgDQWyhN7JF5h2U0259EJOAUqjJGBY4tjx6O0+w+j1txkqVEzV3hu2Ng
	 f0JcNUGmtE82i3bnXUQbvdHc03m6vmP1mbcTeL+q0eRSpNVPVy/xiupfDqHHy7/GEaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=36CIvPZFqSR3d1bRp5FOUkDzIh2a6VXH38LqlQMMHgo=;
	b=fj0RQPoop0bT+Mj9RfWXv83rd7hhYUvbB+Dp49ma/ge/rvfn6vWZP9jIGL55PWzk/PwQ
	 PZU5G7D6P50V4JQcELcnX4OR6R6X77bIHft+Wa4smkdG+lZvVukscm/G7n4a6InEUgrdm
	 zbUi7EL+VsZUmWUIxVOXBbFHAdhb9WytMAgRNSd4g4jHacURC90B68794dgw4586cJzMG
	 7xx32OqM8WSMPWU7pfCCj5lfJg1GgwsWD0MlTY147V+S1NzKaCfNbBchmK5ArSdnxMW+9
	 0zkZxDCFjj96AfhbZ0ms9w5beMY1S8FLjHJWNMeTQjK52Ft538JbBVjIG5eVYt2uMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qc4ZTUYU;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233BB606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 233BB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qc4ZTUYU
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1df146015so8458755e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 11:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792605933; x=1793210733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=36CIvPZFqSR3d1bRp5FOUkDzIh2a6VXH38LqlQMMHgo=;
        b=qc4ZTUYUtGBB48YloE+K0yBo9J5Ll7KjPH93H7mZt7pvpD0QD4DqCJEB+kKxPfziZA
         xlN0wB+iMjfxQvbswipWTCR3WZ7SCRmmc1D3tHgPnikQtaHeDP44PML6bUmtBLTbA6U3
         UdTun/vxjIpnqBvAS1kpG6RmAEeRDNSx/knlx1t+N8SH4oPWEB8jW2V4t06LBprss9nA
         b5eRhKau1OqtphqKj9cS+O+hhE2tYWCeQH9ZUbz46Vk73rldwslq12AwYEn6SkZGN7/f
         LxjEPlpGYL4713pUWpZ+JPhuPWAjpVwpScOCEhkYnSId84tcd2vaJgQInXzvbNL8Td7f
         HwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605933; x=1793210733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=36CIvPZFqSR3d1bRp5FOUkDzIh2a6VXH38LqlQMMHgo=;
        b=CS7qigWSREQ1PMjOdGmeClfn/oFjsxzRgu/MOMCuyIkPs/bEHcDKnpabkOBgERxbbR
         iGcly4Oq0xq8mahcTlIVlWOG8o5uos9tf/Rx/R+JOkCBchnhp3jE8fWmcGbJad3qrt3V
         JciklzWLdA9R0cZcgJdyjlw5+v+kMMWbkwLLguOcYpVetOUnl3EdDBuTqmb8A6Y8QBkj
         aHa0sZ9TYx0K3isRZda0JOdaUpyFR0JUwXK79VvR5XY12Pp6w6f4iMt0DkAsKHQjq6R1
         mxyVU1pgcbCi/i6C6y5bZEWdTCfxf7YAouYjcHlTxbLFfMAbAE47mghtIb7KQo26J1YG
         BK8g==
X-Forwarded-Encrypted: i=1; AKwUvBwoLGKzkEjAHvSP3k+ghQcjhpJqMaRESWamZ/gsqlAHFPLYEudwC5cpXeZgX9JNfMd6q25xl38kiZ2hjXquWj0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLB4iRe4GVpq4p/GCqk/2OSAlk81SykqloKlwIxuwrRKr7e8QFr
	CnKLVEZNVKQEgbox35zXwze5q0ZMQYtO2IC2p3Lz9JZWr9UF3LjSuY9N
X-Gm-Gg: AYBFou0U3j+pGQGSeYeuqifho1lZ4DUR8l7uG6CByP94gnseqvf+ofgastQymzux2PV
	4YFVZ07NdM9EFLqVioasWE8ZggFO37rr4tHMtyqpTg1ZOfxwrlaR5TRhDo9RDFXuDkU2RbVu9nJ
	xU5+Kx4oxpEBBOKDyb62EGFqiqMSOeMWLZ8q+af2M5h3Fdo1FM39zvE3VGdaq8OyTu5K8j16A5G
	DCY8QeSXEYfqmQRIyO0xQ2yOL+aB1BghmjYVDZmDpvYv5jxLg9l/HpBIOPMKmlHRMYr4LM18CDZ
	BC653ThK/9qb4r54LjZRJagcOtD22JT2NM1JVwAV6FuiLn3WSgtFlhSVD1Mt5RHb1NvtqbhSTLq
	qjzRstQim8XT5gik+FLcTa0lVH2M1AOZmm+Ypzz/NIdiLGuhXwAKLvElUXZE7GEjXLw5K3hRWjE
	Gw6oc+Sip+E51rUffL9fyLU2lxLmeuDFrKNl83kZNSTvIO6gvzkqMZHvoCeNDo6pbt1C5Q41OJG
	IlXvOpdD0gB7S1cmzRM4M+yCWy+ojk1W191mEc3QDZKUiIZZSVCrRizUVpfYa1TANfISjvCd8eS
	ORUMQ9PZMZ7hTyuKdahVhg6OTmFdMvi2ViDAR3NPooPv/Zf+vALkhrngNAyB9iLPtjGyctb4S5M
	h0yWELoDos7AhIgKG//X64ZFEaOefe6EU
X-Received: by 2002:a05:600d:864b:20b0:4a2:1e1:d55 with SMTP id 5b1f17b1804b1-4a201e10debmr28279805e9.28.1792605932936;
        Wed, 21 Oct 2026 11:05:32 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c6:e6ea:6401:f04a:ac6f:988e:f33d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd13891sm47007775e9.2.2026.10.21.11.05.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:05:32 -0700 (PDT)
From: Nick Simpson <nick.simo@gmail.com>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Sridhar Samudrala <sri@us.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] ipv6: validate checksum_start before fragmenting
Date: Wed, 21 Oct 2026 19:03:29 +0100
Message-ID: <20261021180329.26358-4-nick.simo@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261021180329.26358-1-nick.simo@gmail.com>
References: <20261021180329.26358-1-nick.simo@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip6_fragment() and br_ip6_fragment() complete CHECKSUM_PARTIAL skbs with
skb_checksum_help() without checking where csum_start points. After
reassembly by nf_defrag_ipv6, the IPv6 header has moved forward by the
8 bytes of the fragment header while csum_start has not, so a
CHECKSUM_PARTIAL skb from an untrusted source (tun/tap or packet sockets
with a virtio_net_hdr, or AF_XDP TX metadata) can have csum_start inside
the IPv6 header, and the checksum is then written into a header that the
forward hook has already accepted. When csum_start lies before the
network header, skb_checksum_help() warns.

Add the IPv6 counterpart of ip_check_csum_start() from
commit 6785011f8b16 ("ipv4: validate checksum_start before completing
checksum") to the two IPv6 fragmentation paths: refuse to complete a
checksum that starts inside the unfragmentable part of the packet (the
IPv6 header and the extension headers before the fragment header) and
drop the packet instead.

For IPv4, ip_check_csum_start() is also called from nfnetlink_queue,
xt_CHECKSUM and xfrm_output; their IPv6 counterparts are not changed
here. A reassembled packet that is not fragmented again, such as an
atomic fragment, and an unfragmented packet whose checksum is completed
at egress are not covered either; those have to be handled where the
CHECKSUM_PARTIAL skb is created, or by a check at reassembly time.

The problem was found with LLM-assisted code review.

Fixes: f43798c27684 ("tun: Allow GSO using virtio_net_hdr")
Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Assisted-by: LLM
Signed-off-by: Nick Simpson <nick.simo@gmail.com>
---
 include/net/ipv6.h    | 12 ++++++++++++
 net/ipv6/ip6_output.c | 10 +++++++---
 net/ipv6/netfilter.c  | 10 +++++++---
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3de07e738538..949695cb6764 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1029,6 +1029,18 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 
+/* Refuse to complete a checksum that starts inside the unfragmentable
+ * part of the packet, i.e. the IPv6 header and the extension headers
+ * that precede the fragment header.
+ */
+static inline int ip6_check_csum_start(const struct sk_buff *skb,
+				       unsigned int hlen)
+{
+	if (unlikely(skb->csum_start < skb->network_header + hlen))
+		return -EINVAL;
+	return 0;
+}
+
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 550965058991..55d7af9084d5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -942,9 +942,13 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	frag_id = ipv6_select_ident(net, &ipv6_hdr(skb)->daddr,
 				    &ipv6_hdr(skb)->saddr);
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto fail;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip6_check_csum_start(skb, hlen);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto fail;
+	}
 
 	prevhdr = skb_network_header(skb) + nexthdr_offset;
 	hroom = LL_RESERVED_SPACE(rt->dst.dev);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87035..8476e4ba399c 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -144,9 +144,13 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	frag_id = ipv6_select_ident(net, &ipv6_hdr(skb)->daddr,
 				    &ipv6_hdr(skb)->saddr);
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto blackhole;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip6_check_csum_start(skb, hlen);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto blackhole;
+	}
 
 	prevhdr = skb_network_header(skb) + nexthdr_offset;
 	hroom = LL_RESERVED_SPACE(skb->dev);
-- 
2.53.0

