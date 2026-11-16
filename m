Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868020;
	b=hw5tvIiANQJ8LZ9hSYVGcLY09YKCZGEBiyu1O9S67EcYKAwzMWQTcBhiL1LxoEuY9oVT
	 62h+G7eIwlmPZYhAIJ109kYqpIjCI3P0hHGzchdxSs1+ClCRbzvUIEdh8ATZXV2LLhlKV
	 ubEOUJ315y0c5DYHSEbf+u3KG4SV7sMp2zj14JAAiS8xBXthrdgRnsxFndMytgcOvPI8T
	 006Zt8lyOT0BoN2P9HhoW8j3oDEa4TrqhcWSEznraaOeynMhpzAVb3uYuUBfX9AbrLDfA
	 ZDpNQDsNvSLvhQ1gAClY/QeUOr8oGkQUa3BvCu+sTcG34MgXcQ2VBaZ5CXISBNPVC9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868020;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=uU8tZTXcUBMR0SdEDPolE4NGbrqe4rVxxNF78kPZVOo=;
	b=TF1XTDqSq7JwrAKnqrIIjjUsIeqyGKwlkV8WROt23las/HTZWKEVGhwE78xGP7nmx2/q
	 prRSjTt9TAceInOH6ow6s4TAI4/Hm23w/r4CdE0t9Xjens5IFJd/yiaouOsQ08lLvC+lv
	 II7aO8kvQIKoUWGAeB6U+D5CSHBCtXeoGmGn6PGaB++KFN+FDu6OM4D/RAdqzFDKqOovm
	 u7CDWnjGT9fSCVk0hxOZrAe6QyOOdDKCAPGzWAGA+Sx9ry/44XjYhKFLgixwAsnHI7hth
	 CFLaO/AhPWUVEJkxZkcn1ZHFav+rBv49LmRa2lzY8C+AdRpacVNVsGU0xEeJPLZnMBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RynVvbRo;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3A606A8AC
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14A3A606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RynVvbRo
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so3891693a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868009; x=1795472809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uU8tZTXcUBMR0SdEDPolE4NGbrqe4rVxxNF78kPZVOo=;
        b=EelueJCp2HK3RUAEui0aOBUbdcjfo9gselQCP2nLJLFaykuXZxmg8vxZHgDLzPLXmc
         8Wl/tEHtB6HsMpszIgXAVw9YLp5EXJRFJzJV0pNOqlCs3ts7nfKQu5Cx4p+Si0Z/1/5q
         rybJg6thHCfBxmTKV72ScnHyne91yy3xa/8+xfLNYguMRGpKAR22HriLer6M6XO+anQR
         naOf4Y7jNy7qxc0JFZjHyP6IsMCGJhHSyqmoXl6QJQWSTePhHMTbs8AAaKU+lrBIyLKt
         eFJiA/OqXhnC/40zXfrxPVNzkc4L6vsZTfdEHy26C3WMJsTtBQK3agv/K120ur81Z93O
         nA6A==
X-Forwarded-Encrypted: i=1; AL+hErFobVCrJrU8+i83yNJlEpL1YoKZkZ/BWyv/+11EjW1detlUBOI5/c7Zt+sUdSzgeJcAbp754r4dsa+ZdQyCAfY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PELeiQI3Ib/w6imxVh1diT0KoVha6ppocoGbGC0VVSJWNzCla
	/rffxpJaAwue1DZ+S5NKG9FmJ4EMh61vcLh2WCpR83jUK17Y5NwVe4+1OojaluBn2hSthQLrjz3
	0EeAAUrjI8gB6TzSLYjoFPPTUnm/ica1B0IhCxhWbTsghPt6E027nv6PelG/kb7Bx2cmoHX7QlL
	P3SsYucIzaCEITalxWaaIEts7vJl4jjJL5g7+AzvtqAlZwdc2bQAG1jLzaYN0F3Ca99Vkaqz0Kq
	Wvo4MdRnb7OwlxuTKqnzgLxmn6B
