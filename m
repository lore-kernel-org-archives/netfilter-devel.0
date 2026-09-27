Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403CF3EC689;
	Sun, 27 Sep 2026 22:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548486; cv=none; b=P4H0+UqnllqDFFTpfvUViKLqvA8S4EcZ7pMP/DYppv3fAapjj8SsnEuTGuBoAzKwXL8z8bKPMNKmgZ9mTANysnMPFT4X4NZvH4a4fXSIqHl3bs4gJFCfbO9m7OidYdQB1E7BOF58IESp936atWo1Uk4mHnkzSxw6D+5Sl9NE/X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548486; c=relaxed/simple;
	bh=4gYwHcs6VxAUzCscwk2jN/RrdLOIjIhi7bK99Umriw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffNo7VDUR9wDEIkgyq0NyMabdy1TTcbsr7H76Lza6XNdJmu7LQjWBCR71+rGh8H9uPiCYr7mkyDCVLIrOEPIcUyPcYVrkSdDhcAp5GhYF3mxfE1jDuJKiGIRnWWJdLi1Jjm5+44SXR0Eohs4HSdzH93NIjR34o9aYwBL4h+aDSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ezf0MKM/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ezf0MKM/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548483;
	bh=IlZXdrgCBC8giz9MB5wZ38bLFlhw5pg/m5D518qcaNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ezf0MKM/ENcPzvgteZOns2vCIl7cnA6Q0xJR2JYw1f6ykEFN2wNSvqz0V6e8GwSMn
	 /N4CBg/yAwJPoTx6yZxicRPCdj4CrbUq0JlaWUuLtOsDagP6hKHldvAYy9dLrdZ1Qz
	 MD4uoQX/v1o4UjzuGgJfryB0onv6rPNNfK4d04GHR7DeWjP32/hVDMsyxNkbLysiVB
	 /ZR5lxpPwOv8QlUflrn/EeJRlnrN5rDuWH9f/vXSY8eYhjX8+kUij8PGGNhJK/2Yl2
	 tXPVoXAFO+4aC5oTaepH/YwUtuwaC3S2tO+8kOxnPOcnp5DeTCCgJfVxnVbJPrivSR
	 ijItneNXd6ZJA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CB43C60082;
	Mon, 28 Sep 2026 00:34:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 02/11] netfilter: conntrack: fix nf_conntrack_expect_max default value in documentation
Date: Mon, 28 Sep 2026 00:34:27 +0200
Message-ID: <20260927223436.269024-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shaojie Sun <sunshaojie@kylinos.cn>

The documentation for nf_conntrack_expect_max incorrectly states that the
default value is nf_conntrack_buckets / 256. However, the code in
nf_conntrack_expect_init() shows:

    nf_ct_expect_hsize = nf_conntrack_htable_size / 256;
    nf_ct_expect_max = nf_ct_expect_hsize * 4;

This means the default value is actually nf_conntrack_buckets / 64
(i.e. 4 times the hash table size, which defaults to
nf_conntrack_buckets / 256).

Fix the documentation to reflect the correct default value and add
explanation of the calculation.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 35f889259fcd..4426cce2a73f 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -44,7 +44,7 @@ nf_conntrack_events - BOOLEAN
 
 nf_conntrack_expect_max - INTEGER
 	Maximum size of expectation table.  Default value is
-	nf_conntrack_buckets / 256. Minimum is 1.
+	nf_conntrack_buckets / 64. Minimum is 1.
 
 nf_conntrack_frag6_high_thresh - INTEGER
 	default 262144
-- 
2.47.3

