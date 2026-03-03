Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D93890F1
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567852; cv=none; b=KoNnR7CQsGEB+bledT3CyISSBI3PZWvktDSa6Rp6+HbaRtQuVsvlRkTaIXRyXC34NkhxhYQi6x9A8vcMkZ2/ffyeFB6DGwGaG7ABET+utbnIwdrXtbcsIC449qcjLhHDuVXxX7sFHJFPaq8ShGadA9D1lHlLapNIG1QMSTj7b5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567852; c=relaxed/simple;
	bh=6wNWceZgJqE9TZcAbM4QEh90Yj2H18e8ohMDr/e/C/A=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=dum4bVmpjnJUo5XnIR1BWgFmheHrqHGdfuDvF0ws7qXCoAabvLC/7amYFFAFZ0yc8tUwr8PculIxrKS2lzWOSCRYVDB+OynkOtcqs0+0x+i2A0OMGq8SgmXXXvn7O0rkPs2LDd+C9y8h33Kq4wvFfCIdKNpZ1t69g4xqr2SnKRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=La4jOZ6n; arc=none smtp.client-ip=109.224.244.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="La4jOZ6n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1772567840; x=1772827040;
	bh=6qYd3K+8FkbLYiLfYPWP8GVlg8j1VlnfnIgK80herps=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=La4jOZ6nCIascUvAYtYzQjXNpW3xeDEW6m3yRTagHm+h7+NW/mYnVWMrbNau1oe7X
	 SuPnthHgdEf9E4emn1zZrsuPnea8somoq6UFuoWV6i3UPO5YHkwFCSTv/sZ/t4Bkb+
	 WyG46kxe87fGJTJwyDFB4gWPdJpbmg0zM1I4S1xCbQruNOia0cgP/ngKrmkWbzFSPm
	 zjEZVkcnn7gHFtHUAvsriXuh1hadAd1zFFDhGcFVy8QdKAaQiJ2GKWqX5F5ZS9EEk2
	 NjZPkq/I/HYCNWbj1B0oKCkUxndWxg+PzIYolrSmTIKQyS8zGiOHGE601k0eQKw3Pz
	 hrai2RY9JbAAw==
Date: Tue, 03 Mar 2026 19:57:16 +0000
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH net-next v8 0/5] doc/netlink: Expand nftables specification
Message-ID: <20260303195638.381642-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 52cacc55e82d025d0162efd212585f65817fd132
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

v8:
- De-duplicate operation attributes.
- Fix typo in max-check, add missing max-check.

v7: https://lore.kernel.org/netdev/20260202093928.742879-1-one-d-wide@proto=
nmail.com/
- Drop "getcompat" operation.
- Fix formatting of lists of attrsets.

v6: https://lore.kernel.org/netdev/20260121184621.198537-1-one-d-wide@proto=
nmail.com/
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

Remy D. Farley (5):
  doc/netlink: netlink-raw: Add max check
  doc/netlink: nftables: Add definitions
  doc/netlink: nftables: Update attribute sets
  doc/netlink: nftables: Add sub-messages
  doc/netlink: nftables: Fill out operation attributes

 Documentation/netlink/netlink-raw.yaml    |  11 +-
 Documentation/netlink/specs/nftables.yaml | 689 ++++++++++++++++++++--
 2 files changed, 650 insertions(+), 50 deletions(-)

--=20
2.51.2


