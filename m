Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877414F1E3
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2024 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705668442; cv=none; b=Sdt6xkFep83b/c9tWHM/PDm8/6XuU9jO3jkYFk8rkpBu+0Iu/6Jajg+PKiCrcH7VgSVWcEWJ0bk8ROnhUxiV+8JdytBnylqLuMY9RXkuFkgKGiFtzEBtLAuDA5dJNLVcelDa7hYUlrfv/BNQJNB0GVktUZ1yr+z6EKnL/Jor4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705668442; c=relaxed/simple;
	bh=wsAnMZ+8aRAgcl8/4vDNbiCwIJFWq7Qq6PrNAsPX6WA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nu21Qpgv4Z/rOC8DtZ8OqFURngwjjv3qPo2Hu2aJU1aA0hvPENXNVJymAMe6CQRDcRLfxWORM2TiKxGHDKuehjeNsSPhhQbdxG/Xw6jgTWWXQtBxJWDIl7vQmaCPw0cM4yrNFJXxMfVRuDXoLVvdtKVkGuJaFGOMxwqrrI9/Z/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rQoHG-00083P-E2; Fri, 19 Jan 2024 13:47:18 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/2] fix host-endian constant values in set lookup keys
Date: Fri, 19 Jan 2024 13:47:07 +0100
Message-ID: <20240119124713.6506-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit b422b07ab2f96436001f33dfdfd937238033c799
("src: permit use of constant values in set lookup keys") allows to do
something like this:

set s { type ipv4_addr . ipv4_addr . inet_service .. } something
add rule ip saddr . 1.2.3.4 . 80 @s goto c1

However, it turns out that this only works if the constant(s)
(1.2.3.4 and 80) have BYTEORDER_BIG_ENDIAN type.

Combining a fixed value with a key portion of HOST type results in
a crash (assertion).

First patch is a refactor, second patch adds needed byteorder
conversions to deal with this problem.

Florian Westphal (2):
  netlink_delinearize: move concat and value postprocessing to helpers
  evaluate: permit use of host-endian constant values in set lookup keys

 src/evaluate.c                                | 65 +++++++------
 src/netlink_delinearize.c                     | 97 ++++++++++++-------
 .../packetpath/dumps/set_lookups.nft          | 51 ++++++++++
 tests/shell/testcases/packetpath/set_lookups  | 64 ++++++++++++
 .../sets/dumps/typeof_sets_concat.nft         | 11 +++
 5 files changed, 221 insertions(+), 67 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_lookups.nft
 create mode 100755 tests/shell/testcases/packetpath/set_lookups

-- 
2.43.0

