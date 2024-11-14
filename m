Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EB81BC49
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731600241; cv=none; b=Sr3qWo02uCwTU8ZZ25Yy0SZUjiL10CIhbobns4ByI/iny6EEaJyBKXOQasIiPRf00nrmjpz0ZwlSa4G9DkoeOzs63OfRBTmY4ZB0YYcKaG83j5CRvSn+xuYpinrpESx17wf/FIsFs7lOOnXyN61bUtZouZBnaigkJ3aL1oe2NxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731600241; c=relaxed/simple;
	bh=/2yVgvPPv3aXfOQJi71q4daFQATxY9ZKELeWvPMBSik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3SsonjMRXtjgNDUcTWecqLyuxSYDMwN3A4PsC9FTHThtXPYjZMABhiVM6cOyVQz7hqsdJYvqhs4li8HllAuxUgOEJADL17oBVNgUbY5xzu7FQqi3OgbJSnba6dDPQsVisCcKevi87xxdzsgSdjdlobs1SI4vy7HJsRd3FMmsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VuSNhs9z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VuSNhs9z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731600238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EjlJE+/lC5L7ZPMGgtq/FoQp051qXaiSxy9vB4GYSH0=;
	b=VuSNhs9zaDDTLYB68WCisPdVpfX0g9/iNbzUDdijnPXkz3KQ6dFD6fMHZDx0u9ZbOdRaaD
	vspfldNZHisOrDpG3flYjJNeOIEV0LK56+hobSvICS0Cqobt21Z5+tb7Y6iA7Q4MR2wXM1
	LK8busVf4clfk7xkELwErLN6NKR1/i8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-xJQ2jf3TMFK680GSz9WaNw-1; Thu, 14 Nov 2024 11:03:56 -0500
X-MC-Unique: xJQ2jf3TMFK680GSz9WaNw-1
X-Mimecast-MFC-AGG-ID: xJQ2jf3TMFK680GSz9WaNw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso6832535e9.3
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 08:03:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731600235; x=1732205035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjlJE+/lC5L7ZPMGgtq/FoQp051qXaiSxy9vB4GYSH0=;
        b=eKQQ0/7VOju+7rnx1Q/mcN9DDGvI9BG0K+TS7SMlUAOyJGN5gyhVysGzOYlMNCLZp4
         uWpzEQufR/vEpSAnwhjB7tX+YyO4jh6D+cetcjDz8xQrcHEesxPw7XM80Lbog3OhoQ1e
         Gjn50z+Qk26qaRdGMDA16AmyIUHdM2E3vQYgGIQ+zggHmCqYyKwYu1DL5U3fbxGSFMLa
         JwXtfVw/sLOxQ1xbilD2udkXyiijEDCprA2pSifhFiafB7zCz3q8Cq/5F3ClbqKtBFq/
         dIL6SsA2zWsGkn+hYQqdI5dvRDgJ/vZs2ZQ2tFjigd0RtwdEMUpa+B6kPTRXE4EkUM0a
         knUA==
X-Gm-Message-State: AOJu0YyA8ahRrSAybxYyJL5go3CSGOBrFxkTZbEdZAw44Sspc0AxnU8d
	2XePNVrF6uYV8Ir/9yWgd9KMbO39gj4EZZRlRy5pFGzb4GL16p8CmqkgEixvgi7Fpzht+ryubbR
	CpxcKw2Hy30ySvaEzGVIe/P0ESk+n4CAcyOKtYjL7sXdan7ve17qkyWbWP8pvPsTHyg==
X-Received: by 2002:a05:600c:4445:b0:431:3933:1d30 with SMTP id 5b1f17b1804b1-432b74fa9ebmr206811005e9.5.1731600235239;
        Thu, 14 Nov 2024 08:03:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIq0+gxNtceIikEHqFUZPtVSZ/7OAVpCZWCan8/A7VNDPjxn0VoCwdnyW4RTJA13xeF7j+aQ==
X-Received: by 2002:a05:600c:4445:b0:431:3933:1d30 with SMTP id 5b1f17b1804b1-432b74fa9ebmr206810235e9.5.1731600234490;
        Thu, 14 Nov 2024 08:03:54 -0800 (PST)
Received: from debian (2a01cb058d23d600b637ad91a758ba3f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:b637:ad91:a758:ba3f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da24498csm29001615e9.1.2024.11.14.08.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:03:54 -0800 (PST)
Date: Thu, 14 Nov 2024 17:03:52 +0100
From: Guillaume Nault <gnault@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH nf-next 5/5] netfilter: nf_dup4: Convert nf_dup_ipv4_route()
 to dscp_t.
Message-ID: <ee8e4571b2bccf6e84503d88686243fb2ff6a82d.1731599482.git.gnault@redhat.com>
References: <cover.1731599482.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1731599482.git.gnault@redhat.com>

Use ip4h_dscp() instead of reading iph->tos directly.

ip4h_dscp() returns a dscp_t value which is temporarily converted back
to __u8 with inet_dscp_to_dsfield(). When converting ->flowi4_tos to
dscp_t in the future, we'll only have to remove that
inet_dscp_to_dsfield() call.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index ec94ee1051c7..25e1e8eb18dd 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -33,7 +33,7 @@ static bool nf_dup_ipv4_route(struct net *net, struct sk_buff *skb,
 		fl4.flowi4_oif = oif;
 
 	fl4.daddr = gw->s_addr;
-	fl4.flowi4_tos = iph->tos & INET_DSCP_MASK;
+	fl4.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(iph));
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
 	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
-- 
2.39.2

