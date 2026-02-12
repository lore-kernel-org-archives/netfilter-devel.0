Received: from mail-106102.protonmail.ch (mail-106102.protonmail.ch [79.135.106.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E63423C4E9
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770926863; cv=none; b=g83BT+tKIEatfoZvTaywKpF02gxj79wTqsMLZzAGZ2tWMyS0PpifcKidXYE6nEfkpJX9O8jrFlPrXh+/Vo8InpFAb2A4Y+9ZArPcajLYZuc/wcjpMAtboLqRTWqX2LFBooBvp3idcbGIJ1tQ85xPchNqlmF4uMha8CtSWhQx+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770926863; c=relaxed/simple;
	bh=zYAVmckSjwyVQeFQkW7lNs/CBbjiNr8fxHAnNgaRepQ=;
	h=Date:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=uB57f7Fi1cb4kMilqFSyH7VdCy647WsJWseeP+1vYsXF1CunCCqexZCBFYpe8sHauaA52+fb4n+djIAohTY+uLc7mmLfwSPtHrWuCKGjKIb6ht1/3fWQpPnDn98xHZJ9E6TPnj+NJnuixNPpHUhZTyT97DiTqnKe5dcMNfcGm18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=qMpPzNLE; arc=none smtp.client-ip=79.135.106.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="qMpPzNLE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770926853; x=1771186053;
	bh=88vFveAWzEz7wgO2Yvvd8XwheeuCP8l5cVStEfjB1KQ=;
	h=Date:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=qMpPzNLEk6EtsF8uO+ctcP4h6XEAqezaBEWD+YRDbk5sl6PCNLQu0k6ljklmeHwPX
	 q5pNY/noXoqTzFSvugwcaL7vNZrtGfxURyRcx9ACen4CMiD3CnLi/vH76gykBQ9jrz
	 BvtQfdkFTf8HBWaeoMPv2J1ErJ+vUUKtlVKFs1NPIEx2e1ZFMkr3j6o0yI37quuglJ
	 uIJcrHGsCiKnBqYnANkwGHI3YQE3axKE4b6Y8ZqJBDGXE5plCsODVZ2ECWcByuTbOa
	 E3nOPwkhlHKs9E6fJuK1aIGBKruEjzWpqx40OT4D8sHpnP2A9eT7Sh0aUGWdI5no6X
	 32QAcwG/cv9OA==
Date: Thu, 12 Feb 2026 20:07:28 +0000
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: [PATCH v2] iptables: fix null dereference parsing bitwise operations
Message-ID: <20260212200617.3297279-1-one-d-wide@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: ff4762adf42e1f3799bb6cc94911d2fb518a544b
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
 iptables/nft-ruleparse.c | 10 ++++++++++
 iptables/nft.c           |  5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index cdf1af4f..19a631f4 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -245,6 +245,11 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, =
struct nftnl_expr *e)
=20
 =09data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_XOR, &len);
=20
+=09if (!data) {
+=09=09ctx->errmsg =3D "missing bitwise xor attribute";
+=09=09return;
+=09}
+
 =09if (len > sizeof(dreg->bitwise.xor)) {
 =09=09ctx->errmsg =3D "bitwise xor too large";
 =09=09return;
@@ -254,6 +259,11 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, =
struct nftnl_expr *e)
=20
 =09data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_MASK, &len);
=20
+=09if (!data) {
+=09=09ctx->errmsg =3D "missing bitwise mask attribute";
+=09=09return;
+=09}
+
 =09if (len > sizeof(dreg->bitwise.mask)) {
 =09=09ctx->errmsg =3D "bitwise mask too large";
 =09=09return;
diff --git a/iptables/nft.c b/iptables/nft.c
index 85080a6d..3d981254 100644
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
+=09    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) =3D=3D NFT_BITWISE_=
BOOL)
+=09=09return 0;
+
 =09return -1;
 }
=20
--=20
2.51.2


