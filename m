Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015063;
	b=vPANIaE2xo20Jx2hjpA0LNZ0WW0BgTRdNVPCySjfhJ2cS9Qn8B9+mGGkD5Y3lgQoqyIZ
	 eL7qlxKENqUtC1KzHIRwA66jxXKu2O8VFSpYlnSbZphH/1ndSb5lIkNLS3BO2q7RCXaew
	 JDf9hknvXKUvzJrhGx2dF5K5VTmOLF57lfcSvWmeh/tM0pwVnJOgBdINcAYPDDTS86zIu
	 NkdZP4AgEcqccuCj1Cv0JewEMt3fXrshl6pOkosNqEWslbh1PHwAODocC0TrQIpuIsdqR
	 FUx0E8nenJejuGXGzOPErj5pgQtrcFf2dA0oYmhnqGRwrgUmrYQwPEZS7nT9/71cTVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015063;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CvfmLkDBN8I5nxmJLaVmq3PqMym7xUmGtMx0tuqzeb8=;
	b=mm5cR3mt4cKftAVlb8ppX/yzPuQDUvCUbu2nfQEGhKBEgF2JFpgQcsTmi7t7lmmRfFeF
	 WXyYC7z7szIJkmixJl9wh3bhZJgR5k/w/lrZvu4yG7AOTlE0FwpNKKPAKbkMcr9l19JBU
	 O1Q2zM/yrFnx/4WFmRQ7m/Wv/MVoaX3fB3SL60k/hXGFofB7pwxdOAQ1vmrxh3Fs3Q67o
	 jx6sZunHCNlBNbCEuYsTc++zTTY9fPXSPG5mqvTDnvw+ehzh5kr38PPf+aWV8pTpB4ewC
	 x1TIjefoso2BT8IP0ppXfl0Y2bRJOSoRi8fpu0+uecM22FKSfr8t4hPXCt4yqtx+/Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WkxoNCmH;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C75F606A335
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 15:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C75F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WkxoNCmH
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c5067a2411bso158979166b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 07:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795015062; x=1795619862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CvfmLkDBN8I5nxmJLaVmq3PqMym7xUmGtMx0tuqzeb8=;
        b=WkxoNCmHgt1cV07ODAtkzGUMS3QEMg/pCYKSsi7za96v7vCk70HO1zqPcE+MRzXRE8
         3Ug+iZhmPZawGyCXpg5TaA9LDGM+5cwSQlDPvnZAS96WzWkFIuLV7BO2ijuec4pvTQaO
         jhvx1sf59NiMJ23lRpkoDMvQaNjUNNKWTMm39AMZmGrJcYc4rRpQTohXAFM9uMAlIPVa
         yEEIp/WRsoOJgDL1T2bqbtafeyS/7mB8YOYKV3gx2K3sKVE7JFUEo8AEMHtpIBEcy6lu
         pNNCyqBz+rDVZmvcdXLNAK42YxSJcqZkrDf+iIldG59pYVnhkSNZobaVYgcPOQZjVa4t
         qIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015062; x=1795619862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CvfmLkDBN8I5nxmJLaVmq3PqMym7xUmGtMx0tuqzeb8=;
        b=JpLMK3NRyshbA8e9DcCU5fZMCSFdSxsKQTQBVgjXjWqWv3E3qc56t2Q73FpBOAPGP0
         S1ybiqIa3K1cwwM/TusLNHh1WQeIeWz5T+OyDVO6r+3uajKyySZJkZ/1U97JoeKfLSPY
         kiRJnlQbY+tvQBZir5VpZcDyyb1Gysb+8XeBw7nF9ioZzzu8cwDI68p6vvhJ7jROcDfe
         Zue7IW3KJclDav4+xS2wfaLAdmv6LLrJ1htxhlaJ1YPhZiDRWhiIA9abW7RM3MQDLcjy
         3e8UbP/HZd8zpcOlt+qzPHE1XBfsL0f35R0xITC2CPEDNRhgJVkILn4L4IOuKmVjBwFD
         7i3A==
