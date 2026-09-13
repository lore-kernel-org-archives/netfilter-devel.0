Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E831F3CB2FD
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789296177; cv=none; b=D+e3Gh0F35zJKAbVR0uhLVXGBj13AWbotNFi3g7GgDvlsjfZBaGjAvxtnKCoZLskzGehZay2eoEyTExFojTSRcUNBjQNEsaoXu01NdSdzZpVzV+4avJz+fWhdvVKqxp2rkXPXpg0pyhcl3n90kminLiOPppJn3I5NkPU0QpYTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789296177; c=relaxed/simple;
	bh=lGehwXEZtaMbMKO1wW9AcdFWi7zSdBA53XIp6hr2YUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Voi0YjL47Wnbl8psmuLEyc1v3lXfEqGIKcCNcG9aldpNH3ydYXl1zBHbIllWMLjAWhiN9HnCzsLCsd9N76KEof7Hb1WuMMf69ZcSskiqS6ZPURV/0Ec8rZBBmoQdis9UAjWzVjQ8CZ9dwhubQhqoOP6zhwDLZM1HecRV/QOAUjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=V7OmJA65; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="V7OmJA65"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663c2so176999266b.3
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 03:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789296174; x=1789900974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Had5sqsucFv7bjWsA15L5n3iBC86r5TDHnTj1IfvOg=;
        b=V7OmJA65N4WoqL5fDkzqKn66IkHweoi+1vJPhOHVPAI+5ufxI/3zDIATp0hwwaGnfH
         agQwaDUWclunTmC2fDWbImhTZTfGXMbsfdU9nnpvtw+NrxGzDXFUIrYyfS1le2h4nftJ
         ZCSY6eJ3s+EVu9VKpTdCEXoYcFBwOuv6WBOtD0PBSRNpBob+OVpcfnyIhro+G3Lkl1R4
         niZ0WrG0Xcx/qi7y93V7gB0Fv3dwSbW+5cbciza0LEAZBMOgMHYHL66flpVS9lYUwrBR
         xGqnKxylnUt9D7155W3Q9RIY8wS0V91dFHxsC3wXSHUiflHLTB97zZVwwRpF4NjInxui
         1fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789296174; x=1789900974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Had5sqsucFv7bjWsA15L5n3iBC86r5TDHnTj1IfvOg=;
        b=jwsqQEdzW+/i9V9X2JWVeRfMAbEuH6IT/D1LcLhnO0uKQjr5JI+4e4heK+OZpCNA6k
         S34kPVeZNkPC30RoGQ+/JbUQUIkGKYd60ZuhFLo5MJdEhHvDjHkO53xlnWnG+1eXz3uZ
         A64RJlL/+WiG0NZ+4z2uTScVUCRZ/szmY9a0sqgtlfMWNUH7XX7gwjFzrqOtbIni1NVH
         2JsF3EtrtM3qpbWeSZHKwP/Lg5RBrSHjfNThCPeVrD4XwqlpTnfr7Ji1zdskxGlE5se8
         XxhMKS98sCjvlLMdeaDR2YaK41g3QMHxNe3UbGiK58qyn0wMWlSd2g3bmwG4wB6Ngyfy
         k8Hw==
X-Gm-Message-State: AFuF++laIdmtnf/jN3wdFALABj1z7U5aMXyNj59fzdvsr8gEp3iXVA6F
	OU1CQW8rwhmIYIqDgrcx4re0J1Rk4YjjgQzHxZXjAu4VC3g/ChUAApd9ob+4KZZOM8ptMbA0a2b
	RiRVVNR8iJc2zmQ==
X-Gm-Gg: AYBFou2heQRxolBnKp7ppCgFsSsJpctPBFHrYPhS0miXZpoYaD99TlogaS0GrS5/FD9
	iznHvfzq4hl6jU8/wplK2VTKYLtL/GqPtUkTgtvbNzYi/NmDHgzviyoou2M87kmoN6KlgFqq2EZ
	v+KZhSzX8G+8kwX0IxB6UF/r8uFJHQMA7WGMBmVazgropHqhLR41AbkERoU3zaSZkvgu7cT8Ejb
	WWMrWLSsi1GkvPf3oEXj782pDRnCIzSsiBkpf3AhBSn2G1wZoUf6o4VQhNCqR/YoCqsOTdE5DQQ
	kqxEP0SBr8XjNSnLInB1flJaiOMZkxwP0e7wmP0egbqRyqrudjXciNt8/EBCCEFunEqIwvYAQEn
	EquBHU0dEBkwNMRffJBRasxKV3E1FCq7GpDZwPZ+o5UW36rDFbnFKwDxi12r0BRHTepXA7Oktja
	Y7i6oXxZyxFP/zYK/+BgGiFnSR49QPUBJesCNWCDJB7bhDdmWqKicV8IzA0Q4HS3Xw8zya0F/gu
	sU2A2cKK0ifAM9QPKjhY3phAr6hoL4WBzU/W5YV3qhqyWU0AUfl8eTvSHCLJw7fyQ1JU/JKveIO
	8p+eFkMPkf5UFYbs2aNT76szlQb7voS/1pQf/KD0yVzM/1OGgdcakvJCjdfEunBf4lA9X31ZBlr
	NnXTSuZFbFvrnCRbl4f4bgQ/F33IiHdaOoO0dT5jZ5yRygvGPPpdUZHD6yjFRF7UdwS7F/b6Y3M
	kQfsSgpNl3FtU5bY9fTnPSG8MhB7IxATxssQ==
X-Received: by 2002:a17:907:3e07:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c2966694b2emr1062643666b.11.1789296174284;
        Sun, 13 Sep 2026 03:42:54 -0700 (PDT)
Received: from Desktop (p54aff833.dip0.t-ipconnect.de. [84.175.248.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296605b438sm278678266b.26.2026.09.13.03.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 03:42:53 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	wenxu@ucloud.cn,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Subject: [PATCH nf v2 2/2] netfilter: flowtable: advertise the vlan match in used_keys
Date: Sun, 13 Sep 2026 12:42:51 +0200
Message-ID: <20260913104251.648421-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913104251.648421-1-julius@bairaktaris.de>
References: <20260906141947.480524-1-julius@bairaktaris.de>
 <20260913104251.648421-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_rule_match() fills the vlan and cvlan keys and sets their
dissector offsets, but leaves their bits clear in used_keys.
flow_rule_match_key() reads used_keys, so no driver sees the vlan
match.

mlx5e consumes flowtable rules through mlx5e_rep_setup_ft_cb() and
__parse_cls_flower(). With the vlan key undeclared and a filter device
that is not a vlan device, the parser sets cvlan_tag in the match
criteria with a zero value, an untagged-only match that the tagged
frames of the flow never hit.

Set the bits where the keys are filled.

Fixes: 3e1b0c168f6c ("netfilter: flowtable: add vlan match offload support")
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/netfilter/nf_flow_table_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 19adc6c7725f..c50bbb1411d5 100644
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
 		} else if (tuple->in_vlan_ingress & BIT(0)) {
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

