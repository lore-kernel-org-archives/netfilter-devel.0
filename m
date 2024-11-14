Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789A14E2D6
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731600220; cv=none; b=Z6i5E3f4TpF6GxB8YqV/AfzE7o+19+c9QopR/6uJUPz4B2zubfYFxM29nrw3myFove6Vn4ZdgDdFfrlbTBBx+5ocKII5IBnrZVDzZLKEnqJ3OaY7jbzuFNTFvGH+I2b4hy/BuYnykZeeB4AXtcaoJXS+6jPWbAe9AX6f0Bvfrsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731600220; c=relaxed/simple;
	bh=5RknSn7bVZ9Sp8G0NfIi7txZbEwVmyyLhHOcziJAz7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+EUH4X2M6sE6AK771ym2ykdZ/1jEVtbk+30w2tq6Cxd4zDA9iTkLHU+mKk1gCqUbBg2oDVu0a5pIMSO+FV/Naw5RJOhqIipNk8eXTNuIwPc/PoL7Rk66s1fMxXL6RUpHL5mb+as8DBiUfn0PJHhTdssCDsAxzUBNpR9XcGnk3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VrIrkF5+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VrIrkF5+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731600218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jFJBfZsuRNKlRmGlsq7skNCrEogTFO/7vDcCzJF9P+M=;
	b=VrIrkF5+YQDe0n9qOZ6Z7cIGVwaLI3BLU67ainKhaugML90KIvi4O4uwDYb5snXcXS0a0a
	O4CcYmKFb5FrGwBXLBdQMQKWQ/VVUeSV356HmxlbAUHUPDDrvmFCutX0cEwrD4S6axhMLR
	zGmK1PAlROxmAWSsV3O5BUZ8hpnkX1I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-jfujAYzLPjSbgtrahkcWhQ-1; Thu, 14 Nov 2024 11:03:37 -0500
X-MC-Unique: jfujAYzLPjSbgtrahkcWhQ-1
X-Mimecast-MFC-AGG-ID: jfujAYzLPjSbgtrahkcWhQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43154a0886bso5879705e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 08:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731600216; x=1732205016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFJBfZsuRNKlRmGlsq7skNCrEogTFO/7vDcCzJF9P+M=;
        b=gCibQHd8Pyr3xNIKjKFHRqYdZxHtR6YzUSFV3ldieZ5yOnEOOVSzRhTIpox9/qoNc2
         n8c5BJCYctE3Lzh7qAmGfIlIFHLJ97pqdY1Y15L4nIaZPDD13j8VtxgYV6FyqTcSY/bc
         4hAFD2N5EDjvyAW7yuLpV76VmE7P1xN7ZXq2ZpFBcugUmLnrT09EhwJF267SmwEfcN2T
         vg1H5ZYpXZ4cGnsD6F9lmIWXmkILSrD8yOkKALNI79l48EfQENcoY7EJHaEqOhGjzQ77
         5NAf+9FUk5g8F+GUOBzTbxwIlVXoz8NqKXzsL4MvUD57ZPmI1jTqJfDl08+DMdftWset
         x4OQ==
X-Gm-Message-State: AOJu0YwiSlVULs1yknz+nsaW0M9XkYvGQcPPoVRtKc7gDRoFvTmPW68J
	LDYm49RYPqjcjgYYCq76knKd+U5aCo4N1G6jk3SATVTk+gcJhTYYKeyPNYQFAuqFFrR17FduYS8
	DhhLe5PVhw0T7i+VDiK7TVu4PyXJTCOper5Nos8IsJf43maTnrJAX8adufpagaFRs9w==
X-Received: by 2002:a05:600c:468d:b0:425:80d5:b8b2 with SMTP id 5b1f17b1804b1-432da790aa3mr28802625e9.16.1731600215794;
        Thu, 14 Nov 2024 08:03:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPYCo/VbNnJPfZ9jCSUk1Uk+WXO2Lu9MT54UrcQ1GHUqbnEPX5xx7mMsc6HvBXUQYcJYRBSA==
X-Received: by 2002:a05:600c:468d:b0:425:80d5:b8b2 with SMTP id 5b1f17b1804b1-432da790aa3mr28800225e9.16.1731600213753;
        Thu, 14 Nov 2024 08:03:33 -0800 (PST)
Received: from debian (2a01cb058d23d600b637ad91a758ba3f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:b637:ad91:a758:ba3f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ada3199sm1826311f8f.22.2024.11.14.08.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:03:33 -0800 (PST)
Date: Thu, 14 Nov 2024 17:03:31 +0100
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
Subject: [PATCH nf-next 2/5] netfilter: flow_offload: Convert
 nft_flow_route() to dscp_t.
Message-ID: <36ab64916593c2cd88cbc17b8369ee4bbe97182d.1731599482.git.gnault@redhat.com>
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

Use ip4h_dscp()instead of reading ip_hdr()->tos directly.

ip4h_dscp() returns a dscp_t value which is temporarily converted back
to __u8 with inet_dscp_to_dsfield(). When converting ->flowi4_tos to
dscp_t in the future, we'll only have to remove that
inet_dscp_to_dsfield() call.

Also, remove the comment about the net/ip.h include file, since it's
now required for the ip4h_dscp() helper too.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/netfilter/nft_flow_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 65199c23c75c..3b474d235663 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -8,7 +8,7 @@
 #include <linux/spinlock.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/ip.h> /* for ipv4 options. */
+#include <net/ip.h>
 #include <net/inet_dscp.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -236,7 +236,7 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
 		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
 		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
-		fl.u.ip4.flowi4_tos = ip_hdr(pkt->skb)->tos & INET_DSCP_MASK;
+		fl.u.ip4.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(ip_hdr(pkt->skb)));
 		fl.u.ip4.flowi4_mark = pkt->skb->mark;
 		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 		break;
-- 
2.39.2

