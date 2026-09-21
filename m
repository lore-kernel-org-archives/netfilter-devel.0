Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14F9335081
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959236; cv=none; b=djL5y5oQM7aG14dXdSt7/PKQY2dcBIeI/aFvzZ2zzQHnrxTciETNAm22imP8/edZ+nqJq28b8N+huXr5MGqRvoxHYChcAPbQnCIsLwqvn3tFs9SghHY1VF9+8WLeiZ9hs2wuKS58yO7F+FcRokL1eLQToLZ9inOHGWqCiwGWuUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959236; c=relaxed/simple;
	bh=o7u+Ilnkg+4xjG93z/0C0NZxlAlBcA2mnfdP5ehaM74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUbVJe0XD60Khsp9Z5mQIOqvLplY+XSlOo1wcd4yCYfOYo0Lg1nZbkh6PbjDt8w/jQMP06nJMqE9cDLScHMkawpvtg1zLxB6b5egB9EGJQJjfk29wt7UJPFe1aPMuHqyr1vdaF2nc7KeY0jMusYfLCY5NGkOzhEUkL85TpT9Qus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=et+W8caU; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="et+W8caU"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cc46c8so322026585a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 19:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959233; x=1790564033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u8Ct4yW9W4ymcEv428o4m/ZX/KrAWtAnJ7CKPNzyvYY=;
        b=et+W8caUeJia6mcj+wTgoqX2bCsCLBK/WVaX/C/smL2cFB37iXQulDUhLvBfJ2MX2n
         XEDtaQ1MZ5fV71ktQtakXlkp7WHuxUYf0RrjxU2tvxFQunVd1G00ZS4Ir7OYKRMLawZR
         sN9lXfmtWKxkJnXP74qbhdDxqAW6PASB+IjujdVpRsnGidWJ7BBZVSiYopVO7BdacymA
         BqcYoM5UxmFn7xygMTlbZYAOlCNaDJRrFleZxjhsRKdxf8Y+1iuq/Q2CPE1n0KRCBQdm
         dMjSfjLEjKrYiz/a7Qq5u/cSrOaesRTqIACJZM0LQPBXVeWfU4e7mt00ygMwRV8fl+qB
         c5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959233; x=1790564033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u8Ct4yW9W4ymcEv428o4m/ZX/KrAWtAnJ7CKPNzyvYY=;
        b=aYci8j5iRMjluGp0SeClUMv6Cg0Q3D7DT3JxoCggRh7IZgpEmXP3L4JJDti6aAbI3Y
         DtZ9DnpvLocozadjMtWDkNHhwjK3pBmXruMfF6N5xaXlNM5bs28olck7ULQEAM9Zp0ND
         KlGNww5RMccvsZBjBRI8g8B+aFcQqrPvutwjwVYD8/wLQbHjlV56YXDXyfeon43j5hBL
         hYTI+YtNW+QFOIMwphhbdkofkJj50aqhv0ifGG4uJbw9VmukTnALI4lmKI6XuHOws6MN
         RhPYHSNes6BsS4mN18/jaNhkCKKG4A5P/dlH/gcQ8P6SB7Jy6BW0DWJJWKrNjlyoIxGI
         cjXg==
X-Forwarded-Encrypted: i=1; AKwUvBxFKkqyZBCXSYx5/2puzTCxUlf+LUVp1rKKdf4hbXJ1Sp91kNpRZ1dij+JrUEwnh7PC8MX+katMGTsWd/MMevE=@vger.kernel.org
X-Gm-Message-State: AFuF++mCV9tMvOqRPwfssG53qLVf/VdDmciiQejH45TqPXXFBWEi+3kY
	WKQAp1Xd920baej6mp9/Bvl4v/RB5HrowlNfShXveTZQXOJv8phP6J36
