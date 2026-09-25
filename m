Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215C1468C1B
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345520; cv=none; b=B6OWdM4PmMX/Bk6aCisjqWPrNjSobHAupRpmJTnfEPLhKcldmbZy8zouwUfYhZkCz2YVwN6pTN2VyL/YncWjF9pfOoxI15jxtRylYtIvrVG+5M54uuSYR9KBPFMkeeOkb4Pp40xUDzWbf+PWSxl6BRiPOYMwgbqFIxr195eCgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345520; c=relaxed/simple;
	bh=bClgww2PEDEwfXY5iR7JQeRsyjdwM433YNLMHw0EdVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GHKJwP+vY6z7h4no1YPShuKDdFMCATGZnJS1DD6EZV9lGCR7ss4kC3G5gCjI2q++RYalyUZQ7TLdU1w0RU3GOs3Bmpv9/Pz0ATwlnMaquyzCoFLNP4EDSc4/klI+w1p3njk95yfqvtFZfDelMFBqlgXkrLErphZWJhDcDzv99vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com; spf=pass smtp.mailfrom=agilebits.com; dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b=B5iFfF/4; arc=none smtp.client-ip=74.125.230.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b="B5iFfF/4"
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91400f92ae8so7340476d6.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1790345518; x=1790950318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dO7NZCxAxiVThQ0A8dmI8vnZ3FIyuKMw3NNH1me1PFc=;
        b=B5iFfF/4mvlPPw3BphhIrn1bZb4aH/fj7RRA3eZ4zH2usE2JEeIerXfGQjx+dGHsdt
         +wAmuiF8z7s4ZnY6toCfecMo1pSDnmtKS73c3aVF8YDg6Jq3SyJmUO60QEGO0ugpvuXn
         BzTN9n4LbfuWhtFFaimkUHgi/T8zdtoo1I7zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345518; x=1790950318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dO7NZCxAxiVThQ0A8dmI8vnZ3FIyuKMw3NNH1me1PFc=;
        b=D4CM7+pgEPpX4WM0Yj3ccCgTCuiPADi2pqLFADtuRBNWsn45yTzl7iWpbU3Nr0SYZW
         tYAkGGB9zkeK2mVGWyk8prnxMlTeAKSSSUv2wsWJs4t+q9U18EpnvN//uieQbv8qFPuI
         VJbvsUpQwWKR8QurJJ0d85b8YgkKViUiNapjetP1AOe0FmPtlf2QT1M9SxvRZk+cKM9G
         T4n7hD0DfjEw8GsbHuKXxIZDwkKqfVmzdpRRGafqjiWEvbHEJNw7X+/ORrHSCVtl6XF1
         RyRfHJyaA5FnbBsh7JKEAWLTBeWSqKynOt75RM6n7VhVb1IQAinF3B5kRTv1i6/2Dxkg
         WEew==
X-Forwarded-Encrypted: i=1; AKwUvBwWHbhvAzjga+wNEIxxq+KrBV/7yRLmF3++uB/ov07jjZZ2jSzHJjSC0kg1y2YAx/JQJq7+a/V3Bf01mGXVMFc=@vger.kernel.org
X-Gm-Message-State: AFuF++mnnp1PnluDoklJ+/+qAPFvWTALr2csIvh3vvzCw3FTZNYoKpiz
	ywuIYIx7StI5tB/fFtweTOG9EDY9VHIZKjAeXwXnBbFzw8NCxgQ0u3VlBHt6HqrECUQ=
X-Gm-Gg: AYBFou2996SenDWBMttgkRhqmgpOjSuq9xHf7HT7WbTaV35i1vsf1nzQUQ/Mr1dwnZO
	3bCceRtz/M/jmwI9GT2iryMCASwVTPPb845G/gxjwTINEyzKqz76p21PYWd1y/R3VayKGRzqu2b
	JcCJPEZUyP81p8/u/U7Bcjz6jUPewcg0+VcaWZtDA2TL6U6MtxDTxtqesbvBWmbHNtlFPanXQgA
	Noqs1nAQZqd4BmdiPYCRiWZ8FiN9Z7GwHg/h5tF6ZlFSqQyxybc+M23UF2J3tNnGE8Fr1KcwwuS
	Bh5hcvAg8Ohc7bpFlawdjZVwdZHXOD8KQVcN3U9LeqBEfcWDlAQoL+siWWNHFhUEbrkz5H62ZY0
	I1o1bhDTpcvoo/IiYMp6VrO5PV9SV4QTD70GyiUDxeSJizopbwgNx3gDpnCMISG6puvJRU1GCxD
	xhJ+16YvURdiQijQt4DpB3oTkfchuZx+/G//IMZI0oOTJpNpks68xJxmtvaroNxTcbjHWTHNZno
	WT1tyNEMwN07q+XbUPpy1PPupLiBg==
X-Received: by 2002:a05:6214:20cf:b0:907:c025:e4 with SMTP id 6a1803df08f44-9142f7af5eemr44633636d6.13.1790345517807;
        Fri, 25 Sep 2026 07:11:57 -0700 (PDT)
Received: from localhost ([2600:4041:59c3:300:7917:c7f6:28c6:182b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430ecf80csm17564456d6.49.2026.09.25.07.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 07:11:57 -0700 (PDT)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Willy Tarreau <w@1wt.eu>,
	Keith Hoodlet <keith.hoodlet@1password.com>,
	Axel Mierczuk <axel.mierczuk@1password.com>
Subject: [PATCH nf 0/2] ipvs: fix OOB write when NATing ICMPv6 errors quoting non-first fragments
Date: Fri, 25 Sep 2026 10:11:53 -0400
Message-ID: <20260925141155.17603-1-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a 16-byte OOB write past the verified skb area,
reachable through ICMPv6 errors that quote non-first fragments.
Following Julian's suggestion, it preserves ESP ICMPv6 handling.

Patch 1 includes the embedded IP header in ciph.len at both ICMPv6
call sites when parsing stops at a non-first fragment. The change
follows the ip_vs_fill_iph_skb_icmp() calls and does not depend on
patch 2.

Patch 2 makes ipv6_find_hdr() set *offset to the fragment payload
for non-first fragments when target < 0, so every successful return
updates it. It carries no Fixes tag because it defines an offset
that was previously unspecified.

Axel Mierczuk (2):
  ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
  ipv6: update *offset for non-first fragments in ipv6_find_hdr()

 net/ipv6/exthdrs_core.c         |  6 +++++-
 net/netfilter/ipvs/ip_vs_core.c | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.43.0