X-Gm-Gg: AZFdTZdDgnUWUXjtYAYyKEoYlTmiB7YBfP+FyyIep++gPhXowPuFXCna1/EEGC6I55k
	bRAbnH86/Jfzkh5GV//w6nmin1CaHTJ32iWLEbW5OpSp1nYWdRWHb7pcHCF0MxVY276gU4zHUF/
	q5lYnAOe7rkr88dcI2EJHhrQShlroJeaZp7skR9Ai+65BdG6sKKhmyV20oyi/fUeWTkHvmTH4z6
	SfFPZIRVjuYd+a6J4oTjA0ruxukvfs3H1dtCzxwGtwEqEoS4K9cfTzA9/0iIILyUBoDOLCK5iyG
	uY/SqwexAioXUOntCNxNLmQZAZ23UI7Lg1IV9rUGiLSWKdXkc7PkysaAM82Ox4BX46W7YpnP0iT
	UPt4Py8Ae0ghE5vTHvskPBh8LOukRddbKtnUbkLmlasEozY2AEMcFlUPl5K7SDfal90XADxjn0a
	SgnIvjBCcaw8eHmG/r+bsG+dT2EEXvqs6fCW94mhSf
X-Received: by 2002:a17:90b:5347:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3b1b0a3ba60mr13256626a91.41.1794868009324;
        Mon, 16 Nov 2026 14:26:49 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abb97b44sm516878a91.2.2026.11.16.14.26.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:49 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-378722fd4a3so4434581eec.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794868007; x=1795472807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uU8tZTXcUBMR0SdEDPolE4NGbrqe4rVxxNF78kPZVOo=;
        b=RynVvbRo361/E/kkfTKPIMFXuQuWTX+dlrY297z3noawUDYhCGRNWHnFLGLbgU7eWH
         zvDmM/m2uVguu/N9oFvSCzD1ASS5/Zw11i+Pq6WMniHp2TbhvxjhMX766lDBHYFYxX4l
         xpEVhCggFFZICleqwvDO14hK5ZzEEKmn3+SBc=
X-Forwarded-Encrypted: i=1; AL+hErHrgRyBdHTJxNPcEm6n1YFuPx81BzUkMr2W/uSdEou6UYgaVCqdiaNFbERAb026ZDkD64PM2yiKzutDWS/36+k=@vger.kernel.org
X-Received: by 2002:a05:7300:d115:b0:36f:29bf:4326 with SMTP id 5a478bee46e88-37960384a9amr10423206eec.0.1794868006212;
        Mon, 16 Nov 2026 14:26:46 -0800 (PST)
X-Received: by 2002:a05:7300:d115:b0:36f:29bf:4326 with SMTP id 5a478bee46e88-37960384a9amr10423168eec.0.1794868005216;
        Mon, 16 Nov 2026 14:26:45 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:44 -0800 (PST)
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
Subject: [PATCH net-next 9/9] docs: net: document Northstar FA setup and NAT qualification
Date: Mon, 16 Nov 2026 14:25:19 -0800
Message-ID: <20261116222519.1416501-10-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
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

Describe the supported topology, GMAC2 data and GMAC0 exception wiring,
configuration, counters and software fallback. Provide classic/software/
hardware NAT controls and same-live-tuple TTL, MTU and ingress-policy
checks. Cover live route/neighbour changes, reachability probes and
read/insertion/deletion completion injection with reprobe recovery.

Explain that every IPv4 route, rule or nexthop event retires all
hardware owners, including unrelated and local-table updates. Document
the resulting offload-residency cost and distinguish actual cached-path
validation from the driver's incomplete FIB eligibility probe. Keep
campaign history and review status in the accompanying package.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 .../ethernet/broadcom/bcm-ns-fa.rst           | 507 ++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   1 +
 3 files changed, 509 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst

