Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.228.135
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793497555;
	b=NeYwxfTxOLDfSLX+0uCwCrp/A58RTjRoW8J275km+2VglT7iAi1jAqpj5DNoV0DvZ8mF
	 Hz1HjGQDX/XKMc4KQ1OwP5/HzRZ8XFjJk5zZF32FBY7rg7GbCX6LJpsP/Eqbod5x1QG0Q
	 9GtyFbGBj6NtXN4HJ2QHS7QZLTddXoX/wfGF86sqZjQ+mtYMFPLMhla7Pgt7YJORWUbr3
	 ET6lJa6pwpGBLRO3lma98jpe+hfCIAB+SJfI4zIbmjTFfVDHiW8cSKU3WaZmbe3aQ6nXt
	 BK+D5JLR2mVAHuwFZ8T0nvP3MX93sgefHtzVlm14UaTyquTU9F6/UurvB18fBuCwMBA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793497555;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=hGJpUD/K7wiBVPEctZzE0GNNEQVoqOVuF2tGYqislSs=;
	b=ldKVFESF3NLKX/Duv97rfdjBvwGiQLIbCGWWC7PKGmKypt25aesw6nf4MwfROTxofOQ/
	 NBXy5G9appGEr9XUfcdmkp0Qc5BcEwZxcSLdN5ixUmdglV8XMtf7rF5LssW+jKcCzAV0g
	 /n4rs1zgehuStp2G+e1YS6KDaGbvfAehpbtkNffxkNR6xgwZH5XPZqRCr/pekAGui9uei
	 3USt+MruRYxAamL2U2EsxvTH1AS3bk4F5Wfj4D7ToFuA+lV+shIpqDw/c5IkESP69wES8
	 YaSC3XDa9Cb0f9dt4mZejk20pRqdUx+1sNl/L6itXR0eVjB2o1x+7gaGaLlGJo1Qj0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=owtMUGm0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.228.135
