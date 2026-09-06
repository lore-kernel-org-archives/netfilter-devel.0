Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA283D8105
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788704393; cv=none; b=EoM2RFlquOlYA+DpsZLcOmp2ohTTlzMFLB6S3fr+7ICoBZ1l4EZct6ngulBFnPwF10AyIy3FbRhWwozceTBhvYRp+nAN0r3ue8cOW4U2HDTVG42LDEGDjuVibfIu/D2Xe0eAM49pxp0vAuZn3SMW9+xq+YabSZYeT0RJm7i1Iss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788704393; c=relaxed/simple;
	bh=8YKa5Bqth0IIk+EC3d0YaMMCxQVa+lDu0NS9FLv723k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qRHocsGy01l5X1aDgZ5TVcdLSliLApmDKplGGBIlCejVPCjW0rEnw0pBfV6shUO3uEoQHEO70CeKtGe04cgmZzgqSZ3Oo6bt1n+UzUl1mDV5ToPcgRmcchYK7HAtxEI7ha3siOjJH9jNKJnwPOgkyC8zLOqOR2BJSC7xyOF8dqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=zZzt/5rw; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="zZzt/5rw"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so250736666b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 07:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788704390; x=1789309190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=81ted4pMTbnzF3OTQRL5I6LA+qBpd0cXl1PuT1/p3yM=;
        b=zZzt/5rwn3tAl0SbaPAQ3Zs4YsFqv83NMIHDkN5rjYziUXdCrPiNeNU4h5f3zFRZuj
         hieUqRJyLABv6HoOguO9ioRnSRHquVbbBrg/L5TvLlncg9aN7P3aRUp2NVBtXnq5VORp
         M+CO5HaaMY1IenKQJRxks1bjqzm6sjbNjatA6EDdmoGGaWOmlR7cTjLfVm+luhGG64T1
         RV10lEySx9Qi7+97GGZYu8kNO7olOj7HXsn1kXEEOAhGG+1ywnoYhe8KQxiUNo6uDhtR
         bePAIo1Xeho9bsQ/H4hYHVms+kW2s8PqNRskVSw3weAnmAPYu0SDhKw0jDSucF5vQKaA
         OlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788704390; x=1789309190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=81ted4pMTbnzF3OTQRL5I6LA+qBpd0cXl1PuT1/p3yM=;
        b=Uy54/u3m9uG0VD5wd6m8IhDoIgYOz7JOzergOxbyH1D8ZshgdIQKbAzJsgMyi8RYp3
         NoFPOtyXVgr6t+hsdpjjh5UIR+KtZZ5wD8BVZNtGEhCzXWAEOiAlaQc9QOm6rJtetQsd
         wbim4dDvdwGSk6IkKOsQb0AKxuCh9jCIR4QAxqlkGZfKJnTaLenPHPn6yKEwWkso8GdY
         QvrkIp+3BHhVxgqnn/qUQqSme1p8W/ZscD0BPDAsujfTwJkr3G6rwDWRVvGL7xQevesx
         C2RTR5heiEp6+7Xgf06FWz7mVLUpGBcTNG+KvM+4Rzl1g7EgcOohmuzCrr1aaFux8w+7
         2QPQ==
X-Gm-Message-State: AFuF++lgmRMZNw4auNtcnhpWxdHN4BvVut2JH4ZlYFFQykYRPMv1GymV
	F7tusYuhomX/9yX9fQ1WFwcBljHQs+YCG/efcrgmO13PVYCiyLi94xn6/8rz5R8ERx4kZqmx4wv
	8k35egW0Tftw=
X-Gm-Gg: AYBFou17BaXbYUM/ANmfijZoUWAQQZbp8QH2RXPSX2x/s2piV1PS0BHAx5AiXsBot/f
	zDjIFMk9InR81pteqJERc/7t4arYY2aWStHou/MEz2o3F+qMi6HMjm9qqSUXaAhYxPrzJ8wy63v
	fZRi31LgNZ8FtnReO7S0NIxBQiifmt3229/6L3F+W+pIxWqq22HLS1snX6vQFtKQdFYamkZsnC2
	eG3k3McRthrOmTSqU4TR3c9PYDRFIfHhckhaED21myW+5h4UF0bqd4DpGctj+1kOndPrxXGt+TY
	4v5Snv56/Gefvs+PTOQ17Kzchwlg85DBL3gjXCuap2k0iSOgIWxTZEvxF/KXfcphaSTJBpmyr5c
	GBZ2zjUpJ/tmtnAovTNu2ULBy0l9+2gldSutyaM8Eup/DeKGZaUZcyLT/8maeMZU4U5keXl50C5
	Y8OPu/7BAxC9Ok9kxstcrftpBNvf6ZwlwNQOtsUcr4BT/U0RGAr+HcSNV6Rq1zlvqjqjvj2WnFK
	AGZ0BARZATCBgJKSfIYY8bqkDEcTf52fk+XEZuWeYMwBrem+5GlAnHxZurRh0xv4QXN9rqapKNg
	Uw3I8wV+c/a4HxnIaZYnxjfmmdHv1iGJZ4tPU7/vMCxZ5JHsTEFCEgXeg3rVDF4t5tmSqFZqkg+
	MeQ4xZxYHN/woYUa6KKd6u+SWp3zjIELquV2kxSp+aXY4Wa0Nf3HipOrBlshQW5Ri4ffohzo=
X-Received: by 2002:a17:906:f591:b0:c20:f529:2d6a with SMTP id a640c23a62f3a-c260ca339fdmr622399366b.22.1788704390262;
        Sun, 06 Sep 2026 07:19:50 -0700 (PDT)
Received: from Desktop.fritz.box ([207.22.59.122])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5b284bsm342888466b.51.2026.09.06.07.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:19:49 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: advertise the vlan match in used_keys
Date: Sun,  6 Sep 2026 16:19:47 +0200
Message-ID: <20260906141947.480524-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_rule_match() fills the vlan and cvlan keys and sets their
dissector offsets, but does not set their bits in used_keys. That bit
is how a driver learns that a rule has the key: flow_rule_match_key()
reads used_keys, and a key the rule does not declare cannot be read.
So no driver sees the vlan match, although the rule carries the vlan
pop action built from the same encapsulation. mtk_ppe_offload.c reads
the ingress vlan through flow_rule_match_key() and so never gets it,
and a driver that checks used_keys against the keys it supports
installs an entry that ignores the tag.

Set the bits where the keys are filled, like the other keys in this
function.

Fixes: 3e1b0c168f6c ("netfilter: flowtable: add vlan match offload support")
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/netfilter/nf_flow_table_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..9ef89127bf25 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -126,6 +126,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
 					tuple->encap[0].id,
 					tuple->encap[0].proto);
+		match->dissector.used_keys |= BIT_ULL(FLOW_DISSECTOR_KEY_VLAN);
 		vlan_encap = true;
 	}
 
@@ -137,12 +138,16 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
 						tuple->encap[1].id,
 						tuple->encap[1].proto);
+			match->dissector.used_keys |=
+				BIT_ULL(FLOW_DISSECTOR_KEY_CVLAN);
 		} else {
 			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
 					  vlan);
 			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
 						tuple->encap[1].id,
 						tuple->encap[1].proto);
+			match->dissector.used_keys |=
+				BIT_ULL(FLOW_DISSECTOR_KEY_VLAN);
 		}
 	}
 
-- 
2.53.0

