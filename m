Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10563EB7FD
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776863913; cv=none; b=q6AiJwlNrnyZltsjHtwTZUzbTy6Mm4uWiRYQbQ4poyBD64Hgy5DsAY+FWIVlnhyY8lGzJ6mZGYHN0I/nQ0pcA++OZO160dDvNOY1cYN0izrPqIu6i0oxXJX3ggia/QCoga6DQMISkbw5rW19sIq3kosPhlvsCLDX2X7mcmHpIWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776863913; c=relaxed/simple;
	bh=5jbenMADlAqpYBWMxC7pJFvrPh4M8+gsA67VPoS2ODw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcnVDZo4puNhuvZ8dBmrbFZBChQiskj51vlTxfmt3nD27GyXQjJL3DBh+W1vFV0YgfeQ+rkdt4FpfC6Ocfz+q2fjdGQq7XwF7HMOAhIuLGhedrw4haBYAdY2zLzX4C+0LaLX0+emO5UqNz9bNP9Q+qz17LHvXURmoNL9/SYfFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+p42hpF; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+p42hpF"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a40b2d268bso4338996e87.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 06:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776863909; x=1777468709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/zLC7MnuJc3YojYoySVhz+I76pvi3WrY2XKk1rhbujU=;
        b=N+p42hpFZtU/NXQ0gf+vNq/y+aPnx5Af45IQg8ZN/6MACHXOtkYYBCK/nqQTDumjEK
         OBcx4ykPrCQWyBXx/8tpaLPQTGxf4sRwBTVB4Jr/fexwJwTYgSSrnLKSV0WZdeEMco1l
         RQNLSrtUCgooWTvx+GNCcFpphb1960ViD8/WiqZOmNwrPLZmrNU/VUK6e/GZmxlZcEcS
         unOHTFLhAzkU67CmZJMJiLfn2FUyrpXW6kU8aDYj9tGWvaDxjLFfd5DZ8Q4Nh09sgSH4
         DUTzlsO8ylpSG+LE/YEvFs5AB3km+2TZGrZW9uW8fZBSAP0rDvkLYXKilyF07Qo0lFRh
         0yYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776863909; x=1777468709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zLC7MnuJc3YojYoySVhz+I76pvi3WrY2XKk1rhbujU=;
        b=P8+jp0TpVOmMBI6AhUFFbqdW6fhdLc8Hr6JuiA9by63WrPhMMIQ0yTLz+8Xz+Z07qp
         qo+1iG7aVCVrUfqUGUMXzY0A5p5iSNn9gyOKB8k+rjLIRu8H72nBL3A9FN/QYttp18Vu
         WFbEt6bsFO31eoDe3VvQUflL88KzL9JCv5SUaM2EaWfHkKEQjQKrPJuy6uO4eXo+MC3D
         CV2n2UrwTyL52McD1Ym0zs6wHzlHfk1Btvl0E/K0fKBbCF58vNCqAoqAkrrVl75q3t6m
         q8zwLpB0RuFjbGCr/VF2IewaCIUAWNPT8TP5QzB02w51hfgT6cEnnxHTEiMgwySzbjP4
         w5Og==
X-Gm-Message-State: AOJu0YxNs1EG7WVs6U6YrY/ua2s/2GTUeVPUSeS+PwyrQ+tuv1/EvB1o
	5iUQYjmANQpD1HbWrRt/D16uPeiYfAyjbO7YwQVafDBIDd1/k62vxGlxsQdCZFQGRbuDz2fu4Nw
	=
X-Gm-Gg: AeBDietwVpC7pdOsfv7D7bsQqG75dwjCcFU12b9lwIqeXJ30ikZf/G6uQQsYgr1NNv/
	WbZeOLmI9m6xpFHnynthEu8anNibPyIQ5faJIdITYWWI38FMcVQfwC5+Y5ntwExu2gEb3KKE+la
	H07u3Uoh44Gl4t1Cx3FO4jUQMzbNghjMu89uaqxP0TTRVKaRrzofxu6CrN16z/kVzJLPXTz4FkX
	qUi/g4HEomuofGOtgBbRQly3naTRDqZYpbxNzXALXhcL/Bvz9lHevH4G9uPIsfM1HdGaskSWO98
	UJqIb397rPXMMeimcNQy+Ie4kBRMRDa7bLubqIOzI4VRPX8ivTh0vN9igmmmYox6MSOqFY0iPie
	XwWZA7oHYPGr6tM43rx4asBmAA06MIAfOQOJb9zdAmddzeDNKkk3tVzvrsDk8VaGmPDTWxs+zz8
	S9f1MRk8wXZflYLhotwjhsq4PW/hp3lSujN3mzXab2oI9ae2lu9nCkFGYM9evvzzY/4mXH0LfbS
	AM5zY9y1g==
X-Received: by 2002:a05:6512:2243:b0:5a3:fd47:aae6 with SMTP id 2adb3069b0e04-5a4172e2794mr7865623e87.32.1776863908248;
        Wed, 22 Apr 2026 06:18:28 -0700 (PDT)
Received: from va-HP-Pavilion-Desktop-595-p0xxx.mshome.net ([193.0.150.248])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a418376d0asm4447656e87.0.2026.04.22.06.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 06:18:27 -0700 (PDT)
From: Vastargazing <vebohr@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	Vastargazing <vebohr@email.com>
Subject: [PATCH 0/1] selftests: netfilter: add regression test for nft_ct timeout UAF
Date: Wed, 22 Apr 2026 16:18:17 +0300
Message-ID: <20260422131818.106417-1-vebohr@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vastargazing <vebohr@email.com>

Commit f8dca15a1b19 ("netfilter: nft_ct: fix use-after-free in timeout
object destroy") fixed a slab-use-after-free but no regression test was
added. This patch adds one to tools/testing/selftests/net/netfilter/.

Vastargazing (1):
  selftests: netfilter: add nft_ct timeout destroy race test

 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../netfilter/nft_ct_timeout_concurrency.sh   | 116 ++++++++++++++++++
 2 files changed, 117 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/nft_ct_timeout_concurrency.sh

-- 
2.51.0

