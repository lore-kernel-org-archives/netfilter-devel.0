Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6153587B3
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222487; cv=none; b=I2DWVYqYfGYY5strfIgVwUnooiWtjP4m8OKZSz3KzOns6H4Jx1Xy80O2jcA29zKxtRyY7M5IaDbfuq7I7QMEti55uS9Ojx32wm7rPjJJ0gQT1++0Rn4N21/O5Gw1O9h7RQAvQbni04roMlYQl7IRZA67MN0OxpG05afZK82i28U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222487; c=relaxed/simple;
	bh=ArVVBiqIBetgJi+p5f+cmJSVHQwk79p7Tqq1GTf/FIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=carB0qCCnqSzXDk9FGVs7ULoGdwJjrmMDXdODVJNpuGZj9KYnT9G2TJ+o5lD+dL8SKl3kk5BkS5yZCzwFomDoqBvO+Xco+Eou7TG0ENNae+Tudx1eslP36dCeIWvILZcmGpF7+YQZnU8WZFbBL1qh84LeVhFXcor/3jjmarOVH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E9j4cyk5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rCxp4Ryz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E9j4cyk5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rCxp4Ryz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768222483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iKF0BzHe4DoMZWSEsankET3G7Dd2Xauwml8GRRGytpc=;
	b=E9j4cyk5z0iEToT85F/Oc74/7Vp/ox9v9+St2NSE2BbsvfxfVnI7M6DsWgeC6i0jZZBejb
	dAn6CK65rZSSIXwbaJihC/fIekDj1Sp6ZJlkPaO0uD9wEaXuVDPyBVyr2itqMBCeIxKVOj
	o4DwzypcW/YD3mpcYZaXTztk8gWUBSQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-oeZQtrDjOtOqugVSmfQBbw-1; Mon, 12 Jan 2026 07:54:42 -0500
X-MC-Unique: oeZQtrDjOtOqugVSmfQBbw-1
X-Mimecast-MFC-AGG-ID: oeZQtrDjOtOqugVSmfQBbw_1768222481
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b844098869cso649593866b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 04:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768222481; x=1768827281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iKF0BzHe4DoMZWSEsankET3G7Dd2Xauwml8GRRGytpc=;
        b=rCxp4RyzYa1uRlHfi4XCk6oEMRJJXQ9SgGaYEBF/YfmuGPtkoZrDAfaxomS6GCz6Za
         QiN9IH2twxYg+43Ig2uUrdLwb3VuNarUO8ZDZfruxNxxxT8n3txWJS7ZxBvGpxY1Marm
         w2N0QCCS58hX+iD7Q3wlj6wTnNiTQAg30DJFY/HwEaUR+1w8K9zQfHZNLP3rST+puygG
         S5TKaTzGsSxcicY34XgrKC/7iSg5UcrA5ppX9ojDzluwSo9+pCpfJenj0wgiCn7A9nSR
         2/mgXe3TuUFIJlmkjqC6oS82ir5qMn0wr4ssq8/HLwbsFVwSS/YtEnjtvtr+Ga6DCD1w
         JjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768222481; x=1768827281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKF0BzHe4DoMZWSEsankET3G7Dd2Xauwml8GRRGytpc=;
        b=ZLpqRuBew3yc6o7OisPfoQgRsiH1PrHAmAvswcANiffkPwzYJiTydn4o/gYD1UNgJC
         VdPazKWJfFJuEbUsmHNEKPMbTlEKiMB0eJHuCPn9ZtHTK+4EXac/+Osuk70XgH3ERsSy
         TBHKkZ2F48AAoGsbAZxniNV7/HyNPkyasbSJV57U1QJzGhjkrk4QRsmOhNoJzDK/KvFe
         KK4JVhvctr9XqTl3Uz4Z/HX5S6eJF5A4ji0N7kP/K5uNrCcfIHxV7s5iQrc8vodqwvoX
         KblTm8wGTpf1l+iJyWKqNYMxbIoRTzd0HiEaEUg8/Nh0eucfuAdZ96u1y9mwQMwHY8yg
         3tZA==
X-Forwarded-Encrypted: i=1; AJvYcCU0omxPvQ1N2gjDG0dkJTfaT6w+xSMnOD4tfuQIfyJhMvqRUYzGERr6hHgPEC5CxVBP8d0vd5Ea/91FFsBHBnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXzPtIpeoZB7Pp7M9W7JUTZiL5+bDa5PP1l52htttHUUg10xrJ
	jJFA6eG3qX4SSDVfZFf5YzbMEVareoehJ6xp9rl4iEH/1JDM8z9d3KlPP2fQdpKGmS4D9kSn/HF
	BEMfz0NvgRMIGlS3D3ooOGVgH9I64+tjeN0c8PO3Mth+scktbTO2qwL9OKLMXifNw/m3mtA==
X-Gm-Gg: AY/fxX6FAE7G0wFcuEtKdngH4u2w4YtuAFkrpITs/dc8wPsLVOrRt4Qy6+A5eii4nIX
	H/ktpfEckYObb8AhV9rv07d2GIvT3whvCT7vlDsW1iXG8NNy6yAaOaR8Cx5vC7/CgPjYzL8ScTb
	DQRcyl+guHjXjiz++d7mrk2+Qsd+sS4EKA2zsFmJqGUgNvno7gub1h267NDMVMRQAHTqKbSrIYx
	hahoNUTc83EIzOsukRs1fAnzppME1kME2fO2LRcjC1rAbmGzOfC9GMnaCb/aEzjvDoB/D9t51EY
	29RQiJwK1zCmYozapV4C17VLY6wU+ZM/4yuQhzP9S/jFiptu7aUWUz8LDRHHmtgseViExFDmBiY
	5XSqva15pgNQ11K+YYptCu27YygV2nYCH2xvi+yMHRDGuJ2FMjMaoTEWbc8s=
