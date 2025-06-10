Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66AB481CD
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 00:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749515338; cv=none; b=P5wuBIHVy76C2zLcLOw1C4AJ1lDqvIK9iOaO4bpGL0iO+77pZ+pNkl5bJK3b3rBCy7l/xvz66PjkA89XISR0qNU+nub7mLmDFjVpe/hpGXBrws5TgUuRHQkXnlcBin6ehsRsh49hMXNBa2LTZuCXUwNvldFMhUieygQN/a/p7go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749515338; c=relaxed/simple;
	bh=ypKEKFyZ6xHsOkaZxHiXa8lPp7oUupfInQJqH5T/+RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0rDKyNDg2j5hSa34ujrKC8jPyH6oBvm6l/z8hJwa4TCItFyj7aMmNQ/LSMsN80XRxlUJ1aN/bmsmK/kZfsIxGkotV9M9NmZ7jh35s2aId39PbhtvFL7f7+lftrEu8o3ishnssjdkElFZWLd2P07yAJOHyIxuLZyWEyLkYsBIxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dKct+Bng; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sp5C1aCA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dKct+Bng";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sp5C1aCA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DE92160600; Tue, 10 Jun 2025 02:28:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749515324;
	bh=YpmrEvLzZhJc3pZ8q2+upM9PJIYPcd7NjRh7eQyGemw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dKct+BnghGQpeWgeoRn+Zc5FPMEhQSfy/1PD4rl7xz+D64VNluSb49ANDyHy8BvJE
	 q7dbqAJQqIrH2v13PX8Hrdlna2v3GUpB+/pVushYFPfwd4BAcaBVYfhC35RcB9Uk3I
	 QtJpIbHLCpOSqfWcMWfAl6r5Nyx1Fpv3ynxIxxB+oPtdpmdVZKvsIKHokAu5uD7HG/
	 ZdScxAWkG8E0ju0yBYCym2CyJ7gxur2jhS3H1qo42dW90VCH30nd30KnS9kOGhVUVY
	 iIKabNChB6vzM7ScT3ourYBhGFLsbPo+F6nEPuDTs+T7uCm79UXp5hZZuwPcElRv0u
	 djNlROfNpeykw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4AAC9605F7;
	Tue, 10 Jun 2025 02:28:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749515320;
	bh=YpmrEvLzZhJc3pZ8q2+upM9PJIYPcd7NjRh7eQyGemw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sp5C1aCAVtQ8gObGVrUaohmsWtgVBjTLrerlf4jiTIQGY2ZusjOlugJhB/VbP6+a/
	 7jTUSF+AAg9uafP2lqtrMxfAbxAwVqnDpT9iYWlv+1kLwzTYt+2R5YbThapMsaXJe5
	 hQRrx2ps46u5YJPwEH8K8kGXJeWY4uM4eFV0ZSTSaW2r8Pa70nSxLBZA31zsssOqSk
	 P8qvVsQeuUccjjvNh4s7vUgtx02P4w/U12D8VjfJsOsp+J8q5rpgSnChx6Uggm8b4R
	 VvF81s0tFaVw0e/1EoF17Lao2RzBY52IZHZweVnqdZSMdaYc/YZ0CCqo8hbUPAakVJ
	 Frgh9lo702ZTQ==
Date: Tue, 10 Jun 2025 02:28:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aEd8Nfv5Zce1p0FD@calendula>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
 <aDZaAl1r0iWkAePn@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eASaaeUYi2+mvofA"
Content-Disposition: inline
In-Reply-To: <aDZaAl1r0iWkAePn@strlen.de>


