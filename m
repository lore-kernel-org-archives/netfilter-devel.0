Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923643D96D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731600210; cv=none; b=gkj8WgKqV/cJLeeVhZ7sVlbKu48vYghSB6b425sboWNY7Jqwygna3K4PHUzzo4MJhDlIdwAkL8UDaaZpNha2SidVoeDbCNL4lq3NYJtpVZj9GoY9FpLyoszPc76GBsuMDkfQ8/2y7Vi7NfkkNovw31OFY84SVXh6XqYUK6v8iZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731600210; c=relaxed/simple;
	bh=jcb9INSeS+o4efk8lCAVbHCe4vqWALUQyWP3Atueu9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3//73YLaurSJYNMbVStNGAMSXGcELy7+dMqlj/SNEY5mZ7H9rcKLk2fdkme1/xqJa5CxVtOe8grak+vWFJoLhQIX6AxxbGYkWFsEMurZYTwUmEJZLgtdm/dN3jTqANxDqYhVdL14DGWSs3AlZKNAByfaEFyhpKTfa7fmACveoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AlE+/BZx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AlE+/BZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731600207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PAq1VgZl8277b2O0WHyEF4cn1whtIrQG1NG+aLkeoAA=;
	b=AlE+/BZx3IldgdnZcpLPyphk5ysCRkiJ4vGHO/NCRC4HwDpJy/e0fEqHSSMga0vp3AOoPy
	emVJt9V+ESEMKSr68HAxDE735q5/lGjjFH9NS0FoQZqvwBRyKaqMxV40r/lWHQ4ev8HBKM
	7th+EVwBLI9cYCeJXSMjKWLJ/ClD4NE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-ZSysSxKQP1GZXx5PksUTQA-1; Thu, 14 Nov 2024 11:03:26 -0500
X-MC-Unique: ZSysSxKQP1GZXx5PksUTQA-1
X-Mimecast-MFC-AGG-ID: ZSysSxKQP1GZXx5PksUTQA
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-53da09b1ca1so671446e87.3
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 08:03:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731600204; x=1732205004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAq1VgZl8277b2O0WHyEF4cn1whtIrQG1NG+aLkeoAA=;
        b=ItZIKvn4RrRB6N9cPGZ5un2jUk9gVr+fu1QA+pNZ6jj7PqMHLfVXLEk9Q3zaCWv4LE
         PLHk4rVGLnvvAdC7Nza38lEaptb8BwgKAiN1PiIcHbFnN0gSEG3EG0eOD4kQZ8IVJRVa
         J7rGTl7ZHnp6f1HKUf4y+hszNQmxjnBgeM95+tyC+WfrvIlZd8xImhmwxM6rwp5m14Qm
         EmEKDfAIz2J0IeGU5b+hocgtD1TM1hGVqaLrHYu+Zp6jg4kD3m1c6+w1hCPlg91uRRp2
         GmW9WeOJmi6J75C3MHVdJ3CQzoM5pnUicsSMTSzyoYbHqdmqL207YjCrWrn/eosnfDCE
         5z3g==
X-Gm-Message-State: AOJu0YysG1NV22mxLpWdTMyHiPmH/mp3dkxJFivQt1ooFPnNuZ1G3ol2
	/HxnqAVxDXrqKolKxzwCvolSWmMOoac6WGTLnvye+WwVurtC2wdLtP5009DUjRbZfbiiVJepqVJ
	+PhHyP46ZkgZytoJC5x/IPYGuciIO16ugq3K7xB21rWPkejoSQWVqr4OQh37scPa3Cw==
X-Received: by 2002:ac2:4c4f:0:b0:53a:16b:f14f with SMTP id 2adb3069b0e04-53d862c5a61mr12562602e87.19.1731600204439;
        Thu, 14 Nov 2024 08:03:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvbxPIAEHdn1mPbERhtCD7kSP6yeYuHglo67Z1qmJWvSZ/FPH+ZbCoGPmAtUoM379TrofBvw==
X-Received: by 2002:ac2:4c4f:0:b0:53a:16b:f14f with SMTP id 2adb3069b0e04-53d862c5a61mr12562551e87.19.1731600203888;
        Thu, 14 Nov 2024 08:03:23 -0800 (PST)
Received: from debian (2a01cb058d23d600b637ad91a758ba3f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:b637:ad91:a758:ba3f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265f28sm28577095e9.17.2024.11.14.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:03:23 -0800 (PST)
Date: Thu, 14 Nov 2024 17:03:21 +0100
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
Subject: [PATCH nf-next 1/5] netfilter: ipv4: Convert ip_route_me_harder() to
 dscp_t.
Message-ID: <799ab09e1cbd8b2070f8891518647352c82c3b02.1731599482.git.gnault@redhat.com>
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

Use ip4h_dscp()instead of reading iph->tos directly.

ip4h_dscp() returns a dscp_t value which is temporarily converted back
to __u8 with inet_dscp_to_dsfield(). When converting ->flowi4_tos to
dscp_t in the future, we'll only have to remove that
inet_dscp_to_dsfield() call.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index e0aab66cd925..08bc3f2c0078 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -44,7 +44,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	 */
 	fl4.daddr = iph->daddr;
 	fl4.saddr = saddr;
-	fl4.flowi4_tos = iph->tos & INET_DSCP_MASK;
+	fl4.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(iph));
 	fl4.flowi4_oif = sk ? sk->sk_bound_dev_if : 0;
 	fl4.flowi4_l3mdev = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
-- 
2.39.2

