Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA4F198851;
	Sat, 15 Mar 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068822; cv=none; b=ecA6Lt5P1gYB5lsgUDjQEXCuDE6N9KG5pN2GKOrhSOLXBHuQZcr6Bx3HqRvN5peNh8I/yktFEgjqsr+0KopwX+Dv0JED4kDidyHBmtSRBreeWnRhXYOrU9FEFojKuUFMzKabIjG9ApQnwk3K4fCzHPq6ltj+ZlUVTxFnOWK++4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068822; c=relaxed/simple;
	bh=ce1xHho51KUVNK+8ge0peQ964zUF8HfAxIE5DEGw2HI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gydq+okUtlK0BCxvPQxp+FfpyPzEwbBDGCTnLUGiXfCg36UQmL1AQ6uR567/oTFYfbMQx1TjmsJ11ayQFKsDQIV5pQEG7/gKcn3AmYFbzV8uUT33HAQSwJ8V17YMzJtCT8CCXO2wvTJGKjbNiX+ugAmZiC1BuF2hsYDgrZBPRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWn1j+0q; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWn1j+0q"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so5568807a12.0;
        Sat, 15 Mar 2025 13:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068819; x=1742673619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fPrJr79XyDH4STUGS/DxMd1IlbzUMez/C/77qDamrRo=;
        b=EWn1j+0q8VSz13u96V9LDT2IeZu5BSlmE1he59xkasN5bUBx98ksVhXZraeDn5I1/D
         qFLi2ut+iTIA6YxOLcOpl3Rl7uVFqYa94wv1HZ3++F7qHBAACBaklz1stuegtCWNZ31u
         3B0M454UWvk8TJd9yQLKKIxVa3c3Go6Xwx7lEbq59w+b5vymbpFBXgUCU/olKFh25rE5
         NVNAGEBunav8i6PCDkZm0Dp26SrB/p+Eyq/33mkCZ4apSWY8VWS578dLxVjqYAULGyl+
         JPTesO1VHSU83Lq6bmibYiRSDRQxxa7zA5JiJ7e53kPUndfuTrdbBoai/lz/wgUngVA6
         SdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068819; x=1742673619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPrJr79XyDH4STUGS/DxMd1IlbzUMez/C/77qDamrRo=;
        b=kigtEJ0kz1lHPzGgB5hYB6eykvdMRVtkTfAyu7cF081Lbk5M7my+ysvJPjvHs4prEs
         UfO4DYx1quow2l/9EGeyQ/ZMPGLukklYLrJA13mBgno+ljFi5ngc2AG7b0c8eoqvwAi3
         PXJQorP5eaUjtuH/DO4pzfaVaDqFD8dl60Dxu40tWZG7bi9Vo9lr65Utl9ZFZFicFyF4
         ZsU7QDRM5zdKCjzI+L8Jyb/DCD1Nf73A5h0SHBaTa+YSlbRsxZv67yKH+V2GRI98IBzN
         eccL4TLYvMPtxI/3eiv1hSrrwfsJtyMNztjQAiY9JJ9jyKiohLQodGidrusZ+kHx3Mnx
         hmIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh9yEKO+gM97qwNdiIKXNLNl1LESSfiweihuiipYqy5J4s2ogtnMCIOBaL962V79wkn/ke4C7LEGK3CfT/hVC1@vger.kernel.org, AJvYcCXjr34fz/2EAd6m8OnSeJhaL8I4eAlz+qU5ocPi7I3tnPnffedw1NuPwZBrdlNlUrmfD7XeZsOGJDh4SjzUgpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUeJ5PraAtT4BLcLwVtA8oiuqFnUdnuPPFaCKqcDByvLBPSqn5
	GNNFu0/INKfTa1CjhsD7aEFuSBXxTRH+Wc6Vbjyx3hOFuQPmihNu
X-Gm-Gg: ASbGncsPqe9dHoxxzOJQpDmUz7Knm5AZtmgUvsprkZMLaL3/qt1+64vw7P3VM8juKhu
	EHTVCrJqM2KwgWQQCwSrOl5bo2/QsoSRpatlmk0h7uEhS5H6FNOfxKk5Hk2eOYillWa6iPuxbz7
	jZnQYZ+/VXdnYczzYNdibuhanofz59DvDiYeGFpVm8hP/pwCA0vlDhr3Nb8ee+zZRgU+IQIzxoS
	ZWYqufRp4SoeCzjsucYr95MH+qp5U6cgv3S3wmA2pvLZr2xGHI6DX87+Rts7W9hRjXeLiO3oS35
	K5JDETgf+nFryL5ZplplURtiOXEX7NXsAuRi3oLi/hTr0w4qyk89MVr/nzRkbzmawlknEJPUrk1
	P7NlQt6hTUrrijYrotnuKIQ5dniq0ivfN8ePn6vfKbRIUtqS4WKNYuBVz3b/xlEo=
X-Google-Smtp-Source: AGHT+IEsZoubmYyBs5/CAqd9wcyfX5PDBTd8irLxgIhCsUKa6gPvky6aixlo6Olvn2dw3jo+QZ2mjw==
X-Received: by 2002:a05:6402:2681:b0:5e6:14ab:ab6a with SMTP id 4fb4d7f45d1cf-5e8b025767dmr6436830a12.7.1742068818538;
        Sat, 15 Mar 2025 13:00:18 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816ad9ca5sm3519503a12.50.2025.03.15.13.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:00:17 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v10 nf-next 0/3] Add nf_flow_encap_push() for xmit direct
Date: Sat, 15 Mar 2025 20:59:07 +0100
Message-ID: <20250315195910.17659-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To have the ability to handle xmit direct with outgoing encaps in the
bridge fastpass bypass, we need to be able to handle them without going
through vlan/pppoe devices.

So I've applied, amended and squashed wenxu's patch-set.

This patch also makes it possible to egress from vlan-filtering brlan to
lan0 with vlan tagged packets, if the bridge master port is doing the
vlan tagging, instead of a vlan-device, as seen in the figure below.
Without this patch, this is currently not possible in the
forward-fastpath.

         forward fastpath bypass
 .----------------------------------------.
/                                          \
|                        IP - forwarding    |
|                       /                \  v
|                      /                  wan ...
|                     /
|                     |
|                     |
|    +-------------------------------+
|    |          untagged             |
|    |             to                |
|    |           vlan 1              |
|    |                               |
|    |     brlan (vlan-filtering)    |
|    +---------------+               |
|    |  DSA-SWITCH   |               |
|    |               |    vlan 1     |
|    |               |      to       |
|    |   vlan 1      |   untagged    |
|    +---------------+---------------+
.         /                   \
 ------>lan0                 wlan1
        .
        .
        .
        .
        .
        ^
     vlan 1 tagged packets

Added patch to eliminate array of flexible structures warning.

Added patch to clean up structures.

Split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (3):
  net: pppoe: avoid zero-length arrays in struct pppoe_hdr
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct
  netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx

 drivers/net/ppp/pppoe.c               |  2 +-
 include/net/netfilter/nf_flow_table.h |  2 -
 include/uapi/linux/if_pppox.h         |  4 ++
 net/netfilter/nf_flow_table_core.c    |  1 -
 net/netfilter/nf_flow_table_ip.c      | 96 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c |  2 +-
 net/netfilter/nft_flow_offload.c      | 10 +--
 7 files changed, 102 insertions(+), 15 deletions(-)

-- 
2.47.1

