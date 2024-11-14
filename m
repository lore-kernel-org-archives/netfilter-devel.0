Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44F17A583
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731600226; cv=none; b=JuDu1tfI4xGxPuqNsS8AtN2g5TzAS6N9b+yfvt3lBOUHQ9ehnCb4GAVuT/Go9K91OzcN9Nt9QoZaFkdKl5sWg52ef+EU6WrYwSiTEtQJFuKkqRIKEwwWzKwzzTesKJxWQfdfL35XW19ybDa9n89HG0D9ZIVDXy23K4YbtM3Om6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731600226; c=relaxed/simple;
	bh=Hg/efvizYk8WzQ8t6Lg1MCcYIg9RXN1TCtGqMqSSU8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNNZ1sxJc3llhzfihhqPaaY1xTsjwhhBPE3kRadhcjWtx/ZUvqa7kBMi5qfDRzM8484U/hKT8psj0Dqz6g3s5QmCCtoc7nwvg0/TGWilN2wGvaOXRLgScXFgGto+ThniVplr0Fj64Mjf9K5eb/72wiWgzucjnOHKAUqraweGcSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AkCqgOVj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AkCqgOVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731600224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZK9SQWS0kJT4zJcnUWs+bLoqvQwItt4OaoBKbfggh0=;
	b=AkCqgOVjX49lKdX4l/tPxuCFemsTPIPsHQ1O+cWrk9XugrE2FOcsknTcPRmbPdHl1BqIAn
	4KhrHUAIsC9sZSi8YUU7SjK9eLmLy8qDz1sFu3I3nYNWWaqtaI6T1pa80s1/pS2BeO6+xn
	rYJWjBHO287QkNV3fbCNGk4amX05cTM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-yv_7mXHrOYK4jhE8L3N4VA-1; Thu, 14 Nov 2024 11:03:43 -0500
X-MC-Unique: yv_7mXHrOYK4jhE8L3N4VA-1
X-Mimecast-MFC-AGG-ID: yv_7mXHrOYK4jhE8L3N4VA
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d5a3afa84so424651f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 08:03:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731600221; x=1732205021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZK9SQWS0kJT4zJcnUWs+bLoqvQwItt4OaoBKbfggh0=;
        b=reBPPfwrT2nDrPn1MA0jpaziCZSSgBB6k6aUlk2pLTJJuW6FxLgNPHluLU2voqqekU
         RMkiey9yMZhYl4npcVBbJBAd4jHsKDv2oxnzgtkLnmFw9cegBoFRt7uIsU8Mb5iTr7i3
         pTa569ZP3yCKsfmIjh5VyrMnDy8Ny4jaZZBmxDtfEGjXywJGtMZKwO+YnlWMW+wZIjJz
         EwCTClxdNMfV+LmQHrQzuL2iEi2gVyeFu5vR/YwGsYhXkzBGMfyDjxSL1L2ge9PoY1Ti
         U9DQBi9uXeQ9NIYf+3iHejP4T9tpVdlvwcGSVZ5GpUbFFrEV6VBnNVliyReMcASO2lFj
         l2fQ==
X-Gm-Message-State: AOJu0YwsmOnnI0u3A+j8nDIrBpSLI/7YuczW8emV/J5LH5YxDnUqYgIS
	nIIhsqeYDq6L/FNZk5ubpfzMQ5obTttUxTLWqCOmW2/K37mbFvJgCMuB9RGJZvOhbKUwSsGeZtP
	NOPdnzxkjvk9rGDUGvuNsZG6O930zJr1oxIUA04KM12PFkU79zj1hOYt5dkFMNs0Erb4r6KXqWA
	==
X-Received: by 2002:a5d:5985:0:b0:37c:babe:2c49 with SMTP id ffacd0b85a97d-38218503517mr1977155f8f.19.1731600221339;
        Thu, 14 Nov 2024 08:03:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFfSQUSDvP1nWEf6H6Zqi3hDixWY32tbX9uiJ7MWMgWsWz+YUcQP0Fk0Y+bRF07oOjfdSFOBg==
X-Received: by 2002:a5d:5985:0:b0:37c:babe:2c49 with SMTP id ffacd0b85a97d-38218503517mr1977125f8f.19.1731600220785;
        Thu, 14 Nov 2024 08:03:40 -0800 (PST)
Received: from debian (2a01cb058d23d600b637ad91a758ba3f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:b637:ad91:a758:ba3f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821adad9cesm1813271f8f.37.2024.11.14.08.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:03:40 -0800 (PST)
Date: Thu, 14 Nov 2024 17:03:38 +0100
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
Subject: [PATCH nf-next 3/5] netfilter: rpfilter: Convert rpfilter_mt() to
 dscp_t.
Message-ID: <20c7fe0c2c84b3fec77cdbfd7df4b587a0225fcd.1731599482.git.gnault@redhat.com>
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
 net/ipv4/netfilter/ipt_rpfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 1ce7a1655b97..a27782d7653e 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.daddr = iph->saddr;
 	flow.saddr = rpfilter_get_saddr(iph->daddr);
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	flow.flowi4_tos = iph->tos & INET_DSCP_MASK;
+	flow.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(iph));
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
 	flow.flowi4_uid = sock_net_uid(xt_net(par), NULL);
-- 
2.39.2

