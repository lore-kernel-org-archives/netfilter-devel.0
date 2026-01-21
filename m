Received: from mail-07.mail-europe.com (mail-0701.mail-europe.com [51.83.17.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3983436998B;
	Wed, 21 Jan 2026 18:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.17.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021265; cv=none; b=In7WXv4D8HTAZBXa7qfT2AgEyl4LZdi2V52aeZhtLmgs/DYXMQByRCda20LDQ2LQU4ASn71Hle08TWv/qDUer/kwmcqSc50Qz+zV67QHOoISpcJGZxavjtbr7bigW0B2eUsZeTAjrXr113HDkJo0Wo4zaOv8ZWLoQ43AGN00wiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021265; c=relaxed/simple;
	bh=XUgUE/aQqUyRCrHTh3KeVaRGZbHKoriW6JkJfAzNPVo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=LYJBvP8tdY9Si1LISQ7VHf4eKfcsHuMSDO5K9E2i8gUVtVWbVlNUSymj7vGpYMH8neGri1w3WHmCjqTPoGlNWffZ6BUdxvyHuOgOSvwZM2IQSHn02ZiytulUyWYK4pYJ/TknGuyZIFpebmbtXKwFfcDcYtN1/mCnQGd4paUzXGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=fail smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=qop6Wxly; arc=none smtp.client-ip=51.83.17.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="qop6Wxly"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769021253; x=1769280453;
	bh=O6jeRObaDPPCbKkRGzG3IGZSDLK8QgrVadNS88A/e7Y=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=qop6Wxly2i2i6AIWPS3ZDrSJ4nlb2fcoVRWtrU7CO4cChkqT0PhPxyu7Y67UKdZRe
	 IM6NnCPJKWXVJtaZBF5MeXuFUgegKOJ4//6S7eIaiEn3RNElY+ZwQ4Y9CQOJtu40xq
	 +JKhOxkRGVlZj9ubJnRo97lbSxoQMGX3gmQYivHGpFse3goZFMrWI9TqGI3c1dBouk
	 s87TQAhNRnL0531kiI5B7LGwnvOBs8Q6q12S//UnJxd4UKI1rcdflbO74CwKshY86g
	 xiky76cGG4gz/okFkGXVtErBmm8zKEp0OslnEKDyRcRTxmRx6TG+9f5LZaSHG4tRZe
	 2KNg2e8WPEdIA==
Date: Wed, 21 Jan 2026 18:47:29 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v6 0/6] doc/netlink: Expand nftables specification
Message-ID: <20260121184621.198537-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 8e11415d56f4cb199534aa192eb44c125aee0240
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Getting out some changes I've accumulated while making nftables work
with Rust netlink-bindings. Hopefully, this will be useful upstream.

v6:
- Sort sub-messages.
- Add description for "Add max check" commit.
- Fix doc comment for expr-bitwise-attrs to match one in nf_tables.h (thank=
s Donald)

v5: https://lore.kernel.org/netdev/20251120151754.1111675-1-one-d-wide@prot=
onmail.com/
- Fix docgen warnings in enums (avoid interleaving strings and attrsets in =
a list).
- Remove "# defined in ..." comments in favor of explicit "header" tag.
- Split into smaller commits.

v4: https://lore.kernel.org/netdev/cover.1763574466.git.one-d-wide@protonma=
il.com/
- Move changes to netlink-raw.yaml into a separate commit.

v3: https://lore.kernel.org/netdev/20251009203324.1444367-1-one-d-wide@prot=
onmail.com/
- Fill out missing attributes in each operation (removing todo comments fro=
m v1).
- Add missing annotations: dump ops, byte-order, checks.
- Add max check to netlink-raw specification (suggested by Donald Hunter).
- Revert changes to ynl_gen_rst.py.

v2: https://lore.kernel.org/netdev/20251003175510.1074239-1-one-d-wide@prot=
onmail.com/
- Handle empty request/reply attributes in ynl_gen_rst.py script.

v1: https://lore.kernel.org/netdev/20251002184950.1033210-1-one-d-wide@prot=
onmail.com/
- Add missing byte order annotations.
- Fill out attributes in some operations.
- Replace non-existent "name" attribute with todo comment.
- Add some missing sub-messages (and associated attributes).
- Add (copy over) documentation for some attributes / enum entries.
- Add "getcompat" operation.

Remy D. Farley (6):
  doc/netlink: netlink-raw: Add max check
  doc/netlink: nftables: Add definitions
  doc/netlink: nftables: Update attribute sets
  doc/netlink: nftables: Add sub-messages
  doc/netlink: nftables: Add getcompat operation
  doc/netlink: nftables: Fill out operation attributes

 Documentation/netlink/netlink-raw.yaml    |  11 +-
 Documentation/netlink/specs/nftables.yaml | 695 ++++++++++++++++++++--
 2 files changed, 656 insertions(+), 50 deletions(-)

--=20
2.51.2


