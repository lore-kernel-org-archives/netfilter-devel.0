Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876BF133987
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731600215; cv=none; b=Jvfw6WxlW/pfP5EewgBLtJSk/08jLMKAwG8y027ODqxzUvlhysYvc3G+qSUYwPXIki3f6MMdXHP5fX6604DCM/KxUM19l1NQYsHQBdgz6fe9pJ+NaJrbwX17eyS6dJgoVZ0MMP3AkbjIStFGYp0wYK1Y+0KsFlINegUBPWM5xX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731600215; c=relaxed/simple;
	bh=EiBG97YNblHkUXL6lTFf1fcI90D+FK3ZliHurtw57i4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dAHv3iBcR9JfApRrr9FbCEc3d7inr0ULOkRh12ABLgxxsVfkcwCHket2eeoPSGEqE/lkD8/rwy0ibaFkTDLkjgJnlXY5Eje+5qh3IHCroFK+/qcK+rO4BHypBGoX0NyBWMfBR+DFCG/GaDuxMXRCli9xYq8Red17xbFwKDSwElc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AumzdvzN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AumzdvzN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731600212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=mqDeygRmWi/kNU1a4hZLWkcZ1ztVZyaf0VsbpEiFlQI=;
	b=AumzdvzNKknyNJTRDnv1a2qOx9pnXNzrg4G0p1bqdt+QNOanxKZLxZs2747cpZyhb6jlFu
	ZC3GwGc18GRnYff5D6IJ5MMT5GQPhIiOEYc+2c2KUbkttV3Z2BQ2wKQydpQDC6+Kthb+lV
	biLwEDiJDAWxfdv5zUakWoS/UGdGvVQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-jodAGmnLP8Cv6wr7KpvrIw-1; Thu, 14 Nov 2024 11:03:30 -0500
X-MC-Unique: jodAGmnLP8Cv6wr7KpvrIw-1
X-Mimecast-MFC-AGG-ID: jodAGmnLP8Cv6wr7KpvrIw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4316300bb15so5977445e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 08:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731600209; x=1732205009;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqDeygRmWi/kNU1a4hZLWkcZ1ztVZyaf0VsbpEiFlQI=;
        b=ibKCijEk/AZbnvCpzBrP4Efx1J1WQw5iqFxpS+Il+SKWucgnMANG69Zmdmq/YyFMJp
         ZUd16yJvFi5w3d/kqCJeeKrOOjOcnX1SOqO7Wpkm2mcP4uGBHHrfTvX0rJXbRiFhIeaF
         2dNbNmKZ4gmIwyL64TOSCXdJnL6lZRv5Mj+2kzOzXj+Yz/1OgjKoXK5ok9/BdGMAKxo+
         K/ovSv77h3KUYaOP39VBjNH/sllizyRkXJDz29DHKHMt+NGjb8yiZIqDX2oCmlV9ldfG
         2eV1k6ycZMmP9HRk+Su4wwJ5JntsXwWt4q1LVCd7hLlLVqeY5ppef3HODas17IRN0L8J
         VaaA==
X-Gm-Message-State: AOJu0YzMM2VGO4jJjK3RGEpCKpf94CxsYMKnkWDa4pwftmK9K8crz/mI
	gaik0o4xTha9SjwE12jDw5ZicexWQhhSXHUfjguGwtmZSfH4HqktxmQUkWPdtUOAxBYBP6cq3Mz
	UZ87fIerThzTpP3CQBMS+sk8eiQpmPNsE1UP0P3VBSV9E9+9DcjzO262B3Lhb3YTPoQ==
X-Received: by 2002:a05:600c:1c09:b0:431:5522:e009 with SMTP id 5b1f17b1804b1-432b750394cmr227379735e9.12.1731600207959;
        Thu, 14 Nov 2024 08:03:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPb1+OHLtmsNZvaVnkw878qmBSxtdRGcXdFiXLwoXAHw0rchZLFpvGTZGMFu9nMowpx0edyA==
X-Received: by 2002:a05:600c:1c09:b0:431:5522:e009 with SMTP id 5b1f17b1804b1-432b750394cmr227368955e9.12.1731600198419;
        Thu, 14 Nov 2024 08:03:18 -0800 (PST)
Received: from debian (2a01cb058d23d600b637ad91a758ba3f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:b637:ad91:a758:ba3f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da299dadsm27965975e9.43.2024.11.14.08.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:03:17 -0800 (PST)
Date: Thu, 14 Nov 2024 17:03:16 +0100
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
Subject: [PATCH nf-next 0/5] netfilter: Prepare netfilter to future
 .flowi4_tos conversion.
Message-ID: <cover.1731599482.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There are multiple occasions where Netfilter code needs to perform
route lookups and initialise struct flowi4. As we're in the process of
converting the .flowi4_tos field to dscp_t, we need to convert the
users so that they have a dscp_t value at hand, rather than a __u8.

All netfilter users get the DSCP (TOS) value from IPv4 packet headers.
So we just need to use the new ip4h_dscp() helper to get a dscp_t
variable.

Converting .flowi4_tos to dscp_t will allow to detect regressions where
ECN bits are mistakenly treated as DSCP when doing route lookups.

Guillaume Nault (5):
  netfilter: ipv4: Convert ip_route_me_harder() to dscp_t.
  netfilter: flow_offload: Convert nft_flow_route() to dscp_t.
  netfilter: rpfilter: Convert rpfilter_mt() to dscp_t.
  netfilter: nft_fib: Convert nft_fib4_eval() to dscp_t.
  netfilter: nf_dup4: Convert nf_dup_ipv4_route() to dscp_t.

 net/ipv4/netfilter.c              | 2 +-
 net/ipv4/netfilter/ipt_rpfilter.c | 2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c  | 2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 ++-
 net/netfilter/nft_flow_offload.c  | 4 ++--
 5 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.39.2

