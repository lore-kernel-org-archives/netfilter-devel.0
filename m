Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651644C225E
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404997; cv=pass; b=DwDeHHhxfsxJCQA3m/s+qIeYz/YOWzLCU//eeWzNrtq54dO63+KVj+5YIXit1OfZx9Dmjwz3RnJfp3gkS2K+qXLrAJEwZOI9rvJMbkRtXr+hMMAdck+tXh7pL8z+H4t1WNkaRPWKZsk4+m7bGZxwKMtEu74GW4AaYTpCu0F49yM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404997; c=relaxed/simple;
	bh=ouMqqOITH7IEhpY2mn/CM2WwJVqpt444KX7rRqa0TGw=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=rGaPEyUq5ajmEZ+0UwlETreKPU7YzuWQk4Bg5I7TOFTzgnJHbrres8TeqQUH5FJjUtulFeeaxo4QyUhF/W/qE6Hb6l1xNXs/DrzrXt/hX2gsIzt+ImTKxqcKrWkS2ssUJs1mbqNuw7x+lQ4KUMWJfx88wU4SFeoTj53KAdex+L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mh3i+on6; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mh3i+on6"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5337c7b9937so404821cf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 03:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792404995; cv=none;
        d=google.com; s=arc-20260327;
        b=AMHmpnpdGNwolpzKzHyK9wL3fCSGt6VGG4fDZi206iHgsxCt4yW891OefmbcD2cadl
         QVFf0r50Gat2MzUyWGdQk8LE10FkfboBSP1UgFXv7/CjcdjKMNQemT25lfs4j5MpfxT6
         bUUj1JclRROX5GWWL0uGjvYGTwSBysnYnHGPmRjC59zOanhc9igOqzYb+5n3vsukb3T6
         fiB3G29fN9/ljvXH60IkxIgwvfN7yCBjZNRsWvdZN5ZA8M4dN5Vnwok/5T8p+txzuSlF
         hKQCc9eNwe60/lyxXI1ufIfuAfQx2ymiJkil9qc0VbZmPlg2r9n7JJ/eyq6qDXSrx45Y
         Y9YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=y0Bn27CnDY1ihLvQBHBS81qpOHjA6zqJWLt9dP4YpXM=;
        fh=i9OkR5Ffjk6BGb6ERgFTuUWSWgRSG//PGl7K0GbDlXQ=;
        b=bn5senMCwDc84PoCn5Wm0Hxab15t6YO6xnMd8fJkaKO05FxVObRkiZbTyeNk8ocLS7
         kNPtxTXM16pRWuXn73PVUdAW6RPu7Qs58IhFSPt2gJzsqebcx/JyyAPx4Fv2es1Yq0Qe
         K+yp8k97EwMmVU9zohpk8BB6sScDue0tVBPjgBlAC4aACupn5P+jj8EifOyql4KargLY
         KR2xYQaJg8/aEOGUqZZPu6jD5W0og3bFlawKJ+lKNX7NEwLro+fu/U3NqYe7/HZhsqV6
         cOvpL3jhGjvwVLmenzmxhZWmUpRRE4W9J1O1+tcyFkuQF53qLlRTT0XLOl6nTUNxWr8G
         Uf2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792404995; x=1793009795; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y0Bn27CnDY1ihLvQBHBS81qpOHjA6zqJWLt9dP4YpXM=;
        b=mh3i+on655CVqKZJ3PrQuYhQx1sKB22kX+Fge1eShq8JUVDjn1P8aBoWLl0BM9eO7y
         QccgDEWF2xglJQTPjnR/VI8tAf6L4XuvwIF5cWcl5E6VSDd6kXYshhoDGPje1P4TJ5Ee
         WPjUC3sNenOb4D2tKdR4uxPEFT7M3rusAMrNa7npH6ERedM6KUlT20k/4bjz5COXmedo
         jM5y9oSrvnoaksSKYj48RRI/jkccJzVkefCbZhrFavHJJlb8cgSOeakiJ/BcV32DlEQb
         Ig2eVDlJgEdRDKTsj2C05W2lj/8g7Ws2SLLg4kj9ViR6o5GpER6ThzGIqXViTBj08Ym4
         xAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792404995; x=1793009795;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=y0Bn27CnDY1ihLvQBHBS81qpOHjA6zqJWLt9dP4YpXM=;
        b=pvokak+atjE8GpwrwHG8MthZSPm2cnpFRacOehIEWv43TK3Bu1YCPgZPR9LE4WY7vQ
         MYa6kig0VWf4+64I1lqkH9jUBjMk1DBSysJvaKwgDy7RWyl8GEBGCYRbwvNjcOPbGF3A
         PW4MTizz+WM1j9BYmUBEzYPF2OLOb6gBapvoe2w/oFAMmGk6DQTMqiEbZ1o0kphmsSfI
         y+Rr/1EkNnAnFLvWlnlBp3wRrvvF+uIPz9OSSSR6hTGRwcu0HgqWgUoOkjzt40k0//Hj
         sVw+HqnutJ78dTI6teWSpa7yIsYl3mx5GDsW2KNvY72PLJPqa/f7QLp5ZAlQqwYh9Z6F
         Y+og==
