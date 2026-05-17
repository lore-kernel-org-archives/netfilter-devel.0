Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B6730C149
	for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2026 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779061805; cv=none; b=JzbIZRa7C3nI09qVUI/J+tYowsKZiqDO+cPvQz1Si4xBxE76tSUCOydGTa0SIZDx6R99zwk8oZBJjee2yaGbmcRhrP+Nt7CCvPMa9ccYYhRv2TxPxqG+uM5GEgfKF467WQbpIL/1WOB5f/sw/siKdHZGGhx992VY2vJxjXKlhu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779061805; c=relaxed/simple;
	bh=CnEPR4WvuGalhEU1d6bA9LwifKrg2bPP2TSmKSwG/Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwT1L0pnlR3TS3bg9+dcwWM3HGXwuLusP5oto69psh5U8nJrrJx8RsUFXSqniA13DRJssuYapDlvckM8zpbYmNHWdup6i+pxbrD6sRcvH8u6t8lrhon5HEwREvx85OGU+JrfBUhLUdBisIr110NJIBUxo/7HCZBp9X1iG8ndPuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zxdie/AY; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zxdie/AY"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9118b952e2bso335226885a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2026 16:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779061803; x=1779666603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIXRslS3bbrBf0TjW6A+hsOey38qddDJZpNKTIIzNw8=;
        b=Zxdie/AY4Vmp5j2w8tMmn0cHPGkJyKimlUUR6lcBSsBMfWfhchYr9Nof+fjdn0ARZL
         2zF8BmcXlAc2aOWQlvvUG9dNScqbYyYGhfdSoTQ01/YIRmrmfvn4J0GBb8n/dBOmGtUQ
         F4+/ZuGKF/8KvptY059e4PE3SnrpY1cvgq1YY6s6VY0kXp+QdcjZhBBBiUEbH+MK94SB
         Ct7+Pj42CKjTLZN3oKorq/89Ngc+v4NArlBuP6mDnJhsAKkDPlBajZf29Btlk9orrTgc
         NJsO1DxAlo0FUj8NYP/SnoXKTJbYVbPi40EPexqRpbh/RLkrnxvrDT1pohamG/9iO7Ay
         huBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779061803; x=1779666603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yIXRslS3bbrBf0TjW6A+hsOey38qddDJZpNKTIIzNw8=;
        b=ltBpANZw3fkpowO9wYJcSVpqfqu5Jil2kmF2ywAY2YKlvuHocn9HjJ/uxaWk9T0hOC
         ePgXfjQCTud6PYgEUModE49BYv8do78O0YmsXx0bFtTDYw8dxKiX3DMMFkPkJux0GtW8
         Oyw2T+VthL8HLaebpOassmmI+/YLwwvnIeTtK8b+oLaOvmnXzuKKEtnxHr5+oVTIYAiz
         P+Sss+K5/zNLjMXYukn/CsBrjn98HQDfDmE85Zst/B6bvSA6uht87Rz88xLbAyEPxQX7
         K97Sa9Uz5K2tnkX/D/Cn99QUwGAZ1FzYWqvbXdKZII5/Ivd7r+dnMpAoYsPWAdzzPhtS
         stkQ==
X-Forwarded-Encrypted: i=1; AFNElJ8dyvBWxqHwYJ/TXTYPiRkWvoPO57JMdQKcoI7OalApZdWev8cl8Jjnlz1AqXOjFgxn5JZ7H6Sl5gqYFt7XiCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn4eWYPIFEnAbCW0rcacdHJOiKl3IeRvzAcWOZP0GrhT0y4Pel
	EUNcAUPS283Vq9fN7vmDaujflmnT3t18viNynimlOsHj84iV4JkoAImX
