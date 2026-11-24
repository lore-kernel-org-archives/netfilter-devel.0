Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510367;
	b=S+cZOjkYXgUKfjDTqIyagbK0/e0T9nVKcLpYRUHcTFemUx2iWwCRDeCloImYuvgeyKEV
	 e6tKR9gv8P67y/Sl3cohCfrzma4CYM/qwBbcdKEZx0jFMDpC/shU+zV3AOS9TF+V0s0Ds
	 p9Y0MOuS5DJvOjoKYy0lr4pmtvetVq9zJ5ZasUb9Mjkg21Ws4Pfpe5SR2WK5sSudVVZug
	 ot00SwbfJ0V1PK0LWhV7kZs5ISAEw/mlrp2nW6lh25+b6ilh5m9eNnO1yf65asrmmp+wh
	 8+xj13R7DHHgkK65/TG/CjvL8gqj3QIbJnBZqO9zW5RK26QIpeDqJJdbqSPoWVOdQfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TR53zPkVba88VfL7TptIVzoMfVRdSeP+zd0R3S3Wgso=;
	b=5HDlOPVDSCVTE5/CmypxUn5vjKtaVxtjWUMxm4LfYTzhIcehN/8NsldzR+7ftyfL1+MQ
	 u5FmCbpjNZk7SSlkfpgxKEiv3cb3Jv8q3GeJhoNd7rD7mvy6zIlyCuKI5A+47ddEBPDG9
	 jj6nCzSlCj+JCiUa+DTP/N7cGErQ/FzFq75q1FIq6n/cLzVF7skosdjJEBnyJ300plmOm
	 h103sMZNtoMkYmnyeqa8pde9Qyr5jabbZp26f3vP8wxtBtz7FAe7BsZTQu5zCz8+VO1s1
	 7SszsMTGfvjp4SpMOTq16fmbXM2CQHYeifLTsh3dSyv3BuOPLch9QENyt4ju5k54jTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uX79fbci;
	arc=none smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D74606A338
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 08:52:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D74606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uX79fbci
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so2635336e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 00:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795510365; x=1796115165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TR53zPkVba88VfL7TptIVzoMfVRdSeP+zd0R3S3Wgso=;
        b=uX79fbcioXcn+HG0sN8Id1Ql5mLaTWW7HjbIPCjEaGDwu39hMqQK2b04NGjw1LxZBL
         er8gkOQTqKf41KfD76JzTiyjxtw+v/1vnxHVjxj5xaeSd/PYlkcFExlDpNoUPhugYqHD
         Hu8gtZOXNTT47VIgSCEoSdlAVqFiHIc1r7nV7sjOW21WqLhJoffxqDF63kXI4UFmUXn4
         CZImKjDDhH7Nlotyu4w66d8E5RLauqnpIfpV7dtLEswiEnwg0Dv9z+9hlyMQtdT8w2JE
         2mu7mwUPFAokUfhYhNCnjD+aaV+3cx9v9C6TJJx2jeG5/V4E7wLoCiGQskV3XVU8ws5i
         QQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510365; x=1796115165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TR53zPkVba88VfL7TptIVzoMfVRdSeP+zd0R3S3Wgso=;
        b=bwddX85DRbz7SyVMvh0IZ+IOfpltrZ3iMtxa4vQ4maIrMYsi/yE9N+UOLtfrXIr9lH
         Pbt/wV6/+rCsrKdMfClQsIzWNe2kBTZT+YrsvZ9gPM3exz4imaJbo1kJoLMNwOnMQKK9
         ivR4Q9WidFq3KMqOblF+bcxmStQbZU+y8PgNt152wjHE7FGWfstuC8pUEy/i0NZeSUxK
         1f25DAh6ixRMTY+uDdWmLVbdqa7lihwNCr5UTY3mLNQSa7CFbyEGMco+rBppC2Q+FyvW
         0qqHN1ojD0AyWM1ApK0bbkafWG0n53kXQXhoh60hLSbF0J7FQhQwDQVfW+pSpOSixezf
         1Oig==
X-Forwarded-Encrypted: i=1; AL+hErGMmDPLqkB+odJNSe4HiYk1P4TY/aSQ5/OSGAXfC5mSjwDPMMk9Ywx0gPgiKaHYZyRdR2OgB+gxS0EfDUf4hbM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/D3YfRiHu7+ExYiyp+ABamWl/xEjY8TglBOROUcOzPX6Yy80AQ
	K3KCOIQhGNoMwn8yklP4GrUaT4oC0FWDAhE0W2dixGTvx/M6XQSUTDPv
