Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FD73563FE
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770027302; cv=none; b=p32rtW9snvcc91el5nizEHgARS1pYJKL/iyHJMLdtDUR7qkM4NuL7cqTpBacByz/yHsThchiLkUehQFyvsimVmwEYbvjIBAhs5lT8Jp1UbrswMd6j2Gsb82Bq0fq1EWlPEuHMNkwzjcf++hQktFIXlnHFJeysV+Oy6KUzuRSlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770027302; c=relaxed/simple;
	bh=mmbm6e1AGXsExBXcfLr90xAWfSzZXX2CBkfyjQTZihs=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ax67dy7ELIhea9dMjz8e80V2GN3QLxIVaa9VX7xyxurzb+d58FriYS2lVWtZdQyPp1ZkfLYrxTufRXkp7xrruR2eZ9Z30Nxry3dqHSVMugwXAM6u5h7qFY1yHy9JDhTFmA5o7x0WQY3vObTmGdz14OMTwiNwHjnVgB69/qT72F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=AfWJhVD+; arc=none smtp.client-ip=109.224.244.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="AfWJhVD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770027296; x=1770286496;
	bh=JbLeAU8dShraBYQ/97ok7h28ODXFkIOhKdtEuy17zvo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=AfWJhVD+9wLvnLa9lKHKtI1XN8tQkwv3QiPWN1E1vh6RGfk0ckvQNNZ5HxLhXwOex
	 3A/NgT7+Nkm3yupfhTvfKD679xlNeFy1sl3IViuzQ6o3g+QkI94ElSqP3ImTU9opOK
	 TsC9aEx8224d4Yr3f7A7lnouyQvK8J8CDQL5qSDXA31tuF95tLnx3pPbfdW5Gd8G+P
	 hE/zb1QVfo+rOmptXebvs8dlcFBWgMtNG9X0nLvnz/z53MoAeNHGG6gdk6PGG73kMy
	 w3lMtpKz5H7LpnyaXazVdN4TEw/xziqUqtCScK9bVEODD5VWtROb1NWkiShT3deC/D
	 B6Sgxdd88ELjw==
Date: Mon, 02 Feb 2026 10:14:52 +0000
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH] iptables: fix null dereference parsing bitwise operations
Message-ID: <20260202101408.745532-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: ebec2e2cb7f86aec2512330cbac2392200c31cae
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Iptables binary only understands NFT_BITWISE_MASK_XOR bitwise operation and
assumes its attributes are always present without actually checking, which
leads to a segfault in some cases.

This commit introduces this missing check.

| /**
|  * enum nft_bitwise_ops - nf_tables bitwise operations
|  *
|  * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, A=
ND, OR
|  *                        and XOR boolean operations
|  * @NFT_BITWISE_LSHIFT: left-shift operation          \
|  * @NFT_BITWISE_RSHIFT: right-shift operation         |
|  * @NFT_BITWISE_AND: and operation                    | These all are aff=
ected
|  * @NFT_BITWISE_OR: or operation                      |
|  * @NFT_BITWISE_XOR: xor operation                    /
|  */

From iptables/nft-ruleparse.c:

| static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *=
e)
| {
|   [...]
|
|   data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_XOR, &len); // <-- this a=
ttribute may not be present
|
|   if (len > sizeof(dreg->bitwise.xor)) {
|     ctx->errmsg =3D "bitwise xor too large";
|     return;
|   }
|
|   memcpy(dreg->bitwise.xor, data, len); // <-- zero dereference happens h=
ere
|
|   data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_MASK, &len);
|
|   if (len > sizeof(dreg->bitwise.mask)) {
|   =09ctx->errmsg =3D "bitwise mask too large";
|   =09return;
|   }
|
|   memcpy(dreg->bitwise.mask, data, len);
|
|   dreg->bitwise.set =3D true;
|
| }

The bug can be reproduced by creating a rule like this:

| # newrule.json
| {"chain": "example-chain",
|  "expressions": {"elem": [{"data": {"base": 1,
|                                     "dreg": 1,
|                                     "len": 4,
|                                     "offset": 12},
|                            "name": "payload"},
|                           {"data": {"data": {"value": [255, 255, 255, 0]}=
,
|                                     "dreg": 1,
|                                     "len": 4,
|                                     "op": 3,
|                                     "sreg": 1},
|                            "name": "bitwise"},
|                           {"data": {"data": {"value": [1, 2, 3, 0]},
|                                     "op": 0,
|                                     "sreg": 1},
|                            "name": "cmp"},
|                           {"data": {"data": {"verdict": {"code": 1}},
|                                     "dreg": 0},
|                            "name": "immediate"}]},
|  "nfgen-family": 2,
|  "table": "filter"}

| # newrule.sh
| set -euo pipefail
|
| iptables -N example-chain || true
|
| genid=3D"$(
|   ./tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/nftable=
s.yaml \
|     --do getgen --json "{}" --output-json |
|     jq -r ".id"
| )"
|
| ./tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/nftables.=
yaml \
|   --multi batch-begin "{\"genid\": $genid, \"res-id\": 10}" \
|   --creat --append --multi newrule "$(cat ./newrule.json)" \
|   --creat --multi batch-end '{}' \
|   --output-json

Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
---
 iptables/nft-ruleparse.c | 5 +++++
 iptables/nft.c           | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index cdf1af4f..1a9084e3 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -232,6 +232,11 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, =
struct nftnl_expr *e)
 =09const void *data;
 =09uint32_t len;
=20
+=09if (nftnl_expr_get_u32(e, NFTNL_EXPR_BITWISE_OP) !=3D 0 /* empty or MAS=
K_XOR */) {
+=09=09ctx->errmsg =3D "unsupported bitwise operation";
+=09=09return;
+=09}
+
 =09if (!sreg)
 =09=09return;
=20
diff --git a/iptables/nft.c b/iptables/nft.c
index 85080a6d..661fac29 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -4029,7 +4029,6 @@ static const char *supported_exprs[] =3D {
 =09"payload",
 =09"meta",
 =09"cmp",
-=09"bitwise",
 =09"counter",
 =09"immediate",
 =09"lookup",
@@ -4056,6 +4055,10 @@ static int nft_is_expr_compatible(struct nftnl_expr =
*expr, void *data)
 =09    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
 =09=09return 0;
=20
+=09if (!strcmp(name, "bitwise") &&
+=09    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) =3D=3D 0 /* empty o=
r MASK_XOR */)
+=09=09return 0;
+
 =09return -1;
 }
=20
--=20
2.51.2


