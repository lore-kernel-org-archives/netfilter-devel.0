Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F83C73DA
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773326578; cv=none; b=HhCGdNsAZt40KEqB3q1vlz8+rRdpVU9CZcEuG2JdubvfOik147ScaHB3fvzRQ5Mj+S2E/+TwTDYO7of/0dxc/gOiuhzYzZR30mT8KP9THYk6ViMZHo7clc/u+iSf2yoCVw177HE7hDu03DQ4GofLkjc+/Rb+yEQ0CAxREXYD/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773326578; c=relaxed/simple;
	bh=fLfxvMI3HNHFGtvXLGAOsW9hcJh8usCAV/jtmwYJ+a8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=pRzGCZwhjGe2NwGrSYSRy8WXuLtJtq2hTfGwdtmat1eiGDVwJCqoMGhU+AdAxQTL9ncqLWo/GfM70/t0WBsUXjds4P0pcgU+m5AsqXGUDLIrF08MBifg9BKTT9penGrcUhOdyWjcdbubU+cTUUcZ9yZAFoflwWvN7ttVIsrCWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F29dmL2x; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F29dmL2x"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509134ab2d2so10482291cf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 07:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773326573; x=1773931373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rc6Cq/F5yHJA/B3e49neXV/SKBu5cRLuMs+2AV0ELpw=;
        b=F29dmL2xEaxztf6XVeLxaDEqBiEL2bwN0RY4Y2aytSxLhj1vuDPqVwDB5qZ0d6R8U8
         K/+Bnne34xbtw0nRGeHLYamoG9oZi2hB8GuaKKurZcRlkMVV4evPF0SI0XKhtMqq4ZzH
         XqdAXKZLLtGyC5DJ2L5jxA8hp0vj+cNNjvuYrZAULgBgGCPvRJxz+gX1uF3IHjXtzJwz
         d2q8t0gPQ+mirmyga8qWm5+JQ48qOeenekVQR/P2dDtsA7Q5LRhmcY86XGhXL7IuDRTS
         M+LtnCD2d3pCL5Kk8WqjdhHwDIrMTCUa/XYXsI3CkoUTSYh2ZHwUJlDuGkuVZM7+piFB
         yLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773326573; x=1773931373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rc6Cq/F5yHJA/B3e49neXV/SKBu5cRLuMs+2AV0ELpw=;
        b=n3+EpRlpOCLctp2r1GU0XClWSiVKUdIVnxbAY3BscKIaMw8ReFxYO5sxR5FWpDprmu
         NNEuH27nQZhd1EzECRZ9AP+7QlBNzYsPRJBzyjNSqKyHkQ1cgJUTajEQO1byxLz3yCi6
         2CsZCVMzcSaMKkl/aI74lSwjHoDQJXUgx+Z/pQLG8hSxegavmqJsIqL6ZqZvKUDZ6w92
         Ks7XfH4PcTV/U96um/PLLgQMBc1i4Q0rWJxGPQ2h+NScWd5gPqO0YVyx7RYRwF8yQsS1
         8rm9bHZfZJVuAEEAFdHS1LFFG1r3mycH62pdvLXHMk6OJdJ8akzmZ1JCBz7nvvUEOcxV
         mXFQ==
X-Gm-Message-State: AOJu0YzSNaX/itZcXBWe/n+ZaEGNbrEIM796Yx1YtMVz1Shox44n5ltC
	ZnxXhXXQInRfKwGtfmn2255UTy1iX5PfcdTr4XQCVwElJOWBaHpfXxslmzwxnCTB
X-Gm-Gg: ATEYQzz2wC6P+BV/xipEyAczCaCMCmLE65vioEb1lfE/Mv095mzbYe+u4UjY8SmAVu3
	hu++ODdfleTcShIqweZnnWir1KrTKmTKqTtnzfX/o769Rge5zYYRvMEpjmCUo6RIyMTYchOmGxH
	nJKKUlWnm+9voJQFbYEP+sQwqlVfUb7PJO7mt28OSEUZKQUr/4k4r4txXl4iEX3zfostoUDN2gC
	hVy46RvBLcyzQ384r897kBJCumil4Cz12dq8pIIaHEvcaoE7NHfr/4lRbMaj5Yp9EHyhuXIb56V
	YP0BtKfOlmxMYPwtZn/vZHIJUnhvStYyN5yKh6BP1/R8YJqhiI58K8nlmWGWIbcVK//iREoXy18
	2Cj7+Iqssh5AlzsTKHoFmVGfAkP9WS9STVYTQ+9Q4guGQk12y6PSZjPp7bhO2nykqtYL5XJrTmQ
	WPiR/AwZMAj9tiziQ5XGwuXaFQ9zNqQ1Pk3oRCrmpFEReK
X-Received: by 2002:ac8:508:0:b0:509:456b:52e7 with SMTP id d75a77b69052e-509456b85c9mr39945261cf.16.1773326573217;
        Thu, 12 Mar 2026 07:42:53 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a1192d7sm32840221cf.26.2026.03.12.07.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:42:53 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] netfilter: ctnetlink: validate CTA_EXPECT_NAT_DIR value
Date: Thu, 12 Mar 2026 14:42:52 +0000
Message-Id: <20260312144252.2985553-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ctnetlink_parse_expect_nat() reads the CTA_EXPECT_NAT_DIR attribute
from userspace via netlink and assigns it to exp->dir without checking
whether it is a valid direction value. Since exp->dir is used as an
array index into the 2-element tuplehash[] array, an out-of-range
value causes an out-of-bounds access.

Add a bounds check to ensure the direction is less than IP_CT_DIR_MAX.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1239433830..ddf3a417f408 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3496,6 +3496,8 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 	exp->saved_addr = nat_tuple.src.u3;
 	exp->saved_proto = nat_tuple.src.u;
 	exp->dir = ntohl(nla_get_be32(tb[CTA_EXPECT_NAT_DIR]));
+	if (exp->dir >= IP_CT_DIR_MAX)
+		return -EINVAL;
 
 	return 0;
 #else
-- 
2.34.1

