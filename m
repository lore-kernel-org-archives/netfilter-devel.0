Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5413B293
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085833; cv=pass; b=bNB+wwQ+lU2XB4GsqKLMdQkwwb86OtpsFD/R00pr5j7KgSaNEaOJPehH//JcwvOAX7Z4qXGZZ8ZMS+jj/EB1jaS2pWjDzRvhMhwFcGLMAwUVNcttPN/harB79LH5PCuJdDdmJJFQwli6nTowJ88nXcNcK5skQTwomjnaK6MN7ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085833; c=relaxed/simple;
	bh=UhcXak3PP4CSJsJ+2ZmTXWyuXKO/e2C9z0rfeaGezsc=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ej0SYQRTYob0uN9Tna6q7FhR+s5CF1KKJdcchBNDAtTxqUtv0pTOj/f9H/ZvFzI+Cqkfigfa9Ks2iZJmnowBffYLc6kWeo/O6QMCATFqxb5CLfAszsSUb9t6xLY9dSHwshcUw6NS0/e7IbPnbnqDOfYZRN/+mxqJS7Hsv8SKH9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=XGSRsjBU; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="XGSRsjBU"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db22383fe8so1566165ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 17:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789085830; cv=none;
        d=google.com; s=arc-20260327;
        b=kGrYS175hgR+B3Pw2lwW1At64CGHGo5jua//Sc6+IHl9CY5CIecrgERuN4jidi1/lw
         iTbcJWCBsqF4NRj9NNdYpKtoVIXtQRwybnCX0WiFhPr1NFBBCafhQBSM06NDzD98V3dt
         KVOr+8vWot2XERMWNZR+9q9pYxKoyqNpaaE5w9KRdgMQgkouvLviNnkOjb/VT61kEsIk
         +O0D77PnGfxBpbWCeQUEa+LbwiRKGT8ahKnwQ5sncbQCO3OVJwmUcht4jMQ70/mhv51g
         fcvJLjtavvtzrZ1filzkJNYANDio8T18YYZj8TCmCK+Lg4CwvPYsFJA5/L3TIKyHTPNY
         6Shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=S44dTWF40G+fGHovL3O3dgYh1dI0740WCQy5o7cAbGo=;
        fh=sGncHQ6oks3tE5JSi6QNeLh9dV+r+39d0SaerodJOig=;
        b=k4VWyqJMDMh5ZC+FDPH7MPgoaYwvzlYoCi/qVNqHJS6Z7ZhBfhTe0SILznzCY0yjIq
         xv0/B59V/AKzVM7ICw/K9FDoPAzMXhhwC+YZSnIh+rbjP60fUBljbBp+5urXZ+lH1Vbb
         dKvsjmDzwGdplLUs0xbQ7XsIEnLmzLX6EPvAzj6OnXnJJ3kRls64Ll70cbCps+nJSzyI
         Pdntx8vu+tux89FXRkms1r7KNrFPM/UUX3z620HXz72S73NvPubyJmB3iCgqxucOloPP
         rHgcNOr6asn7stTv+Nb3dNgc/TpPqoYVpuut65wCpDjFEEuwX/Oc48XY/JQkED0GJnVw
         OWvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789085830; x=1789690630; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S44dTWF40G+fGHovL3O3dgYh1dI0740WCQy5o7cAbGo=;
        b=XGSRsjBUp4g76BmBhsyD4RnkmKpW1/+QL08F6ioVnKzv/M7EDTcin4QOOsu0JHX2QZ
         VNIVemujvk8kAa5UyYxQ48k9oPl4dA0KQqCjXkN+0UepeXO3atV5i2tpfvZTgPAGcwE8
         g5H5wB7CRNcRk7dWc48nNWf/70rfm8SVMeuVoAEU/biHkzRgslvYlWlxw/N1dqQsNbgX
         WQU0scJ3/C9BTHZzQvABQnWInCjoz/aZ71rVpEEnu87snffCPNbftdkIac3vCnMY81eI
         IF3QGDjRmwqLlX1yq3KCL1tP3+WogDKh9JxbMT0cEMu4AnDs1P+5s5OevOsq+ZxzbfsJ
         M0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085830; x=1789690630;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S44dTWF40G+fGHovL3O3dgYh1dI0740WCQy5o7cAbGo=;
        b=Rcp36kj1fzPjOf3V0Z2/wKnAaNo+uwPL0fNZDKc5bAaLL+wz9cWcHFDjNE/Y9WW6UQ
         kRW4hsCRLWxE1z747TiEZ1UiVDHBjnQBTVpu3Rpw8Su7jJoq1wuODGQWY0aJk0IgsUDO
         0hkWS3Zy8uwkp0zv6hb6zKrHFpWzACumPOZumB6u2wlJeUhrBEuu3sc2GdG4cXSv8xjh
         3izKTTdMNOo1hPxLh3JXV4ppAjjnOxI6PNFaSuMdKDb5H6jqU0jig1nf5wDTITxJBbEX
         zK1mkV8o6hmqWdnkncAEoj0KgGovH3Nam7fW2GW+hB6vKnFvJn4EY3SpTjF+lm5/+ZHu
         mpPg==
