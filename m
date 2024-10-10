Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057C1C2DC8
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728562765; cv=none; b=sPwyg8XyCbpGfkq8UIuTcBpdhLulwkoymvai6nS30Wx9YP7R1hMEnpktT6G/NT8GoxtAr2h/l3AavBmWmXwvQMThwyy9LdgHaE1ViuK4qwSqQYAJvZ3odNwuUF627jjqZkxH/aDUXCklL763TLVmu8bbEe6JhxThXyucDGerb+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728562765; c=relaxed/simple;
	bh=CkiGvMUprULzKM7bRxqHw8kfDvlhJpn7zt9ejDL5Yz0=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=Y/lwBC/l3J5zc5Jia2WgOTUlavmDdbLOWsoID59CzR/LHg5iyEYBTw0JXhqVwpd/kOQmB3Vo6tvTaQ+Hnew3oWDAC6mGtItsDiD9c8G7rDTJxzIcbhwA9BveSlHY9MluWuQw3PQ6ejMxIXjyctgSy7roAKWYkk6VRdsos4MVDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A5WTmHs+; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A5WTmHs+"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fabfc06c26so7175081fa.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 05:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728562761; x=1729167561; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9PqR7IFi4N3WTTH54vZihcGum71KjGAKIERyfxgT38=;
        b=A5WTmHs+e1Ahtiz1GUjSjM9ZNdw3xpSIBLjpeqTDgbC/+MzIjUip9cP/htGAuX4ItA
         z2SVR4qt7PecvX/kmz8AqdMkatFIFu7HXWxUKk8YpRnBWcznb5EI69zxAFTGQu/zdb+m
         LYLDdA04CbukeH2UzbWhsJYWZAH4R6Af+eBYRdWoFFKc53dI491CEYfoxfO1stPO+1Mg
         1Zy89YKNcuLkOsYzNpWV2HfRdFkeC4590vQayum3FR6QZNnkcytQ+fGM77ztPcI6wcR4
         BguG5fsvjsKjYRKNf4NbfPYovuzR+ywIwVaVVgZPgGZgtHkGdOekS6cjUMgAJ19FjKQh
         Jffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728562761; x=1729167561;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d9PqR7IFi4N3WTTH54vZihcGum71KjGAKIERyfxgT38=;
        b=q2G6UPnLWksGixwvxNGuYTgBOeLYg/k2zNQ9kEVMVJiqnvMG4qR21AdHFo98IqC/ns
         yBA55/+lmEd+Xaj2BwEbePaIA2fCAyXSC47SO8HCMITcZqRZjVnlf43/Du8UcczMt1KE
         z+sJ5BMOLSl0O/c5S3fGGl1i8gZSz0n7H5X56rkasImlrvqAoQdmtO/+worBqnli6r3S
         H4xw9ElhYmgnW+3+zJ6BbBd3XRhoZgfBEbv9n/lNPQhod7U6R8yoS/H4qFZVPO9S3YaP
         KuUakReoeh9RdD2xf0xRei7aU9/u3TXOophvonhF9NBqJBC1PL8ZmvssDI13txukgz0b
         i7gA==
X-Forwarded-Encrypted: i=1; AJvYcCXOXrR/PDCX4AzbbIQAxs4+4PYTbulnUbUnMbkUHEv8mIG8XDegqnNL+y1VEXWtqcKcXGRwIGCfbgmF7KIknZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaY520JMN2G8Q3C9RNYiW1GRpoI3h/ZusahQ4EvyGmNf8zv3lb
	EAGz7Lzw/dCwcU1jjTIPznfNcrSfFsP/mtHyeiuM//0NwOb3EfNb6BD02Lv/RiUxt2kpTeD52sT
	NSncWPnRK
X-Google-Smtp-Source: AGHT+IFJ7oHj0SOZm86/VEOHHk2xu5ejOVEJIv4t2g+uktpV/IB41OxC99uqTj7rzOJoRGI9lDDIFQ==
X-Received: by 2002:a2e:742:0:b0:2fb:cc0:2a05 with SMTP id 38308e7fff4ca-2fb187f803emr31546181fa.37.1728562761559;
        Thu, 10 Oct 2024 05:19:21 -0700 (PDT)
Received: from [10.202.96.10] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c2167d9sm8550055ad.229.2024.10.10.05.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 05:19:20 -0700 (PDT)
Message-ID: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
Date: Thu, 10 Oct 2024 20:19:16 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Yadan Fan <ydfan@suse.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 Michal Kubecek <mkubecek@suse.de>, Hannes Reinecke <hare@kernel.org>
Content-Language: en-US
Subject: [PATCH] nf_conntrack_proto_udp: Set ASSURED for NAT_CLASH entries to
 avoid packets dropped
X-Mozilla-News-Host: news://news://nntp.lore.kernel.org:119
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

c46172147ebb brought the logic that never setting ASSURED to drop NAT_CLASH replies
in case server is very busy and early_drop logic kicks in.

However, this will drop all subsequent UDP packets that sent through multiple threads
of application, we already had a customer reported this issue that impacts their business,
so deleting this logic to avoid this issue at the moment.

Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")

Signed-off-by: Yadan Fan <ydfan@suse.com>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 0030fbe8885c..def3e06430eb 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -116,10 +116,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
-		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
-		if (unlikely((status & IPS_NAT_CLASH)))
-			return NF_ACCEPT;
-
 		/* Also, more likely to be important, and not a probe */
 		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-- 
2.34.1
