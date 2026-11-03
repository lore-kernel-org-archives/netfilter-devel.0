Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725161;
	b=ruyehjfUkxZmRVxhSMgYJD/EzDvqRDOMqISNhcZdovKYv7UQtyuYcVDuZ9CFNt9N87Ii
	 mQSvCTMevnRHbflpVdDW9DPUWpgSxdHzJ78jp7i/Wn3V1KM9mSff1FpBXfDAovNzS1dej
	 uVTJNW0qupReL3eBcuCO+2KuEiXkQhT4jYnYodBVPp8MgD7cUWnC/daBgQeRAC6nkt+40
	 FEwLIge3pe+I5Huri9QRHtpeM0iMoio7MxxXxT7Y30ZcnLQAHxP8PGiGTiuB1IMMvwQuu
	 zBRyR9aK3heL8GKyxqbIP2oo+5K1+Yfj53Ks9jzQPECtdVRLZboCX4SxQN7Bo3BeiRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1NI3skowoAtNdcXptzYo27srndyE5ZnDqWHrHmy4U4=;
	b=DPkJu1TkHygNq8vLASrBpgrsnafi6svaL9xYAWdwS7ET2N0TLxWyosu6LqbCkjJi6hEQ
	 Fdwzcoj0eXHI2AdVC8bahPC3ph0VO3Ta+Gi4qnhbEWO/WG+vsXWH4iipkX7tbrMiuebBc
	 FftmuHVn7yy5Ucc6mPxlLeJiLxaHshAuX98ztDeXygzmAasohPufMIPM6d/uEUnmaxfLo
	 Bvpfc501DkaAOioS5I4Uxf3gGT3vActpoPrW4ymmKUuvdLXU8Im0B54SAuE/uFJCD2tiW
	 E6Z73IF2FfzkfJDO1Cs3nqYBRNFLB9sJdu4Z6GWmIxZp9yT2Uj+ywHc/kM7tpQPJdaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1password.com;
	spf=pass smtp.mailfrom=agilebits.com;
	dkim=pass header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=HvE6CnDk;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32C4606A333
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 16:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B32C4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=1password.com header.i=@1password.com header.a=rsa-sha256 header.s=google header.b=HvE6CnDk
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53644b28706so67263351cf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 08:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1793725160; x=1794329960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x1NI3skowoAtNdcXptzYo27srndyE5ZnDqWHrHmy4U4=;
        b=HvE6CnDkjqXySwNnSQZMyeD4DSmhSNJZ5RuJy5b40IJ8vc3t7iydK31t81eeeIpz0e
         ZBLyyMJH+Z3iDY+sb0OebSLGqPrZy9R9RhUXkFrBvJT0VjU+YQ6c1S/inFLyGnz3EY9t
         Bdaj8s+/76t7301785EuSYGoocmPSroSPJJNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793725160; x=1794329960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x1NI3skowoAtNdcXptzYo27srndyE5ZnDqWHrHmy4U4=;
        b=Ujt5y5jdswMCOPf/sTskKr+G4bJpHLXQ4FaUjglZLRUItYCh3OVNb8k13czKuwyzsI
         VRa8evQdGN4KbTZWzsnTj6qsZBQ3K5aOhgZLIysvFljxj61OLa0/iMXYDq/k1zuDc9dc
         a2HM1zNjnG/+kPAhK5U9fA+9ah+9mBZd+bnE3A0T7SiTvBv/TJ7j7/rCNNEZZPrKuNMt
         W22pK3bpro6rKSxx017EBK6jNQ2iANzqS39sFPWb8DQsbUR1NdbmO/yH1ztXA5DiSUPj
         wr6jJkLLYN37eud9rLTiKPUg+RyWK/f1h/FPcqdgwl097txKGq+eBqlHjV7sCks+nyTz
         /DFQ==
X-Forwarded-Encrypted: i=1; AKwUvByeTq1XpyCHTPIf/WV6Z9fthTWUmFnmwb0lw5jK7YiYNENVR7dRQRUTFBFLTZUIuXhG1ywo4HT9p8UsUVGOs4w=@vger.kernel.org
X-Gm-Message-State: APuU4Z/X/RJkI8WVdsN04quACp95Ki8uxZbF6s5xFeGxhCKirH4r1s4n
	gXjLZq99ReUpGgK6sT5BWmapIT9eOubfhATQXbDsZmwH0LEWck4DqCOkaxFjx279bs4=
