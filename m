Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BC194C7D
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2024 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723208867; cv=none; b=leZrxW7EplwQCVWVbIi83vqmfeRbhYpw21++7mgnMi/DiLn8UVlTp9M8cGLW2e1+wSSuPiMUlWLjPMh+vQNIpGggX3ROMtodlGTSAPRj9WiD8FH9qptwbwoqvfRlnhnidYBaw2NZeV/KmnOQHyeG7FEiqSAyb76lLfg1KEHsAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723208867; c=relaxed/simple;
	bh=sVGaznC/hjxOJr46kj2Q2XyYVmEnNUA+dVOP71xcPB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GLyM1CmiI8l7V/7jdMPtYcnkImG69ZMgHx1y6SlzWvbyy+srpreagWmyd/jD7aI+RS3Q/WHrAOOBvi3Ywz0XBEKn6+NViCXNDElpf5fwpcbq2SMra8d0PFskwZ/XlKL1dRBHZ/kbygvth5TGWKu7ERrffGbnz13r5JdBbk4122k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=P7AU1pcb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="P7AU1pcb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7A+r66srTjI11b+clkwZKZV7zl5oFLfEpJEhxvp0ofQ=; b=P7AU1pcbelYhfK7aiyelO31NQr
	lSmFIZg27owj4XSQsE/OrRt4YcUK9JSRgln160hRNsuihXa3sQAOcekYda1xlDWS5FJTSx6+8FyxX
	+JbTD/+0cjs2na8qn0u+DSzsPEo2Io08JuTsJhHo/0UJB21slL3A6YDk57Sv9INfaDQrNO/uue+E+
	An8APxsJP2NKEKgO6fxDuupR6j8h1ywdbVsXfkuaQmWbBafo7JcZPeQQ3OfDNuo5ClY6BzKVFGHEh
	3650252u8IMlo5ia2DwpV9PnV61I9jqBVK3nbolLXWblwQt6buci07DYLbDpPHs88tW0pvgNYhOxz
	RtHvNlLA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1scPLG-000000000Dr-1VaY;
	Fri, 09 Aug 2024 15:07:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH v4 0/3] Add locking for NFT_MSG_GETOBJ_RESET requests
Date: Fri,  9 Aug 2024 15:07:29 +0200
Message-ID: <20240809130732.13128-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Analogous to getrule reset locking, prevent concurrent resetting of
named objects' state.

Changes since v3:
- Applied patches onto current nf.git

Phil Sutter (3):
  netfilter: nf_tables: Audit log dump reset after the fact
  netfilter: nf_tables: Introduce nf_tables_getobj_single
  netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests

 net/netfilter/nf_tables_api.c | 147 +++++++++++++++++++++++-----------
 1 file changed, 102 insertions(+), 45 deletions(-)

-- 
2.43.0