Received: from mail-ej2-f7.google.com (mail-ej2-f7.google.com [74.125.228.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08147606A31D
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 01:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08147606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=owtMUGm0
Received: by mail-ej2-f7.google.com with SMTP id a640c23a62f3a-c40b9a88a5dso150531866b.0
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 18:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793497553; cv=none;
        d=google.com; s=arc-20260327;
        b=q05/K9sq6cd+qaTw5QzJoACDw0H4gIHTOYy2YrlZzqhdCFBU0bhR4xvJGNCAi9URBm
         eGBV2O8WIaRcqjluRq/L4tyiTBAcS2SnuGbwCm7tsKKe6Q8/JdwcxUSIxRUYgOYduE1U
         HOTGamjFQtjelhLXXOO8kv+bzTdORux5nC3jvjJdV31LaLmYtUT4p5EPSyHZJXs9DGxw
         YX7u7fa5fnH4DIdivD8IC+bCyU2ZoVz0ws7vp1o9t5iYZ+anGMGUAafYhULFnM99JMXz
         JUShwKpnK8ie1dXQuSdZrsGUfqO50prab1YTkcTw8NNOFiJjyHoHS258r7VDvid7/AiN
         5TKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hGJpUD/K7wiBVPEctZzE0GNNEQVoqOVuF2tGYqislSs=;
        fh=k69nQsenHpc8S9/4+YrmIKFTmVtIfFeqZGpopBgN4qA=;
        b=h/76+kXCI7TgpN+n4Kq89l2ouZskSqast33QHxCaXp9QJGqnDYjjKjRDKlDO+wM+y1
         hPJsJzBktse8Jgw1HGFBAosofsdaOlwjv2gldaC//aBTJREf+CAZXnWruGdwRL3++WCb
         4dlWlXNEHGmZbX9QojVT4VHe6CumfbIWHfUhEUQwNem4yjfWtldXU6XK8xD5EgwxAq7k
         zzc0wzLlmis1XK08rTGhE2Uv4ypRlcLnA4Id6DJIgyXSKda1E/lQl/KDvbEUZibZ1y99
         ZQE7aiaDAzo8j+BuhJRYo71SypE98Nd5pLAZnc01pJuEvTOCT8kBJLb8+UygXjvGGbYo
         SQ3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1793497553; x=1794102353; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hGJpUD/K7wiBVPEctZzE0GNNEQVoqOVuF2tGYqislSs=;
        b=owtMUGm0OdNJmRFp74HzDid0RKOQfT9ca+jz2J9n0a/6ogdYSnaqzKScCoC2K8h8tK
         w1dFpL9U9+Oh5B5rH59fhyBQn38g7CWYgJxEBZj3RfvfPDSJfSH4WynUeCQp601BhtsG
         KAdvCO7JMFK+T9zIg7dhSYCNGG5HgLxyIuXYvoXrMNQWgnGpiWNgp9h0dr91tIcOz21q
         tYmg0B3W1LukaizHOy08re25PYaQ6CZl7Nm0uaoIeJ0XWsBZAPhKoKp497vuzDEZ0Wlk
         oz+Kf1Vk2gM/Dse3T9qtJ5ylLcwz7Xb2jA/9hAa/Gc+rNlNPS3xUNyLxyrtWEkj+wlDb
         cKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793497553; x=1794102353;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hGJpUD/K7wiBVPEctZzE0GNNEQVoqOVuF2tGYqislSs=;
        b=KFa4kztiT9GSzlnv53MQcYEAHTuuECYAAYWlUI/65Y0gBdSBH15CUcoMC8ZWNVxu7Z
         az6uSS1OxaQZrTPYZCa+m4raS4CfLchmQbSBJ5oK7vSM9lVYI3nwY3SXxvXcum3SmGmE
         Qx15otdc8rWmJLo3uh5HRAs6EFtSy9leakHe9sVBowHWe+JNXe562UdEqVfRp6OMW+Ms
         bRoz95YlKaYTxF+EAoOdIoH5kR133wD5FvavJLcFKro2VQEplgCpTCq1H5U3261mDNK2
         ygbbNH4hd1nxMfOFo/b0oDPUVoPiU3A5z6iPQ7XUOXjQcXwyNCntE2q/qrkYKG05zcOJ
         WNRw==
X-Forwarded-Encrypted: i=1; AKwUvByBwUYD9pgOBIZKa9e8sNwtUt9e8GGY++9ug/hllMLkS6IhFVX3IR+JIlE7t9wBnzCkT6A1KJSaIh5jqVc84qY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJsUtbh0cb04nsIlVF/2FVM/rIdpKDo1qOsOtDF9uCtCNmoYQ/p
	MsbG+8C113uJgMU9Hx5CVfeTawHDerbA++D8JOvxCauxVFN9Z4cEFZXsYrgKvSIqZpUtW6wvnim
	hf3o4IwBhA6B6PA2eNJxmJcmSianFtDj3rbW7Ekh+aJg=
X-Gm-Gg: AYBFou3M32WHxTettK4qNtONy9zdU8ZwuHS9q+n5bT1iU7/w5NRsiMRXNW/iEe7Nmj2
	XwUngJaX+1S88EYX8YOQhwM4g0ZwOy0uCl5KaEGyR4y50f1kU4Np2Bp+PX+bx/P6hwE43KzvnI2
	6sNrRemziT2Q1ZmuTh1qX6aEIDkF7egLKsPjPdZ7oPTK5fMO8yenp2rSCl/YalD0Nq5kUCjcYDh
	GK4i2hf1zQWMowAd6z+XtH7vgATzWWKohbsynvp4tjQ841ZNZtEXm8b0OuNUEbEZ3eDdz1WhhSB
	azMEoCk1IEY8skvS8X5Q+MehUFQF/xXuZNsQsCiAXR3I/MAUGDz2O6lxzk+MNHJE4L1ndtXfbBA
	Xmzew7vhJMoMduSW4qJyZRZZuwmeYdkhZipubQsH9ZrEezemYx8L5tNO/xQW3xlvWh9KLIoooZQ
	ODzxeyCAUVNzbw/0x+ZCOt/AkKhVrOUMgEVVjddCBTOkcFyjgtxdaQ
X-Received: by 2002:a17:907:7fa5:b0:c2e:4fa2:f3f7 with SMTP id
 a640c23a62f3a-c4ca7a7256bmr486650866b.22.1793497552755; Sat, 31 Oct 2026
 18:45:52 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 31 Oct 2026 20:45:52 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 31 Oct 2026 18:45:10 -0700
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?5bKp5qmL5ra85LuL?= <ryosuke@ikotaslabs.com>
Date: Sat, 31 Oct 2026 20:45:52 -0500
X-Gm-Features: AclHuK_b3bDv0sRbhrEahX0SXn_K2x3jJKE35ZugLZPz44ifFXG_ivfkMJa01gk
Message-ID: <CAN2NGG5Y_A4ZcH3Wh8A8HeF42zOR=HnUpKYH7zxi7DJeqhwwjQ@mail.gmail.com>
Subject: [PATCH nf] netfilter: nf_conntrack_reasm: restore IPv6 nhoff after reassembly
To: pablo@netfilter.org, fw@strlen.de
Cc: security@kernel.org, phil@nwl.cc, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

From 8197824cf0c745a032f6deddfc19fd62302c804e Mon Sep 17 00:00:00 2001
From: Ryosuke <ryosuke@ikotaslabs.com>
Date: Sun, 1 Nov 2026 10:43:10 +0900
Subject: [PATCH nf] netfilter: nf_conntrack_reasm: restore IPv6 nhoff after
 reassembly

nf_ct_frag6_reasm() removes the fragment header and resets the transport
header, but unlike ip6_frag_reasm() it leaves IP6CB(skb)->nhoff set to
its pre-reassembly value.

Subsequent IPv6 local delivery consumes this stale next-header offset
alongside the updated transport header. As a result, the two cursors
can point to different protocol boundaries after conntrack
defragmentation, causing later processing stages to interpret a
different transport protocol than the one evaluated by conntrack and
nftables.

Restore IP6CB(skb)->nhoff from the saved pre-fragment next-header offset
after reassembly, matching ip6_frag_reasm().

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Ryosuke <ryosuke@ikotaslabs.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c
b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49b..ab06b05 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -321,6 +321,7 @@ static int nf_ct_frag6_reasm(struct frag_queue
*fq, struct sk_buff *skb,
 			     int *refs)
 {
 	void *reasm_data;
+	unsigned int nhoff;
 	int payload_len;
 	u8 ecn;

@@ -345,7 +346,8 @@ static int nf_ct_frag6_reasm(struct frag_queue
*fq, struct sk_buff *skb,

 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
-	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
+	nhoff = fq->nhoffset;
+	skb_network_header(skb)[nhoff] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
 	if (skb_mac_header_was_set(skb))
@@ -360,6 +362,7 @@ static int nf_ct_frag6_reasm(struct frag_queue
*fq, struct sk_buff *skb,
 	skb->dev = dev;
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
+	IP6CB(skb)->nhoff = nhoff;
 	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
 	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;

-- 
2.56.0
