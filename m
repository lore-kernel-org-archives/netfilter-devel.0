Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794704165;
	b=CYV6IS/H5sv0Y88CnXTVdymM/X3/HI1D/vdWO5VJyLNB6jMQjtNbYBcNgZ6CmcBDboe9
	 RpgERT17a6hbmfOzUAZTAT4J4+2h8wBWeyLByYOGSkc3c4CQwMct/vwz1/fVNY+pRffuP
	 QqUlwAjnZHnU6MqZYdT4YWoJhq2nNcZky92nACIWHzjNjHDnkdLUB73CWPEfpKnKGi8MC
	 KKneAqVNvs7J76uKQLH+f0SEPVyhcPjcF/OZYh1McZ58tlFFwUgr4yLrc6lw7Jeznmq1K
	 pMcrYcFGKrreDiDr987pwToedrmG3MvNEr7n0nk30UTJZS3siQAdOOW+WCM/+NrjUlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794704165;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TEe8D5P09T7tDxCiTRWgdiV435JqX7aUW5WkZ/vkqBo=;
	b=Pyl4CO3HkcrW3dMYHu2Gs4qGxDOyHo/Hdw1UBi9o7U/x/ztDBXELOVEf8vDTkqc5cLRZ
	 Y6/SDWMm0+bk6DTBmXyx7piRwFFsuFZ5mjf1SwEezamKsgzAsbruhg8SwLTV0fawW9F0T
	 hL1awamcuXAkgzHLgVEAl+5PxVRDmIHB9fRAYA4EUmo0QYjcS/5LO5CFF7jjrYc1EikmR
	 9G104iB3mNFVAbqR/cKmhZ1LTMyqLeE21rIjTCx/dkSehBV2LAhqK96/nNwJCHnDmbbE9
	 hM9Mm18c2C6bB47GKHSKPnDing4mAdQiCk6RVssZnmgxJkp7qr9vSBUFXDQvVEa0Dhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=i+nkYYZ5;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20131606A327
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20131606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=i+nkYYZ5
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so3550093a12.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 16:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794704163; x=1795308963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TEe8D5P09T7tDxCiTRWgdiV435JqX7aUW5WkZ/vkqBo=;
        b=i+nkYYZ5WZXVA6Sd0W0lzQbXlYxqA3vHmcbCdRKjpn6GwmxOBt05KqSQ42DKqy2cB1
         2d/22IZLsvA89rAo79MhNCwBgNaGQ9I2YD2u+KeqgnU1FJcVAyt6LwMsEw3yEYiLLTDw
         AzN90wQSgNRtob67YBfLzt8kjyvPMrcoCJnssaYlsV/3uC33vxMnZDVO/UEW+yL5a69n
         tBXiIJUPWoT0C/QF7yksztaJOXgNm77b6NxI9KseoF4vphdyh3W4qoFbUZvl7njsKRlC
         UcaseQlog7w9NR6qwYDsadwyGTzbkca2RPxxAUK0Z5nWg01wE+icO99+cwTLCjzDaXXG
         jenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794704163; x=1795308963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TEe8D5P09T7tDxCiTRWgdiV435JqX7aUW5WkZ/vkqBo=;
        b=MbsCsfMSOrpvetk4Dhbcu0T8TmQ4styogkaHHhXHYVa73wL4Lb5ubmqA9L95azEKYp
         JwrLy6NofhAlihh1off182Y9eLGZoW1EP+dtvD6+7DgE9T0rrZDIq0tYWE1TutXgsbF6
         iSFh1a28W7hlczZ17WIA0DXTSNCq1/lzSUeVVwPtOzqAqOnYcEifm3JEay/e712rwLUU
         ihppl9fq/+ksB5iwIJaJbHERGzo5NUJxavZJ41tZHKGq3HHAVPilL3AsIIZEZZtA4m/S
         jev+S1oV+qCOe3V3ItTT89luLgWuBRYghcgm9Cre+1AOXcbynm7W2dWt3Bv7Sa5sfUfq
         QWLQ==
X-Gm-Message-State: APuU4Z+0hZWDn3OJimrjkR4nSstefM2x8/37t7MCFmEPcVO38lw7MbQh
	wI+ZKMugHoGgu3hqBjh+7TYXM/ZCbf7vRC2MnuCiCZc++mTqwvMKLh90AAIUF1gipnFpir/c+IN
	d81yBoFGN
