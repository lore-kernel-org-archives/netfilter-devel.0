Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB6E3264CB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030866; cv=none; b=Bk24t1l8h+cqbhs0ixHfVbUDEcrKB3UV/9xlU+YAAfQVmcRTW+SNbxC/vmDPLftldS7Jm86bL39MI22jRKZrpyj3ayGxsobwvl0DAWCLkxiYywoebIKLjMcACqTvr5wp/aMnR5ILJenRTu2TF+QptFKvay9RWgXkeFdoiPM+00k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030866; c=relaxed/simple;
	bh=aiOlrU8SPLLSxXxmoliWQ97yoakbvmOPHkOmt7DqkOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7UY17cMvsbwePfxPMdUwUQ/QYh7mIPrd0HeVUZ9Ihf9KNDTThB0oZYvCiHULYzFJHw6f62vr3On3iuaUOEXr4AL19ufMkrtf1iTilDK7J1th4It5c5rlzWzs2Uzff1CJvrZ1shLNzpHbxCSsR6E78juFNLTZMGCe27MQSu3Lco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=lLAJSLj3; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="lLAJSLj3"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2938116fefso276919566b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 02:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789030855; x=1789635655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VL7uwmVve2coZFoj6sSDZb9y2OX7dyJBOYXu4XyOYm4=;
        b=lLAJSLj343DkpEeiAHb+6V53GFpRquRcmGYj/vR4SJhy1NZKzrJlgpIzcSpCl7sOLn
         Eu5zLKmBZBIF0LI7huw3n1j1nP5Gw/oEshg/KdFB/Vecn1J14HM9jMD3U6J4Km/knWMG
         ujfOo10aI8gGElWz589TmBEEW0onLTgj3kkT3eokXwyz5u2tpq/I0haMZJ0yINC72OUu
         gdrqK1gvIyngcK6ZVxWEabhkYyAV2Yzb80l5iPKOVUF50DWhFkBuUrhQpq1ZmfczPXrh
         4DjeSmrv0vapicdcClE+CwIw2iiK53k+btRLFPKkICDYBJPAcEzUfNDM+1KTgW3Czrw8
         amsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030855; x=1789635655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VL7uwmVve2coZFoj6sSDZb9y2OX7dyJBOYXu4XyOYm4=;
        b=eYoZV4sfIzveMREhEw/eU/7ZzVtYx1nSqbGabqICvGv6DKaym843bBGYGH1AWPMLm/
         /U+JKDOJyjB+eHxmiemQLvTf+eM4YYzTOAsHlGxbqnpo8yg2tIYrGkOU/mESDCZiUbEy
         PxE0OqNnpOxMyYyvM/VGctPauF0k6iEjiudZM/bfxD7dQ3MzQ75Guqjn+j4hxJDpWSYT
         wBPOKUu/n4PTGyY0qFKmKVXZfn+pJqx0ETLKaCaDL3TlBbJhi3t73ym4iRewFAgK8gDM
         5qe/9sGbW67tgKbBf1XZjoZ4TVPjqkhQYHMbFjsTiYGZpWd/ylE5Kt19mn1aUn971HDa
         no9A==
X-Forwarded-Encrypted: i=1; AKwUvBwx9jvT6V29bRu4KNDlLMFWo4BQmCBYUh1AUs1E3bMrkAaHWDhH6ol6ticyN6qElg9KxUChGLtCmOYjZi8krZ0=@vger.kernel.org
X-Gm-Message-State: AFuF++kuRlX+c61wH5F3KK2jejAopcAcbLB9XNvzjR9PdHU87gWNmAp4
	4A/5RloZjUc7tszXJrq6CPz8a+1Wd+nEbwmMinQZcZEgmZBvB+Cg+fZOm2GU59sCQvnJxXWVWxz
	uNfYSv7Jb9dPz7A==
