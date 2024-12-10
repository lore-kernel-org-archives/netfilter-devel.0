Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F98878F30;
	Tue, 10 Dec 2024 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823975; cv=none; b=cOvlYvNaZCxvw48CsYGNo81yNXKiH/lahAlIo4tT1DMYE/dj4ZD32Wa7Tdk3wD7hDFMmy6dllh57K02bg/y+9Emyeq7uZFuU3PZanuPnjBqV/yhsD2+yaElmjLklCwWDE6gR1VqFWU3nNlmM9YuH9n8nVPYw8FC3zzR+u/UFdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823975; c=relaxed/simple;
	bh=KeM3nCVomxM9bMY0OfFkkMpPTEaLh8sz1NtNJzSH1Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lXDSkKbooaCy7PUsMPlCLWFMWbU4eCmg/l6pHgLu7050Z+L4l0Wl4bm7d6h15WdcC1g+y3ULrprZXq1fITVwgipNSuMqgP6zm06B/s/7KR4CQqj+uW44kua6kT2CLSnl2Zk2oehmEq0aQM8tV3zGHG2s4j50+XcDh8YucjacZP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fp0Ga/2K; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fp0Ga/2K"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3e8f64d5dso4368892a12.3;
        Tue, 10 Dec 2024 01:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823972; x=1734428772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UocVRl+s36yfKdOwyD9w/O24SaGw6oRqRxZTrP2zIsQ=;
        b=Fp0Ga/2KyICT6IpmbK3/qkFhKV34c0udCxQeff1KEv6Ww6UBe2eQq/ju37LnzXO0sU
         F3lcX0fDUqiRv8jC3RlOQLdLw8BOZiwu2Wet8X/sro1jfkb60ZCTmpiwgYEoL4szuYtb
         zbALIGcDFAs3dApUNrA6NEqoo/4m6OlVWPO92YRSBvgN0VnfiqdPzQjO/e+FJ5mRJ8Fs
         1PCpIjUu+jM3MUd5fWmPp2G97BIkY5UsKLZk2lpXUqV6TV82DE0zj7egGKc/jkbnd2iL
         44AVgk76s5ickT3cpuQBQvJTf3KpamvSKgrlw+P6fase2Dw7JxuTPhIfsVbtzlFTq88z
         m9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823972; x=1734428772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UocVRl+s36yfKdOwyD9w/O24SaGw6oRqRxZTrP2zIsQ=;
        b=g0WVbcVjUTJiqihVT0d0AZ2HvuqWzJ4Kn38dmpjtH5GMGks9MIBBJGCTePtqGqnDYS
         g4k7oi8Evc7z2fw6+TN0kXGdZTV3ml5Db1Ui2Sdu0DRQkrAdRxhf5S0AT2sshLElaumT
         +jadG0utuaoqqCdHy7C5oxnde6etV4U3zHxJ6Hhf7OpOb9NwUoaJKiewLlck2y3U0b2t
         0WIc9C/GG/UscYFGUVcJAuiLRxjSXfScYMpamNoahDF20JlbWwCgeaeOCZluZtLCi/7+
         5cje2RrsundXYcyXm1WAV0LZbR1k8tgipLG+FKuu9aXAEnb6qmvF+oysIKJzDjxehFhG
         lelw==
X-Forwarded-Encrypted: i=1; AJvYcCW63mWZEH1cFP4GKDcUpYGLPmJfFf6oXW1hoWJzT13ao6GOsZplXZr7sjLF9RoFvWNhs+wQdYd36w8xLFzYJ+e2@vger.kernel.org, AJvYcCWJOaOg8tyk2XqrE9X424sOPXb9qvv69WfzGrDTtxuMYXTRDHANu3RcNOfPJz1WPoIqTgSU0jjF+wN23FE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXW8hBL0E7314gNrADo1gJN4hSrYUaSID1Pw74m/ToiyMTyexk
	1nc40M9lxzM9ynedfkSuMACERHegmdohoKNcvgSG0yb9i+uaSyOC
X-Gm-Gg: ASbGncsWpWgcDlgihZ5qIRYHJL7dcz1utNIuW+mfHyKp+IRhxlYoTZhA3mWw8GHAz0t
	OyGiOjInzS2qt475YW4q0WBWsdcak7T5j5B6d+aYILLn7+2KT8Qhr5C8+TsC3bEkP6tdkmc+rDE
	04u5/kd+A1gAcX/ebg2I5WRqkZH/xjzYuy3F/R9LTx2gRLlrLq+Rai/mcHBYb2WtFH/2oWteZsl
	8IrYqhLS1Eua8vHnOrPaAruxlyVC8qwt9yCXVnzpY60oMvpcgjDHgoKuWQA+rLIkOAvP27tdc+e
	byt5G6cOgF9oj4jg1T3DFlAYqLvE4l9n7PwcqCYN+Jm3TW2g9QmMT0pmaeXWCjW41kZFywk=
X-Google-Smtp-Source: AGHT+IFCrrW6RNVZquoW/mErh5cCOuR46lfhdmTnJoE8ueHEeCps74gS5DZ/AuLUpkGnYzNZigdJOQ==
X-Received: by 2002:a05:6402:320d:b0:5d0:d91d:c195 with SMTP id 4fb4d7f45d1cf-5d3be73fd12mr15089760a12.32.1733823971640;
        Tue, 10 Dec 2024 01:46:11 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:11 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v3 net-next 00/13] bridge-fastpath and related improvements