X-Gm-Gg: AYBFou1AWiZOBSWojwkeesuntgIWUR+zKuyRIFrH6ooJRjSJrEK6dvfc5UbwX4R1Aa6
	cSRwQavsM09114JSQ9sda3zXn+XFO9ZpEBHl8vwLi8htNz3E8X4wseKg4tBW/QzqlP8Nvev5v+6
	V9WmeIdZG2ofjJeOpmN7NRImeQoWgWG6YiJAdANP1UDAY33ApuTWqHm4u0mYuPbTotTh3rbh3Kh
	Hwuj+SAu14RTus1TLVgdOeHlcRFRQkqm1gUcMUThuKlPtFlBOQK2rNXKaT7rBz5U3Q3l7sR+05X
	4IbMsD0UkkzAKnma/qEA3XiUWLTbJgWvicFbBIQ+rUP8MPU2K3Dagikg38vL9E4wu3swXQd5sKy
	2bPdiba4vdAPPuCYjx0WMxW43DuQyRDoALeogCN5ZZBpTobznUit4lyF3CPWG0Kedg/0gkmJnFX
	6azl7NRnu0zIfsOc4rpZSy0Fsi9G0k4n8sq7s4X6X+NxkFyUzWRhJhnH6kf0v7dmKYfsB2hEsCv
	0sBNIG2LjlRXzk3aBP51nuOCxropDqFxb81NyGsA54DJCoJPyv91gcuS2RU6Ohl9E9Lm/hTw+UR
	gE9zO2zjG1T552GVUwJO9TQTHwVrR2t38wMxx6O90dQur/TT8tQaMbqiRrnAKQVKxS8QiMxs+d6
	pxdRSvRa2NdczqQ+hyw5hR2/HsYVCTuYDksuSN4aKVCsmYfABAX0dnh1a+HjkMv4VKHRxN1FGvo
	qs6kZBFbOWx5uleIPi80DN7VjNtGiJxnCFV5HXOee6TKk0YtRFxN5VB/hr0Ql4ynCXEj6X5hIce
	OzMawtaeV4fZgNeybY2J8Rh1R/bUuEwPG5lnSnmkoqSSwcwKoN95eXDyHPzRXWj5OzI/oLSY2ig
	XaDP95eAgalaVulTDPnwB+zW+w6ulpjM1VMgE7tfyd8xI56wmfSUn6FjMPFIAesHZ2P319AB
X-Received: by 2002:a17:907:3d44:b0:c40:4965:72c3 with SMTP id a640c23a62f3a-c509637c12emr491035466b.19.1794704162921;
        Sat, 14 Nov 2026 16:56:02 -0800 (PST)
Received: from Desktop (p200300f2470a670069e45948b1a17361.dip0.t-ipconnect.de. [2003:f2:470a:6700:69e4:5948:b1a1:7361])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b921d4sm266313166b.83.2026.11.14.16.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:56:01 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v10 0/3] netfilter: flowtable: tear down bridged flows on layer 2 roaming
Date: Sun, 15 Nov 2026 01:55:52 +0100
Message-ID: <20261115005555.645727-1-julius@bairaktaris.de>
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

A flowtable flow that transmits straight to a bridge port keeps sending
to the old port when the host moves to another port, for example a Wi-Fi
station roaming between access points.

Patch 1 is a bridge fix the series needs: br_fill_forward_path() fills a
path to a port that does not forward (STP blocking or disabled, an MST
vlan not forwarding), so the flowtable transmits where the bridge would
not. Patch 2 makes the gc tear a flow down when the fdb entry moves or
the port no longer forwards in its vid. It is Pablo's patch with my
changes on top: it keeps his authorship, his Signed-off-by from his
posting and a note of what I changed. Patch 3 adds selftest cases.

The gc finds the bridge port from out.ifidx through the vlan devices of
the path and the bridge from the port, and looks the entry up in the vid
the forward path used, which the tuple now keeps in out.bridge_vid. With
two bridges on the path it also checks the outer one. struct
flow_offload grows from 296 to 312 bytes on x86_64; its slab cache is
SLAB_HWCACHE_ALIGN, so an object takes 320 bytes either way. A gc pass
over 2000 flows, 1021 of them offloaded to a bridge port, took 277 to
278 us with the series and 171 to 281 us without it (median of each of
three runs), and no flow was torn down.

Tested on nf-next 734bef548a96 in an x86_64 guest with PROVE_LOCKING:
nft_flowtable.sh passes three runs out of three, including the eighteen
roaming cases in both of its passes, with no lockdep splat; the "block"
case took its final form after those runs and passes three runs of its
own. On v9 the cases for the fixes of this version fail (stacked
bridges, the untagged vlan that is not the pvid, the disabled port, the
vlan leaving the port); without the series every roaming case but "del"
and "age" fails. net/netfilter and net/bridge build without warnings
with W=1 (x86_64 allmodconfig), each patch on its own, and with
BRIDGE_VLAN_FILTERING off.