--eASaaeUYi2+mvofA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Wed, May 28, 2025 at 02:34:10AM +0200, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> 
> Hi Fernando
> 
> Thanks for working on this, I got inquiries as to nft_tunnel.c
> and how to make use of this stuff...
> 
> > diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
> > index 9930355..14a42cd 100644
> > --- a/include/libnftnl/object.h
> > +++ b/include/libnftnl/object.h
> > @@ -117,15 +117,19 @@ enum {
> >  	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
> >  	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
> >  	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
> > +	NFTNL_OBJ_TUNNEL_GENEVE_OPTS,
> 
> If every flavour gets its own flag in the tunnel namespace we'll run
> out of u64 in no time.
> 
> AFAICS these are mutually exclusive, e.g.
> NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX and NFTNL_OBJ_TUNNEL_VXLAN_GBP cannot
> be active at the same time.
> 
> Is there a way to re-use the internal flag namespace depending on the tunnel
> subtype?
> 
> Or to have distinct tunnel object types?
> 
> object -> tunnel -> {vxlan, erspan, ...} ?
> 
> As-is, how is this API supposed to be used?  The internal union seems to
> be asking for trouble later, when e.g. 'getting' NFTNL_OBJ_TUNNEL_GENEVE_OPTS
> on something that was instantiated as vxlan tunnel and fields aliasing to
> unexpected values.
> 
> Perhaps the first use of any of the NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX
> etc values in a setter should interally "lock" the object to the given
> subtype?
> 
> That might allow to NOT use ->flags for those enum values and instead
> keep track of them via overlapping bits.
> 
> We'd need some internal 'enum nft_obj_tunnel_type' that marks which
> part of the union is useable/instantiated so we can reject requests
> to set bits that are not available for the specific tunnel type.
> 
> >  	switch (type) {
> >  	case NFTNL_OBJ_TUNNEL_ID:
> > @@ -72,6 +73,15 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
> >  	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
> >  		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
> >  		break;
> > +	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
> > +		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
> 
> No null check.  Applies to a few other spots too.
> 
> > +		memcpy(geneve, data, data_len);
> 
> Hmm, this looks like the API leaks internal data layout from nftables to
> libnftnl and vice versa?  IMO thats a non-starter, sorry.
> 
> I see that options are essentially unlimited values, so perhaps nftables
> should build the netlink blob(s) directly, similar to nftnl_udata()?
> 
> Pablo, any better idea?

Maybe this API for tunnel options are proposed in this patch?

Consider this a sketch/proposal, this is compiled tested only.

struct obj_ops also needs a .free interface to release the tunnel
options object.

--eASaaeUYi2+mvofA
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-tunnel-rework-options.patch"

From 56362a22008911873bd8b8a2f55e68406e55e0de Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 10 Jun 2025 01:43:28 +0200
Subject: [PATCH libnftnl] tunnel: rework options

Only vxlan gbp can work before this patch because
NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR is off by one in the internal object
flags.

Replace them by NFTNL_OBJ_TUNNEL_OPTS and add a new opaque
nftnl_tunnel_opts struct and nftnl_tunnel_opts_set() to set up
tunnel options.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/object.h |  32 ++++-
 include/obj.h             |  16 +--
 src/obj/tunnel.c          | 275 +++++++++++++++++++++++++++-----------
 3 files changed, 222 insertions(+), 101 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 9930355bb8f0..0331cf7ac5d8 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -112,14 +112,36 @@ enum {
 	NFTNL_OBJ_TUNNEL_FLAGS,
 	NFTNL_OBJ_TUNNEL_TOS,
 	NFTNL_OBJ_TUNNEL_TTL,
-	NFTNL_OBJ_TUNNEL_VXLAN_GBP,
-	NFTNL_OBJ_TUNNEL_ERSPAN_VERSION,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
+	NFTNL_OBJ_TUNNEL_OPTS,
 	__NFTNL_OBJ_TUNNEL_MAX,
 };
 
+#define NFTNL_TUNNEL_TYPE	0
+#define NFTNL_TUNNEL_BASE	4
+
+enum nftnl_tunnel_type {
+	NFTNL_TUNNEL_TYPE_VXLAN,
+	NFTNL_TUNNEL_TYPE_ERSPAN,
+};
+
+enum {
+	NFTNL_TUNNEL_VXLAN_GBP		= NFTNL_TUNNEL_BASE,
+	__NFTNL_TUNNEL_VXLAN_MAX,
+};
+
+enum {
+	NFTNL_TUNNEL_ERSPAN_VERSION	= NFTNL_TUNNEL_BASE,
+	NFTNL_TUNNEL_ERSPAN_V1_INDEX,
+	NFTNL_TUNNEL_ERSPAN_V2_HWID,
+	NFTNL_TUNNEL_ERSPAN_V2_DIR,
+	__NFTNL_TUNNEL_ERSPAN_MAX,
+};
+
+struct nftnl_tunnel_opts;
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
+int nftnl_tunnel_opts_set(struct nftnl_tunnel_opts *opts, uint16_t type,
+			  const void *data, uint32_t data_len);
+
 enum {
 	NFTNL_OBJ_SECMARK_CTX	= NFTNL_OBJ_BASE,
 	__NFTNL_OBJ_SECMARK_MAX,
diff --git a/include/obj.h b/include/obj.h
index d2177377860d..5d3c4eced199 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -78,21 +78,7 @@ struct nftnl_obj {
 			uint32_t	tun_flags;
 			uint8_t		tun_tos;
 			uint8_t		tun_ttl;
-			union {
-				struct {
-					uint32_t	gbp;
-				} tun_vxlan;
-				struct {
-					uint32_t	version;
-					union {
-						uint32_t	v1_index;
-						struct {
-							uint8_t	hwid;
-							uint8_t	dir;
-						} v2;
-					} u;
-				} tun_erspan;
-			} u;
+			struct nftnl_tunnel_opts *tun_opts;
 		} tunnel;
 		struct nftnl_obj_secmark {
 			char		ctx[NFT_SECMARK_CTX_MAXLEN];
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 8941e39ffb03..80199928d954 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -57,20 +57,8 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_TTL:
 		memcpy(&tun->tun_ttl, data, data_len);
 		break;
-	case NFTNL_OBJ_TUNNEL_VXLAN_GBP:
-		memcpy(&tun->u.tun_vxlan.gbp, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_VERSION:
-		memcpy(&tun->u.tun_erspan.version, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX:
-		memcpy(&tun->u.tun_erspan.u.v1_index, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID:
-		memcpy(&tun->u.tun_erspan.u.v2.hwid, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
-		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
+	case NFTNL_OBJ_TUNNEL_OPTS:
+		memcpy(&tun->tun_opts, data, data_len);
 		break;
 	}
 	return 0;
@@ -116,21 +104,9 @@ nftnl_obj_tunnel_get(const struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_TTL:
 		*data_len = sizeof(tun->tun_ttl);
 		return &tun->tun_ttl;
-	case NFTNL_OBJ_TUNNEL_VXLAN_GBP:
-		*data_len = sizeof(tun->u.tun_vxlan.gbp);
-		return &tun->u.tun_vxlan.gbp;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_VERSION:
-		*data_len = sizeof(tun->u.tun_erspan.version);
-		return &tun->u.tun_erspan.version;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX:
-		*data_len = sizeof(tun->u.tun_erspan.u.v1_index);
-		return &tun->u.tun_erspan.u.v1_index;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID:
-		*data_len = sizeof(tun->u.tun_erspan.u.v2.hwid);
-		return &tun->u.tun_erspan.u.v2.hwid;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
-		*data_len = sizeof(tun->u.tun_erspan.u.v2.dir);
-		return &tun->u.tun_erspan.u.v2.dir;
+	case NFTNL_OBJ_TUNNEL_OPTS:
+		*data_len = sizeof(tun->tun_opts);
+		return &tun->tun_opts;
 	}
 	return NULL;
 }
@@ -171,11 +147,14 @@ static int nftnl_obj_tunnel_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
+				    struct nftnl_tunnel_opts *opts);
+
 static void
 nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 {
 	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
-	struct nlattr *nest, *nest_inner;
+	struct nlattr *nest;
 
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ID))
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ID, htonl(tun->id));
@@ -212,34 +191,8 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 		mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_TTL, tun->tun_ttl);
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_FLAGS, htonl(tun->tun_flags));
-	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP)) {
-		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
-		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
-		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
-				 htonl(tun->u.tun_vxlan.gbp));
-		mnl_attr_nest_end(nlh, nest_inner);
-		mnl_attr_nest_end(nlh, nest);
-	}
-	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION) &&
-	    (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX) ||
-	     (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID) &&
-	      e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)))) {
-		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
-		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
-		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
-				 htonl(tun->u.tun_erspan.version));
-		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX))
-			mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
-					 htonl(tun->u.tun_erspan.u.v1_index));
-		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID))
-			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
-					tun->u.tun_erspan.u.v2.hwid);
-		if (e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR))
-			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
-					tun->u.tun_erspan.u.v2.dir);
-		mnl_attr_nest_end(nlh, nest_inner);
-		mnl_attr_nest_end(nlh, nest);
-	}
+	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS))
+		nftnl_tunnel_opts_build(nlh, tun->tun_opts);
 }
 
 static int nftnl_obj_tunnel_ip_cb(const struct nlattr *attr, void *data)
