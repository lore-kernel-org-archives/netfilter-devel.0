Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D8228BAB5
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749548859; cv=none; b=MsCO5afamLVO4ERreBmqTFZdoIBS1Z72fGZFAGL3kGlmRIjAxw6IBgMU67jQLfxs6d9XLLLQOZ7AKhWMEjZZnVNqyWuPnOeAHn8blaZf+/NlKGtWE8fNKkwZDFIgaPbTy6IQkKalrnbF7j0VoCJfY6bwDs9TVX9FZIYemWxEYcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749548859; c=relaxed/simple;
	bh=7hXJWu9X7cr2yB3jKTJQJaSf8ppvpNivUSUBRN6fZPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJ6yFtVu7i2FXInXZABRgFHLLBek6AycKJ/Vx85A4VwMt0EjszubwWQyRMj/KRfsVVmLUiRCKI8PamhkXygmYHbZNy0HsKPtPdzJaMzMGllgBFv804OTP7lRvgUGdFmi5j3AbNrT+9rx9vrZVyVQob6cjV8TKntDRR9fYNblsJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qjHZPLgO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j1JrUXx+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qjHZPLgO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j1JrUXx+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0DF466060F; Tue, 10 Jun 2025 11:47:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749548853;
	bh=PSBU8iWeBbI5vJFSMpPd8SnPd1LQXgvRijZcag+ZoP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qjHZPLgO7C4j/bjVsYQnCA3T0hFYvaoh3j5x+2n7ez02ZnZ9QpXH5DT04dy7fTwp0
	 bqvTshD5wzCGJMTJ/30TIbeoaOaMeDOTulmjVazetybZJmdgOEVK55kld9+7/RWAaZ
	 wX5ISZsxHkdTM+4wtwaoNRbAcN2wzjvOz9jR8vHjaNnEqMHGGq6Q4+l+zYmUshFMzY
	 YVVEVaSB2oNhGoDdbvooZs7RBWG/WuDJprQGxQY5XMoOH9NoL8YNIXdq7rsfKpcHVK
	 NFKyRJ3K1SYQF3y81T4JSeSsskO8rTs4lVGRTIiyK3Ic/6jzMWRpYSf75kdALA9drB
	 yOASy9pkBvd2Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9AA306024E;
	Tue, 10 Jun 2025 11:47:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749548847;
	bh=PSBU8iWeBbI5vJFSMpPd8SnPd1LQXgvRijZcag+ZoP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1JrUXx+NpFr0rb1MZT6klCK4y6TZh34Gbh6JFxmh30pdY7gzABaV3RvoYYVtNnbR
	 Z/sCTmEVSH0FBHeYKy6h9qbS/APKRyyGKJwd1Z2GnZrVA1Zp+POIPYVOlGIi4XpTKF
	 XutcKdbrOXzRm0Elq03jSKiIu4fTZOjpkL4bCeXBwWTJLZTS1L9LDts1CYUmiE634O
	 16vZIetFqNh8Ot7O2/Sw0G4lPxvsdBFb6SQPRSkiZEo3ArXAiPx88EJtDrLYABwhfc
	 wx/j518ZdOJ5IeI6l+gE2f4o5YoROVkiXZ3pg94m9b5El83P4pc6OHlwM1SR1E/aiv
	 0Dw/CAYcvwRew==
Date: Tue, 10 Jun 2025 11:47:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aEf_LPJT1cFjYknu@calendula>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
 <aDZaAl1r0iWkAePn@strlen.de>
 <aEd8Nfv5Zce1p0FD@calendula>
 <aEfKRbJehyaq1p8S@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7mB+q3SAaKvrhBFa"
Content-Disposition: inline
In-Reply-To: <aEfKRbJehyaq1p8S@strlen.de>


--7mB+q3SAaKvrhBFa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jun 10, 2025 at 08:01:41AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Hmm, this looks like the API leaks internal data layout from nftables to
> > > libnftnl and vice versa?  IMO thats a non-starter, sorry.
> > > 
> > > I see that options are essentially unlimited values, so perhaps nftables
> > > should build the netlink blob(s) directly, similar to nftnl_udata()?
> > > 
> > > Pablo, any better idea?
> > 
> > Maybe this API for tunnel options are proposed in this patch?
> 
> Looks good, thanks Pablo!
> 
> > Consider this a sketch/proposal, this is compiled tested only.
> > 
> > struct obj_ops also needs a .free interface to release the tunnel
> > options object.
> 
> nftnl_tunnel_opts_set() seems to be useable for erspan and vxlan.
> 
> Do you have a suggestion for the geneve case where 'infinite' options
> get added?
> 
> Maybe add nftnl_tunnel_opts_append() ? Or nftnl_tunnel_opts_add(), so
> api user can push multiple option objects to a tunnel, similar to how
> rules get added to chains?

