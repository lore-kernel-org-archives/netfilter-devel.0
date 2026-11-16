Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867986;
	b=SS4DnyEpbBJOH1OqnkLLe/jV5TWeoj2qwcjijHD6Wgkv8n5Ri9gqxhvXcpep+o1+P0pb
	 FORPHF5AWHQyUHf/vJ5nO6kGQtvHrK6bKd6VDbxp/lXs8DcpDqkPxi5qnKMMUR/yKVj+0
	 ZUxHSMqRAjnO1wbz03ruqOJ3Jpmi2aoM6vjdhJluPROFLpwyGAcOdX57KD5G5S/CaWN08
	 xPAe/jm0YY2iqcwJ+tgKSp+Gj0yxUZGQmUTz259BousnhByJeAnOXEVF95yPFmLIFbDT9
	 6vHvRhcjD26BZffsawg39UHDKlpOyjeYtWevMS+NiTwoj2AGQcYOg7m3s8JG4CRi7lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867986;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=3SslE8qgO26XXBHOVGhvKn10x5qVEd0Ps4LIMSMCbA4=;
	b=oHH1LMhZ+GlS9OaOc/jUYkftEAR8cCYiC6c6SX0AG8hxKI2P42SDx+0kGkdE4TYnkQlM
	 JaIYeBEdjQv+BrA1ITTpQC57hiaFjoM+NljEkMe6AOuAp0q8aJZv8vRA/R594/0eSev/N
	 11cbOM0oQYLyvQWhLCQsrxHVpK8Q8pi47XWRVdHAH1eEva6RUP2Uk/B4Qb+N1GWQsGC6t
	 27hkNDECzj0zSl7WawsT7YczPqgZJru8KqXUmsbRWqY+7MNRpVPRI7GqrROBYoetjrGXo
	 t4FHYzTWLSnjN3Y90WCZqnf+2Y+/4y3sHSzgWVaVd9smlC2v+8sj58QIttpd77qzmMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=amoT01zp;
	arc=none smtp.remote-ip=209.85.210.226
Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155F606A329
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9155F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=amoT01zp
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-8a070755c8cso2140175b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867986; x=1795472786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3SslE8qgO26XXBHOVGhvKn10x5qVEd0Ps4LIMSMCbA4=;
        b=XKDQf1os7E0NnGvgV5oZzDmFoHgixO6VUR1xgIAfWD/tiAGowsYnuCb9EUmJNuDQRt
         iALhRgmTrZdwkPvhYD2HHDXg3tLztxM37bBW9ZCCOogsyVXV/xg7PbhiwhbaMgdQ+Aws
         jy6ckOSKV4od9EXi8vD41yfsUTYmsUfUeel2kUu+PpAzXcHHrc22cy+bhiagMdZ089ul
         HuTJLrt6EpfDzeiqLXMw8Kx5cOeTBMPjmOReRvFhjE2KU4/k2yoY/L+0kiHhrJHorCOT
         e2c9Wrd1C0Bheba8iWSLMQendl7evL+Ah4q8rD4g4LFzB8xpswGKgP2Lqex6swYiWvap
         sONw==
X-Forwarded-Encrypted: i=1; AL+hErHDH/Ur7RWxVlblRpwraN0L7AVoA6wgxRizff86NOPxf1FbWFCTaPSLHVZ2hRVm+LL0SC7psErQma63mgndwD8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/l5hrJuX/1/vms0sRf5GpMR8MPzlKMJSeU9rKQ5Z02GShq7lEh
	4DsSopggGDEfDXYi0yJvWM4icpanROpwya/2+QqHYy8X6aFV2fX5PT1USMmGqqd4tew4nrUlTir
	U1zuMxNPjF1NsgjUIezLMlKux7OLHASuQZ1bfaYdQeXa7QiUJxlXulatyxCeImUGWDEcQNrjGiT
	xSqhnMeIoSkkytN6wR2tzquOOIAPx/ExPpiT5vwxyAeCHWyEKYty2FAOVQVrenL7UfYWohkCYKI
	VGXyD4sxhEv7Em4E3PzdeU12fYg
X-Gm-Gg: AZFdTZd/7av/iI8uUQP9fACNn4Hz/B/D3YkySmMP3h2WXQyuHqsiDqPKFg6K+L4ojSt
	K9h1+FJ9aS/rE3KUXVXbS/j1uolAq/d1ha2gAIKLqugIAoKwbWYFm3aEIbJc7dlmMAY8jtfVQDF
	uvpBr0Vf1TfyB5wfrtk3WAbiDyt+ZCG+zuw/Ab/P13AcrHXKOYf4hqwbaNxZam3rSfLEMJrUmFq
	bWzD5kaq1WqRaORyHNiXPFqHP71u7bOF290H+MFeFG7QhCy9IprhxYkNn6/Jr9F+anFhEpV1Dxx
	p+VkCvYNvaEaHLn0eCQtrcGh9JWIxxNXlZEDajRnMG/ZYCSLUW+rG5xe5nJF6WIKCXo2M9+248p
	0Wz6nQP5mC+mqimHHNrESYzbcrFrtitxRW071ZQSL6Z9nlxlvcb6e6qYl6ReqakkYM825jushRr
	jYsQ93580Fco0w7JRQdo3nJHOEqBx1a0IvVM704Xxd
