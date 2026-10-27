Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793077569;
	b=1a+M3rkB7NoKbL7jiS1KenZZh9oF0QzzO7z+//4DfSlrHblZxJQxznn6cpLsiJqMx/EA
	 Pyr+iX33VKSP/CyhHDQ7u+gKWWkQdh2OkPCljtE//9EXR88zoPtjwy3WoQlW2e3puE+nz
	 AEE+mzCsTmqZOLydWFnbp91nwdz4OgiMKqyE7dEhlaxUf8hgObuY3aH5FM4sxYUW2PsgY
	 QNG0YEhGt96x/daYfzGXH59vrxEtHUFqe3cnzEtShc021Lx/Vqc99oESdfpDKY/FF1QMx
	 v/Wa/bpDA7LIMhMZ6BC7jtMOkmvnuWYIYamuEmaOo17dLwBKX4Xjx0no18baUI+qFGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793077569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=INKdVC6tziuChLIQqoOKLccCWn87+guyYChHCXE76D8=;
	b=JxS6K9ZTj7Ka/cjbTxl4YmbwTAIl+Ti6m3eRr3Ul59SSk2r+CYV+vZ+I42peHHKR7tdB
	 uaGQVJkE/Ny6QS8LdqweOKJVlK9VnAzQQCScpndp0qhGfupk3PXQmP/UEduW6ifduCDqZ
	 nzfErVxY35DncBsziozmu5x+IfrH4TE9kqWFV/rNv7UKt9Dj8PMk3PqFP/lHWSRMcVxmp
	 o9ZVyuh4BNiCqvwWm96zBNL0ClpOTfhdwqG9oAAb6JqM5FaUJp296A0lvSFkVhonYxbzV
	 GGZFZ4j0yJTqS5LVFFQu1ZyAPHm1LP7b8iGJqYuLwp+Bu9gDDZttkvlq5i1Wq1m5lLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=uPhRQ86Z;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44E8606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 05:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A44E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=uPhRQ86Z
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1931ff67a29so2675407c88.1
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 22:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1793077568; x=1793682368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=INKdVC6tziuChLIQqoOKLccCWn87+guyYChHCXE76D8=;
        b=uPhRQ86Zcw6g5N6kgatKFK5Hx9VImUv5zEpUA+/FlPCDAeJ7J3fjT/+4UA8G+HEg9j
         0Rc8xmXFdTNMmmIuYtOhD0tLgu7JFPnIfkS8BkMFTqvben37cX1NFP52w5kTfgLrTTd0
         7Wtoo5nz89fI+tZCwqzZGTXqnPpYU9RTFUjf+RO9AtUCtOgs06g+VeU+It+STntoH4iZ
         sXBqaNdJuEJ4oY49hdNtHqlsHfz2UrUCEr5BQQtdt1Tlmi2ONzDcf/c/0vBjF9fwfolD
         i3kdeMgTuNc5n6KMu5B1PuKrH2UMjMHG92PQh0hGuk17SW87wHGCsz0NnLeCwDtLrtiy
         pzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793077568; x=1793682368;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=INKdVC6tziuChLIQqoOKLccCWn87+guyYChHCXE76D8=;
        b=0IQwHlbvb4zTUSTwQ675oKETw02a68anmcQ+S8aEF1Dq1/w0akEChVGMMiVoIb8Aye
         8j6SLaDUj1KOjRHnb1qTbA7m5n9/UlIS9KIiENARrSAJUXTGkfD55NNWzFmAkvR8Ntrj
         uzjXRtd/uUxB4FCcbBCLtyYe2mYnFlBB5YD2vckNX9LAE6Cg4+poBlCJa2dnQTlwmbZk
         1YNUsc8XCkWnUKcX1Gjpsv9yuzi/3ZuHgm+f69kMe0qAayudzgwD2fq0m/s7a3nFo9qE
         ATDjnP3mNTB9DIeMJexl3gU6el6L0tNwGOvI7yxG6FLRv7fZmznUHe2LvEkUUAS0qCkQ
         YSeA==
X-Forwarded-Encrypted: i=1; AKwUvBx1egYD4bKQ1TbcB6pxwZP9Pp6nI+Lc5cNr1c5ypwOzUN8P5qO4ua4k9+HQhRXYfu6PT4hP0itFdOEywoPRBIw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLDgp1Z8QuQy0CQy9RZZ2IOq0iRdOBXTsedaeiZq2PMz3eaab6y
	R4zbqrE7YSWSLC7PQs+dOgWjGKr9YDPqPQbpbamj4cRm6X9h7XI9SV9EwQh7WbYXXtBoDJkmO/L
	Zfy0OCniHAJU=