I used Claude (Anthropic) to help write these patches.

Changes in v10:
- the tuple keeps the vid of the fdb lookup (out.bridge_vid) instead of
  the bridge_vlan bit and the port pvid: a bridge vlan that leaves the
  port untagged is popped from the encap stack (DEV_PATH_BR_VLAN_UNTAG)
  or never pushed (DEV_PATH_BR_VLAN_KEEP), so v9 looked in the pvid of
  the port, which is another vlan when the untagged one is not the pvid,
  and kept the stale flow (Sashiko). This answers Pablo's v7 question on
  bridge_vid: no bit can recover that vid
- the gc also tears the flow down when the port stops forwarding in its
  vid (STP blocking or a disabled port, a vlan removed from the port,
  vlan_filtering toggled); v9 kept sending to a disabled port and in a
  vlan removed from the port. The new patch 1 keeps the forward path
  from recreating such a flow
- with two stacked bridges the gc checks the outer one too; v9 checked
  only the bridge of the transmit port and missed a move on the outer
- selftest: vid 10 untagged on ports of pvid 1 through a vlan device on
  the bridge and through the bridge pvid; a move from behind the inner
  to a port of the outer bridge; the host's port disabled; the vlan
  leaving the port; vlan_filtering turned off before a roam
- selftest: the IPv4 roaming cases turn IPv6 off on the host, whose
  router solicitations crossed the bridge and refreshed the entry the
  "age" case waits to expire (2 of 8 runs failed)
- selftest: lines wrapped to 80 columns, namespace names initialised
  (NIPA checkpatch and shellcheck on v9)
- Cc coreteam and linux-kselftest (NIPA cc_maintainers on v9)

Changes in v9:
- reset port_vlans at each bridge in the forward path, so the gc checks
  the bridge the flow transmits on: with a vlan device of one bridge
  enslaved to another, v8 counted the vlans below both bridges, looked
  up the bridge port from the wrong device and read past encap[]
  (Sashiko)
- selftest: a bridge port that is a vlan device of another bridge
- selftest: the roaming cases give socat five times SOCAT_TIMEOUT, as
  roam_stop() ends it; on a loaded host a case took 109 s and the 60 s
  timeout ended the transfer before the check
- authorship: Pablo's patch is credited as such, with his sign-off from
  his posting and a note of my changes, instead of Co-developed-by; his
  paragraph on the switchdev notifier alternative is back in the commit
  message
- rebased onto current nf-next

Changes in v8:
- drop bridge_ifidx and bridge_vid (Pablo): the bridge port is found
  from out.ifidx through the vlan devices below the port, the vid comes
  from the encap stack (bridge_vlan bit) or is the pvid of an untagged
  port of a vlan_filtering bridge
- the fdb check sits in nf_flow_dst_valid() next to nf_flow_dst_check(),
  the hook is fdb_valid_dst() again, and the comments Pablo pointed out
  are gone

v9: https://lore.kernel.org/netfilter-devel/20261108155344.35845-1-julius@bairaktaris.de/
v8: https://lore.kernel.org/netfilter-devel/20261017235849.1066624-1-julius@bairaktaris.de/
v7: https://lore.kernel.org/netfilter-devel/20261014235628.197976-1-julius@bairaktaris.de/
v6: https://lore.kernel.org/netfilter-devel/20261004171605.3544792-1-julius@bairaktaris.de/
v5: https://lore.kernel.org/netfilter-devel/20260914072541.897040-1-julius@bairaktaris.de/
Pablo's patch: https://lore.kernel.org/netfilter-devel/20261014210256.1573072-1-pablo@netfilter.org/

Julius Bairaktaris (2):
  net: bridge: fill a forward path only to a port that forwards
  selftests: netfilter: nft_flowtable.sh: roam a host between two bridge
    ports

Pablo Neira Ayuso (1):
  netfilter: flowtable: tear down direct xmit flows when the fdb entry
    moves

 include/linux/netfilter.h                     |   7 +
 include/net/netfilter/nf_flow_table.h         |  22 +-
 net/bridge/Makefile                           |   2 +
 net/bridge/br.c                               |   2 +
 net/bridge/br_device.c                        |   2 +-
 net/bridge/br_forward.c                       |  19 +
 net/bridge/br_nf_utils.c                      |  35 ++
 net/bridge/br_private.h                       |  14 +
 net/netfilter/core.c                          |   3 +
 net/netfilter/nf_flow_table_core.c            |  68 +++-
 net/netfilter/nf_flow_table_path.c            |  29 +-
 .../selftests/net/netfilter/nft_flowtable.sh  | 364 ++++++++++++++++++
 12 files changed, 561 insertions(+), 6 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0

