Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0C363C75
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786378028; cv=none; b=M74xZ4ZmqRljQZHhYY4IxfKrHobzexR6kzUZGxaGB1p8Q7UYUe1Crzkz55z9N8Ahr7lRsvTEkNFY1mxJIYN9dxwJpW6a8nWXwU20gdZsumfT939aXyWN6MfZgD1vP2GDWhPQwc09YbTXeOsKFKsbvs3ObtLi/IVLbSQz4AEkiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786378028; c=relaxed/simple;
	bh=TNUssqU+6WjzJhYGg+GE3ddxY9P2DiNmni13QbBxsMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sAX3eXuWMLrcFog+z4xaKd8FtmkBhx8L8XXdjIv1ivxBhhcrarf5VTY7on2Af1l5Yjbv1NUwknhGaYD6jfmjCyUHc6IFhvAzahGsKCM7pPv9DePMgP0PmfvM5f5yKXclNmdqPszxZSFZY7zuJn1HywD1+jgSen4XaJF1S+/xYEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=gzAro5Hs; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="gzAro5Hs"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-908934450cdso17712116d6.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 09:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1786378026; x=1786982826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1WVUCeqwLELgUg4fs5XXfLh0aBANIvrQI7hc+E9tLXw=;
        b=gzAro5Hsy/RZgbug/CVZnbM8O6/F42LNrimntqXBbQ4Kya3P6kc8ApbonIJVfOMkkU
         LN2byDuOFWc89Ex5K9/+SP9XF6bZ33+LTLPxAyb2NBo2vtNyMkFsmiwdS1551FKmwVbY
         rDQACzEVFyxqokeYpVk2VNGl0ikyjJJ2Lxqo82dr6z7z51eGrCXMaQWpu5J2Hopyhhte
         m00q/gfzocidYv3MutAi5burPiUz1Iw0g6kz3ZVwWOgd9YKIZVbTpRqIFAUhfZC80tPk
         Z2m8RPdOLdHW+9l57pVoz7OpADbzhTNK71mMzurZHNva2WwnFHidqofwLrVFSjUe6L8a
         tbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786378026; x=1786982826;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1WVUCeqwLELgUg4fs5XXfLh0aBANIvrQI7hc+E9tLXw=;
        b=R/CIDC6/uDzc5c1V8+Yl/Nh6ytw2L40Wf6ogPFG8lVWzDvO/gTx0tdj5vZLhiouZS5
         0n6IopRn9zB0JydoHmV6vvSoh0h6ynqS8mzV+dbw5Hd+XBLqe//gn3FKhTkulx9nGIv8
         tCaUMJf6ESz+Q+Eun2sRqSaXPBVPng5j7EUTpW+/HH7hQY+vyaZN5ia+XBX23yFJ+qqU
         v2ItBXN+1D1I2WIB05ThjkM5kUX/5z3CjoMlyWw5PLujugTWaSBJlnbtvKKG7l0zzcKE
         djfmqh9bcOb9cy3qBwNwVgTT1eeS32XJpITu7SfMYDYl6YoIcUIa0oEqasZsfgOMaxUf
         xG4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq87Q3C5bYxUqv7QlniEzvjbfsp7ZkQhA64eXOOBm6YQuEAyEEXDuxmWBTGPSaMlSllf1EUo5nqrCg9b3nCk6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMoK8Kg4aHAFvHcANkEqMPPo0l0/7JconJyPWeGLCF5jqA5iTf
	gKuDtybllR2nmD1TlkOXTp9OOmlR0Az6d4lw3IOKB2ndCqOndwauPK+f/7OT95xRGRM=
