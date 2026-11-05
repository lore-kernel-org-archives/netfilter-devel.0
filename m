Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900248;
	b=mGokDe4r2isTdZWk2/463AQEIeIl61AIQoqNK1SYVPU/xwP3HmXWNgGoqdAPxO0urBsN
	 jpO8xWQ4VG9s1t46nl9JKB8by+CrRT5R1Y+BPhCxzhaNVuEUOlqPIGNArlTPFZNI0AvE3
	 yJtXQ9IElzb0VbwJznQH4aXzEVf5tZoLnLqK2nsrupGHYXORyAW4PsPBfxbTAGMn7v8yX
	 WA7PP5GEyCwsLB/unoV77HUJl5UyVchPSAgOu/27+/NPvJJ902N3hg07VT82GkPlFpe4D
	 9laKbCujbATAFkvkECyhf5dzhXjXSwdpTo5WSfqr7NgsX7kYNc25zQoeUzg3OVs10WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900248;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=orKyNph5xKzHC2PRV0YuuWloKDmVCdsmKJZ+TRbtzmM=;
	b=ngSIYZtXVpy0OjMt6d/fotQ7tyADa/Aav4rtzT2shp6nl3yzCQNZj/yLGV0vSAyUMwB5
	 IJRst10cVWTiRxJsZu+6uf3nm7mRKAPnNQDpEZ6aQCW/zqm4OUOfv36kKmtBp7NreYrB/
	 wPSHelaEhMoJS0Mbsmi01T4fmErERpGCA39FNCBEYiJ+9CqGk7IlZCF5ORNIiuRRQs3iy
	 7iQcFJ7//38lFCqME4bu0ubQErRz1VRfa/sEqwrQdZD4HjiknzUnSccvhBW8qOl6m5mIq
	 TmdjV2JZopBDb6ZyjUtPcjFhVVhcmx1bUdcfujweCW8PMSlPKFTg85yrcwyVrJQa54A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D255F606A33D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 17:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D255F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=orKyNph5xKzHC2PRV0YuuWloKDmVCdsmKJZ+TRbtzmM=; b=byEsMiLunpYDxUMwZlPpHXiipO
	C8vEhqLLnHHr018apx8CYkSepJDbLrDbkOXoU8htZ8CQVvJTRiYArCQZsqePuMRUecIFQO8HNq/j0
	H1eMGbxbm+ulx7fwK/YNNZJ5Gm2cBzjv89cWG3fvez7Yb57y3wk9AKpYJiLmeadWJu3sSNZeimkcq
	Sdlk8+SWBK9D45NStewqhIRVZg1SISBgE2i11acDnD5S2vq/Enf+z6ir+JiyRx9pt0W7EQUy4ohZX
	BwdG5NUTrcSN3Ug5rv2nton3Kuabah4daS7mSRUj1NfdWc32Lpn0v6OaiylE6kJoyplFNGhIvpK15
	yaDf+LPQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xP1Oo-000000005lO-1bZa;
	Thu, 05 Nov 2026 18:37:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	xelra <xelra@protonmail.com>
Subject: [nft PATCH 0/3] Fix for exclusive start cond corner cases
Date: Thu,  5 Nov 2026 18:37:10 +0100
Message-ID: <20261105173713.72238-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
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

Patch 2 fixes the issue xelra reported in [1], patch 1 fixes a related
issue and patch 3 extends scanner debugging output a bit which helped
when analyzing the bug.

[1] https://lore.kernel.org/netfilter-devel/VPAY0CnKhCaOKYE6oo_AU7sR5MaGIGzyPkXi00RlaucbyN78KYBqK73XfyJ-yyXQENIvvXeFJq_fNrYbJuW8LcqZvZyf4J3kr66jvsojxCU=@protonmail.com/

Phil Sutter (3):
  parser_bison: Fix for comment following exclusive start cond
  scanner: Fix delayed start condition pop logic
  scanner: Add start condition debugging

 src/scanner.l                                 | 21 +++++---
 .../dumps/exclusive_start_cond.json-nft       | 52 +++++++++++++++++++
 .../parsing/dumps/exclusive_start_cond.nft    |  2 +
 .../testcases/parsing/exclusive_start_cond    |  6 +++
 4 files changed, 73 insertions(+), 8 deletions(-)

-- 
2.54.0

