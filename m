Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1260A76057
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459619; cv=none; b=KLZPy7mAY0j6m4xXvOfKhqnUtmV6hIn0Mo9jkvXNi4DreOc5CBLHh10IE3UW6ihKqpWWHDnEf8miNgbHFMij+XPrtIdokIsoYkwRvrLPDoi+vwJ0t3kTByUD+rKcRoMhx/cTPgecK+GMHhL7AtyG6EP60+cUkZqd56MV/uf2feI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459619; c=relaxed/simple;
	bh=HeFhExx+x6+c4IjZfSzd0POROlsX2nkK050QNUIenD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mTDcLZPUftJMI7tl+4cW3MpGJa/QSYNvc0nqP7TqClVeZ3yPRDL30byHpi7aBfmvlGZnv8X52QC9kB/sxhE4IcWmkXzyJ+v+RaEQCjK5ZTKtOFhlCejqUOiL6SSG/y6GVmf0aKe76blDRGBFE9ZQGmwNhMh1civssFlLOdQkA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GOAFKu+5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GOAFKu+5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Oor3dB8U50CotOR5P4uEBB02qxfK9ArFZCcy2I7WmMo=; b=GOAFKu+5DC6xSSGZ1Fpu5Ltwfq
	6y0oMQchnfUl4tzQmFNP5g3fe/dgtn/Qy8u4+Pm2YGu6zX5uayy9UVFTtvUihp93hcZxTuNv4Bfzg
	4hTTU3g0Ya6L30gtahIGZ2SeRuMsmMA4YwqJbNmhhECH3stu5vTj1gXeVLDUO2P/Y0YkuN/LyA4r2
	MCUPZvs7zTKd7Ba1mp9nDHSArs81kxd/IxEZDtmjq85vXWIHqae2sJZkoaQQh4omOFitKaXfKbmj6
	6lwnUn0Vp74NQkCpuIAFHpN3Fs0JFA8eieGL6RcHiEJvGsLLpI7hnvR0+8xOMTE9psWOkiUPvxHOJ
	t6l9xRng==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rp6pL-000000002rp-04JP;
	Tue, 26 Mar 2024 14:26:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Quentin Deslandes <qde@naccy.de>
Subject: [nft PATCH v2 0/2] Add support for table's persist flag
Date: Tue, 26 Mar 2024 14:26:49 +0100
Message-ID: <20240326132651.21274-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support for kernel commit da5141bbe0c2 ("netfilter: nf_tables: Introduce
NFT_TABLE_F_PERSIST") in user space.

Patch 1 is not a dependency, but trivial enough to go along with the
second one.

Changes since v1:
- Fix memleak in patch 2.

Phil Sutter (2):
  doc: nft.8: Two minor synopsis fixups
  Add support for table's persist flag

 doc/libnftables-json.adoc                   | 11 +++-
 doc/nft.txt                                 | 13 +++-
 include/rule.h                              |  3 +-
 src/parser_bison.y                          | 43 +++++++++----
 src/parser_json.c                           | 68 ++++++++++++++++++++-
 src/rule.c                                  |  1 +
 tests/shell/features/table_flag_persist.nft |  3 +
 tests/shell/testcases/owner/0002-persist    | 36 +++++++++++
 8 files changed, 159 insertions(+), 19 deletions(-)
 create mode 100644 tests/shell/features/table_flag_persist.nft
 create mode 100755 tests/shell/testcases/owner/0002-persist

-- 
2.43.0