nftnl_tunnel_opts_add() sounds good.

It should be possible to replace nftnl_tunnel_opts_set() by
nftnl_tunnel_opts_add(), then a single function for this purpose is
provided. As for vxlan and erpan, allow only one single call to
nftnl_tunnel_opts_add().

See attachment, compile tested only.

> Would probably require a few more api calls including iterators.
> 
> Fernando, do you spot anything else thats missing for your use cases?

--7mB+q3SAaKvrhBFa
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-tunnel-rework-options.patch"

From a8bc6cc58ae4728134e7dc16bf4e553c2c58e176 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 10 Jun 2025 01:43:28 +0200
Subject: [PATCH libnftnl,v2,WIP] tunnel: rework options

Only vxlan gbp can work before this patch because
NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR is off by one in the internal object
flags.

Replace them by NFTNL_OBJ_TUNNEL_OPTS and add two new opaque
nftnl_tunnel_opts and nftnl_tunnel_opt structs to represent tunnel
options.

- nftnl_tunnel_opt_alloc() allocates one tunnel option.
- nftnl_tunnel_opt_set() to sets it up.

Then, to manage the list of options:

- nftnl_tunnel_opts_alloc() allocates a list of tunnel options.
- nftnl_tunnel_opts_add() adds a option to the list.

Although vxlan and erspan support for a single tunnel option at this
stage, this API prepares for supporting gevene which allows for more
tunnel options.

TODO: Missing .free interface for objects to release this list of
objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/object.h |  38 +++-
 include/obj.h             |  16 +-
 src/obj/tunnel.c          | 353 +++++++++++++++++++++++++++++---------
 3 files changed, 306 insertions(+), 101 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 9930355bb8f0..8ce62b7d97a2 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -112,14 +112,42 @@ enum {
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
+struct nftnl_tunnel_opt;
+struct nftnl_tunnel_opts;
+
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
+int nftnl_tunnel_opts_add(struct nftnl_tunnel_opts *opts,
+			  struct nftnl_tunnel_opt *opt);
+
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type);
+int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+			 const void *data, uint32_t data_len);
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
index 8941e39ffb03..0c901f4848c4 100644
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
@@ -335,6 +288,35 @@ static int nftnl_obj_tunnel_parse_ip6(struct nftnl_obj *e, struct nlattr *attr,
 	return 0;
 }
 
+struct nftnl_tunnel_opt {
+	struct list_head			list;
+
+	enum nftnl_tunnel_type			type;
+	uint32_t				flags;
+
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
+struct nftnl_tunnel_opts {
+	enum nftnl_tunnel_type			type;
+	uint32_t				num;
+	struct list_head			opts_list;
+};
+
 static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -354,21 +336,29 @@ static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type);
+
 static int
-nftnl_obj_tunnel_parse_vxlan(struct nftnl_obj *e, struct nlattr *attr,
-			     struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_vxlan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_VXLAN_MAX + 1] = {};
+	struct nftnl_tunnel_opt *opt;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_vxlan_cb, tb) < 0)
 		return -1;
 
+	opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+	if (!opt)
+		return -1;
+
 	if (tb[NFTA_TUNNEL_KEY_VXLAN_GBP]) {
-		tun->u.tun_vxlan.gbp =
+		opt->vxlan.gbp =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP);
+		opt->flags |= (1 << NFTNL_TUNNEL_VXLAN_GBP);
 	}
 
+	list_add_tail(&opt->list, &opts->opts_list);
+
 	return 0;
 }
 
@@ -398,35 +388,41 @@ static int nftnl_obj_tunnel_erspan_cb(const struct nlattr *attr, void *data)
 }
 
 static int
-nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
-			      struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_erspan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {};
+	struct nftnl_tunnel_opt *opt;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_erspan_cb, tb) < 0)
 		return -1;
 