@@ -335,6 +288,26 @@ static int nftnl_obj_tunnel_parse_ip6(struct nftnl_obj *e, struct nlattr *attr,
 	return 0;
 }
 
+struct nftnl_tunnel_opts {
+	enum nftnl_tunnel_type			type;
+	uint32_t				flags;
+	union {
+		struct {
+			uint32_t		gbp;
+		} vxlan;
+		struct {
+			uint32_t		version;
+			struct {
+				uint32_t	index;
+			} v1;
+			struct {
+				uint8_t		hwid;
+				uint8_t		dir;
+			} v2;
+		} erspan;
+	};
+};
+
 static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -355,8 +328,7 @@ static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 }
 
 static int
-nftnl_obj_tunnel_parse_vxlan(struct nftnl_obj *e, struct nlattr *attr,
-			     struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_vxlan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_VXLAN_MAX + 1] = {};
 
@@ -364,9 +336,9 @@ nftnl_obj_tunnel_parse_vxlan(struct nftnl_obj *e, struct nlattr *attr,
 		return -1;
 
 	if (tb[NFTA_TUNNEL_KEY_VXLAN_GBP]) {
-		tun->u.tun_vxlan.gbp =
+		opts->vxlan.gbp =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP);
+		opts->flags |= (1 << NFTNL_TUNNEL_VXLAN_GBP);
 	}
 
 	return 0;
