Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B2347ECC8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345495; cv=none; b=OnrIUIgJlIBNV+fTgiWfQ5u7nfYtX8u32RyBcfNWlAaJ/Ykr4KeBxdmF4i11VPVEKMoRAkbk0N8GOEfQv0SZX0jj8e5qqI9i9SgSI5GQWEVvfnYVpqvuoZng5alkMGvitXtMIeX6butH1sV+vt5IJUMJmZUpvg366dGYS03f/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345495; c=relaxed/simple;
	bh=yo5fwu86Mw0YOj9FzmflPUzYzC7n+VFBQsdjcJILCps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1NkAHprYqyk3nnmhai/sYBHcv4Mn5efir+uANKutemYHUMBUQCZeXb9aD3LjTjX+86K4t964uZrexsEkjIgHrAGLRtTX4LhZYxe8pF+5hXOy0MmjOGH1jG3WeZGRoMAjPIRSXtvipq0UrCQfqnImURD7gMgbgFfDimRUvEmh0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com; spf=pass smtp.mailfrom=agilebits.com; dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b=BeuZ3XDm; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b="BeuZ3XDm"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfa7b2093so105349685a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1790345493; x=1790950293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q2mrYp40d3SwEyzC0ifjna6lr6WRZQqdhud4xFgB7sU=;
        b=BeuZ3XDmCWzyj9lW3Te9VH4Pvy2bKx+62S87w6P7p6kW3aw0IMTZB9GNgBfYxfIh5V
         3Qvkqs+3RTlTBGVyoYsdoV6lx/xPosuxztA1RDJ17qfgvkMPBifRRTM58H+gu3VtC4Ob
         CerNsrh+pL2PDb+QXIp5rpPx+em0cr4fpGx3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345493; x=1790950293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q2mrYp40d3SwEyzC0ifjna6lr6WRZQqdhud4xFgB7sU=;
        b=jaysLbt4/FvenBY8XYmY2V2z15Mc6kIQ/vdb/+PRnKql+zv8aSHbrVXbbanmG3lUWK
         RmGu/7y6UC0L5vN2XnQsmLRmyLP4+ZP5SCP0kz7E8IGmjiEtq1QRZ8VVscz+uNBTZ7UZ
         4CoBuFPWlZzrAVsZcdHz8KiWSQtm9WteIjk8GyLG4neQjpd5REdxBc0llPgMEL3D/NWL
         wO/jl4xlNv9U4h5VIVf0qz8/2M/80kbyTlCHIUmm3xp/zOQF1gYemaeAzYDEoD3Y/0+4
         AjlV1noNWGM9oZ72Twge+U6bxFgLCa8dvc2Fql1951dCbbeTxJ5MkKwzrtEHuG4lQyBh
         270g==
X-Forwarded-Encrypted: i=1; AKwUvBz6ym+RufFlW5rBT3NWBOcsnhz6kwLTSx3S/leeY+4Jy0BvxClnCQo4qe2flcws+ItF8ciVQG3EtVJgqZ9RZYQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lhzBLkcdJWb9VrbuWbp5n2xxo+KXhGHVtrhr2wnqVwO0b6Hzs6
	jIIbAZxg6fSXAD07LmJNXZDqEGXr8V4lCYUV8b/pFFaJNtrXe5ldkoCrYhquerCk7FspVisIFcn
	7P76SGBM=
X-Gm-Gg: AYBFou1/bcSed+ZozEC+asEVuvOSx+5u2oz88a1e6bx8icW+KPJOE+XQKiBdoU+5BdA
	fRkeOBQDVG12LAjJcXTbSdu1M18iLkOcvbP+GVSDGMPS5F5O1CoyR3K47RGDjkQybo7bgLIhAsl
	3yEBuPJuQn3EHGERmihUxf+9cWEljbOTTiFUezQ3AhHbE9qe01dA3Wnixaj59BRnEkRvSYk6IHM
	evouWFZBGKbw+fc4qlwoz5tsUYBIn9HN2Ix/hgcWkZM4XVGjcVQxZVDN1dS0YsfSBR34DW0h1F5
	Y3QJrOaoixZhpV+9Ppiu6RA889BMS8ddnhW9YHIn+kpsg6Lf9qSNTs64PM+JYufgsSiZCNkQF2Y
	AGnQWEi0jtxSYe6W9f/qtnV00QXteyxC7zI55LY9dvmqmEQy4yZYKgbT4m5eqQ4YO0WehSHS20C
	veYlndxGWQum+xQSq8a/oTjcEbrIZ0TAeyNuw43ptqG+YT6Mi7ZvwRVB+X5Xoa3HOG5HPf0gMrp
	tvLHS1BfpHBVeOWFerEpnRME9UUlw==
X-Received: by 2002:a05:620a:6887:b0:93b:c58c:d3be with SMTP id af79cd13be357-93c43d7be0amr477352185a.37.1790345492707;
        Fri, 25 Sep 2026 07:11:32 -0700 (PDT)
Received: from localhost ([2600:4041:59c3:300:7917:c7f6:28c6:182b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c448b06easm190017485a.16.2026.09.25.07.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 07:11:32 -0700 (PDT)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Willy Tarreau <w@1wt.eu>,
	Keith Hoodlet <keith.hoodlet@1password.com>,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	stable@vger.kernel.org
Subject: [PATCH nf 2/2] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
Date: Fri, 25 Sep 2026 10:11:15 -0400
Message-ID: <20260925141115.16126-3-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260925141115.16126-1-axel.mierczuk@1password.com>
References: <20260925141115.16126-1-axel.mierczuk@1password.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_vs_conn_out_get() does not filter templates. A template with
cport 0 and DR or TUN forwarding bits is matched by a packet sent
to client port 0 that traverses the out hook, and handle_response()
then runs ip_vs_set_state() and the timeout update on a connection
that must never see packets. A backup server receives such
templates over the unauthenticated sync protocol. Connections that
still wait for their cport with IP_VS_CONN_F_NO_CPORT can be
matched the same way.

Require a nonzero cp->cport for a match. Templates keep cport 0
throughout their lifetime. FTP data connections learn their client
port from incoming traffic before replies are processed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c..24dbe34a4827 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -579,7 +579,8 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 				    ip_vs_addr_equal(p->af, p->vaddr,
 						     &cp->caddr) &&
 				    ip_vs_addr_equal(p->af, p->caddr, saddr) &&
-				    p->protocol == cp->protocol) {
+				    p->protocol == cp->protocol &&
+				    cp->cport) {
 					if (__ip_vs_conn_get(cp))
 						goto out;
 				}
-- 
2.43.0