+	opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+	if (!opt)
+		return -1;
+
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]) {
-		tun->u.tun_erspan.version =
+		opt->erspan.version =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_VERSION);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]) {
-		tun->u.tun_erspan.u.v1_index =
+		opt->erspan.v1.index =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]) {
-		tun->u.tun_erspan.u.v2.hwid =
+		opt->erspan.v2.hwid =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]);
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]) {
-		tun->u.tun_erspan.u.v2.dir =
+		opt->erspan.v2.dir =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]);
-		e->flags |= (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR);
 	}
 
+	list_add_tail(&opt->list, &opts->opts_list);
+
 	return 0;
 }
 
@@ -450,22 +446,36 @@ static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
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
@@ -532,6 +542,191 @@ static int nftnl_obj_tunnel_snprintf(char *buf, size_t len,
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
+	INIT_LIST_HEAD(&opts->opts_list);
+
+	return opts;
+}
+
+int nftnl_tunnel_opts_add(struct nftnl_tunnel_opts *opts,
+			  struct nftnl_tunnel_opt *opt)
+{
+	if (opt->type != opts->type) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	switch (opts->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		if (opts->num > 0) {
+			errno = EEXIST;
+			return -1;
+		}
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	list_add_tail(&opt->list, &opts->opts_list);
+
+	return 0;
+}
+
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type)
+{
+	struct nftnl_tunnel_opt *opt;
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
+	opt = calloc(1, sizeof(struct nftnl_tunnel_opt));
+	if (!opt)
+		return NULL;
+
+	opt->type = type;
+
+	return opt;
+}
+
+static int nftnl_tunnel_opt_vxlan_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+				      const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_VXLAN_GBP:
+		memcpy(&opt->vxlan.gbp, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+static int nftnl_tunnel_opt_erspan_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+				       const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_ERSPAN_VERSION:
+		memcpy(&opt->erspan.version, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V1_INDEX:
+		memcpy(&opt->erspan.v1.index, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_HWID:
+		memcpy(&opt->erspan.v2.hwid, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_DIR:
+		memcpy(&opt->erspan.v2.dir, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+			 const void *data, uint32_t data_len)
+{
+	switch (opt->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+		return nftnl_tunnel_opt_vxlan_set(opt, type, data, data_len);
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		return nftnl_tunnel_opt_erspan_set(opt, type, data, data_len);
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+static void nftnl_tunnel_opt_build_vxlan(struct nlmsghdr *nlh,
+					 const struct nftnl_tunnel_opt *opt)
+{
+	struct nlattr *nest_inner;
+
+	if (opt->flags & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
+				 htonl(opt->vxlan.gbp));
+		mnl_attr_nest_end(nlh, nest_inner);
+	}
+}
+
+static void nftnl_tunnel_opt_build_erspan(struct nlmsghdr *nlh,
+					  const struct nftnl_tunnel_opt *opt)
+{
+	struct nlattr *nest_inner;
+
+	if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_VERSION) &&
+	    (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX) ||
+	     (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID) &&
+	      opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)))) {
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+				 htonl(opt->erspan.version));
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX))
+			mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
+					 htonl(opt->erspan.v1.index));
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
+					opt->erspan.v2.hwid);
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
+					opt->erspan.v2.dir);
+		mnl_attr_nest_end(nlh, nest_inner);
+	}
+}
+
+void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
+			     struct nftnl_tunnel_opts *opts)
+{
+	const struct nftnl_tunnel_opt *opt;
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+
+	list_for_each_entry(opt, &opts->opts_list, list) {
+		switch (opts->type) {
+		case NFTNL_TUNNEL_TYPE_VXLAN:
+			nftnl_tunnel_opt_build_vxlan(nlh, opt);
+			break;
+		case NFTNL_TUNNEL_TYPE_ERSPAN:
+			nftnl_tunnel_opt_build_erspan(nlh, opt);
+			break;
+		}
+	}
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
 	[NFTNL_OBJ_TUNNEL_ID]		= { .maxlen = sizeof(uint32_t) },
 	[NFTNL_OBJ_TUNNEL_IPV4_SRC]	= { .maxlen = sizeof(uint32_t) },
@@ -544,11 +739,7 @@ static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
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


--7mB+q3SAaKvrhBFa--
