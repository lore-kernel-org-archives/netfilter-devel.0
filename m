Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8E11D173A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896798; cv=none; b=jCE+ZBKvLbwyRJNmJcNBNg8dmroAbPJDFvjVT4hnMsFdsNcfiALaxtPmA4cATI32j5EUE75Fqb2a6IMZ98315/d4Gwc9/hx6L2vC997YF0Z/KEGnwTxVSu+5KD2QtHv6j1GjVQ/P2LUVfr5k6h5sxrQOs86neuC7RuyecBZ0yAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896798; c=relaxed/simple;
	bh=P2jqJWgouS6waC90iudAULIbaWvh+EecjhEyvYqNhrM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bA4vqsEn4hzvxN7TY9WCjHn3cQFQnvjgj3tGrIcJX4iPDpfmTvoLBq1BcVSsjy8oz87jx663SxNqyRgDNp6LYhqn+Xvr+l6R0cIV6b14gMBKlQTFQErJlDm1CiXFCyVIfQ6Dh2GAaUXYrlXDskJ1e+eg3IqbO1j8MdhZ+SCIoLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Vb5KBtLR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Vb5KBtLR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CWW1BQNEbmCogdb/2WS3XHlE6srx47Hn68K9JZjo7R0=; b=Vb5KBtLRf6DBEwkp4JsAR+Gdd6
	fCp3yROiyDyLh8vBzsvGqItWzy33kbxHP5NY71bCbU1cx/PggJspYVLJADDfCt9mloqKM9NOGlZVG
	uno1MzzfFoLNBkIJ2TyLt2cVM1di0TpLsFfnOqrU7jc1bPkrWCUrCur1Div//JXgJDZA9v6tk/9MP
	D6gOVhUqUnkiLd0l4InvRuR+BPlFCiKFBlG/0OdJ8AHPGXXGjxkKs/3eusqsSfGSXeaZ05jB0Yr9A
	CeL9dO0GBih4AeDeA0lTum/eg+zjLp8gMt2s+b8eW6h6PP1t93EwiUpyQN516sHEAtRUlCRLjZEu1
	ldd8oQgw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw4t1-000000002lT-0M9X;
	Wed, 02 Oct 2024 21:19:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 0/4] Support wildcard netdev hooks and events
Date: Wed,  2 Oct 2024 21:19:37 +0200
Message-ID: <20241002191941.8410-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is the first step of enabling support for name-based and
wildcard interface hooks in user space. A following series for nftables
depends on this one.

Patch 1 is fallout, noticed when checking for minimal #include
statements in a new source file.

Patch 2 introduces helpers to convert wildcards from user representation
("eth*") to kernel ("eth" len 3) and back. Note that nftables does not
use the serialization part of this since it needs the offsets for
location information.

Patch 3 introduces a helper I wrote for the code in patch 4, but puts it
into a common spot for use in many source files.

Patch 4 finally implements deserialization for NFT_MSG_(NEW|DEL)DEV
payloads. This is a bit of pointless overhead since nftables will use it
in monitor code only, but I didn't want to bypass the standard
integration entirely and fiddle with libmnl in there directly.

Phil Sutter (4):
  include: utils.h needs errno.h
  utils: Add helpers for interface name wildcards
  utils: Introduce nftnl_parse_str_attr()
  device: Introduce nftnl_device

 include/libnftnl/Makefile.am        |   1 +
 include/libnftnl/device.h           |  39 +++++++
 include/linux/netfilter/nf_tables.h |   8 ++
 include/utils.h                     |   8 ++
 src/Makefile.am                     |   1 +
 src/chain.c                         |  49 ++++-----
 src/device.c                        | 153 ++++++++++++++++++++++++++++
 src/expr/dynset.c                   |  12 +--
 src/expr/flow_offload.c             |  12 +--
 src/expr/log.c                      |  13 +--
 src/expr/lookup.c                   |  12 +--
 src/expr/objref.c                   |  18 ++--
 src/flowtable.c                     |  34 +++----
 src/libnftnl.map                    |  10 ++
 src/object.c                        |  14 ++-
 src/rule.c                          |  22 ++--
 src/set.c                           |  22 ++--
 src/set_elem.c                      |  38 +++----
 src/table.c                         |  11 +-
 src/trace.c                         |  28 ++---
 src/utils.c                         |  45 ++++++++
 21 files changed, 369 insertions(+), 181 deletions(-)
 create mode 100644 include/libnftnl/device.h
 create mode 100644 src/device.c

-- 
2.43.0