X-Gm-Gg: AYBFou04EU2bT3V7swI9QW6qGzu4cV7Bfs8opuzd7OMviMX9r1tSrbrcBtPjNOniEax
	s74i2EjwVAVChfWqPaJN/C3lCub1zi33SVViEMCWNaWGCqNYh5sjuDp+zVm9jaJcxmGGUov7hyu
	et7PFvbKhssILEWgTMY5F0XP9YhzyIi3KzTVtYNHE3Tdp3FYb3hnd5Wf4LZZbpzJ4xLcd56gy3r
	6iDIEy+gTIxcpHK17W52q3clhoLU367B44NkiSdqvnjKEjfUtRW6byjjRHVck87oRYPmvbK/sF7
	TM1OVF0Lhs5ilwtvMOAnZ85I3BnsmK5PcUmyASZw0BN6nBJeS4rgH//7j4iI9SNJaPro2GKAm/6
	PbIMRd9PaFRWGS6ohAT184+pp7YchUO2Hkf0KlVeV2AhU7FfSsJkeUInqztuwAq2kzEB0/VEUL3
	AUIAFiZ4X5t8o2zd04334fhyTOCWzPTWmy7x+k++DH3kezoXO/UynVOavbuyhj3asUPPnWPHt8V
	2ejdrvY27amSX0uHs9ubOmgVsRa7fg+dJHKKUObR3HkbrqKjalY1qQQ9stcWPnhOr0bFmrwhphd
	2hus5oULqrEpTmyAjpeEzfCy+l0sU4dGgrhAvEDBGCltomqzhAvoGcP3yv8lKwyu5EBIe4Z3ni+
	K1RVEFtsEER4Bd315trJyYiWEzDC4l08dIUVaKVv4b1WzpY2NBozfHJcaQVVVFBQ8E83rEODzm7
	2y2TV9ZA==
X-Received: by 2002:a17:906:730e:b0:c20:af9d:4533 with SMTP id a640c23a62f3a-c260c9f74d6mr1653720266b.19.1789030854926;
        Thu, 10 Sep 2026 02:00:54 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293eaf1ae8sm156106766b.40.2026.09.10.02.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 02:00:54 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: [PATCH nf-next 3/4] netfilter: nft_flow_offload: offload a TCP flow that has no reply
Date: Thu, 10 Sep 2026 11:00:51 +0200
Message-ID: <20260910090052.2034970-4-julius@bairaktaris.de>
In-Reply-To: <20260910090052.2034970-1-julius@bairaktaris.de>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Dotzler <geldot@protonmail.com>

A connection whose reply never reaches the host cannot become assured,
and only assured TCP connections are offered to the flowtable, so every
packet of it stays on the classic path.

Offer such a connection to the flowtable in the original direction. The
reply direction follows once conntrack has seen a reply, so a flow that
starts one-directional picks it up if the path turns symmetric.

Signed-off-by: Gary Dotzler <geldot@protonmail.com>
Co-developed-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: Claude:claude-opus-5
---
 include/net/netfilter/nf_conntrack_l4proto.h | 7 +++++++
 net/netfilter/nft_flow_offload.c             | 6 ++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fde2427ceb8f..a4e3d9ed7a64 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -208,6 +208,13 @@ static inline bool nf_conntrack_tcp_established(const struct nf_conn *ct)
 	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
 	       test_bit(IPS_ASSURED_BIT, &ct->status);
 }
+
+/* A flow picked up without its reply cannot become assured. */
+static inline bool nf_conntrack_tcp_unreplied(const struct nf_conn *ct)
+{
+	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
+	       !test_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+}
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_SCTP
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..0b6be8ac3d24 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -73,7 +73,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
 		if (unlikely(!tcph || tcph->fin || tcph->rst ||
-			     !nf_conntrack_tcp_established(ct)))
+			     (!nf_conntrack_tcp_established(ct) &&
+			      !nf_conntrack_tcp_unreplied(ct))))
 			goto out;
 		break;
 	case IPPROTO_UDP:
@@ -117,7 +118,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
-	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+	if (!tcph || !nf_conntrack_tcp_unreplied(ct))
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0

