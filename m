Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6EC20C47E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 21:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730929063; cv=none; b=dH2B3/IiEf2KrENDFg3nraQ1p+1PZqtBrSv8MVJgM+b9vB7mLnXC1B1lbvhHeksTrdnBNv09v0A/nv/h1wPqZGKyT6Or5uDOBj4ydTwVtKRuZWt/9zBJ7WKobAc6s0yWcECPGyiLmiOaQQ/XILlhumJwB9dXxTBlmQTEneuC1yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730929063; c=relaxed/simple;
	bh=ns67C/BQnqLU+rMKxn2lZJhID9Ubh/mo990c7FfSSd8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KXJw4FLwQHQ4xu5/g9dQ1t+17Xt1iUCRup8P6fbjmOisgJiKjuGfvzT/NnGlrtb/VmPOR+orjHYjAMDEoekLw915ZBw+yeL0y27m8hP7O06sHnOwUjjE9HtuPk2zuwz4G2DUgLT8JkG0F7MC8FHGdqEaJZgOXLxN+92Sgd/sXXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CCwYEMYr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CCwYEMYr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730929060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YV3axQsGEJ50qpHJdWfIL4Kylk3egm3V/oNR8O82ej0=;
	b=CCwYEMYrXYl64P1tLV0yCUWk4DBrSqdjX76ZByMvzYK77818BKrwdkIQl7FVUVumbqfQRY
	DfrTQJeDwTs1P7mnQDFw1O7OtNJNl2a8AxuQDxXNP4vSykprclYd6jdFvEDvBMz7MaE8CN
	eu68+4qtNy4uh+xkCSY/0Mlz8zo6708=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-Z3JRMh9-OdSCvXHvrZxP0Q-1; Wed, 06 Nov 2024 16:37:39 -0500
X-MC-Unique: Z3JRMh9-OdSCvXHvrZxP0Q-1
X-Mimecast-MFC-AGG-ID: Z3JRMh9-OdSCvXHvrZxP0Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314a22ed8bso1877165e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Nov 2024 13:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730929056; x=1731533856;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YV3axQsGEJ50qpHJdWfIL4Kylk3egm3V/oNR8O82ej0=;
        b=tWS1TBJPuJ8tW8rTc2LZoPK6tXsA0sMn4qbjUSP+54aRXH8G28cPPDOqMM76d5kIgY
         xvDWBfHlkfZ0PKzwNrSq6Gsj+44GiCleoU9It2U6iOY1UZfE9u0OetVqbsKDxRK0bqX1
         T2kZSkHu5y9lzBi/D87ix2++UXf8jseLUJe9K99cTbxthv2GNK43g995Et3bSJ2+JXGr
         cQ5P/qSQrF8QYNaU7nwv+/Dxqssa4l9HrFz0o+iazoqoOnSHTiKzx1TgXQpImKlse1mS
         lyhkDf5lm/3aP1dd9mjn3y1xh404oXhXzypPb6H5cV6MGJvX/tyRVnQxWR/X54UvMDdn
         mvUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD1Fcx8BiKpnk1wOgtP7AH8CmJneXmICUS2NJ6QNSqcUFi0+GweG2cpn49lS3pOA1+edFLBdYqKEQknIK0U2M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYV04Wl02ED5RHS+HofjOgKFwWdmYElLLRr6zwXFSioK2wdFX+
	Mk4YAnUuPSgQ2gkpqi6Z6Euw70yEAdweRHHc/sc9RtmT7FbuF8dzrjOzqIDetVT4Nn35LUoCAEc
	1sD/8AEdd+c6VjXBDF9PVCY2ytVxddeHM+w7gBAISZtz6o0ix+As6l9jY/896g4oOEg==
X-Received: by 2002:a5d:64ae:0:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-381be776602mr20876074f8f.17.1730929056506;
        Wed, 06 Nov 2024 13:37:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbkpQFHUZRdXmo+dnhte4YYrdw5L2sWqP9Fq7zpQvehKn9Ej9pPuiDg3MYJtL7c++nP6QDCg==
X-Received: by 2002:a5d:64ae:0:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-381be776602mr20876057f8f.17.1730929056046;
        Wed, 06 Nov 2024 13:37:36 -0800 (PST)
Received: from debian (2a01cb058d23d60051d26877cf512a7d.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:51d2:6877:cf51:2a7d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10e747csm20226026f8f.64.2024.11.06.13.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 13:37:35 -0800 (PST)
Date: Wed, 6 Nov 2024 22:37:32 +0100
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] ipv4: Prepare ip_route_output() to future
 .flowi4_tos conversion.
Message-ID: <0f10d031dd44c70aae9bc6e19391cb30d5c2fe71.1730928699.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Convert the "tos" parameter of ip_route_output() to dscp_t. This way
we'll have a dscp_t value directly available when .flowi4_tos will
eventually be converted to dscp_t.

All ip_route_output() callers but one set this "tos" parameter to 0 and
therefore don't need to be adapted to the new prototype.

Only br_nf_pre_routing_finish() needs conversion. It can just use
ip4h_dscp() to get the DSCP field from the IPv4 header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/route.h             | 6 +++---
 net/bridge/br_netfilter_hooks.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 586e59f7ed8a..0a690adfdff5 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -156,12 +156,12 @@ static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4
  * structure is only partially set, it may bypass some fib-rules.
  */
 static inline struct rtable *ip_route_output(struct net *net, __be32 daddr,
-					     __be32 saddr, u8 tos, int oif,
-					     __u8 scope)
+					     __be32 saddr, dscp_t dscp,
+					     int oif, __u8 scope)
 {
 	struct flowi4 fl4 = {
 		.flowi4_oif = oif,
-		.flowi4_tos = tos,
+		.flowi4_tos = inet_dscp_to_dsfield(dscp),
 		.flowi4_scope = scope,
 		.daddr = daddr,
 		.saddr = saddr,
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 17a5f5923d61..7f2f40cef5fe 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -406,7 +406,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				goto free_skb;
 
 			rt = ip_route_output(net, iph->daddr, 0,
-					     iph->tos & INET_DSCP_MASK, 0,
+					     ip4h_dscp(iph), 0,
 					     RT_SCOPE_UNIVERSE);
 			if (!IS_ERR(rt)) {
 				/* - Bridged-and-DNAT'ed traffic doesn't
-- 
2.39.2