X-Gm-Gg: AYBFou2EtQDjKs388KNXpECLIfUYjaiQgcnmpPVcQASj4aThSW2PPlYvf4MmSFulR0H
	cLFV6ZlRrnZ9AX0MaawuHdRRwbRSLljV/iQtp3xij+T4kJHD21beECJTQN7Ad7uzaZZvHF2TfHN
	W/Hko8OHzzEksEprTUMx/wXFqdI8Eu3cNUoxH0hqpkzcMsc5sJBeyal9YLeyA0eyZpadIPG5sqO
	VbZKDYS0/HiMDJDi/1g6rDhyJOLW9q3+Mtf7/c5vbVfa1/Hm7Kyul3ibkH4oYNMacvkk3NCeggG
	37qpriGnv45QDvDBBbUPUdeFNJ3+xY6zJgeER4PHq0GLn+ERV1VdFTVdsOAyeOk3EVMWOMP0VMu
	dF6ha76GBeyf/ombliqjrNfoq5fPnkLF6bc/Pd24X94I98Flj/4NGjnfLnBvGmL23yltJSTjgbl
	Jscu996DkTGDc5UU2KEg/gCO0PvzWDTeaBzJIeQc+MRoflU00riP/FRZWz/xdJDyuQpZ/REmL+Q
	3fgK/zlaJFZEN0yztO+ICVjtP9KWglbwRaLqr4v6AmjNCIvTNo1sK/lF+bNEmErSk8p
X-Received: by 2002:a05:7022:98d:b0:13b:4ab5:41d7 with SMTP id a92af1059eb24-199298b3adcmr16097645c88.3.1793077567421;
        Mon, 26 Oct 2026 22:06:07 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([2001:49f0:d0db:fffe:97d4:c0de:15a1:9c01])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a2e32479sm27117892c88.21.2026.10.26.22.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 22:06:07 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	zhilinz@nebusec.ai,
	tonanli66@gmail.com,
	kaber@trash.net,
	vega@nebusec.ai
Subject: [PATCH nf v2 1/1] ipset: ignore port ranges for portless protocols
Date: Tue, 27 Oct 2026 13:05:55 +0800
Message-ID: <6b22dc397da38cb68a404d41ebae6d4ac387d5ca.1793077266.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IPv4 UADT handlers for hash:ip,port,net, hash:net,port, and
hash:net,port,net canonicalize the port to zero when the protocol has
no ports. However, when an address range is present, the handlers still
read IPSET_ATTR_PORT_TO and iterate over the requested port range.

This can create keys with nonzero ports that packet-side matching never
produces. The unreachable entries consume maxelem and, with forceadd,
can evict effective entries. Only expand the port dimension when
with_ports is set; continue expanding address ranges with the canonical
port.

Fixes: 41d22f7b2e48 ("netfilter: ipset: hash:ip,port,net set type support")
Fixes: 21f45020a308 ("netfilter: ipset: hash:net,port set type support")
Fixes: 7c3ad056ef79 ("netfilter: ipset: Add hash:net,port,net module to kernel.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Link: https://bugtracker.nebusec.ai/f/12359
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Assisted-by: LLM
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v2:
  - Extend the fix to hash:ip,port,net and hash:net,port, which have the
    same port-range handling issue.
  - Use with_ports to gate port-range expansion in all three IPv4 handlers.
  - v1 Link: https://lore.kernel.org/netfilter-devel/ab8bb46b65a7666885cd5fe0fccdb0e39e279674.1792609477.git.zhilinz@nebusec.ai/

 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 2 +-
 net/netfilter/ipset/ip_set_hash_netport.c    | 2 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 195853a25b060..3d5ea0710bf83 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -247,7 +247,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	port_to = port = ntohs(e.port);
-	if (tb[IPSET_ATTR_PORT_TO]) {
+	if (with_ports) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
 		if (port > port_to)
 			swap(port, port_to);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 5de4b511de763..30115766775f5 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -219,7 +219,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	port = port_to = ntohs(e.port);
-	if (tb[IPSET_ATTR_PORT_TO]) {
+	if (with_ports) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
 		if (port_to < port)
 			swap(port, port_to);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 61af1ce271279..dd6cf8c36ba07 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -278,7 +278,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 
 	port_to = port = ntohs(e.port);
-	if (tb[IPSET_ATTR_PORT_TO]) {
+	if (with_ports) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
 		if (port > port_to)
 			swap(port, port_to);
-- 
2.55.0

