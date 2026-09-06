Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DD03AA4F2
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788704422; cv=none; b=adjrNM0VMccL9aieuyy74++HC/EHtrawwObKIVxruUqPyUQNtsNdiam8P9tJGPwmXDF0SwnDnr7bgjZKBGrf5qYYD6xs+xP0Bllvn657dYYZtaukwW7i8Be7vyOF1NwSXmAsq0ASLpcfPsMpGUQnHbNvZ/G1IAysMAnfZHIo8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788704422; c=relaxed/simple;
	bh=8YKa5Bqth0IIk+EC3d0YaMMCxQVa+lDu0NS9FLv723k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I3z5s3cU/wEMcREI1yeevbCrYmvoYvPSS5fLw1ItelB3lRTL0NbLWDV6MkZt05m6Pdodr/4Ts/JbtTfvBXeKLjQtTjsFEZOG67Oc+Hs5DuoBvv8pQauyc1hMOLGYoFfYflGDVgLD6atVjuMaWYfjo7Fm+GTE+GOSPgatf7+E8nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=wwSbD2+O; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="wwSbD2+O"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c263110a8cdso107576266b.3
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 07:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788704419; x=1789309219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=81ted4pMTbnzF3OTQRL5I6LA+qBpd0cXl1PuT1/p3yM=;
        b=wwSbD2+OszJtm9MadMRj4FnaZrp2TjoAKobDy6BkPkgX9bM9M1PiotVAU6BKKCx+2E
         YPSxxv1/T1v8WijOpqllPTxVWqvZcKSIjSinNTyRgWaQdI/+YT9gE4+cLPsMHGjSxNpT
         c9OoKR2KuChKnb1zFhgBCWauvaUDUAThu/3i88YnAKd2mHPHJPM5eekxunnZ1qwlyhM7
         U8Whdvv8z0V8ypgb+QYImOpb/SofUv+V5QEjL0EZMNm/V04S2r1EpHcsXBXuw56CZ4Kn
         /tRfRKmrKZ7SLLOh5NlKb1jkbe092LtGeNojpFNpj7tuD+QlSDzk4jlRmKj3sTg3DsQr
         A+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788704419; x=1789309219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=81ted4pMTbnzF3OTQRL5I6LA+qBpd0cXl1PuT1/p3yM=;
        b=Mb/deE7U891RYLUJt3NFVl44YkRJJFHADxjfPkez8OLg4diuaRuwukVZcVwIMfpMxo
         wsIbIc35glew7/m0IHAP4yYiFdgZbOU+W6gZ9qYWd9AOE4GloghyWXh69xCuZOHyIYbh
         T4QsjC20npUqY9KZu5WJDgyATNNTtUR+XwCjIfRn5wtb6kU6n20UVA/v3k+QFrbdLFjk
         RZmjRrN5VnAvajVLjx1Wd3GJninjJmY5Us+YkQ0sR4LbCSwpncVq8i9XauM5NyUdAgTG
         Rn6hPaEFZ6hPwaJLhz7x3W0gWxgv/WxDymaYDWlSPF13SvMoWnuTnvKE/TWbYfT4OVRP
         d/1A==
X-Gm-Message-State: AFuF++nvEtsaWeu13y5j0RddUXuLNNrhF3o8Vj93VO0y15PrYvpolxfI
	LjSI4HI0jRUHirJMs8mwVZZaTfX7Y6xrI2snStlk3uWH+UHt5G9l/ReKYSmiUD7whOmH7n5RsVm
	FKxlcLYGalvc=
X-Gm-Gg: AYBFou1GNDLmavOY1DecPzW94YvvzEv53CbQNAA805vO75lbTtv69+sYcT/Fxfo4Qep
	qBBsfRtZC4OaOSxDyRK5j7hVmgHwOc3JQDx9pmY2Czzec0YdvKboNW7qG0UEMN9Nkpf4cQT0moP
	oPNpOZMSW+Y5w3R694RVuThvVvEWtuBJnU/Z4dZPPBemSQT1xHoLOYipOCA73da2hAlZuqH1W10
	NaQW86KgpZbmOzn+PWTwRIeeFj8Q+K3bLZhJKAnqREXKdXLVRkRDr7GBxB0qMCRagtFz5naBcuG
	K3dcGeBPAlW3whR7Vy8BV2kUISL7p3kx1NL0dHBIaC9FqrwFFs2yv4M8ItUNzxijcYF2Ta4DxX0
	bYXkpySDqhaLlpASQP3sdy4hx8jCRpetVimlNiaklpZrl4uXseHS/JhP1SB1xihH/lwrH+FqN3P
	A/lug3vfTQSZmVVXFWEsxw+hCS1JycuEex1ENnB6IdkdOfxvrUg3J2OrQKZw9TyS9TfmpuG0TuT
	UfeRcbgeztKmpWhqwH2evc7uW/awGwAfyVtrIejKy4Q1Z2WWDKYTyMCAKpRRixoAspucjkRCz8A
	onr/oUVakCQQKLC8dqLLXIH018j83v3A3/jgn/Sga8CHZ1wJb/wL3CqAO9aIeNorPUnoBgIxYe1
	5LLcHfz6hAq6g7Wf6FUrMSRPwNpnNIaNN8ICNJYHIprDZHRLKC0pf2GjEgwIyJflKfa0AR12UDC
	4J7sJsug==
X-Received: by 2002:a17:906:7949:b0:c26:19e3:e989 with SMTP id a640c23a62f3a-c2619e3ef5emr537106066b.41.1788704419230;
        Sun, 06 Sep 2026 07:20:19 -0700 (PDT)
Received: from Desktop.fritz.box ([207.22.59.122])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d581f51sm354248266b.42.2026.09.06.07.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:20:18 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: advertise the vlan match in used_keys
Date: Sun,  6 Sep 2026 16:20:18 +0200
Message-ID: <20260906142018.480577-1-julius@bairaktaris.de>
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