X-Gm-Gg: AYBFou3Rz6Iic+58hB5A5c1zsOfFbLyw4e9E2Ivdyv33/lRZQ9BJEd/FYI0HGJegY8y
	RQBSiOLKxbrsiwsh6TPAvUIm0KkXtYEkGk8GRVcGvhvMSWHYhCMG0qL42QGmcPkS+CNrke4ICBm
	4+yGxDw3diCKbbS09QZ2Tw53vI74clbPtBiMWbzKQ0LZyVp48TUMJcyUPRKYqNuOLP2au37/jvp
	QP0wwuJ1r/gCELnvso7PmK5KEdlChfYr53k5hDvgqNsBpNch8SLvfPg9oapMe2eRA8jOnaRTJ5o
	aBeEUHLwmnLCV/k6aVc/ix32pXmy9JuR7GH9grJMbw2tLSsLp+Prm0RbKaHaJUOa63XDAjU1Gxt
	uRoDeCjHgvxrkQZXtGp2NmOAT5/AR++Nkfl0e6kyCStFZlPb3PMflccSU9HnG4NDlUUKa6R7i1e
	GoeRoFA7X4glP9qP9X7OEzhat9lQi3H7zg2xIjMOHdEDyhjjyj6/u0ATRM/Z5z5BU8yAqqDfmKx
	t8VkgK7mHnQGtO1FvqZoTO0sIogzYmrNMbQ2qfcHJN5t3wJDtmz2Y94mXBy4E/Pas9pDbiJ9Mg2
	9U6uHWq+MkYNMgL600PkaxwCwaVt5gGLytzJM/nzB/QdDKIsD7w0jKKKjVC/
X-Received: by 2002:a05:620a:4385:b0:93e:5eaf:dd87 with SMTP id af79cd13be357-944217c1057mr2138536485a.62.1793725159609;
        Tue, 03 Nov 2026 08:59:19 -0800 (PST)
Received: from localhost ([2600:4041:59c3:300:a850:2af1:eb93:4121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca8066ba4sm120593986d6.33.2026.11.03.08.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:59:19 -0800 (PST)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: ja@ssi.bg,
	horms@verge.net.au,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	w@1wt.eu,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v2 2/2] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
Date: Tue,  3 Nov 2026 11:57:46 -0500
Message-ID: <20261103165746.39516-3-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261103165746.39516-1-axel.mierczuk@1password.com>
References: <20261103165746.39516-1-axel.mierczuk@1password.com>
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

ip_vs_conn_out_get() does not filter templates. A template with
cport 0 is matched by a packet sent to client port 0 that traverses
the out hook, and handle_response() then runs ip_vs_set_state() and
the timeout update on a connection that must never see packets. A
backup server receives such templates over the unauthenticated sync
protocol. An ordinary connection scheduled for a client that uses
source port 0 has cport 0 as well and is matched the same way.

Apply the rule used by __ip_vs_conn_in_get(): a lookup for client
port 0 matches only connections flagged IP_VS_CONN_F_NO_CPORT, which
still wait for their cport, and a lookup for a nonzero client port
matches only connections without this flag. Test p->vport, which was
already compared with cp->cport, instead of reading cp->cport again.

ip_vs_ftp_out() relies on the first case: it looks up the data
connection with client port 0 to find the IP_VS_CONN_F_NO_CPORT entry
created for an earlier PASV or EPSV reply. That lookup keeps working.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 94f25fb7d87e..29cbe797bb86 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -579,6 +579,8 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 				    ip_vs_addr_equal(p->af, p->vaddr,
 						     &cp->caddr) &&
 				    ip_vs_addr_equal(p->af, p->caddr, saddr) &&
+				    (!p->vport ^
+				     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
 				    p->protocol == cp->protocol) {
 					if (__ip_vs_conn_get(cp))
 						goto out;
-- 
2.50.1 (Apple Git-155)