X-Gm-Gg: AYBFou3vJcvV0TDo4sV2f/QJeNYt8j1zu4Fz++nzaLjblyKskqotA2Lps2K1M4WoKjb
	uR1pUTaDsBLDBP8DMwrO1HvBmPLLcRogEP9lG0rFxTwk7/MuptrLgL7T0pxt+goQGQbTt70IyWw
	W33kzNqRK7rsbgy1YhagDUqypTIpyHxV5Y0iEVTMFx8Xx7+ZVjf1aYH1dMFb6crjAq29pIiv/Yv
	zHByK86saLVagYF/oqTaX9QLW2UJCGSdTPcXAOO9o6N/ZDHn92fvtDjc/5CaFDEdnLBg1/ypj2K
	tNTMC7UvN7v12J8isoXi/t2hSmxZRT3VNSpZGofnfMmXddlBc6QQHRBgdlw/ti6EjDyqMFPNEjM
	i3gfp6RLDGP4ded2UkVad2mmQhXWgsNQy4ZQMoSUUwYdfV9/70WvTEoLuk8Leb+6fE+iVC9aRzw
	x/WY2x+l3vvY6W/7NG0IybJvA9UvuXjSYjXPxYLSHShqclvH3Tl32WwvvldFUwgIWj8gSw8flF2
	KT/DtZvgYjOuXKucxKtqYnheuDTyebFSrMaYTnVlOfLUZLgw+B2CZ+Kq0QfQ/qsJr6a6NO6
X-Received: by 2002:a05:620a:1724:b0:93b:d7a0:d9f0 with SMTP id af79cd13be357-93bf57eea2emr869731285a.74.1789959232559;
        Sun, 20 Sep 2026 19:53:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:155:4200:2c80:64b9:5e22:f77c:324e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedb3de58sm528732785a.37.2026.09.20.19.53.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:53:51 -0700 (PDT)
From: Paulos Yibelo <habte.yibelo@gmail.com>
To: netdev@vger.kernel.org
Cc: richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	willemdebruijn.kernel@gmail.com,
	jasowangio@gmail.com,
	mst@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	andrew+netdev@lunn.ch,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	dsahern@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-um@lists.infradead.org,
	virtualization@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v5 2/2] ip: reject partial checksums covering network headers
Date: Sun, 20 Sep 2026 22:53:41 -0400
Message-ID: <20260921025341.44846-3-habte.yibelo@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20260921025341.44846-1-habte.yibelo@gmail.com>
References: <20260920004733.6473-1-habte.yibelo@gmail.com>
 <20260921025341.44846-1-habte.yibelo@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_do_fragment() and nf_br_ip_fragment() complete a CHECKSUM_PARTIAL skb
before reading the IPv4 header length. ip6_fragment() and br_ip6_fragment()
complete one after parsing the IPv6 header chain. A virtualization
interface can supply a checksum start which, after link-layer removal,
still points inside that parsed network header.

skb_checksum_help() then writes the completed checksum into header bytes
the stack has already consumed. For IPv4, changing iph->ihl after routing
and validation can make fragmentation copy beyond the skb's logical linear
head into transmitted options. A negative checksum-start offset is rejected
by skb_checksum_help(), but only after a WARN_ONCE which can panic a
panic_on_warn system.

Validate the checksum start against the parsed header length before
completing it. For IPv4, read and validate IHL first, retain it, and
reacquire iph after skb_checksum_help() in both implementations. For IPv6,
use the length returned by ip6_find_1stfragopt() in both implementations.

Compare the signed checksum-start offset with the bounded signed header
length so integer promotion cannot bypass either boundary.

Fixes: dbd3393c56a8 ("ipv4: add defensive check for CHECKSUM_PARTIAL skbs in ip_fragment")
Fixes: 405c92f7a541 ("ipv6: add defensive check for CHECKSUM_PARTIAL skbs in ip_fragment")
Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
Link: https://lore.kernel.org/netdev/20260920004733.6473-3-habte.yibelo@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
---
Changes in v5:
- Compare the checksum-start offset and IPv4 header length as signed
  values.