@@ -398,8 +370,7 @@ static int nftnl_obj_tunnel_erspan_cb(const struct nlattr *attr, void *data)
 }
 
 static int
-nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
-			      struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_erspan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {};
 
@@ -407,24 +378,24 @@ nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
 		return -1;
 
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]) {
-		tun->u.tun_erspan.version =
+		opts->erspan.version =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION);
+		opts->flags |= (1 << NFTNL_TUNNEL_ERSPAN_VERSION);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]) {
-		tun->u.tun_erspan.u.v1_index =
+		opts->erspan.v1.index =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX);
+		opts->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]) {
-		tun->u.tun_erspan.u.v2.hwid =
+		opts->erspan.v2.hwid =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]);
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID);
+		opts->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]) {
-		tun->u.tun_erspan.u.v2.dir =
+		opts->erspan.v2.dir =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]);
-		e->flags |= (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
+		opts->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR);
 	}
 
 	return 0;
@@ -450,22 +421,36 @@ static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
+
 static int
 nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *attr,
 			    struct nftnl_obj_tunnel *tun)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {};
+	struct nftnl_tunnel_opts *opts = NULL;
 	int err = 0;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_opts_cb, tb) < 0)
 		return -1;
 
 	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		err = nftnl_obj_tunnel_parse_vxlan(e, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN],
-						   tun);
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+		if (!opts)
+			return -1;
+
+		err = nftnl_obj_tunnel_parse_vxlan(opts, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]);
 	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		err = nftnl_obj_tunnel_parse_erspan(e, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
-						    tun);
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+		if (!opts)
+			return -1;
+
+		err = nftnl_obj_tunnel_parse_erspan(opts, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]);
+	}
+
+	if (opts) {
+		tun->tun_opts = opts;
+		e->flags |= (1 << NFTNL_OBJ_TUNNEL_OPTS);
 	}
 
 	return err;