X-Gm-Gg: Acq92OEEvj7KPck4xPypGq7RnNM2l13Q9ekNI3ma8tzibqeQsAdZAwlYxwRphOrHGSY
	3iJPip3nBIpqKvdKwgRZQPqWnqz59H480GVZjG3uG/1w2+hbVIPveuPJkCX1ckb4Ws8dTrl3RP8
	XYKNfmXzhfPV5Sq3xj9xG/0tJpgkPnNTaAniEtwTxByahOWZ52CkCukNQKs0z3Yv0mODS06wTpG
	zmBpjN6GBz7TESdSJaj2dzX+/oExSkwUT6CTDJLUl7Q3y5Z5d2pAZLzIVVj6rN4cA1+XY9Z3Lic
	k7IdDEFaaXvT41RbHv6xcR/rHJc8vr04DBrqM5Ki/D4dEH6cGLra+jPJ6uU0jRwP3jlvuPILk3J
	bRZrD3O2M+J+E9jIvk4qbq46xj5XkS/pjVfkrF9VDHk+meMdCixve1jedtiOiyDecewOGfiRIgw
	8LPalfnHpdmsRtC7VvuOBxad/hNfIQGfVwyBn2cV2YeK0GV8qPT2vydPdSwhlVF2bz+MltScn9v
	xjxt30HiXhpH04r/7jIZjTFmmMPnMsfWCTKClV+pn0=
X-Received: by 2002:a05:620a:46a9:b0:911:6136:281a with SMTP id af79cd13be357-911cc4bc1b8mr1891279485a.17.1779061803265;
        Sun, 17 May 2026 16:50:03 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9138a830c89sm502230585a.6.2026.05.17.16.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 16:50:02 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org
Cc: davem@davemloft.net,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] xfrm: validate IPv4 header length before output transforms
Date: Sun, 17 May 2026 19:49:55 -0400
Message-ID: <20260517234955.1276828-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <agae9ph6pzaQJv3E@gondor.apana.org.au>
References: <agae9ph6pzaQJv3E@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IPv4 output path validates ihl before handing packets to xfrm,
and raw_send_hdrinc() now rejects IP_HDRINCL packets with ihl < 5.
xfrm can still see a malformed IPv4 skb after that point, for example
if a netfilter rule rewrites the packet between the normal IPv4 checks
and the xfrm output transform.

Do not let xfrm output consumers be the first code to discover that
malformed header.  xfrm4_transport_output() consumes iph->ihl before
AH gets control, and the BEET/tunnel path records IPv4 option length
from iph->ihl before constructing the outer header.

Validate IPv4 skbs before xfrm output handles offload/GSO and again
before each software outer-mode transform.  Warn once for ihl < 5,
since that means a malformed IPv4 packet was reinjected after the
normal IP stack checks, and reject the packet before transform code can
consume the bogus header length.

A QEMU regression with an nft payload rule on the IPv4 output hook
rewriting byte 0 to 0x40 now reaches the WARN_ON_ONCE, drops before
AH, leaves xfrm packet counters at zero, and exits without a panic.
A valid AH transport regression with normal ihl=5 UDP still succeeds:
five sends complete and the xfrm state accounts 75 bytes and five
packets.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---

Posting this as a follow-up to Herbert's requests in the  existing
thread.  Patch 1/2 from the original series landed as 915fab69823a1;
the AH-only hardening did not.  I read the patch-2 comment as asking
for the defensive guard to live in common xfrm output code rather than
per-consumer, and this patch is my attempt at that first block.  Happy
to revise if you'd prefer the validator placed differently (only at
xfrm_outer_mode_output, only at xfrm_output, gated under a debug
option, or moved further out to __ip_local_out / xfrm4_extract_output)
or the WARN_ON_ONCE swapped for a silent counter.

 net/xfrm/xfrm_output.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index cc35c2fcbbe09..02f38eaa68ff6 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -27,6 +27,31 @@
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb);
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 
+static int xfrm_output_validate_iphdr(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	unsigned int ihl;
+
+	if (skb->protocol != htons(ETH_P_IP))
+		return 0;
+
+	if (unlikely(!pskb_network_may_pull(skb, sizeof(struct iphdr))))
+		return -EINVAL;
+
+	iph = ip_hdr(skb);
+	if (unlikely(iph->version != 4))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(iph->ihl < 5))
+		return -EINVAL;
+
+	ihl = ip_hdrlen(skb);
+	if (unlikely(!pskb_network_may_pull(skb, ihl)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int xfrm_skb_check_space(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -459,6 +484,12 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 
 static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
 {
+	int err;
+
+	err = xfrm_output_validate_iphdr(skb);
+	if (err)
+		return err;
+
 	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
@@ -769,6 +800,13 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	err = xfrm_output_validate_iphdr(skb);
+	if (err) {
+		XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+		kfree_skb(skb);
+		return err;
+	}
+
 	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
 		if (!xfrm_dev_offload_ok(skb, x)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);

base-commit: aaec7096f9961eb223b5b149abe9495525c205d9
-- 
2.53.0