- Add parsed-header checks to the IPv4/IPv6 output and bridge-netfilter
  fragmentation paths.
- Drop the prior Acked-by and Reviewed-by tags because the code changed.

Changes in v4:
- State that a TUN device is sufficient and no guest is required, as
  noted by Michael S. Tsirkin.

Changes in v3:
- No code changes.

Changes in v2:
- No code changes.

 net/bridge/netfilter/nf_conntrack_bridge.c | 21 +++++++++++++++-----
 net/ipv4/ip_output.c                       | 23 ++++++++++++++++------
 net/ipv6/ip6_output.c                      | 12 ++++++++---
 net/ipv6/netfilter.c                       | 12 ++++++++---
 4 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 7ecb8a26b..d81ed8692 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -38,18 +38,29 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	struct iphdr *iph;
 	int err = 0;
 
-	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
+	iph = ip_hdr(skb);
+	hlen = iph->ihl * 4;
+	if (unlikely(hlen < sizeof(*iph) || hlen > skb_headlen(skb))) {
+		err = -EINVAL;
 		goto blackhole;
+	}
 
-	iph = ip_hdr(skb);
+	/* Complete offloaded checksums only after the validated IP header. */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (unlikely(skb_checksum_start_offset(skb) < (int)hlen)) {
+			err = -EINVAL;
+			goto blackhole;
+		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto blackhole;
+		iph = ip_hdr(skb);
+	}
 
 	/*
 	 *	Setup starting values
 	 */
 
-	hlen = iph->ihl * 4;
 	frag_max_size -= hlen;
 	ll_rs = LL_RESERVED_SPACE(skb->dev);
 	mtu = skb->dev->mtu;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a24cc8ee1..fa6a74d20 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -770,16 +770,28 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct ip_frag_state state;
 	int err = 0;
 
-	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto fail;
-
 	/*
 	 *	Point into the IP datagram header.
 	 */
 
 	iph = ip_hdr(skb);
+	hlen = iph->ihl * 4;
+	if (unlikely(hlen < sizeof(*iph) || hlen > skb_headlen(skb))) {
+		err = -EINVAL;
+		goto fail;
+	}
+
+	/* Complete offloaded checksums only after the validated IP header. */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (unlikely(skb_checksum_start_offset(skb) < (int)hlen)) {
+			err = -EINVAL;
+			goto fail;
+		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto fail;
+		iph = ip_hdr(skb);
+	}
 
 	mtu = ip_skb_dst_mtu(sk, skb);
 	if (IPCB(skb)->frag_max_size && IPCB(skb)->frag_max_size < mtu)
@@ -789,7 +801,6 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	 *	Setup starting values.
 	 */
 
-	hlen = iph->ihl * 4;
 	if (mtu < hlen + 8) {
 		err = -EMSGSIZE;
 		goto fail;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 550965058..d157b6ade 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -942,9 +942,15 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	frag_id = ipv6_select_ident(net, &ipv6_hdr(skb)->daddr,
 				    &ipv6_hdr(skb)->saddr);
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto fail;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (unlikely(skb_checksum_start_offset(skb) < (int)hlen)) {
+			err = -EINVAL;
+			goto fail;
+		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto fail;
+	}
 
 	prevhdr = skb_network_header(skb) + nexthdr_offset;
 	hroom = LL_RESERVED_SPACE(rt->dst.dev);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87..da7ada12f 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -144,9 +144,15 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	frag_id = ipv6_select_ident(net, &ipv6_hdr(skb)->daddr,
 				    &ipv6_hdr(skb)->saddr);
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto blackhole;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (unlikely(skb_checksum_start_offset(skb) < (int)hlen)) {
+			err = -EINVAL;
+			goto blackhole;
+		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto blackhole;
+	}
 
 	prevhdr = skb_network_header(skb) + nexthdr_offset;
 	hroom = LL_RESERVED_SPACE(skb->dev);
-- 
2.46.0