@@ -532,6 +517,138 @@ static int nftnl_obj_tunnel_snprintf(char *buf, size_t len,
 	return snprintf(buf, len, "id %u ", tun->id);
 }
 
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type)
+{
+	struct nftnl_tunnel_opts *opts;
+
+	switch (type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return NULL;
+	}
+
+	opts = calloc(1, sizeof(struct nftnl_tunnel_opts));
+	if (!opts)
+		return NULL;
+
+	opts->type = type;
+
+	return opts;
+}
+
+static int nftnl_tunnel_opts_vxlan_set(struct nftnl_tunnel_opts *opts, uint16_t type,
+				       const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_VXLAN_GBP:
+		memcpy(&opts->vxlan.gbp, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+static int nftnl_tunnel_opts_erspan_set(struct nftnl_tunnel_opts *opts, uint16_t type,
+					const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_ERSPAN_VERSION:
+		memcpy(&opts->erspan.version, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V1_INDEX:
+		memcpy(&opts->erspan.v1.index, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_HWID:
+		memcpy(&opts->erspan.v2.hwid, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_DIR:
+		memcpy(&opts->erspan.v2.dir, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+int nftnl_tunnel_opts_set(struct nftnl_tunnel_opts *opts, uint16_t type,
+			  const void *data, uint32_t data_len)
+{
+	switch (opts->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+		return nftnl_tunnel_opts_vxlan_set(opts, type, data, data_len);
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		return nftnl_tunnel_opts_erspan_set(opts, type, data, data_len);
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+static void nftnl_tunnel_opts_build_vxlan(struct nlmsghdr *nlh,
+					  struct nftnl_tunnel_opts *opts)
+{
+	struct nlattr *nest, *nest_inner;
+
+	if (opts->flags & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
+		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
+				 htonl(opts->vxlan.gbp));
+		mnl_attr_nest_end(nlh, nest_inner);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+static void nftnl_tunnel_opts_build_erspan(struct nlmsghdr *nlh,
+					   struct nftnl_tunnel_opts *opts)
+{
+	struct nlattr *nest, *nest_inner;
+
+	if (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_VERSION) &&
+	    (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX) ||
+	     (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID) &&
+	      opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)))) {
+		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+				 htonl(opts->erspan.version));
+		if (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX))
+			mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
+					 htonl(opts->erspan.v1.index));
+		if (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
+					opts->erspan.v2.hwid);
+		if (opts->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
+					opts->erspan.v2.dir);
+		mnl_attr_nest_end(nlh, nest_inner);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
+			     struct nftnl_tunnel_opts *opts)
+{
+	switch (opts->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+		nftnl_tunnel_opts_build_vxlan(nlh, opts);
+		break;
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		nftnl_tunnel_opts_build_erspan(nlh, opts);
+		break;
+	}
+}
+
 static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
 	[NFTNL_OBJ_TUNNEL_ID]		= { .maxlen = sizeof(uint32_t) },
 	[NFTNL_OBJ_TUNNEL_IPV4_SRC]	= { .maxlen = sizeof(uint32_t) },
@@ -544,11 +661,7 @@ static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
 	[NFTNL_OBJ_TUNNEL_FLAGS]	= { .maxlen = sizeof(uint32_t) },
 	[NFTNL_OBJ_TUNNEL_TOS]		= { .maxlen = sizeof(uint8_t) },
 	[NFTNL_OBJ_TUNNEL_TTL]		= { .maxlen = sizeof(uint8_t) },
-	[NFTNL_OBJ_TUNNEL_VXLAN_GBP]	= { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_VERSION] = { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX] = { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID] = { .maxlen = sizeof(uint8_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_TUNNEL_OPTS]		= { .maxlen = sizeof(struct nftnl_tunnel_opts *) },
 };
 
 struct obj_ops obj_ops_tunnel = {
-- 
2.30.2


--eASaaeUYi2+mvofA--