X-Gm-Gg: AZFdTZeMM7gjqIP1vJyAYCc3/eErznbgAqJcS0Q9EnVcYl0QzeyKIfOx4FWlayvlsVS
	tavVRYP07dnvwVlE84if6/1LJjDQuTJ+2qQNA6bOsNHD4uehntRwiBOcz0nEcwo09OiXkaO+1qo
	zZl1NXGSjaChaRZBh/NBlCyR/lPXZ6POwf7JK0myhK/MQ133Yyxk7sL2ckRHMdPtLWtToPKk3OF
	CJ6hOE7Fa7Z1tD4WqRuwMWt9zDQqR3NA715JzTsDaVZbiv14wRQBPlnYjkG0aEzf3ygmrXTXhpG
	R7vXOWKrpnOzBGoAat1QwUj7S8BU4JaCpgUJG/xved0f6trTCzaXAjFtPKBskkKeD+8p7k/MQfw
	gD7WpuSf3AmRRUW/bFIdB2grJ9aMhZBK5vSLliZ/kuL77csihhkCAxAkMDOxB3p1QRNDEkZ1qkI
	LhhjMvRprMcvGIYjiSR0jD94X162Sa6McRuaYfknBLabRdZSVcNMsSjuHQh4zqQhrP8/V1ZwDBP
	dqO7PGZcd7baT/T3KgYuMjfHbR/QpxEji8SfmeUwYqvz+vxcB5BG5nGGVbex1GCJaIClEFagk0u
	RmvtjnataesC+fbofNk/djaSJAoxWX8wO2UeXVOmOgKVgcXvDvue0IU=
X-Received: by 2002:a05:6512:3e04:b0:5c1:5169:7d96 with SMTP id 2adb3069b0e04-5c1bc7bcc2fmr4609413e87.18.1795510364703;
        Tue, 24 Nov 2026 00:52:44 -0800 (PST)
Received: from theodors-laptop.dotcomltd.ru ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bcf33576sm3575596e87.6.2026.11.24.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 00:52:44 -0800 (PST)
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
Subject: [PATCH nf v6] ipvs: ftp: do not link expectations to unconfirmed conntracks
Date: Tue, 24 Nov 2026 11:52:39 +0300
Message-Id: <20261124085239.62750-1-theodorlarionov@gmail.com>
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
the seqadj extension. This makes the conntrack check before the mangling
redundant, so remove it.

Fixes: b25adce16064 ("ipvs: correct usage/allocation of seqadj ext in ipvs")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
v6: remove the conntrack check before the mangling and the 'mangled'
variable, and unindent that block.
v5: drop the second nf_ct_get().
v4: check the conntrack at the start of ip_vs_ftp_out(). A server reply
that fails the check is now dropped even when it is not a PASV/EPSV
response. Without a conntrack, e.g. with a notrack rule, only PASV/EPSV
replies were dropped before.
Link to v5: https://lore.kernel.org/netfilter-devel/20261118151726.2509853-1-theodorlarionov@gmail.com/
Link to v4: https://lore.kernel.org/netfilter-devel/20261117123944.270667-1-theodorlarionov@gmail.com/

 net/netfilter/ipvs/ip_vs_ftp.c | 45 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 44de99f4d187..c90f7a9e1452 100644
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
@@ -382,29 +389,21 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	}
 	buf_len = strlen(buf);
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && !nf_ct_is_template(ct)) {
-		bool mangled;
-
-		/* If mangling fails this function will return 0
-		 * which will cause the packet to be dropped.
-		 * Mangling can only fail under memory pressure,
-		 * hopefully it will succeed on the retransmitted
-		 * packet.
-		 */
-		mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
-						   ipvsh->len,
-						   start - data,
-						   end - start,
-						   buf, buf_len);
-		if (mangled) {
-			ip_vs_nfct_expect_related(skb, ct, n_cp,
-						  ipvsh->protocol, 0, 0);
-			if (skb->ip_summed == CHECKSUM_COMPLETE)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-			/* csum is updated */
-			ret = 1;
-		}
+	/* If mangling fails this function will return 0
+	 * which will cause the packet to be dropped.
+	 * Mangling can only fail under memory pressure,
+	 * hopefully it will succeed on the retransmitted
+	 * packet.
+	 */
+	if (nf_nat_mangle_tcp_packet(skb, ct, ctinfo, ipvsh->len,
+				     start - data, end - start,
+				     buf, buf_len)) {
+		ip_vs_nfct_expect_related(skb, ct, n_cp,
+					  ipvsh->protocol, 0, 0);
+		if (skb->ip_summed == CHECKSUM_COMPLETE)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		/* csum is updated */
+		ret = 1;
 	}
 
 	/* Not setting 'diff' is intentional, otherwise the sequence
-- 
2.34.1