diff --git a/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst b/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
new file mode 100644
index 000000000000..2bc6cc5d94ce
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
@@ -0,0 +1,507 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+Broadcom Northstar flow accelerator
+===================================
+
+Status and scope
+----------------
+
+The driver supports BCM4708, BCM53011 and BCM53012. IPv4 TCP and UDP
+SNAT/DNAT have been validated on BCM953012ER (BCM53012), including normal
+and software-flowtable controls, external wire checks, hardware table
+pressure, software fallback, natural aging, teardown and recovery.
+
+BCM4708 and BCM53011 remain unvalidated. BCM53012 validation covers the
+limited topology below; maximum throughput has not been established.
+
+The driver accepts nftables flowtable offload through ``TC_SETUP_FT`` on
+bgmac. DSA forwards flowtable binds from its user ports to the GMAC2 conduit.
+The FA is inline on the UniMAC2 / switch IMP0 (port 8) path. GMAC0 and GMAC1
+are pass-through paths and cannot accelerate these flows.
+
+The initial supported configuration is deliberately limited:
+
+* IPv4 TCP/UDP with source NAT or destination NAT, including port translation.
+* Two standalone, untagged DSA router ports on the same switch, both using
+  GMAC2 as their conduit, in the initial network namespace.
+* Distinct unicast MAC addresses on the LAN and WAN router interfaces.
+* MTU 1500 on both router interfaces, one hardware flowtable, no upper devices.
+
+IPv6, VLAN devices, PPPoE, tunnels, bridges, bonds, hairpin forwarding,
+plain routing, multipath/nexthop-object routes, and simultaneous source and
+destination NAT in one direction
+are rejected for hardware offload. They can still use software forwarding.
+Hardware admission requires a second, operational CPU connection from switch
+port 5 to GMAC0. B53 CFP redirects IPv4 exceptions through this connection,
+physically bypassing FA. This includes TCP SYN/FIN/RST, TTL 0/1, IP lengths
+above 1500, and packets that do not match the input port's router MAC. TCP
+also requires the flowtable FIN/RST exclusion mask. Boards without the
+auxiliary connection retain software forwarding for both protocols.
+
+The hardware has 1024 directional IPv4 entries, arranged in 256 four-way
+buckets, four router MAC entries, and 128 next-hop entries. Capacity exhaustion
+returns an error to the flowtable infrastructure, leaving traffic in software.
+One connection normally needs two directional entries. Next-hop entries are
+shared by destination MAC; router MACs are shared with an internal/external
+side attribute. The driver learns the tuple hash from opcode-2 miss tags,
+so it does not implement an assumed software equivalent of the hardware CRC.
+A finite RX hash cache can also cause an offload attempt to fall back to
+software under miss floods.
+
+The new ``brcm-fa`` DSA tag protocol carries the prepended FA miss descriptor.
+Its hash, bucket, and parser status fields differ from the ordinary switch
+tag. The bgmac receive hook observes the metadata for hash learning; the DSA
+tagger consumes it and selects the input port. Timestamp descriptors are not
+supported. The ordinary ``brcm`` and ``brcm-prepend`` taggers retain their
+opcode validation.
+
+Implementation notes
+--------------------
+
+Table operations use the documented indirect access sequence. DATA0 triggers
+the transfer; reads discard the initial DATA0 value and wait for the fetch
+before consuming DATA7 through DATA0. Every wait is bounded. The driver keeps
+clear-on-read disabled because clearing on a read gives unreliable hit counts.
+Instead it reads cumulative packet counts and computes wrapping deltas in
+software.
+
+The indirect read port is released after each access, including an access
+that times out. Leaving read mode armed prevents per-entry hit counters from
+updating and breaks the flowtable's activity accounting.
+
+Live packet lookups must not overlap software table transactions. On the
+tested BCM53012, that overlap can advance the indirect address more than
+once and persistently copy one flow's key into another slot. Before each
+transaction, the driver requests GMAC2 CPU flow control, waits for pause to
+assert and allows an in-flight frame to drain. It preserves automatic flow
+control and restores the previous MAC control on every exit path. The switch
+CPU port must honor pause, with matching internal link speeds at both ends.
+The FA stays in normal mode so packet and Broadcom-header processing retain
+their usual paths. Completion checks cover both the busy bit and the
+auto-incremented table address. Frequent statistics and debugfs reads also
+consume time on the internal link; include that work in performance tests.
+
+Router destination MAC validation is enabled before publishing a forwarding
+entry. With no installed entries, it is disabled to obtain hashes for the
+first unknown tuples. VLAN TPIDs are disabled in the FA parser so tagged
+packets cannot match an installed untagged tuple merely by sharing its inner
+five-tuple, including the TCP/UDP protocol bit. When both CPU connections
+are explicitly described, B53 CFP reserves rules for TCP SYN/FIN/RST, TTL
+0/1 and IPv4 total lengths above 1500. These redirect to port 5 with a
+classification and termination reason. Nine masked prefixes cover every
+length from 1501 through 65535. Per-port allow rules require the router's
+destination MAC on that physical input port; a final IPv4 rule redirects
+everything else to port 5. MAC changes disable admission while updating
+these rules. Both
+meter outcomes use the same action. Ordinary data uses port 8 only; flooding
+to the auxiliary CPU is disabled. Standalone ports use basic EAP mode, with
+private VLAN membership restricting forwarding to the CPU connections.
+VLAN, EAP and STP filtering remain enabled. CFP classification is disabled
+on bridge members and CPU ports.
+
+FA must ignore switch exception metadata to accelerate standalone data,
+which normally carries the switch flooding reason. Consequently, an inline
+SYN/FIN/RST trap through port 8 is insufficient: FA would accelerate those
+packets as well. The auxiliary GMAC0 path avoids that lookup entirely. It
+uses embedded Broadcom tags; the port 8 data path uses prepended FA metadata.
+The tagger dispatches control packets to FA before delivering them to Linux.
+The auxiliary conduit uses promiscuous mode to receive the router port MACs.
+Before disabling its CFP redirects, B53 disables hardware lookup, retires
+all entries and blocks admission. Re-enabling the path permits fresh
+connections to offload.
+
+On a valid TCP control packet, NAPI marks the matching direction as closing
+and immediately disables IPv4 lookup in the parser. Broadcom-tag relocation
+remains active so the control packet can traverse the software forwarding
+path. A worker removes both NAT directions before resuming lookups. Global
+bypass is unsuitable here because it also disables tag relocation. IP options
+and fragments retire pairs by their L3 identity before Linux can process a
+reused tuple. RCU protects entry
+identity, and a generation check prevents an insertion learned before the
+control packet from racing past it. Closing rows retain their final packet
+delta for software accounting until the flowtable deletes their ownership.
+
+Hardware packet counters refresh flowtable last-used time and packet
+accounting. The hardware has no per-entry byte counter; reported byte totals
+therefore do not include accelerated traffic. Three-bit timestamps are not
+used for aging. Debugfs reads do not consume the driver's accounting deltas.
+
+Netdevice shutdown, address/MTU changes, new active switch ports, and upper
+interface changes flush entries. Every IPv4 FIB route, rule and nexthop change
+flushes all FA-owned flows, including unrelated prefixes and local-table
+entries. This is intentional: the rule does not carry enough routing-policy
+context to prove that an event cannot affect an installed path. Work is
+coalesced, but even unrelated routing churn can reduce offload residency.
+Redirects and next-hop MAC or validity changes also disable lookup and schedule
+entry retirement. The driver also notifies the flowtable owner to retire
+its cached software path; merely removing hardware rows would leave stale
+direct-transmit routes and destination MACs in use. Generation checks reject observations and publications
+that raced with invalidation. Before admitting a rule, the flowtable owner
+validates its actual cached routes and direct-path neighbours. Hardware
+flowtables retain validation-only route references, so this check preserves the mark,
+DSCP and output-interface context used when those paths were selected.
+These references do not enable automatic route checks for plain direct
+flows in other drivers or hardware-enabled flowtables. Existing direct
+tunnel, neighbour and XFRM route checks keep their previous behaviour.
+A proven stale cached route or neighbour retires the software owner too.
+The driver's separate FIB lookup is only a hardware eligibility probe:
+it lacks the complete policy context, so any mismatch declines hardware
+offload without tearing down a valid software owner. Unsupported route types,
+such as multipath, nexthop objects and lightweight tunnels, decline hardware
+admission without tearing down valid software flowtable forwarding.
+Valid neighbour aging transitions do not unnecessarily flush entries.
+Hardware counter activity drives Linux
+neighbour reachability probes, so an accelerated connection cannot leave a
+stale neighbour untested indefinitely.
+
+The flowtable classifier provides no per-route MTU. The driver therefore
+keeps all flows in software while any IPv4 route in the initial network
+namespace has an explicit MTU below 1500. The initial FIB notifier replay
+seeds a hash of low-MTU table/prefix pairs; route replacements and deletions
+update it incrementally without further FIB dumps. Ordinary routes use no
+tracking memory. If allocation fails or more than 1024 low-MTU prefixes
+need tracking, hardware admission remains disabled until reprobe; route
+updates and software forwarding continue. This conservative restriction also
+applies to unrelated routes. The CFP length trap handles packets exceeding
+the admitted interface MTU, including packets of an already installed tuple.
+
+A table timeout disables parser lookup
+and prevents further hardware insertion until reprobe. Tag relocation remains
+active for software fallback. Reconfiguration can
+leave an existing conntrack entry temporarily labelled HW_OFFLOAD after its
+hardware entries have been flushed. Use fresh connections after topology or
+ruleset changes; the label alone is never proof of forwarding by hardware.
+
+Device tree and kernel configuration
+------------------------------------
+
+Enable at least::
+
+  CONFIG_BGMAC_BCMA=y
+  CONFIG_BCM_NS_FA=y
+  CONFIG_NET_DSA=y
+  CONFIG_B53=y
+  CONFIG_B53_SRAB_DRIVER=y
+  CONFIG_NET_DSA_TAG_BRCM_FA=y
+  CONFIG_NF_CONNTRACK=y
+  CONFIG_NF_TABLES=y
+  CONFIG_NF_FLOW_TABLE=y
+  CONFIG_NF_FLOW_TABLE_INET=y
+  CONFIG_NFT_FLOW_OFFLOAD=y
+  CONFIG_NFT_NAT=y
+  CONFIG_NF_NAT=y
+  CONFIG_DEBUG_FS=y
+
+Modules are supported too. Use the board's existing ARM configuration and
+retain its PHY, switch, filesystem, and boot-device options.
+
+For a BCM53012 board, add the following node under the root address space
+(adjust the compatible to ``brcm,bcm53011-fa`` for BCM53011)::
+
+  / {
+      fa: flow-accelerator@18027c00 {
+          compatible = "brcm,bcm53012-fa";
+          reg = <0x18027c00 0xc0>;
+      };
+  };
+
+  &gmac2 {
+      brcm,flow-accelerator = <&fa>;
+      status = "okay";
+  };
+
+Both tested user ports must use switch port 8 and GMAC2. In the existing B53
+switch node, port 8 must have ``ethernet = <&gmac2>``. Also enable
+switch port 5 with ``ethernet = <&gmac0>``, ``phy-mode = "internal"`` and a
+1 Gbps full-duplex fixed link. Enable GMAC0 and bring its network interface
+up before testing either protocol; retain port 8 as the preferred conduit for
+user ports.
+Remove any other conflicting CPU assignments for this test. B53 selects ``brcm-fa``
+when it finds the enabled accelerator through this phandle. Do not set
+``dsa-tag-protocol``: B53 does not implement the runtime protocol-change
+operation. No existing board is enabled automatically by this series.
+
+The FA resource is outside the GMAC3 DMA register window. It is managed by
+the GMAC2 consumer; it does not need a separate platform driver or character
+device. Leave the accelerator disabled or omit the GMAC2 phandle to retain
+the existing board configuration.
+
+Three-host hardware test
+------------------------
+
+Use a dedicated test router with serial access and two external Linux hosts.
+Traffic generated on the router itself does not exercise the inline receive
+path. Keep all other switch user ports administratively down. Replace the
+interface names below with those on the board::
+
+  LAN host                 BCM5301X router               WAN host
+  192.0.2.2/24 -- lan1 192.0.2.1   198.51.100.1 wan -- 198.51.100.2/24
+                           \       /
+                         GMAC2 / FA
+
+Assign distinct router MACs before bringing up the interfaces::
+
+  ip link set lan1 down
+  ip link set wan down
+  ip link set lan1 address 02:00:00:00:01:01
+  ip link set wan address 02:00:00:00:02:01
+  ip addr add 192.0.2.1/24 dev lan1
+  ip addr add 198.51.100.1/24 dev wan
+  ip link set lan1 up
+  ip link set wan up
+  sysctl -w net.ipv4.ip_forward=1
+
+On the LAN host, assign 192.0.2.2/24 and a default route via 192.0.2.1.
+On the WAN host, assign 198.51.100.2/24 and a default route via 198.51.100.1.
+Do not put the router ports in a bridge or create VLAN uppers. Ensure that
+other firewall rules on this lab router permit the test packets.
+
+Mount debugfs if necessary and locate the FA status file::
+
+  mount -t debugfs none /sys/kernel/debug
+  find /sys/kernel/debug -name fa -type f
+  cat /sys/kernel/debug/<GMAC2-device-name>/fa
+
+The file contains ``failed``, global ``hits`` and ``misses``, error bits,
+and a row for every programmed directional entry. Each row identifies its
+slot, cookie, input/output interfaces, and raw hardware packet count. Save
+snapshots with timestamps before, during, and after every test.
+
+The adjacent ``fa_table`` file shows each software-owned tuple and the eight
+hardware words in DATA7 through DATA0 order. It uses the same lock and
+bounded indirect accesses as statistics collection. Save it when an entry
+stops counting to compare the hardware key against software ownership.
+
+Install a uniquely named test table; do not flush unrelated tables::
+
+  table inet fa_test {
+      flowtable ft {
+          hook ingress priority 0;
+          devices = { lan1, wan };
+          flags offload;
+          counter;
+      }
+      chain forward {
+          type filter hook forward priority 0; policy drop;
+          meta l4proto udp ct state established flow add @ft
+          ct state established,related counter accept
+          iifname "lan1" oifname "wan" udp dport 5001 counter accept
+          iifname "wan" oifname "lan1" udp dport 5001 ct status dnat counter accept
+      }
+      chain prerouting {
+          type nat hook prerouting priority dstnat; policy accept;
+          iifname "wan" udp dport 15001 dnat ip to 192.0.2.2:5001
+      }
+      chain postrouting {
+          type nat hook postrouting priority srcnat; policy accept;
+          iifname "lan1" oifname "wan" ip saddr 192.0.2.2 snat ip to 198.51.100.1:45000
+      }
+  }
+
+Save this as a ruleset and load it with ``nft -f <file>``. For the two control
+runs described below, edit only this test table. Delete it between phases
+with ``nft delete table inet fa_test``. Delete matching conntrack entries
+between phases, for example::
+
+  conntrack -D -p udp --orig-src 192.0.2.2 --orig-dst 198.51.100.2 --dport 5001
+
+For SNAT, run a UDP or TCP echo server on the WAN host at
+198.51.100.2:5001. Run a client on the LAN host, bind its source to
+192.0.2.2:40000, and connect to that server. Verify the server observes
+the translated peer 198.51.100.1:45000. Include a sequence number in each
+payload and check every returned payload for loss or corruption.
+
+Run three phases with a fresh connection each time:
+
+1. **Normal forwarding:** omit the ``flow add @ft`` rule. Forward-chain
+   counters should grow throughout the test. FA entry counts and hit counts
+   should not grow for this traffic.
+2. **Software flowtable:** restore ``flow add @ft`` and omit ``flags offload``.
+   Expect OFFLOAD and no hardware entries/hit growth for this flow. Reduced
+   forward-chain counters in this phase demonstrate why those counters alone
+   cannot prove hardware offload.
+3. **Hardware flowtable:** restore ``flags offload``. Wait a few seconds for
+   asynchronous rule installation, then compare multiple debugfs snapshots.
+
+The hardware phase passes only when all of the following hold:
+
+* The WAN server sees the peer as 198.51.100.1:45000, proving address and
+  source-port translation. The client receives the original payloads.
+* ``conntrack -L -p udp -o extended`` identifies the expected original and
+  reply tuples and reports HW_OFFLOAD. OFFLOAD alone is insufficient.
+* There are two hardware entry rows for the connection and **both** packet
+  counters advance while the echo stream runs. The netfilter core can mark
+  HW_OFFLOAD when only one direction is accepted, so check each direction.
+* The global FA hit count advances with the transfer, ``failed`` remains 0,
+  and hardware error bits do not increase.
+* Captures on the external hosts show the expected rewritten IPv4/TCP or
+  IPv4/UDP tuples, valid checksums, unchanged payloads, and exactly one TTL
+  decrement.
+* Router CPU load and GMAC DMA packet growth are substantially below the
+  software phase at the same offered packet rate. A router-side capture
+  should see initial misses but few steady-state packets from this stream.
+  Compare external captures; packet-capture placement and GRO can affect
+  counts on the router.
+
+Use ``tcpdump -ni <host-interface> -vv -w <capture.pcap> udp`` on both external
+hosts. If host checksum offload obscures validation, temporarily disable the
+relevant offloads on the test hosts and restore them afterward. Capture from
+the receiving host or a wire tap when checking checksums.
+
+For DNAT, stop the WAN server and run the echo server on the LAN host at
+192.0.2.2:5001. Run the client on the WAN host, bind it to 198.51.100.2:40001,
+and connect it to 198.51.100.1:15001. Verify destination IP/port translation
+on the LAN capture and the source IP/port restoration on the WAN reply.
+Repeat all three phases and require hit growth in both directions.
+
+Stress, teardown, and negative tests
+------------------------------------
+
+* Change SNAT to a port range for parallel sessions. Exercise multiple
+  clients and next hops, hot buckets, more than 128 next-hop MACs, and over
+  512 bidirectional sessions. Failures to allocate must fall back to software
+  without modifying a different connection's entry. Four-way collisions can
+  exhaust a bucket before the whole table is full.
+* Keep a densely occupied table active while repeatedly reading statistics.
+  Compare the software tuples with the raw entries in ``fa_table`` before
+  and after the test. Every valid hardware key must match its owning slot,
+  cookies must stay stable and every active direction's counter must grow.
+  Intact echoes and HW_OFFLOAD labels alone can conceal damaged entries
+  whose traffic has fallen back to software.
+* Stop the generator and wait longer than the configured UDP conntrack
+  timeout. Hardware rows must disappear. Run sustained traffic longer than
+  that timeout and verify that counter-based last-used refresh keeps the
+  connection alive. Check packet counter wrap handling during a long soak.
+* Delete the test flowtable during traffic. Entries must disappear and
+  forwarding must continue through the remaining firewall/NAT path. Delete
+  only the flow-add rule first if retaining the table is useful for this test.
+* Disable ``hw-tc-offload`` on the conduit with ethtool. Entries must be
+  flushed and new hardware insertions rejected. Re-enable it and use fresh
+  connections.
+* Test port down/up, a third port up, router MAC changes, MTU changes, a bridge
+  or VLAN upper being added, conduit down/up, module unload/reload, and
+  suspend/resume if supported. Require removal of stale entries and clean
+  resource reuse. Start fresh connections after each topology change.
+* Try IPv6, ICMP, GRE, PPPoE, VLAN and QinQ devices, double NAT, and
+  hairpin NAT. They must not create FA entries. Exercise tagged packets whose
+  inner tuple equals a live untagged offload; they must not hit that entry.
+* Send IPv4 fragments, IP options, bad IP checksums, runt/truncated headers,
+  and switch exception traffic. Require software handling or the normal
+  stack/switch drop behavior, never a stale or unrelated hardware hit.
+* Verify UDP zero-checksum packets, nonzero checksums, packets whose updated
+  checksum folds to zero, minimum-size frames, and maximum MTU packets.
+* Repeat SNAT, DNAT, table pressure, software fallback, aging and recovery
+  with TCP. Require the TCP bit in every owned raw table key and advancing
+  counters in both directions. Compare classic, software and hardware modes.
+* While hardware data counters advance, capture SYN/FIN/RST on the GMAC0
+  auxiliary conduit. Require embedded Broadcom tags and delivery to Linux.
+  Close with FIN and RST, reuse the same tuple, and change its NAT
+  mapping; require immediate removal of the old hardware directions, correct
+  new peers and intact framed payloads. Repeat with options and fragmented
+  control packets. An HW_OFFLOAD label alone does not qualify this test.
+  Bring GMAC0 down while TCP data flows. Require removal of its hardware
+  rows, intact software forwarding, and rejection of new TCP hardware
+  entries. Bring GMAC0 up and require fresh connections to offload again.
+* Run TCP and UDP with identical IP addresses and transport ports. Require
+  independent hashes, hardware protocol bits and correct payload delivery;
+  closing TCP must leave the UDP directions installed and advancing.
+* With a development fault-injection mechanism, force an indirect-port busy
+  timeout. Require bounded completion, ``failed 1``, no further insertions,
+  no reuse of uncertain table resources, and working software forwarding.
+  Reprobe before repeating. The driver provides no writable debugfs register
+  interface; do not poke live registers from userspace.
+
+Boundary and invalidation qualification
+---------------------------------------
+
+Run these tests with UDP and TCP, SNAT and DNAT, and classic, software
+flowtable and hardware forwarding. Install both hardware directions and
+verify their raw keys before injecting packets of that same live tuple:
+
+* TTL 0 and 1 must produce the software baseline's ICMP time-exceeded
+  response without forwarding a wrapped TTL. Ordinary traffic must decrement
+  TTL exactly once.
+* An IP length of 1500 must pass. At 1501, DF must produce ICMP fragmentation
+  needed with MTU 1500; without DF, Linux must fragment into packets no
+  larger than 1500. Check transport checksums after reassembly.
+* Inject the tuple on the opposite physical port, addressed both to the
+  original input MAC and the receiving port's MAC. Require the same ingress
+  firewall policy as the software baseline. Also test unrelated unicast,
+  broadcast and multicast destination MACs. These must not enter IPv4
+  forwarding merely because a five-tuple matches.
+
+While a hardware connection is live, replace its neighbour MAC and require
+all subsequently forwarded frames to use the new MAC. Set the neighbour to
+``NUD_FAILED`` while preventing ARP replies and require forwarding to stop.
+Restore reachability and require recovery. Force a valid neighbour to STALE
+while hardware counters advance and require a Linux ARP reachability probe.
+
+Install a blackhole host route and then a source-policy blackhole rule;
+require forwarding to stop after each netlink acknowledgment. Remove each
+change and check payload delivery and fresh hardware admission. Add an MTU
+1200 host route both during an existing connection and before a fresh one.
+Require zero hardware entries, intact small software-forwarded packets and
+ICMP fragmentation-needed with MTU 1200 for a 1280-byte DF probe. Remove
+that route and verify recovery. Keep the flowtable installed throughout;
+recreating it would conceal missing invalidation.
+
+Fault injection qualification
+-----------------------------
+
+A development kernel can enable ``CONFIG_FAULT_INJECTION``,
+``CONFIG_FAULT_INJECTION_DEBUG_FS`` and
+``CONFIG_BCM_NS_FA_FAULT_INJECTION``. The per-device ``fail_table`` directory
+uses the standard fault-injection attributes. The default probability is
+zero. Injection returns a timeout after an indirect transfer has completed,
+which deliberately makes completion uncertain to its caller. This tests
+software handling of uncertain reads and writes, including a write that may
+already have published an entry; it does not emulate a physical bus hang.
+The ordinary hardware busy/address waits remain bounded independently.
+
+For one injected failure, with the device name adjusted as needed::
+
+  D=/sys/kernel/debug/bcma0:5
+  echo 1 > $D/fail_table/times
+  echo 1 > $D/fail_table/interval
+  echo 0 > $D/fail_table/space
+  echo 100 > $D/fail_table/probability
+
+The next table access fails. To restrict injection to a table write, set
+``fail_table_write_only`` to ``Y`` before arming it, then insert a fresh
+connection or delete an installed one. Run read, insertion and deletion
+cases on separate clean probes. Verify ``failed 1`` and exactly one
+``fault_injections`` increment. Lookup must be disabled before the paused
+switch traffic resumes. Broadcom-tag relocation must remain active, and
+uncertain entries and MAC resources must not be reused until reprobe.
+
+Keep UDP and TCP SNAT/DNAT traffic active across each failure. Validate all
+eight wire directions for correct tuples, payloads, checksums and exactly
+one TTL decrement. Require a fresh connection to work in software and an
+ethtool feature toggle to leave the failed state latched. Stop the test,
+reprobe and require clean hardware admission again. Do not poke live
+registers from userspace; no writable register interface is provided.
+
+Automated validation
+--------------------
+
+Run the supplied KUnit configuration from a clean source tree::
+
+  ./tools/testing/kunit/kunit.py run --arch=x86_64 \
+      --kunitconfig=drivers/net/ethernet/broadcom/.kunitconfig \
+      --build_dir=/tmp/bcm-ns-fa-kunit '*fa*'
+
+The backend, switch and tagger provide KUnit suites named ``bcm-ns-fa``,
+``b53-fa-guards`` and ``brcm-fa-tag``. Enable ``CONFIG_BCM_NS_FA_KUNIT_TEST`` and
+``CONFIG_NET_DSA_TAG_BRCM_FA_KUNIT_TEST`` and ``CONFIG_B53_FA_KUNIT_TEST``
+with KUnit and their parent drivers.
+They cover cross-word field layout and endianness, NAT action rejection,
+miss-hash learning exclusions, opcode validation, source-port demultiplexing,
+consumption of the four-byte metadata tag, route-MTU admission and CFP UDF
+layout. The length-prefix test checks all 65536 possible IPv4 lengths.
+These tests do not simulate the FA.
+
+Build the bgmac, B53, and DSA objects with ``W=1`` for ARM, plus an x86
+COMPILE_TEST configuration; also check the FA-disabled configuration and
+built-in/module combinations. Run ``dt_binding_check`` for both new schemas,
+``checkpatch.pl``, and ``git diff --check``. The hardware matrix above remains
+mandatory even when all automated checks pass.
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 403ae9c2b06a..007e5c5c892a 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -18,6 +18,7 @@ Contents:
    amd/pds_vdpa
    amd/pds_vfio_pci
    aquantia/atlantic
+   broadcom/bcm-ns-fa
    chelsio/cxgb
    dlink/dl2k
    davicom/dm9000
diff --git a/MAINTAINERS b/MAINTAINERS
index c05ac2258889..7fbc78f9dd41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5672,6 +5672,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
+F:	Documentation/networking/device_drivers/ethernet/broadcom/bcm-ns-fa.rst
 F:	drivers/net/dsa/b53/b53_fa_test.c
 F:	drivers/net/ethernet/broadcom/.kunitconfig
 F:	drivers/net/ethernet/broadcom/bcm-ns-fa*
-- 
2.53.0