X-Gm-Message-State: AFq9FYJwtE8EPgMqVFchf6uG+S17Yod2QTlOcojWuyKKTwarkHt5HsDW
	b/q3MFX/QZRR1eQd5XmqqC3YK2cFRr6IU9Bvfj/O1+DzKh7heHqDFBIiThgvRzUlBpQQDz219he
	zvQpgbY5Vu49U1RkYWNH3KR4PTqkb6mAMkmRVAcJ4
X-Gm-Gg: AYBFou3sUAp5OkkaJoexD9aW2/nFXqSGKtGk/kROJelyKQsa8Ga1MnaRogX+GqyihXT
	3mV1r45jh5XD7ElWMHeWggsy8mDiNrDmLDWdpckENpqiHeGyHnR5xbKX3z32EKzmsH05m4y8cH1
	j/JlpRw6Y23/6uopag9V9S/53CulrO9+zp4D1LBy93ItCTfCu+HIrONUQK/kf2HrJLh/iiITRM5
	Zw7p563Gy88S+d3ueXhkmbkkhTfFBtbNC10QP/WFAyBMr/WWje5ih6a6rXbocDGc5lNQW+MxUlx
	iu/WkrCLnvUtivTtkzfPqgMvbqy6wiLOHxUl/RjV+SnNPbrSvIuGZLMsAxTLJV7GJ/PhYcc5Mwi
	G15Wt1CDGvdfO7J1I6JhWRDPJZErTYjHdkqWd2SUdjIsvpSEiNEKLh1NeOf2dSblpj/P/dY+D8n
	azlo9vSyrQn5VEUeozK9lOKjVLPmo3e+UA4IpX0vOfKS/BcEvyvMc0og3F640mrvs=
X-Received: by 2002:a05:622a:4a8f:b0:531:282:6560 with SMTP id
 d75a77b69052e-5362b4fcd9dmr35234971cf.15.1792404994008; Mon, 19 Oct 2026
 03:16:34 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 05:16:32 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 05:16:32 -0500
From: Dominik Maier <dmnk@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 05:16:32 -0500
X-Gm-Features: AclHuK_pkStAKyz1wgutnTEn2UxxNqqHbPz5YRakSn0riuF38UVb8Xsgl6GI_6k
Message-ID: <CAE7N4Sq0wALccc4+715nZLtYQWeZz=uBHfyK34F+LVz4iov_vA@mail.gmail.com>
Subject: [BUG] netfilter: ipv6: nf_defrag: u8 prev_nhoff truncation in find_prev_fhdr()
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, dmnk+artist@google.com
Content-Type: text/plain; charset="UTF-8"

In Linux 7.3.0 (commit c03c1a14507d), find_prev_fhdr() in
net/ipv6/netfilter/nf_conntrack_reasm.c (line 398) tracks the current
extension header offset in int start and writes the preceding header's
nexthdr offset to int *prevhoff, but declares prev_nhoff as u8.

When nf_defrag_ipv6 (CONFIG_NF_DEFRAG_IPV6=y/m) reassembles an incoming
fragmented IPv6 packet whose unfragmentable extension headers place the
header preceding the Fragment header at offset start >= 256 (for
example, start = 296 with a 40-byte IPv6 header, a 256-byte Hop-by-Hop
Options header, and an 8-byte Destination Options header at offset
296..304), assigning prev_nhoff = start truncates 296 modulo 256 to 40.

During reassembly in nf_ct_frag6_reasm(), writing
skb_network_header(head)[nhoff] = fhdr->nexthdr overwrites offset 40
(HopOpts.nexthdr) with IPPROTO_UDP (17) while leaving NEXTHDR_FRAGMENT
at offset 296 (DstOpts.nexthdr). Subsequent Netfilter hooks and
xfrm6_policy_check() (__skb_flow_dissect()) parse the 8-byte
Destination Options header as the outer UDP header, whereas
ip6_protocol_deliver_rcu() delivers the real UDP payload at
skb_transport_offset(skb) = 304 to the destination socket.

We reproduced this in QEMU by sending two IPv6 fragments containing a
256-byte Hop-by-Hop Options header and an 8-byte Destination Options
header (placing the Fragment header at offset 304), causing
nf_defrag_ipv6 to overwrite offset 40 instead of offset 296 and bypass
an inbound XFRM_POLICY_BLOCK policy on the target UDP port. The
reproducer is available upon request.

Below is a proposed fix (also tested in QEMU) changing prev_nhoff from
u8 to int to match start and *prevhoff.

Fixes: 029f7f3b8701 ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
Assisted-by: ARTIST LLM
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c
b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 13bd8997f36c..8fb7380f239d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp,
int *prevhoff, int *fhoff)
 {
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 	const int netoff = skb_network_offset(skb);
-	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
+	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
 	int start = netoff + sizeof(struct ipv6hdr);
 	int len = skb->len - start;
 	u8 prevhdr = NEXTHDR_IPV6;