X-Gm-Gg: AR+sD11hSbDVnB/cuC7/KyfTF1vF1fSixkVUMYsM6HX2dwKqnTzwg91zxRLaIeCRFek
	n7V9QbKtdCji66R/AWw5/bY3vQDj//KUhp32ulKTyruhFMFUl/cXTCMspFkA7StM9PBKNaAba6/
	iBRVlDEcnXnHcOk8hDEksMbSVHhXw2ck9IuRkGQJn/AnBhTlBENGylbxPF3YnztJ7JvNQABSOPX
	C3INVGg+LxLCDhI+cD3JibgS9XbkgFHGnRx7HZDR8IIJAJZi/FX+6y/t836ZbtuTaG4VHzjdrQ5
	zshZmyn76SdwBddd131xuwmUpE4zjsNOvQ3S4EWWXtbMvXrIy6Vu/jOwkUTwGzZ9V7ubJ0jFn/K
	BzYrdY9QhiQaFEh58V+UPSrVBe1jwXtjiqLd0MnN2Umm+WvxOS9UaUjTq+rwv+LmuegtjEmiOWu
	h4djxqD+h9lV0hzKfgEX93XaXmhKJ0hEdOmFgYKbio7yNRKZKXYH53kAnUL4BxlfKr3p4=
X-Received: by 2002:a05:6214:85c7:10b0:90a:35f9:9694 with SMTP id 6a1803df08f44-90a35f99750mr183376416d6.31.1786378025540;
        Mon, 10 Aug 2026 09:07:05 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-908a918d7f1sm74673426d6.10.2026.08.10.09.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 09:07:05 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Lee <david.lee@trailofbits.com>
Subject: [PATCH nf v2] netfilter: nf_reject: initialize IPCB at inet ingress
Date: Mon, 10 Aug 2026 16:07:03 +0000
Message-ID: <20260810160703.861885-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
neither IPCB nor IP6CB has been initialized when nft_reject_inet passes
a packet to nf_send_unreach() or nf_send_unreach6(). skb->cb can
therefore retain metadata from an earlier protocol layer.

For IPv4, icmp_send() treats IPCB(skb)->opt as parsed IPv4 options.
Stale option offsets can make __ip_options_echo() copy an
attacker-controlled length into its 40-byte reply option buffer and
overflow the stack. On an unpatched v7.2-rc5 kernel, the IPv4
reproducer produced:

  BUG: KASAN: stack-out-of-bounds in __ip_options_echo()
  Write of size 255

For IPv6, icmpv6_send() consumes IP6CB(skb) as parsed IPv6 metadata. It
always uses iif for source selection and, when MIP6 is enabled, uses
dsthao as an extension-header offset. These fields must not be stale.

For NF_INET_INGRESS, clear the address-family-specific control block
and restore its input interface before constructing the ICMP error.
This matches the initialization normally performed by ip_rcv_core()
and ip6_rcv_core().

Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
---
Changes in v2:
- Initialize IP6CB in nf_send_unreach6() for inet ingress.
- Preserve the IPv6 input interface before constructing the reply dst.

v1: https://lore.kernel.org/netfilter-devel/20260804095105.715387-1-david.lee@trailofbits.com/

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Trail of Bits has an IPv4 reproducer for this bug that triggers the
KASAN stack-out-of-bounds write in __ip_options_echo() and can share it
if needed. A separate IPv6 test reaches nf_send_unreach6() from inet
ingress and confirms that an ICMPv6 unreachable is constructed.

 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4626dc46808f..4933f65138d6 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -355,6 +355,12 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
+	/* Inet ingress runs before IPv4 initializes IPCB. */
+	if (hook == NF_INET_INGRESS) {
+		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
+		IPCB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (skb_csum_unnecessary(skb_in) ||
 	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ef5b7e85cffa..c36910b8a95a 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -9,6 +9,7 @@
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
 #include <net/netfilter/ipv6/nf_reject.h>
+#include <net/dst_metadata.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 
@@ -440,6 +441,14 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	/* Inet ingress runs before IPv6 initializes IP6CB. */
+	if (hooknum == NF_INET_INGRESS) {
+		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
+		IP6CB(skb_in)->iif = skb_valid_dst(skb_in) ?
+				     ip6_dst_idev(skb_dst(skb_in))->dev->ifindex :
+				     skb_in->dev->ifindex;
+	}
+
 	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
-- 
2.53.0
