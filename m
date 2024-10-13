Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F0513DDAA;
	Sun, 13 Oct 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845734; cv=none; b=euwgRwDfHR3e5+Jnpy5A6xerY7CjMEOb/WVjjzAVCxeXAvgQ3k++O5EQ2aorJdejzRsEsAMSVWux+qCHOhBi1uNweTJWua5B6ed1vJGWImvUl64EuLGJvpwHmVAuLE/kbL3QOPuuOrH31OWXqp9Kd7+OhAFbAUg9pqmkGpO8xTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845734; c=relaxed/simple;
	bh=tnoLGACvyZlv6R4EDQ15M1x1Pd9+UnPAmSvMFk51BbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gww8GtRaqVex3EUJSG3W6quNJpp8efOnn+4bP2crTB9HWnTLIkbnmYCpjqyA5QlroErc3CqRqRqxoopCEdquKmgl7HpQpFMFei7EXJx999Nw9vKjGLorrmmiQfZFGtxE0kqwY7upNjtPOJo2kP1ufk7Nmh8sieS0x9q5l/3umV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8OHtDmW; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8OHtDmW"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c957d8bce2so1642556a12.2;
        Sun, 13 Oct 2024 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845731; x=1729450531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D+/sR2kjz9V+zWn0d2wDxRH2CVHlBDFu10ji8AcnuMk=;
        b=C8OHtDmW4qvnJxgUrLE/lA3cfZsQuUiOziQOZ6ta482l1Ymb3njffRXZn6iHu4L0gz
         c5QbUmaiUNZ2lt28jEednQItW/6Lcfkv+Oo8zWvqSbcZtEyROFCOkcCsMbtyOBaWuhSo
         d+PiEPxF9g/sAMoO3gl7njnfeuDjhedHOofBnGk6Bp8c9ZpVA+6P6AtSIKuB37hS4TqE
         kbaP5jY63DR+j2FT/bhlrJqYWKjj5q22aUeWP9w53OqK2mqWc/ad08P/Fz9rFOwC8T4I
         ZrdyjUZdzWrvaeONGOl5negtOsZCVT5f16jU0feMqlaEv9aEQOi5V9sFgdX7f2ShI8NF
         TxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845731; x=1729450531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D+/sR2kjz9V+zWn0d2wDxRH2CVHlBDFu10ji8AcnuMk=;
        b=ccnP/cwdzJmHy3uH9mqsYg1NJuht4KvQ5Ea+C8ZyKj/n0Bos5CJinG+z0DkC7bFgJA
         Pz3b/63QEI9ESSEr6PLsQTGToVsJiCLgG8suIuJvW3q/mN6yFhY8qx1DoDxhN+VF9PPg
         X2yW7zpImXNUx9haz4sW31p4aT+8FRDpASXPmZMVkayTqUGofU+P9Qrqn7QTobqrPip3
         xpk45Oun9ON2aQcP4Vbzkk2JAEWkV5f33GYSOESYN8VAVXzbKneuamjIQpWjel1DTnVw
         +UfnOR0SkLB0Y/1iBvrFvqK+jJevGVbq5Fw4hImJ03M4wRlfDrrjsCLzwaySNWOXFsfr
         PHeg==
X-Forwarded-Encrypted: i=1; AJvYcCUOe7q8jA+uTVPbpW1MDDbCKK2tpf7/yvS45vlbQoKp60fVO4eoPpHwj9T3QpmU3uCWx+z0mOhrqvdJKYE=@vger.kernel.org, AJvYcCWNDZA/WgLCOD5tvXV1GsjXiQ6F/B2g9Wm6xonpJSknZt4hxtTzhZALDPN8MvwuX44zyxRgHIzfNrqcLq7nZQtx@vger.kernel.org
X-Gm-Message-State: AOJu0YxEi0zYNReIE+9yeF3mnLV9jqS7wlGp14mSOrjlJ8MPJeQ9u+lK
	ghpRjBu4oIqvrY0Yfk3KCrM/frItfrD9qMbdNUY6xOiN3yx1Z/T3
X-Google-Smtp-Source: AGHT+IFUs+QjM43yj3nlR0ziuQLWkrMusL86D6FHgNlbZ4Yj4coPCVb+b+uweHJZ0+t4PyPXDgXOQg==
X-Received: by 2002:a05:6402:3510:b0:5c9:5aac:c622 with SMTP id 4fb4d7f45d1cf-5c95ac09918mr12547222a12.5.1728845731151;
        Sun, 13 Oct 2024 11:55:31 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:30 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related improvements
Date: Sun, 13 Oct 2024 20:54:56 +0200
Message-ID: <20241013185509.4430-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes it possible to set up a (hardware offloaded) fastpath
for bridged interfaces.

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
DEV_PATH_MTK_WDMA in nft_dev_path_info() and avoiding
DEV_PATH_BR_VLAN_UNTAG_HW for bridges with ports that use dsa.

Conntrack bridge only tracks untagged and 802.1q. To make the bridge
fastpath experience more similar to the forward fastpath experience,
I've added double vlan, pppoe and pppoe-in-q tagged packets to bridge
conntrack and to bridge filter chain.

Eric Woudstra (12):
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe
  bridge: br_vlan_fill_forward_path_pvid: Add port to port
  bridge: br_fill_forward_path add port to port
  net: core: dev: Add dev_fill_bridge_path()
  netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
  netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
  netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
  netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
    nft_dev_path_info()
  bridge: br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
  netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()

 include/linux/netdevice.h                  |   2 +
 include/net/netfilter/nf_flow_table.h      |   3 +
 net/bridge/br_device.c                     |  20 ++-
 net/bridge/br_private.h                    |   2 +
 net/bridge/br_vlan.c                       |  24 +++-
 net/bridge/netfilter/nf_conntrack_bridge.c |  86 ++++++++++--
 net/core/dev.c                             |  77 +++++++++--
 net/netfilter/nf_flow_table_inet.c         |  13 ++
 net/netfilter/nf_flow_table_ip.c           |  96 ++++++++++++-
 net/netfilter/nf_flow_table_offload.c      |  13 ++
 net/netfilter/nft_chain_filter.c           |  20 ++-
 net/netfilter/nft_flow_offload.c           | 154 +++++++++++++++++++--
 12 files changed, 463 insertions(+), 47 deletions(-)

-- 
2.45.2

