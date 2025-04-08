Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE51DB148;
	Tue,  8 Apr 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122499; cv=none; b=Q4GpWUkDWsbIRvIYcpZA1xn9GdrTF0uS/5g8j/Lsr0kmLr1tgefOmHN1gtXqvx+VcERHcGiK735GG3wz9zGoFKF3z5oQ/qs3RUwe+yDG3+DOgK9meIwqpo19OKbnKSvrCb4hnyIiw8PE99fHU9GM8FhckdOg+FZ9bSWVYXpYyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122499; c=relaxed/simple;
	bh=lErjI/YqIYRsXvXQflvwzYfNLYFv4Um1Zmu0i4NiNm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rEzFIdWjYOGzvPmrnyJy5Yi3aLep+eh9796SMgQNbu6qIpS2+06EtMdmut5UGpZ6wq84cb4DPdc8qBSkKx4rxlseoPKYiJ/tl3Rhx+1lPA+gqPe9w0Qt6j+L14Unq66DclFobDUEvY68XFDhTrG65kJVen1oOpWU16yO5I2lRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+BiNbRA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+BiNbRA"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e5e63162a0so8956166a12.3;
        Tue, 08 Apr 2025 07:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122495; x=1744727295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5BFzr+RmGXXOsHTXqFyGDkv5yWiKdI5zdAeFPopjpSg=;
        b=i+BiNbRAPOkK3WUetE02h67yVLSpYfu+1DsIiddwRnZVdI/suSSCTn3Y7ZVNJfvcUY
         GXHiSd5+54aNXB3XQInZojuJWAibJj0w5QQciBDia4u09Kp7cxshR6t7IRWkaUzlxhXm
         m0z9/q6z/iord8ZS2WJN8d2SibynOrpMNkQiYB9iujfaRZdOjjm69K0nZ+IWEJSn+fPZ
         NbP2lMeD6O7dHL/FHd+KA3ncpAfndO9izpf5JoipX2iuXLPcvgwNli5FtEkgfO5BbvrT
         iplo0O80FTpnBIbEyvtcKCXjQgI9M94SeP6ldGstWnhUe395/9OHBbrwYXWEx01fH6jF
         Q5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122495; x=1744727295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5BFzr+RmGXXOsHTXqFyGDkv5yWiKdI5zdAeFPopjpSg=;
        b=O/RKCqjFIrt6Us7wCQvJjEJgntXTZO0IkqWNNPpA+o/kiIeQSc0D2WilprFlFDbv+K
         iWiZSOeBj2kPvH5Pb83kdmJAV42+by2wqxgjctIAWLz6AMBnfgldlX9YzqEZz4JAOoCl
         BnDCbeTF41Rd5q7f02GaoW/iAZMAdCvoxgUQxy0cm0cVxNbqCvhcFjEBCTXocog/g+pr
         SuD4bBeAqEgXclMGdXrHQ7/ZSi/WZtEbkVgOEKlN/jar4OcVpp4D8tn62pAmKNrtnNWT
         JgDHHnhJIefOUaAGuTGTlh8miaD5rKIRIoevXTgHj7qPCzzlex4GIDA2tAWQuFSGQqP5
         6kFg==
X-Forwarded-Encrypted: i=1; AJvYcCU+gEDh8ld+pvGhrtnHwaz1a6JNZVzG5witZhuMvCV2CJjNbaGH7pxuR1IdQ9IWKnryIEvedzCG+a/4Ow6oZYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuhPW3uuPxeO+Yb670YD7wc7PUnH0/GI9WVN4bnP4SUONMUEIB
	YPG53G54S9fpFuClKxkaQaoGyAw9kbflNuCQQBGpfjODhBURIoEn