X-Forwarded-Encrypted: i=1; AL+hErGYpHPL4egq0HR3cIqzyFXw7Xd7p6o3JCuvXQxgV2ND8iMVqZDMewqGfBSjp06XIG/XGkKpvUkG4d666yWDclw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4VVLno7nTOMNK+zggoJv/TZNOT9qZJnVD5a+v7gUOjZ609Jxp
	Wa6Gl/8VK2glyjIqr1rnbT4vpZg4dtV6jgO/VYn6iPPjmP53xluVO4P6
X-Gm-Gg: AYBFou05STrR0pnVvMpnSAuhPJqy1NUVI+/c/FrAEj+sw8IAxDET6LsIvVUTotjIslT
	GdaIgF48B/fhQtGH7PbEbS+KxQOheLYWQoOY33Gh5K1tLK6rGsUgSwwRcCcrqYfZSit/BEiPDa4
	taoiL1hdnQz/Z+WW+XC7Nt22vovDhLX/V/sZhOe0tpDfo8qB+lCSXbLyZX/Bdde12LftLnowHZy
	+LZ+GEVOrkZlxBfpipRsc0skkhC7iG5R4HDUOqYTBy7birZMwjEiW6Rb3ZUH4uI644stJ+/D5Fo
	1VQRl7woQiN8vhwoz3tOz3Byfyc20M2kQFc4zWCgjUE0RWEMTVuTd1xnJl0NqBmgnEY6RW/5XeP
	5d8QeM3CnTjym7UKO9GpftWxu4xX2W0DzrqGhLQmPQCmOn0mg0TCpfjYCpQN+newCmh9MeSXpCe
	Im1i3A2WrYrAHlRNAUebxhO2RXNY7FNJf7rewtJAg4O/hhKjo3Qh1OgqzRsR+2D7TPzpZErGrTX
	a3QU5wUDeOBTNzU9Hhpg8AT8WN0lkhwPqf8yX4zyrHGccsKNMTpIkSdQOxi+ZVoia816O/djYUU
	/t6HjI2142io37N6p1RvRpR0O8VGgGr+i4dHWhnn
X-Received: by 2002:a17:907:7f91:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c510e32a1a6mr291758866b.38.1795015061528;
        Wed, 18 Nov 2026 07:17:41 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b888ef94b0sm1226142a12.5.2026.11.18.07.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:17:41 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH nf v5] ipvs: ftp: do not link expectations to unconfirmed conntracks
Date: Wed, 18 Nov 2026 18:17:26 +0300
Message-Id: <20261118151726.2509853-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

ip_vs_ftp_out() can link an expectation to an unconfirmed conntrack. A
later extension add on the same packet, such as seqadj in
ip_vs_update_conntrack() or NAT, then reallocates ct->ext and leaves the
expectation pointing into the freed area:

  BUG: KASAN: slab-use-after-free in nf_ct_unlink_expect_report+0x490/0x4c0
  Write of size 8 at addr ffff888004dd4e48 by task syz.2.17/649

Check the conntrack at the start of ip_vs_ftp_out() and drop the packet
unless the conntrack is confirmed, is not a template and already carries
the seqadj extension.

Fixes: b25adce16064 ("ipvs: correct usage/allocation of seqadj ext in ipvs")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
v5: drop the second nf_ct_get().
v4: check the conntrack at the start of ip_vs_ftp_out(). A server reply
that fails the check is now dropped even when it is not a PASV/EPSV
response. Without a conntrack, e.g. with a notrack rule, only PASV/EPSV
replies were dropped before.
Link to v4: https://lore.kernel.org/netfilter-devel/20261117123944.270667-1-theodorlarionov@gmail.com/

 net/netfilter/ipvs/ip_vs_ftp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 44de99f4d187..cf640cba0b12 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/gfp.h>
@@ -283,6 +284,12 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
 
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || !nf_ct_is_confirmed(ct) || nf_ct_is_template(ct))
+		return 0;
+	if (!nfct_seqadj(ct))
+		return 0;
+
 	/* Linear packets are much easier to deal with. */
 	if (skb_ensure_writable(skb, skb->len))
 		return 0;
@@ -382,7 +389,6 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	}
 	buf_len = strlen(buf);
 
-	ct = nf_ct_get(skb, &ctinfo);
 	if (ct && !nf_ct_is_template(ct)) {
 		bool mangled;
 
-- 
2.34.1