X-Forwarded-Encrypted: i=1; AKwUvBz2Hl7dNczRu71J1T0j/PWJiI4UlOj2sgnW+2KWBDbpYaQNZRih46D1OK5kkI8c4n87fJrso5FjclQk2MJTLQk=@vger.kernel.org
X-Gm-Message-State: AFuF++nxaOqQpyrz7eFXJwA7t4ILzKsj+WTUpjGgMu/phAillWvZguTO
	uZl/XRLZkUwY6ijTqSXet88kXH/LLNz4cOxk1wEk6i07A32UlJKIg9jLchUmrFIiGUsq0YaxnCf
	cCYI5QFtmP+Vzli+tGhv6Yy5iIlrEneyVM8Wh1Ctn
X-Gm-Gg: AYBFou1fQLgWuOjQaxgqXR0UhKBjDC8IM9jl1sDb/eUV3ZGjvJDKrno5wOFB+3Vyhcj
	mOioSpQXD3NUo6wb4R+FZ83WQqkHU7glNR2WGGmeFnn/YzMHB+iT3WqTxmhzqvogEVUz/zsbH8A
	3qMbC8M8ckTnxl3ckfOgxk5q9Tm5t2HwtFswtjKX4P3t66cwBF7NS66K+CGeqJNRktO4LQFEPP/
	J5yeDvqyiBWA1Zz41kpqqQmp/JdLuTot5+uFYwzCD/xziN7Jg7hGfJa3Mkj3TgqO1hexOjbNhoe
	PzFGe1dJX3aQ4KOjbX5pCLBNeP3ZFAoc8PoaqQhlhB8OGPlimpkDWs7ciaRwu45VbALT9Uv7t7I
	qfDxCcNbx7/favM7tpfl3HxkhgTUiTpkulnI1t5g4k/k=
X-Received: by 2002:a17:903:19cf:b0:2c9:e9db:8167 with SMTP id
 d9443c01a7336-2dd2a1ea679mr40406725ad.7.1789085829154; Thu, 10 Sep 2026
 17:17:09 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 00:17:08 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 00:17:08 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 00:17:08 +0000
X-Gm-Features: AcwNN1UI0Y2k7NpwvQMDJPRWXKOGhgWR9UD98ZG3_PEz1AwjbPB5B0x8KFFklCw
Message-ID: <CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com>
Subject: [PATCH net] net: reject a forward path that loops back to the tunnel
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: falemi@asu.edu, Simon Horman <horms@kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ipip_fill_forward_path() and ip6_tnl_fill_forward_path() assign the outer
route's device to ctx->dev without checking that it differs from the tunnel
device itself.  When a tunnel's outer route resolves back to that same
tunnel, the walk in dev_fill_forward_path() makes no progress and trips its
loop check WARN_ON_ONCE(last_dev == ctx->dev). Release the route and
return -EOPNOTSUPP when the resolved dst device equals ctx->dev, so the
path walk either advances to a different device or fails cleanly.

Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
---
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -375,6 +375,12 @@ static int ipip_fill_forward_path(struct
net_device_path_ctx *ctx,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);

+	/* The path walk must advance: a route back into the tunnel is a loop. */
+	if (rt->dst.dev == ctx->dev) {
+		ip_rt_put(rt);
+		return -EOPNOTSUPP;
+	}
+
 	path->type = DEV_PATH_TUN;
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1863,7 +1863,12 @@ static int ip6_tnl_fill_forward_path(struct
net_device_path_ctx *ctx,
 	fl6.flowi6_proto = 0;

 	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
-	if (!dst->error) {
+	err = dst->error;
+	/* The path walk must advance: a route back into the tunnel is a loop. */
+	if (!err && dst->dev == ctx->dev)
+		err = -EOPNOTSUPP;
+
+	if (!err) {
 		path->type = DEV_PATH_TUN;
 		path->tun.src_v6 = fl6.saddr;
 		path->tun.dst_v6 = fl6.daddr;
@@ -1873,7 +1878,6 @@ static int ip6_tnl_fill_forward_path(struct
net_device_path_ctx *ctx,
 		ctx->dev = dst->dev;
 	}

-	err = dst->error;
 	if (err)
 		dst_release(dst);