X-Gm-Gg: ASbGncsMLHT0aVPPInv0KA5xAq/2/ATIxaYV2CYR88jxvj+BfXtSqW3Y0AI11OSY6X6
	xu4EDaTTlCI4cxtk02ORxmLsR4+DyNtBSnafL8dOc0ph7sw0dpf30kUyCbRAajQdJrRiAQKnEGg
	fzk4MLZhrYLbt41oK66g6E7nyGVPaQIQUCHZWx2paI2wMi1Zc+TiJUnyQ2oCe7si4VhFD3lKSHR
	LvhLULrwEq0IERas1lK2/LVt5yO4Aw25Ii+CQZX/aXgi062zOmY++1aceoDrF0Szz2DG18rOcFo
	gKi4PadVPnN9cORTuyFWGOog4oOluHPVm743TJsuU1qPWIxm1DZxWrYS+pIqnPpNNtl8rAlaZ6r
	2TBwN7RuQe7Sl1FLEhBOWnoVo7T/wEbhgTdTjY40QL5UFO6V0J8qGQPmQiTCPuUQ=
X-Google-Smtp-Source: AGHT+IGGUQrSOB4qpE3QjNkiYb11QRJ+mj4qPf57cTWASVDr2tmbCOxluKgRKa8GJjYOmWsNRMZVYw==
X-Received: by 2002:a05:6402:c45:b0:5e4:cfe8:3502 with SMTP id 4fb4d7f45d1cf-5f0b3bc9216mr16012511a12.17.1744122495447;
        Tue, 08 Apr 2025 07:28:15 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2236164a12.35.2025.04.08.07.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:28:14 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 0/6] netfilter: Add bridge-fastpath
Date: Tue,  8 Apr 2025 16:27:56 +0200
Message-ID: <20250408142802.96101-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes it possible to set up a software fastpath between
bridged interfaces. One patch adds the flow rule for the hardware
fastpath. This creates the possibility to have a hardware offloaded
fastpath between bridged interfaces. More patches are added to solve
issues found with the existing code.

To set up the fastpath, add this extra flowtable (with or
without 'flags offload'):

table bridge filter {
        flowtable fb {
                hook ingress priority filter
                devices = { lan0, lan1, lan2, lan3, lan4, wlan0, wlan1 }
                flags offload
        }
        chain forward {
                type filter hook forward priority filter; policy accept;
		ct state established flow add @fb
        }
}

Creating a separate fastpath for bridges.

         forward fastpath bypass
 .----------------------------------------.
/                                          \
|                        IP - forwarding    |
|                       /                \  v
|                      /                  wan ...
|                     /
|                     |
|                     |
|                   brlan.1
|                     |
|    +-------------------------------+
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
        .  ^                 ^
        .  |                 |
        .  \_________________/
        .  bridge fastpath bypass
        .
        ^
     vlan 1 tagged packets

Note: While testing direct transmit in the software forward-fastpath,
without the capability of setting the offload flag, it is sometimes useful
to enslave the wan interface to another bridge, brwan. This will make
sure both directions of the software forward-fastpath use direct transmit,
which also happens when the offload flag is set.

Changes in v11:
- Dropped "Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath" from
   this patch-set, it has moved to another patch-set.
- Updated nft_flow_offload_bridge_init() changing the way of accessing
   headers after fixing nft_do_chain_bridge().

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (6):
  bridge: Add filling forward path from port to port
  net: core: dev: Add dev_fill_bridge_path()
  netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
  netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
  netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
  netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()

 include/linux/netdevice.h             |   2 +
 include/net/netfilter/nf_flow_table.h |   3 +
 net/bridge/br_device.c                |  19 +++-
 net/bridge/br_private.h               |   2 +
 net/bridge/br_vlan.c                  |   6 +-
 net/core/dev.c                        |  66 ++++++++---
 net/netfilter/nf_flow_table_inet.c    |  13 +++
 net/netfilter/nf_flow_table_offload.c |  13 +++
 net/netfilter/nft_flow_offload.c      | 151 +++++++++++++++++++++++++-
 9 files changed, 250 insertions(+), 25 deletions(-)

-- 
2.47.1

