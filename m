Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5C4370ACF
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527599; cv=none; b=b+m733lOpluZelhYi7M32ejvt/WeDtfpGzZx1Qx2r0d6RpjYKOMREJLeiuWplEIgQIKF/OZxGlsPJzeTd7yhoX660UwRli8pF5S92uZaNmgMpou0ZCKla7LxTK0tysT63XQyOw1VjUlnYB0DH5ENUw33Dx9xun9uFtVL+cuWBjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527599; c=relaxed/simple;
	bh=JGP6Ea25woPEvgvs5+S0Qki7BLdthTBP+0lfx743egQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YoJywVp/mQQq4CWKR+6kZb9zbYNCRdHLvOCdIZhhsKede5uJK8QuSP+QEW651ipd84/WdeJPX5w379N9dG/E+vpYqDxtTrXcijQSVQbBE77bl2AqP4Ajsu4icUn0z9PkmnJOTqPlZ9/fRDHrCk7MbpRDNJp3e2gELeni8x+Go8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iomohwEa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iomohwEa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=20WI0nl9t/B2N0VeQ38NRwdt91ljw+gPnnUpbvs806s=; b=iomohwEa1oWVyLIRa4RgDogs7d
	ZpVR+LIxJsVu+25YfUjl2pQZsz6MzG6kWHBqiCEN3N9WrdZEBUJtFdSkzytjI6Lrnz+/W/zE0YAWd
	IlomwnAgjhfWHO0wjNCTgVtT+8rEU/qBzVS83orEYp9HgJmE+352hrBxPpyesBKJk1RjrHyS7+8y9
	OBVAuwQzLVInPdrhUtI2/Xcf0jbOV33wtDNz7xMcUo+AxebnLeZO84ZB/jjOMrXzQLuw2yzd0WoxH
	GafU4IAQ6cDxCEkyuGW7S4WOXQUHRtxGPCwRjABaonB7dY69UlZsLh30V0qL3a0KZJvwLFf4T9NgL
	vrwcfDLQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whUzz-000000001sA-3Orj;
	Wed, 08 Jul 2026 18:19:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [nf-next PATCH 0/4] Address Sashiko review of NAT hook dump code
Date: Wed,  8 Jul 2026 18:19:36 +0200
Message-ID: <20260708161940.1477671-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 is mere preparation to add the missing case handling to
nfnl_hook_dump_nat(), the remaining three patches address the actual
concerns.

Link: https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de

Phil Sutter (4):
  netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
  netfilter: nfnetlink_hook: Deref hook entry using READ_ONCE()
  netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
  netfilter: nfnetlink_hook: Fix for concurrent NAT hooks dump and
    change

 net/netfilter/nfnetlink_hook.c | 43 ++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 12 deletions(-)

-- 
2.54.0