X-Received: by 2002:a17:907:a4a:b0:b83:8f35:773b with SMTP id a640c23a62f3a-b844501e49emr1772456666b.54.1768222480781;
        Mon, 12 Jan 2026 04:54:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSZz6AlBAsyDbYMyXJssyt5r14tT5j/dhOjPD0uwwtT32eYJd5F4wjSbE4zxf083DcjrlpEg==
X-Received: by 2002:a17:907:a4a:b0:b83:8f35:773b with SMTP id a640c23a62f3a-b844501e49emr1772452766b.54.1768222480270;
        Mon, 12 Jan 2026 04:54:40 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:ff56:9b88:c93b:ed43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm497062466b.16.2026.01.12.04.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:54:39 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-riscv@lists.infradead.org,
	linux-m68k@lists.linux-m68k.org,
	linux-s390@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [RFC PATCH 0/5] net: make config options NF_LOG_{ARP,IPV4,IPV6} transitional
Date: Mon, 12 Jan 2026 13:54:26 +0100
Message-ID: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This RFC patch series makes the config options NF_LOG_{ARP,IPV4,IPV6}
transitional. Recently, Kees Cook added a feature to kconfig to assist
transitioning deprecated config options. Here is a first RFC patch to apply
this feature for NF_LOG_{ARP,IPV4,IPV6}.

The plan is to mark all deprecated config options in net transitional, and
update the kernel configurations in the kernel tree to not use those
transitional config options. Then we leave these transitional config
options for a year or two to allow users that only update from one LTS to
the next to see that these config options are deprecated. After such a
grace period, we can finally drop these transitional config options.

This patch series is the manifestation of that plan for the three
deprecated options NF_LOG_{ARP,IPV4,IPV6}. If there is general agreement
that this is how deprecated config options are to be handled, then please
apply the patches 1 and 2 to the net-next tree.

Note that for the time being, as there is no dedicated kernel-wide Kconfig
file for collecting transitional config options right now, so simply adding
them at the end of the net/Kconfig file seems the best choice for now. 

The patches 3, 4 and 5 are added here to understand the complete treewide
change to transition the deprecated config options; I expect the patches
3, 4 and 5 to be applied by the corresponding arch maintainers, though.
Note that all patches in this series can be applied independently from each
other without causing any regression, i.e., if any patch 2 to 5 is applied
without patch 1, the resulting kernel configurations still enable the same
functionality as before as well as with patch 1 applied.

Once the general approach and patches are accepted, I plan to send some
further patch series to transition more net config options. My current
investigation identified that these further config options in net can be
transitioned:

  IP_NF_MATCH_ECN -> NETFILTER_XT_MATCH_ECN
  IP_NF_MATCH_TTL -> NETFILTER_XT_MATCH_HL
  IP_NF_TARGET_MASQUERADE -> NETFILTER_XT_TARGET_MASQUERADE
  IP_NF_TARGET_NETMAP -> NETFILTER_XT_TARGET_NETMAP
  IP_NF_TARGET_REDIRECT -> NETFILTER_XT_TARGET_REDIRECT
  IP_NF_TARGET_TTL -> NETFILTER_XT_TARGET_HL
  NETFILTER_XT_TARGET_CONNMARK -> NETFILTER_XT_CONNMARK
  NETFILTER_XT_TARGET_MARK -> NETFILTER_XT_MARK


Lukas


Lukas Bulwahn (5):
  net: make configs NF_LOG_{ARP,IPV4,IPV6} transitional
  selftests: net: replace deprecated NF_LOG configs by NF_LOG_SYSLOG
  m68k: defconfig: replace deprecated NF_LOG configs by NF_LOG_SYSLOG
  riscv: defconfig: replace deprecated NF_LOG configs by NF_LOG_SYSLOG
  s390/configs: replace deprecated NF_LOG configs by NF_LOG_SYSLOG

 arch/m68k/configs/amiga_defconfig            |  3 +--
 arch/m68k/configs/apollo_defconfig           |  3 +--
 arch/m68k/configs/atari_defconfig            |  3 +--
 arch/m68k/configs/bvme6000_defconfig         |  3 +--
 arch/m68k/configs/hp300_defconfig            |  3 +--
 arch/m68k/configs/mac_defconfig              |  3 +--
 arch/m68k/configs/multi_defconfig            |  3 +--
 arch/m68k/configs/mvme147_defconfig          |  3 +--
 arch/m68k/configs/mvme16x_defconfig          |  3 +--
 arch/m68k/configs/q40_defconfig              |  3 +--
 arch/m68k/configs/sun3_defconfig             |  3 +--
 arch/m68k/configs/sun3x_defconfig            |  3 +--
 arch/riscv/configs/defconfig                 |  4 +---
 arch/s390/configs/debug_defconfig            |  2 +-
 arch/s390/configs/defconfig                  |  2 +-
 net/Kconfig                                  | 21 ++++++++++++++++++++
 net/ipv4/netfilter/Kconfig                   | 16 ---------------
 net/ipv6/netfilter/Kconfig                   |  8 --------
 net/netfilter/Kconfig                        |  1 +
 tools/testing/selftests/net/netfilter/config |  3 +--
 20 files changed, 38 insertions(+), 55 deletions(-)

-- 
2.52.0