X-Received: by 2002:a17:90a:ae08:b0:3b1:bf11:c65 with SMTP id 98e67ed59e1d1-3b1bf110f0amr7299339a91.1.1794867985727;
        Mon, 16 Nov 2026 14:26:25 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abe1c098sm502756a91.5.2026.11.16.14.26.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:25 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36efb506f29so4050888eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794867984; x=1795472784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3SslE8qgO26XXBHOVGhvKn10x5qVEd0Ps4LIMSMCbA4=;
        b=amoT01zpW1QiyWV7iomzHY4VI3soQ9GJqEyg0fwZrUGc+2SAmFe7WWlkbH2pUYrzJV
         S23qsAOVfZRSxhqClj8gXxMtFBxcClMDWLGRSEevbZyVVCXzHgv+YHrk+cifXiBbpOij
         Jmm5hZM5UwAnBukIUdjljQrf5Gsy2oa9e9fcg=
X-Forwarded-Encrypted: i=1; AL+hErGqsbM4g9/ix/SdxkRwHEZNsJnWNrRx+2m5KQMdIS26WxgHB1p9qfP5imoz7S1al582gwvk0TP4YAgTrHWvh40=@vger.kernel.org
X-Received: by 2002:a05:7300:f797:b0:378:d42c:5064 with SMTP id 5a478bee46e88-379676f55ecmr11977677eec.41.1794867983546;
        Mon, 16 Nov 2026 14:26:23 -0800 (PST)
X-Received: by 2002:a05:7300:f797:b0:378:d42c:5064 with SMTP id 5a478bee46e88-379676f55ecmr11977651eec.41.1794867982905;
        Mon, 16 Nov 2026 14:26:22 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:21 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
	linux-kernel@vger.kernel.org (open list),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH net-next 0/9] net: bgmac: add Northstar IPv4 TCP/UDP NAT flowtable offload
Date: Mon, 16 Nov 2026 14:25:10 -0800
Message-ID: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This patch series adds support for the Broadcom Northstar IPv4 TCP/UDP
NAT flowtable hardware called Flow Accelerator (FA). There is a second
generation called FA+/FA2 which will be added on top later on since it
builds upon the custom Broadcom tag.

Florian Fainelli (9):
  net: ethernet: bgmac: validate RX length against the DMA packet
    capacity
  netfilter: flowtable: reject non-host IPv4 packets before lookup
  netfilter: flowtable: retain offload ownership until deletion
    completes
  dt-bindings: net: describe the Northstar flow accelerator
  net: dsa: add Broadcom FA metadata and IPv4 exception paths
  net: flow_offload: allow drivers to validate and invalidate cached
    paths
  net: bgmac: add Northstar IPv4 TCP/UDP NAT flowtable offload
  net: add KUnit coverage for FA and flowtable path validation
  docs: net: document Northstar FA setup and NAT qualification

 .../bindings/net/brcm,bcm4708-fa.yaml         |   45 +
 .../bindings/net/brcm,bcm5301x-gmac.yaml      |   27 +
 .../ethernet/broadcom/bcm-ns-fa.rst           |  507 +++++
 .../device_drivers/ethernet/index.rst         |    1 +
 Documentation/networking/nf_flowtable.rst     |   13 +
 MAINTAINERS                                   |    8 +
 drivers/net/dsa/b53/Kconfig                   |   12 +
 drivers/net/dsa/b53/b53_common.c              |  427 +++-
 drivers/net/dsa/b53/b53_fa_test.c             |  102 +
 drivers/net/dsa/b53/b53_priv.h                |    6 +
 drivers/net/dsa/b53/b53_regs.h                |   39 +
 drivers/net/ethernet/broadcom/.kunitconfig    |   21 +
 drivers/net/ethernet/broadcom/Kconfig         |   35 +
 drivers/net/ethernet/broadcom/Makefile        |    1 +
 .../net/ethernet/broadcom/bcm-ns-fa-test.c    |  661 ++++++
 drivers/net/ethernet/broadcom/bcm-ns-fa.c     | 1901 +++++++++++++++++
 drivers/net/ethernet/broadcom/bcm-ns-fa.h     |   30 +
 drivers/net/ethernet/broadcom/bgmac-bcma.c    |    5 +
 drivers/net/ethernet/broadcom/bgmac.c         |   41 +-
 drivers/net/ethernet/broadcom/bgmac.h         |    2 +
 include/linux/dsa/brcm.h                      |   19 +
 include/net/dsa.h                             |    2 +
 include/net/flow_offload.h                    |   12 +
 include/net/netfilter/nf_flow_table.h         |    8 +-
 net/dsa/Kconfig                               |   20 +
 net/dsa/tag_brcm.c                            |  120 +-
 net/dsa/tag_brcm_test.c                       |  199 ++
 net/netfilter/Kconfig                         |   10 +
 net/netfilter/nf_flow_table_core.c            |   21 +-
 net/netfilter/nf_flow_table_core_test.c       |  171 ++
 net/netfilter/nf_flow_table_ip.c              |    4 +
 net/netfilter/nf_flow_table_offload.c         |   62 +
 net/netfilter/nf_flow_table_offload_test.c    |  129 ++
 net/netfilter/nft_flow_offload.c              |    6 +-
 .../kunit/configs/nf_flow_table.config        |    9 +
 35 files changed, 4651 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
 create mode 100644 Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
 create mode 100644 drivers/net/dsa/b53/b53_fa_test.c
 create mode 100644 drivers/net/ethernet/broadcom/.kunitconfig
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa.c
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa.h
 create mode 100644 net/dsa/tag_brcm_test.c
 create mode 100644 net/netfilter/nf_flow_table_core_test.c
 create mode 100644 net/netfilter/nf_flow_table_offload_test.c
 create mode 100644 tools/testing/kunit/configs/nf_flow_table.config

-- 
2.53.0

