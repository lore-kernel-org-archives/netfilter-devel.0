Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F2D79DB0
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203516; cv=none; b=IqaXzbpKtGWiFWnURy3Fi0/C8X2k0d3MuuEgMp81yBFeCtyo+VSv/1p6ighSlzB14f9TdLIxBdb46kXB2Rw3B/WrKeq8sR4D5KHHOjIvlANDshErt+GEpC1iDt/necr0QpYQ+bi0sfuqG0OSqKcUqHcFGXj4yTtZ7luGthjvUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203516; c=relaxed/simple;
	bh=pa24BGLjtQ3vMLGTKKSqd3kqprinmih+1izCnEYRqts=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PkiDrKJb+Eav0uIEBqvZjFa5975EPeY77ywUrk6JuZ0HWrO2PfeExYVZX5DNUslVWUKuS9HbPyYiaQDdlIXkjNkbKqpxVdk6T5BBL7RtfwU9D/tzu3T6loN3ifyWuSXI/PKyM3Ytnkq1MV2MAuYoLUYbtFabtN2WV3EMk66CdDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rfduS-0007dF-Rh
	for netfilter-devel@vger.kernel.org; Thu, 29 Feb 2024 11:45:04 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] nftables: add typeof support for objref maps
Date: Thu, 29 Feb 2024 11:41:22 +0100
Message-ID: <20240229104347.5156-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First patch extends the bison parser to permit typeof with objref maps.
Second patch "fixes" nftables listing mode to keep the typeof
information for objref maps rather than doing a fallback to 'type'.

Third patch adds a test case for this.

These patches are on top of the two bison parser compaction changes.