Date: Tue, 10 Dec 2024 10:44:48 +0100
Message-ID: <20241210094501.3069-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes it possible to set up a software fastpath between
bridged interfaces. This also creates the possibility to have a hardware
offloaded fastpath between bridged interfaces.

To set up the fastpath with offloading, add this extra flowtable:

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

While testing direct transmit in the software forward-fastpath, it is
useful to enslave the wan interface to another bridge, brwan. This will
make sure both directions of the software forward-fastpath use direct
transmit.

To have the ability to handle xmit direct with outgoing encaps in the
bridge fastpass bypass, we need to be able to handle them without going
through vlan/pppoe devices. So I've applied, amended and squashed wenxu's
patchset. This patch also makes it possible to egress from vlan-filtering
brlan to lan0 with vlan tagged packets, if the bridge master port is doing
the vlan tagging, instead of the vlan-device. Without this patch, this is
not possible in the bridge-fastpath and also not in the forward-fastpath,
as seen in the figure above.

There are also some more fixes for filling in the forward path. These
fixes also apply to for the forward-fastpath. They include handling
DEV_PATH_MTK_WDMA in nft_dev_path_info(). There are now 2 patches for
avoiding ingress_vlans bit set for bridged dsa user ports and foreign
(dsa) ports.

Another patch introduces DEV_PATH_BR_VLAN_KEEP_HW, needed for the
bridge-fastpath only.

Conntrack bridge only tracks untagged and 802.1q. To make the bridge
fastpath experience more similar to the forward fastpath experience,
I've added double vlan, pppoe and pppoe-in-q tagged packets to bridge
conntrack and to bridge filter chain.

Note: While testing direct transmit in the software forward-fastpath,
without the capability of setting the offload flag, it is sometimes useful
to enslave the wan interface to another bridge, brwan. This will make
sure both directions of the software forward-fastpath use direct transmit,
which also happens when the offload flag is set.

I have send RFC v2 as I previously only owned a dsa device. I now have
obtained a switchdev supporting SWITCHDEV_OBJ_ID_PORT_VLAN, and found
there was more to do to handle the ingress_vlans bit and corresponding
vlan encap.

I am now sending RFC v3 as the previous RFC did not get any comment.

Changes in v3:
- Squashed the two 'port to port' patches to avoid build errors when only
   one of the two commits is applied.

Changes in v2:
- Introduce DEV_PATH_BR_VLAN_KEEP_HW for use in the bridge-fastpath only.
   It is needed for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.
- Different approach for handling BR_VLFLAG_ADDED_BY_SWITCHDEV in
   br_vlan_fill_forward_path_mode() for foreign devices. Introduce
   SWITCHDEV_F_NO_FOREIGN, BR_VLFLAG_TAGGING_BY_SWITCHDEV and
   br_switchdev_port_vlan_no_foreign_add(). The latter function can be
   used to make sure the vlan was added to a switchdev native device.
   When that fails, adding the vlan with br_switchdev_port_vlan_add()
   means it was added to a switchdev foreign device.
- Clear ingress_vlans bit and corresponding encap for dsa user ports.
- Add check for ingress_vlans bit to nft_dev_fill_bridge_path().
- Adapted cover letter description to make clear the patches apply
   to software fastpath, making hardware-offloaded fastpath possible.
- Fixed clang error for vlan_hdr * and struct ppp_hdr * by adding block.
- Updated !CONFIG_BRIDGE_VLAN_FILTERING version of
   br_vlan_fill_forward_path_pvid().
- Removed erroneous check netif_is_bridge_master(ctx->dev) from
   dev_fill_bridge_path().
- Cosmetic changes.

Eric Woudstra (13):
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe
  bridge: Add filling forward path from port to port
  net: core: dev: Add dev_fill_bridge_path()
  netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
  netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
  netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
  netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
    nft_dev_path_info()
  netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user
    port
  bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
  bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
  netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()

 include/linux/netdevice.h                  |   3 +
 include/net/netfilter/nf_flow_table.h      |   3 +
 include/net/switchdev.h                    |   1 +
 net/bridge/br_device.c                     |  23 ++-
 net/bridge/br_private.h                    |   5 +
 net/bridge/br_switchdev.c                  |  15 ++
 net/bridge/br_vlan.c                       |  29 +++-
 net/bridge/netfilter/nf_conntrack_bridge.c |  88 +++++++++--
 net/core/dev.c                             |  66 ++++++--
 net/netfilter/nf_flow_table_inet.c         |  13 ++
 net/netfilter/nf_flow_table_ip.c           |  96 +++++++++++-
 net/netfilter/nf_flow_table_offload.c      |  13 ++
 net/netfilter/nft_chain_filter.c           |  20 ++-
 net/netfilter/nft_flow_offload.c           | 166 +++++++++++++++++++--
 net/switchdev/switchdev.c                  |   2 +-
 15 files changed, 490 insertions(+), 53 deletions(-)

-- 
2.47.1

