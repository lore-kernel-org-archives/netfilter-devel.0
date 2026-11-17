Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794919199;
	b=z7/c+2m/EYGd5Q96nP7ggcOQMF+KxN4W4HspveeHGh0RviVxyBXC+/JpTrC4KfDorm1+
	 Fy/SFZ7CarNo2jtZI8nXwOmu5vzMgUjiOgY4uyd+fLIjjKG3oU0JtlJosD2Io6ZkXsybK
	 wjv6zUD3FeIf5tbPYpDRrBoSO/Pg4qkqAP2VZoNDlHewNzMSfqNgzcL1NuEhrXwInyXWp
	 HZTHF6AjlCqpWetF1/KKJ/nNelbZYXR5vMEakH+15Tl2sYJNGog67pDs05sMnd4EMUtIP
	 dQLS9mIjWumsJvjlmRqE3fXdL8iihFZ9vRW2v8iFF4z7Dv99sYEIZpCEYvbEwaRW5Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794919199;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KhOt0cRnKYV36pufkweOfchwWzEZ+liNrgU+2GDZ2tM=;
	b=XcB2DL46c9chWAHK8kndsxtqF2wX0cW14fXWuD1Rcy7xa3RG6/TOxUczLbyXryaZYkdj
	 ja3hjp4ly8lCmybJhgKZ40ci/uxeGlfbdLJgSypq8iVoxnv2Kl6ZrOYr0e8xwJwyH3gcu
	 j4fufHdeyB9+g0WKmY1OK1JboO9RHpCL7VmlAgXwNEwYgPNUakQCLAWmHO7HoTY3mThcG
	 ZwxReOkWfFxBZN4esEdTudB20jtpYC/DX/GY0rH0v+v/RlqKIi0awCr4Bz/MWBx2y6rpi
	 ANudmIOlVk0xZ0/l9mnS3s1t1VChydAilNqsY+WUbmqp3OD+kLrIvubGyogoYU+hLOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Z+o3y/xe";
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D3D60A382E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6D3D60A382E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z+o3y/xe
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c247f6687dcso802104866b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 04:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794919196; x=1795523996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KhOt0cRnKYV36pufkweOfchwWzEZ+liNrgU+2GDZ2tM=;
        b=Z+o3y/xeqrCWgUnciSXgqXTvKZXDUNgxhFOeohIWAz2lHSZDsIpFgtW92+/ECzkP4/
         tdGYlRJR8Bep+VubJLpJvM8Rrpm/tfnKbg/1PotIYPmy1H3kHUiAGeFaC9AKeZhzIbLA
         0OS04vBCxQnKt1BDrIxiMLppZIGYI9wfB0xtmH1K/7JFDLo0LIEx0k2/Hn1O6AXl8VsA
         aUR1ZhsuZzNLCcLOAL/zuqqCE2lrLISii7Usv9C0gOOedV5nm8LyBooafuWNGMl0V8Ss
         0foEh2ocfyd3GV3dDQm9jw9t/Jv9vFD3+SjlX3GIdKcamGZqG9kfozc20DII3fvaXGPW
         rmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794919196; x=1795523996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KhOt0cRnKYV36pufkweOfchwWzEZ+liNrgU+2GDZ2tM=;
        b=zZEw9uBFSTU+XfaLGMq5Hs2r3HPDzMu/ZLtY65QJZKzKDJQgrW9D6daLuNElvJF8VJ
         /fgsldVRR42roWmew5TtTb2t55HKipIDo1cqy/+Bpg0RTI1xGjHBDEhJeKEtrrc7FYlo
         AwOPhLGKJ74j8xs8cYUnizI6/02IKDVZQVZDb7b2nnRaYkIxUokxaf32w/M+G/3xM11w
         Y2yJg8icxPiYzP8MEU+Nym7CXjo2ZDzHRP+p7LHvxAmKB70yTq1G+Yv0EyXgQo39IIAT
         ipzWwlZPHwnz+aloXVJH88xG2oEP52UwqzzgwrUdb86EE9HQKw8aspQ5SPJoTBcvRUz5
         9OAQ==
X-Forwarded-Encrypted: i=1; AL+hErHjFap2eIAKhIqfK7Tjvz495w1UNHhTaWVGHFX6Vo1fPWwcwb3EnyX8OQLSpdUxcR3GvyO2vdWTwWV6L4h45sw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/peC2Ex6B2a9mda8Q3BQI7LWxnGUxiHedqXUmRT3NDos/R0K8a
	68hQGfqmH+ESUdjLBsWTOy2Xh4YRkBjbtdVo+lEooA2S7f+BREVDC734
X-Gm-Gg: AYBFou0nGQDtUZAWaeFRkjW7sEUXZIVlAxz5mYGM2YneXWCuPY/muXcCEKoXwoClNNS
	NXO1Xki3JgH59tRnZSOGtdbC9ADPsoeAAyXdptEYdx4BoOTd6MoHdxqxqdkA1iZw7RqbtqUmGTJ
	eeZej5mDFXksoPkSoPGgAwhJRhNVImp/sJo/y2E2j4hYOOPpbDed8RPDrp9GVU9c0+lndWeICZz
	5H5LQtQNz3qYDujOBUEGAqqfobxaZUeDbgOCVU9elvC6dhK5i42mMyKC1ZdWAyN75o1IfGhjSsW
	wJKz0Csat4ejVzR49OlSRCFI3YhNZKgM3NlOE4LOKzPSgaEgk7CszgjPOgN669O+eJ4XpGNNMFB
	20d44bW/Q8GvCV8Y0hWrjFxsRbGzDLr3REOVchpfJgYpkrmNXw2xdnYwafiAzKX8zAS9PuJajQp
	x1QXZNzrScOX0LnknR/q3vg+YLcgrLRhYXCOGbqhNYJ7r4l3hs/0xomVeTSl+ZsTYm4OwYY57vY
	fKE7FOG7xjNo0vFfQsmhtWBqxo0CFqaHLpU4yjOAnMwYYXpnb9IKL7bl0agQptjsJZu1AHnn1yh
	6cYxIbfCiXCZ11gT8Le3lET5Y8LI3O/Vh0BfFsFPmxh3LSi7O/UCIrM4Y8T2
X-Received: by 2002:a17:907:8e08:b0:c31:c767:ae0b with SMTP id a640c23a62f3a-c5095db2440mr1272747066b.0.1794919196151;
        Tue, 17 Nov 2026 04:39:56 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5c520sm532332666b.9.2026.11.17.04.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 04:39:55 -0800 (PST)
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
Subject: [PATCH nf v4] ipvs: ftp: do not link expectations to unconfirmed conntracks
Date: Tue, 17 Nov 2026 15:39:44 +0300
Message-Id: <20261117123944.270667-1-theodorlarionov@gmail.com>
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
unless the conntrack is confirmed, is not a template and has the seqadj
extension that ip_vs_update_conntrack() adds on the first packet.

Fixes: b25adce16064 ("ipvs: correct usage/allocation of seqadj ext in ipvs")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
v4: check the conntrack at the start of ip_vs_ftp_out(), as suggested
by Julian. A server reply that fails the check is now dropped even when
it is not a PASV/EPSV response. Without a conntrack, e.g. with a notrack
rule, only PASV/EPSV replies were dropped before.
v3: https://lore.kernel.org/netfilter-devel/20261116101506.98853-1-theodorlarionov@gmail.com/

 net/netfilter/ipvs/ip_vs_ftp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 44de99f4d187..216be082162f 100644
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
-- 
2.34.1

