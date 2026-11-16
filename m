Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868009;
	b=YFlUBhhVaKWZTaeWA9cH4R8QsLF+WoH35DJVHQNQkeYfdVM2/y7mNsRRHW1pEB+QkflJ
	 ENZB9y24ArbzNf+dbpSGvLJcLk8INzJ58dh99QydS1SVJE3Ec8IcLmNQWfzSulIhxbPyV
	 jLDyP/DfOjfRM3a7icOi3olyS6VVf8uZbq42v7fauRMmXbyZ4q3sO07R+3dOyCGcfcrRn
	 apzbaDgZkJTpi3BP+WCPxS+cqL2ElIsLdwlzY1AJdFhOAkCSJyHRvZC8N+UrwKU27V+ro
	 xAkO8Gw9ezcc5El2++yhbrIytcfQYVNpyxvKJGiHY4bcbwQBZtx7iw2rLVDKP4jku7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868009;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=0UvpdA4kXI/eJkaSguT/eY5jWp7hwuatXakdQ0IbE5c=;
	b=SjKTi4pmIGEUb9bDARyqvzqMfnw4BONFIdR9s9JZKvQzzz9YIPZpyvBqlDcXzeoXfD6b
	 4OjXLFWy5EEhLmiFHUNK6C1rhOB0dtEKOSP5CDHP69ZZv+0+OcKOdiS6m/nYrbWz7F224
	 27LbdeTlebyWCPfxLDlSby4mVq+BQVRPzJdctoFr8AnsH7nBDuKPM7BQRLBJAkdbcAvAH
	 vNdSVpPUr01lzTHxoaNCpXN5DZQ+CcImWhBc/mXqnPE5SgOQc2wn3r9pp8fN+sBYbzxrm
	 KzPZx8PxD/rivVXGNubrMNZmf7hucS+cn7MeM2J+2r/L1DQ+TUaeBgP19CtJGnsLUJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=SuKpvAVu;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99900606A33D
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99900606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=SuKpvAVu
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso1723681a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868006; x=1795472806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0UvpdA4kXI/eJkaSguT/eY5jWp7hwuatXakdQ0IbE5c=;
        b=Jm5PfBqDlNlY81yr1/g9Lm2F8++Pq6AhHk5+3dYjGGH3ix2uni22hN5qWwChM4KQDI
         Vx866l3kzgi/eskugQPF6pglhpC5YH9OLLWYvmWG0OZcDSr2UGP8mTIvReGwsZtgXRSR
         X18T0wcEHOV6ILLWfZJSuq3sDEFG/8eMOFlz3q3BiBe/NO6KfDJJDV7V9bj3Rk+H6npl
         lPwCf3sffGPxTGnODZ6FHJfJHGaQTl0VgNv3EuKKb5P511v4WZuGiD1NIPXZg8rfS4A5
         6ZNKj7vw17XSEfwDSahJGGsxUK9TtIUmEiSIeDrlIX4mA88ML5w5iRZ1KykI0dsrysUU
         X2IA==
X-Forwarded-Encrypted: i=1; AL+hErHR0/HVfX8CQK/y/LzGGdNp8vz71pb+K067DG8W8G8ieYWWvuQylK+WS8dVm0svLRiSlnlMmV6FQDkLdtzjRZE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+8roZbLMKwMr6sdtG3QurmhG9itTzOo7KcuZVPuDc5rnx7UCH6
	VN5xs45e/xC6MF5+8Qid+ffRBi7mMr/VrH5oHxa0Gsdr2IqBhi8PmlUIjVjdRyMRpDBf7+jtekg
	ShIIWIE+k4p/wndwnh2Cqda+NQCzGeMjnIfkOvzgwH6DOF+QSGPa1PwcT2XBTv1IZzcavtqtrbX
	xiH89DfkU66bwllCFelVtwzrtilOrpr4WJrKw6tM4dyBKS7430YjA0ob/Hopc+F18L3+lBhjJup
	7uT/w5sMUqSyre95uKsqYGfj5sc
X-Gm-Gg: AZFdTZcVRLDoJvxIqKb+czF5eSsqRYyFCGsiPasXNkxiaEI3DEoUqw+dY8EL4eGIv9i
	4cSRX5f7Hrt+S/28tavhLfOkbr1Un2GuuUz1+x5ulb3c/Q3upEencktC7Q71XRpZ98V4V+XkDuj
	h5qW6q7XklOoatqZ3be4xGqAHwVZXDgcjVUwfpKFPFzrm3O2gWJMb6UW7dhUl2KXiQrZtKTcoGa
	0MOS000vIO99Y4P+Ey3v9xBlAq9Sh7K2p9yWRblCEFhhFewDHB36ZN/Sy+60iWA9CAHz296zWcu
	LlH5MQAxQtJzoTE3JmVSMN6ChwWyG3W/fuhniLPwerpB4lOQ4IpKugJm48XRZ18VRiYV6POfBtM
	0+Sbfy4s+O3tGQ59GRxanxvFNrnDZTuvZxsBE3r9F/GA/v34teSQMXE5CJj3SxYflGQHiIn+m3m
	RgqH3rdtd5E7uo3zt+f8lD2bLFPQPUWtFPUFVqIdRzKlk=
X-Received: by 2002:a17:90b:4a:b0:3b1:6978:5be with SMTP id 98e67ed59e1d1-3b1b0a40379mr9740857a91.33.1794868005779;
        Mon, 16 Nov 2026 14:26:45 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ac14d2dbsm437369a91.8.2026.11.16.14.26.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:45 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-37628596fc9so10520956eec.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794868003; x=1795472803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0UvpdA4kXI/eJkaSguT/eY5jWp7hwuatXakdQ0IbE5c=;
        b=SuKpvAVuzNMK/FNFJGPXbB1vF+WUZuVqsaAxcR+pxPkG7fRsdhuJMMo3DF97fzBv/j
         ZLHVdbiqd+lGYe94B/FHEAI7fjKogcSg1FAAGeRIIm13Jnxeu8Ua8Yt6jWwrQ+hnP/+T
         tN2RCWAy8SHb1tyVNudpKhcMJw1dfRkEKnlPE=
X-Forwarded-Encrypted: i=1; AL+hErFvAoeW4jB1Do9ymnAzmVDtYXbVgo+jew9ONWVivx4RZqtKufeQZV1WWh3sMuWsUMSirHV2Ou4mn42/RylL1TY=@vger.kernel.org
X-Received: by 2002:a05:7301:2424:b0:362:fa87:2aa6 with SMTP id 5a478bee46e88-3796057b51cmr10727502eec.0.1794868001545;
        Mon, 16 Nov 2026 14:26:41 -0800 (PST)
X-Received: by 2002:a05:7301:2424:b0:362:fa87:2aa6 with SMTP id 5a478bee46e88-3796057b51cmr10727458eec.0.1794868000320;
        Mon, 16 Nov 2026 14:26:40 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:38 -0800 (PST)
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
Subject: [PATCH net-next 7/9] net: bgmac: add Northstar IPv4 TCP/UDP NAT flowtable offload
Date: Mon, 16 Nov 2026 14:25:17 -0800
Message-ID: <20261116222519.1416501-8-florian.fainelli@broadcom.com>
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

Expose the inline BCM4708/BCM5301X accelerator through TC_SETUP_FT on
GMAC2. Learn placement hashes from miss metadata and install exact IPv4
TCP/UDP SNAT or DNAT rules with shared router-MAC and next-hop
resources. Restrict admission to two standalone untagged DSA ports,
distinct router MACs, MTU 1500 and one flowtable in the initial
namespace. Require an operational GMAC0 exception path for both
protocols and the flowtable FIN/RST exclusion mask for TCP. Reject
unsupported or exhausted rules.

Gate lookup synchronously and retire all hardware owners on every IPv4
route, rule or nexthop notification, including unrelated prefixes and
local-table changes. This is deliberately conservative: the driver lacks
enough policy-routing context to prove an event irrelevant. Coalesce
control work, accepting reduced offload residency during unrelated
churn. Track explicit low-MTU prefixes incrementally from notifier
replay and updates; avoid repeated FIB dumps. Bound tracking memory and
latch software fallback if tracking is exhausted.

Use the owner's actual cached-route and neighbour validation as the only
authority for stale-owner teardown. The driver's partial FIB lookup is
an eligibility probe; it lacks mark, DSCP and output-interface context.
A mismatch or unsupported shape declines hardware offload without
tearing down a valid policy-routed software flow. Reject publication
across invalidation generations. Use RCU lookups and tracked netdevice
references. Drive neighbour probes from hardware counter activity,
including the initial pre-wrap jiffies epoch. Retire owners on
neighbour, topology or exception-path changes that withdraw their
hardware paths.

Quiesce lookups using GMAC2 CPU flow control around indirect table
accesses, drain an in-flight frame, check busy and address completion,
and release read mode before resuming traffic. Preserve Broadcom-tag
relocation when disabling lookup. On an uncertain transaction, gate the
parser before releasing pause, retain uncertain resources and reject new
entries until reprobe. Add optional per-device completion fault
injection.

TCP control packets retire both NAT directions before tuple reuse.
Accumulate packet deltas and preserve the final delta for retired
owners; do not fabricate hardware byte counters. Provide debugfs status
and raw table readback. FA2/FA+, PPPoE and board enablement remain
separate work.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 MAINTAINERS                                |    1 +
 drivers/net/ethernet/broadcom/Kconfig      |   24 +
 drivers/net/ethernet/broadcom/Makefile     |    1 +
 drivers/net/ethernet/broadcom/bcm-ns-fa.c  | 1897 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/bcm-ns-fa.h  |   30 +
 drivers/net/ethernet/broadcom/bgmac-bcma.c |    5 +
 drivers/net/ethernet/broadcom/bgmac.c      |   31 +
 drivers/net/ethernet/broadcom/bgmac.h      |    2 +
 8 files changed, 1991 insertions(+)
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa.c
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa.h

diff --git a/MAINTAINERS b/MAINTAINERS
index dce9a88f4aef..80969b91af40 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5671,6 +5671,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
+F:	drivers/net/ethernet/broadcom/bcm-ns-fa*
 F:	drivers/net/ethernet/broadcom/bgmac*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index f0bac0dd1439..865b346a7249 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -163,13 +163,36 @@ config BNX2X_SRIOV
 
 config BGMAC
 	tristate
+	depends on BCM_NS_FA || !BCM_NS_FA
 	help
 	  This enables the integrated ethernet controller support for many
 	  Broadcom (mostly iProc) SoCs. An appropriate bus interface driver
 	  needs to be enabled to select this.
 
+config BCM_NS_FA
+	tristate "Broadcom Northstar IPv4 TCP/UDP NAT flow accelerator"
+	depends on ARCH_BCM_5301X || COMPILE_TEST
+	depends on OF && NET_DSA && NF_FLOW_TABLE
+	select NET_DSA_TAG_BRCM_FA
+	help
+	  Offload IPv4 TCP/UDP NAT flows from nftables flowtables to the inline
+	  accelerator on BCM4708, BCM53011 and BCM53012. Requires GMAC2, a B53 switch
+	  using brcm-fa tags, a second CPU link through GMAC0 for IPv4 exceptions,
+	  and explicit device tree configuration.
+	  VLANs, bridges, and double NAT use the software path.
+
+config BCM_NS_FA_FAULT_INJECTION
+	bool "Fault injection for Northstar FA table transactions"
+	depends on BCM_NS_FA && FAULT_INJECTION_DEBUG_FS
+	help
+	  Add per-device fail_table controls in debugfs to simulate an uncertain
+	  indirect table completion. The failure disables hardware lookup until
+	  reprobe and leaves forwarding to software. Intended for driver testing.
+	  Injection is disabled by default and can be armed through debugfs.
+
 config BGMAC_BCMA
 	tristate "Broadcom iProc GBit BCMA support"
+	depends on BCM_NS_FA || !BCM_NS_FA
 	depends on BCMA && BCMA_HOST_SOC
 	depends on BCM47XX || ARCH_BCM_5301X || COMPILE_TEST
 	select BGMAC
@@ -183,6 +206,7 @@ config BGMAC_BCMA
 
 config BGMAC_PLATFORM
 	tristate "Broadcom iProc GBit platform support"
+	depends on BCM_NS_FA || !BCM_NS_FA
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	select BGMAC
 	select PHYLIB
diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 10cc1c92ecfc..1c445d9849ef 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
 obj-$(CONFIG_BCMASP) += asp2/
 obj-$(CONFIG_BNGE) += bnge/
+obj-$(CONFIG_BCM_NS_FA) += bcm-ns-fa.o
diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa.c b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
new file mode 100644
index 000000000000..8665ba94cbab
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
@@ -0,0 +1,1897 @@
+// SPDX-License-Identifier: GPL-2.0-only AND ISC
+/* Broadcom Northstar inline flow accelerator, GMAC2 / switch IMP0.
+ *
+ * Table formats and access sequence follow the BCM5301X FA theory of
+ * operations and the ISC-licensed 2013 Broadcom ctf_config.c reference.
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/dsa/brcm.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/etherdevice.h>
+#include <linux/fault-inject.h>
+#include <linux/hashtable.h>
+#include <linux/if_vlan.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/seq_file.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/workqueue.h>
+#include <linux/unaligned.h>
+#include <linux/tc_act/tc_csum.h>
+#include <net/dsa.h>
+#include <net/arp.h>
+#include <net/flow_offload.h>
+#include <net/fib_notifier.h>
+#include <net/ip.h>
+#include <net/ip_fib.h>
+#include <net/neighbour.h>
+#include <net/netevent.h>
+#include <net/net_namespace.h>
+
+#include "bcm-ns-fa.h"
+#include "bgmac.h"
+
+#define FA_CTL			0x00
+#define FA_CTL_BYPASS		BIT(1)
+#define FA_CTL_CRC_OVERWRITE	BIT(3)
+#define FA_CTL_THRESHOLD	GENMASK(12, 4)
+#define FA_CTL_INIT		GENMASK(17, 13)
+#define FA_CTL_NO_DA_CHECK	BIT(18)
+#define FA_MEM_CTL		0x04
+#define FA_MEM_READ		BIT(12)
+#define FA_MEM_TABLE		GENMASK(11, 10)
+#define FA_MEM_CURRENT_INDEX	GENMASK(22, 13)
+#define FA_BRCM_HDR		0x08
+#define FA_BRCM_HW		BIT(0)
+#define FA_BRCM_RX		BIT(1)
+#define FA_BRCM_TX		BIT(2)
+#define FA_BRCM_PARSE_EXCEPTIONS	BIT(3)
+#define FA_L2_SKIP		0x0c
+#define FA_L2_TAG		0x10
+#define FA_L2_ETHERTYPE		0x20
+#define FA_IPV4			0x28
+#define FA_IPV4_CSUM		BIT(16)
+#define FA_NAPT			0x2c
+#define FA_NAPT_DEC_TTL		BIT(21)
+#define FA_STATUS		0x30
+#define FA_INIT_DONE		GENMASK(9, 5)
+#define FA_STATUS_MASK		0x34
+#define FA_RX_STATUS		0x38
+#define FA_HITS			0x3c
+#define FA_MISSES		0x40
+#define FA_ERROR		0x64
+#define FA_ERROR_MASK		0x68
+#define FA_DEBUG_STATUS		0x70
+#define FA_MEM_BUSY		BIT(0)
+#define FA_DATA(n)		(0xa0 + 4 * (n))
+#define FA_FLOW_TABLE		0
+#define FA_POOL_TABLE		1
+#define FA_NH_TABLE		2
+#define FA_SLOTS		1024
+#define FA_WAYS			4
+#define FA_POOLS		4
+#define FA_NEXTHOPS		128
+#define FA_TAG_LEN		4
+#define FA_MISS_OPCODE		2
+#define FA_FLOW_CLOSING		0
+#define FA_MTU_HASH_BITS		6
+#define FA_MTU_ROUTES_MAX		1024
+
+/* IPv4 flow entry, indexed by DATA word; global bit numbers in AN300 table 3. */
+#define FA_FLOW0_HITS_LO		GENMASK(31, 3) /* hits[28:0], bits 31:3 */
+#define FA_FLOW1_HITS_HI		GENMASK(2, 0)  /* hits[31:29], bits 34:32 */
+#define FA_FLOW1_ACTION		GENMASK(4, 3)
+#define FA_FLOW1_ROUTER_MAC	GENMASK(7, 6)
+#define FA_FLOW1_NEXT_HOP		GENMASK(14, 8)
+#define FA_FLOW1_REMAP_IP_LO	GENMASK(31, 15) /* remap_ip[16:0], bits 63:47 */
+#define FA_FLOW2_REMAP_IP_HI	GENMASK(14, 0) /* remap_ip[31:17], bits 78:64 */
+#define FA_FLOW2_REMAP_PORT	GENMASK(30, 15)
+#define FA_FLOW2_DPORT_LO		BIT(31) /* dport[0], bit 95 */
+#define FA_FLOW3_DPORT_HI		GENMASK(14, 0) /* dport[15:1], bits 110:96 */
+#define FA_FLOW3_SPORT		GENMASK(30, 15)
+#define FA_FLOW3_TCP		BIT(31)
+#define FA_FLOW6_DIRECTION	BIT(0)
+#define FA_FLOW6_DEST_MAP		GENMASK(10, 1)
+#define FA_FLOW6_OPCODE		GENMASK(19, 17)
+#define FA_FLOW6_OPCODE_INGRESS	1
+#define FA_FLOW6_VALID		BIT(20)
+#define FA_FLOW7_IPV4		BIT(31)
+
+/* Router-MAC pool entry: external in bit 0, MAC in bits 48:1. */
+#define FA_POOL0_EXTERNAL	BIT(0)
+#define FA_POOL0_MAC_LO		GENMASK(31, 1)
+#define FA_POOL1_MAC_HI		GENMASK(16, 0)
+
+/* Next-hop entry: frame type in bit 0, tag op in 2:1, DA in 66:19. */
+#define FA_NH0_TAG_OP		GENMASK(2, 1)
+#define FA_NH_TAG_NONE		2
+#define FA_NH0_MAC_LO		GENMASK(31, 19)
+#define FA_NH2_MAC_HI		GENMASK(2, 0)
+
+/* Flowtable rule validation holds RCU, rather than RTNL. */
+static bool fa_has_upper_dev_rcu(struct net_device *dev)
+{
+	struct list_head *iter = &dev->adj_list.upper;
+
+	return netdev_upper_get_next_dev_rcu(dev, &iter);
+}
+
+/* No implicit padding: also used as the key for the RX hash cache. */
+struct fa_tuple {
+	__be32 src, dst;
+	__be16 sport, dport;
+};
+
+#define FA_ACT_REMAP_IP		BIT(0)
+#define FA_ACT_REMAP_PORT	BIT(1)
+
+enum fa_direction {
+	FA_DIR_UNSET = -1,
+	FA_DIR_SNAT,
+	FA_DIR_DNAT,
+};
+
+struct fa_rule {
+	struct fa_tuple tuple;
+	struct net_device *in, *out;
+	u8 eth[ETH_ALEN * 2];
+	u8 eth_mask[ETH_ALEN * 2];
+	u32 remap_ip;
+	u16 remap_port;
+	u8 action, l4proto;
+	enum fa_direction direction;
+};
+
+static int fa_direction(struct fa_rule *rule, enum fa_direction direction)
+{
+	if (rule->direction != FA_DIR_UNSET && rule->direction != direction)
+		return -EOPNOTSUPP;
+	rule->direction = direction;
+	return 0;
+}
+
+static int fa_mangle(struct fa_rule *rule, const struct flow_action_entry *act)
+{
+	u32 mask = act->mangle.mask, val = act->mangle.val;
+	unsigned int offset = act->mangle.offset;
+	enum fa_direction dir;
+
+	switch (act->mangle.htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_ETH: {
+		u8 *data = rule->eth, *known = rule->eth_mask;
+		unsigned int i;
+
+		if (offset > sizeof(rule->eth) - sizeof(val))
+			return -EOPNOTSUPP;
+		for (i = 0; i < sizeof(val); i++) {
+			u8 m = ((u8 *)&mask)[i];
+
+			data[offset + i] = (data[offset + i] & m) |
+					  (((u8 *)&val)[i] & ~m);
+			known[offset + i] |= ~m;
+		}
+		return 0;
+	}
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		if (mask || (offset != offsetof(struct iphdr, saddr) &&
+			     offset != offsetof(struct iphdr, daddr)))
+			return -EOPNOTSUPP;
+		dir = offset == offsetof(struct iphdr, daddr) ? FA_DIR_DNAT : FA_DIR_SNAT;
+		if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_IP))
+			return -EOPNOTSUPP;
+		rule->remap_ip = be32_to_cpu((__force __be32)val);
+		rule->action |= FA_ACT_REMAP_IP;
+		return 0;
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		if ((act->mangle.htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP &&
+		     rule->l4proto != IPPROTO_TCP) ||
+		    (act->mangle.htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP &&
+		     rule->l4proto != IPPROTO_UDP))
+			return -EOPNOTSUPP;
+		if (offset)
+			return -EOPNOTSUPP;
+		mask = be32_to_cpu((__force __be32)mask);
+		val = be32_to_cpu((__force __be32)val);
+		if (mask != 0xffff && mask != 0xffff0000)
+			return -EOPNOTSUPP;
+		dir = mask == 0xffff0000 ? FA_DIR_DNAT : FA_DIR_SNAT;
+		if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_PORT))
+			return -EOPNOTSUPP;
+		rule->remap_port = dir ? val & 0xffff : val >> 16;
+		rule->action |= FA_ACT_REMAP_PORT;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+struct fa_learned {
+	struct fa_tuple tuple;
+	u8 mac[ETH_ALEN];
+	unsigned long generation;
+	u8 hash, port, l4proto;
+	bool valid;
+};
+
+struct fa_mac {
+	u8 addr[ETH_ALEN];
+	bool external;
+	unsigned int refs;
+};
+
+struct fa_neighbour {
+	__be32 address;
+	int ifindex;
+	u8 mac[ETH_ALEN];
+	u8 state;
+	bool valid;
+};
+
+struct fa_flow {
+	struct list_head list;
+	struct rcu_head rcu;
+	void (*invalidate)(unsigned long cookie);
+	struct fa_flow *reverse;
+	struct fa_tuple reply;
+	unsigned long flags;
+	unsigned long cookie;
+	struct fa_tuple tuple;
+	struct net_device *in, *out;
+	netdevice_tracker in_tracker, out_tracker;
+	unsigned long lastused;
+	u64 pending_hits;
+	u32 hits;
+	u8 pool_in, pool_out, nh, l4proto, in_port, out_port;
+	bool installed;
+};
+
+struct fa_mtu_route {
+	struct hlist_node node;
+	u32 dst, tb_id;
+	int prefix_len;
+};
+
+struct bcm_ns_fa {
+	struct fault_attr fail_table;
+	bool fail_table_write_only;
+	unsigned long fault_injections;
+	struct brcm_fa_control control;
+	struct net_device *conduit;
+	void __iomem *regs;
+	struct mutex lock; /* Flow blocks, table port, and software ownership. */
+	spinlock_t learn_lock; /* RX NAPI versus flowtable workqueue. */
+	struct fa_learned *learned;
+	unsigned int learn_next;
+	unsigned int nr_flows;
+	struct fa_flow *flows[FA_SLOTS];
+	struct fa_mac pool[FA_POOLS], nh[FA_NEXTHOPS];
+	struct fa_neighbour neighbours[FA_NEXTHOPS];
+	unsigned int neighbour_next;
+	struct list_head block_list;
+	struct list_head entries; /* RCU readers in NAPI, writers under lock. */
+	struct work_struct control_work;
+	unsigned long control_generation;
+	unsigned long invalidate_generation;
+	unsigned long pending_generation;
+	bool control_pending;
+	bool tcp_ready;
+	bool stopping;
+	bool route_mtu_ok;
+	bool mtu_tracking_failed;
+	DECLARE_HASHTABLE(mtu_routes, FA_MTU_HASH_BITS);
+	unsigned int nr_mtu_routes;
+	unsigned long invalidations;
+	unsigned long neighbour_check;
+	struct notifier_block netdev_nb;
+	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
+	struct dentry *debugfs;
+	bool failed;
+	bool enabled;
+};
+
+/* Serialize control changes with the NAPI stop request. */
+static void fa_control_update(struct bcm_ns_fa *fa, u32 set, u32 clear)
+{
+	u32 val;
+
+	spin_lock_bh(&fa->learn_lock);
+	val = readl(fa->regs + FA_CTL);
+	writel((val | set) & ~clear, fa->regs + FA_CTL);
+	readl(fa->regs + FA_CTL);
+	spin_unlock_bh(&fa->learn_lock);
+}
+
+/* Caller holds learn_lock. Stop lookups without bypassing tag relocation:
+ * global bypass wires the switch directly to DMA and breaks brcm-fa frames.
+ */
+static void fa_lookup_update(struct bcm_ns_fa *fa)
+{
+	bool enabled = fa->enabled && fa->tcp_ready && fa->route_mtu_ok && !fa->failed &&
+		       !fa->control_pending && !fa->stopping;
+
+	writel(enabled ? ETH_P_IP | ETH_P_IPV6 << 16 : 0, fa->regs + FA_L2_ETHERTYPE);
+	readl(fa->regs + FA_L2_ETHERTYPE);
+}
+
+static void fa_reply_tuple(const struct fa_rule *rule, struct fa_tuple *reply)
+{
+	*reply = (struct fa_tuple){ rule->tuple.dst, rule->tuple.src,
+				  rule->tuple.dport, rule->tuple.sport };
+	if (rule->direction == FA_DIR_DNAT) {
+		if (rule->action & FA_ACT_REMAP_IP)
+			reply->src = htonl(rule->remap_ip);
+		if (rule->action & FA_ACT_REMAP_PORT)
+			reply->sport = htons(rule->remap_port);
+	} else {
+		if (rule->action & FA_ACT_REMAP_IP)
+			reply->dst = htonl(rule->remap_ip);
+		if (rule->action & FA_ACT_REMAP_PORT)
+			reply->dport = htons(rule->remap_port);
+	}
+}
+
+static bool fa_control_match(const struct fa_flow *entry,
+			     const struct fa_tuple *tuple, unsigned int port,
+			     bool ports_valid)
+{
+	size_t len = ports_valid ? sizeof(*tuple) : offsetof(struct fa_tuple, sport);
+
+	return entry->l4proto == IPPROTO_TCP && entry->in_port == port &&
+	       !memcmp(&entry->tuple, tuple, len);
+}
+
+/* Switch traps bypass FA lookup. Stop subsequent data lookups before Linux
+ * can reuse their NAT tuple; retire both hardware directions in process context.
+ * The publication lock also closes the race with an in-flight insertion.
+ */
+static void fa_tcp_control(struct bcm_ns_fa *fa, const struct fa_tuple *tuple,
+			   unsigned int port, bool ports_valid)
+{
+	struct fa_flow *entry;
+	bool found = false;
+
+	rcu_read_lock();
+	spin_lock_bh(&fa->learn_lock);
+	if (fa->stopping)
+		goto out;
+	fa->control_generation++;
+	list_for_each_entry_rcu(entry, &fa->entries, list) {
+		if (!fa_control_match(entry, tuple, port, ports_valid) ||
+		    test_bit(FA_FLOW_CLOSING, &entry->flags))
+			continue;
+		set_bit(FA_FLOW_CLOSING, &entry->flags);
+		found = true;
+	}
+	if (found) {
+		fa->pending_generation++;
+		fa->control_pending = true;
+		fa_lookup_update(fa);
+		queue_work(system_dfl_wq, &fa->control_work);
+	}
+out:
+	spin_unlock_bh(&fa->learn_lock);
+	rcu_read_unlock();
+}
+
+static int fa_wait(struct bcm_ns_fa *fa)
+{
+	u32 val;
+
+	return readl_poll_timeout(fa->regs + FA_DEBUG_STATUS, val,
+				 !(val & FA_MEM_BUSY), 1, 1000);
+}
+
+static int fa_wait_index(struct bcm_ns_fa *fa, unsigned int next)
+{
+	u32 val;
+	int err;
+
+	err = readl_poll_timeout(fa->regs + FA_MEM_CTL, val,
+				 FIELD_GET(FA_MEM_CURRENT_INDEX, val) == (next & 0x3ff) &&
+				 !(readl(fa->regs + FA_DEBUG_STATUS) & FA_MEM_BUSY),
+				 1, 1000);
+	if (err)
+		netdev_err(fa->conduit, "FA index wait: expected %u control %#x busy %#x\n",
+			   next, val, readl(fa->regs + FA_DEBUG_STATUS));
+	return err;
+}
+
+static DECLARE_FAULT_ATTR(fa_fail_table_default);
+
+static int fa_table_complete(struct bcm_ns_fa *fa, unsigned int next, bool write)
+{
+	int err = fa_wait_index(fa, next);
+
+	if (!err && IS_ENABLED(CONFIG_BCM_NS_FA_FAULT_INJECTION) &&
+	    (!READ_ONCE(fa->fail_table_write_only) || write) &&
+	    should_fail(&fa->fail_table, 1)) {
+		fa->fault_injections++;
+		return -ETIMEDOUT;
+	}
+	return err;
+}
+
+static void fa_fail(struct bcm_ns_fa *fa);
+
+struct fa_table_access {
+	u32 mac_control;
+	bool paused;
+};
+
+static int fa_table_begin(struct bcm_ns_fa *fa, struct fa_table_access *access)
+{
+	struct bgmac *bgmac = netdev_priv(fa->conduit);
+	u32 val;
+	int err;
+
+	access->paused = false;
+	if (!netif_running(fa->conduit))
+		return 0;
+	if (readl(fa->regs + FA_CTL) & FA_CTL_BYPASS) {
+		/* Initialization and final release use global bypass. */
+		fsleep(20);
+		return 0;
+	}
+	access->mac_control = bgmac_read(bgmac, BGMAC_DEV_CTL);
+	access->paused = true;
+	/* Keep automatic flow control and request a pause from the CPU too. */
+	val = (access->mac_control & ~BGMAC_DC_FCM_MASK) |
+	      FIELD_PREP(BGMAC_DC_FCM_MASK, 2) | BGMAC_DC_CFCO;
+	bgmac_write(bgmac, BGMAC_DEV_CTL, val);
+	err = read_poll_timeout(bgmac_read, val, val & BGMAC_DS_PO, 1, 1000,
+				false, bgmac, BGMAC_DEV_STATUS);
+	if (err)
+		return err;
+	/* Drain a frame already on the switch link before taking the shared
+	 * table port. Do not change the FA packet path in the middle of a frame.
+	 */
+	fsleep(20);
+	return 0;
+}
+
+static void fa_table_end(struct bcm_ns_fa *fa, struct fa_table_access *access)
+{
+	struct bgmac *bgmac = netdev_priv(fa->conduit);
+
+	if (access->paused) {
+		bgmac_write(bgmac, BGMAC_DEV_CTL, access->mac_control);
+		bgmac_read(bgmac, BGMAC_DEV_CTL);
+	}
+}
+
+/* Reading DATA0 triggers a transaction, including the final read below. */
+static int fa_read(struct bcm_ns_fa *fa, unsigned int table, unsigned int index,
+		   u32 data[8])
+{
+	struct fa_table_access access;
+	int i, err;
+
+	err = fa_table_begin(fa, &access);
+	if (err)
+		goto restore;
+	err = fa_wait(fa);
+	if (err)
+		goto restore;
+	writel(FA_MEM_READ | FIELD_PREP(FA_MEM_TABLE, table) | index,
+	       fa->regs + FA_MEM_CTL);
+	err = fa_wait_index(fa, index);
+	if (err)
+		goto out;
+	readl(fa->regs + FA_DATA(0));
+	err = fa_table_complete(fa, index + 1, false);
+	if (err)
+		goto out;
+	for (i = 7; i >= 0; i--)
+		data[i] = readl(fa->regs + FA_DATA(i));
+	err = fa_table_complete(fa, index + 2, false);
+out:
+	/* Release the software read port so packet hit counters can update. */
+	writel(0, fa->regs + FA_MEM_CTL);
+	readl(fa->regs + FA_MEM_CTL);
+restore:
+	/* Gate lookups while the switch is still paused on an uncertain access. */
+	if (err)
+		fa_fail(fa);
+	fa_table_end(fa, &access);
+	return err;
+}
+
+static int fa_write(struct bcm_ns_fa *fa, unsigned int table, unsigned int index,
+		    const u32 data[8])
+{
+	struct fa_table_access access;
+	int i, err;
+
+	err = fa_table_begin(fa, &access);
+	if (err)
+		goto out;
+	err = fa_wait(fa);
+	if (err)
+		goto out;
+	writel(FIELD_PREP(FA_MEM_TABLE, table) | index, fa->regs + FA_MEM_CTL);
+	err = fa_wait_index(fa, index);
+	if (err)
+		goto out;
+	/* DATA0 commits the complete entry. Never write the valid word last. */
+	for (i = 7; i >= 0; i--)
+		writel(data[i], fa->regs + FA_DATA(i));
+	err = fa_table_complete(fa, index + 1, true);
+out:
+	if (err)
+		fa_fail(fa);
+	fa_table_end(fa, &access);
+	return err;
+}
+
+/* On an uncertain table transaction stop all acceleration. Do not recycle
+ * any table resources until reprobe has reinitialized the hardware.
+ */
+static void fa_fail(struct bcm_ns_fa *fa)
+{
+	if (!fa->failed)
+		netdev_err(fa->conduit, "FA table timeout; offload disabled until reprobe\n");
+	spin_lock_bh(&fa->learn_lock);
+	fa->failed = true;
+	fa_lookup_update(fa);
+	spin_unlock_bh(&fa->learn_lock);
+}
+
+static void fa_mac_encode(const u8 *addr, bool external, bool next_hop, u32 data[8])
+{
+	u64 mac = ether_addr_to_u64(addr);
+
+	if (next_hop) {
+		/* Ethernet II with no VLAN tag; DA spans DATA0 through DATA2. */
+		data[0] = FIELD_PREP(FA_NH0_TAG_OP, FA_NH_TAG_NONE) |
+			  FIELD_PREP(FA_NH0_MAC_LO, mac & FIELD_MAX(FA_NH0_MAC_LO));
+		data[1] = mac >> 13;
+		data[2] = FIELD_PREP(FA_NH2_MAC_HI, mac >> 45);
+	} else {
+		data[0] = FIELD_PREP(FA_POOL0_MAC_LO, mac & FIELD_MAX(FA_POOL0_MAC_LO)) |
+			  FIELD_PREP(FA_POOL0_EXTERNAL, external);
+		data[1] = FIELD_PREP(FA_POOL1_MAC_HI, mac >> 31);
+	}
+}
+
+static int fa_mac_get(struct bcm_ns_fa *fa, const u8 *addr, bool external,
+		      bool next_hop)
+{
+	struct fa_mac *macs = next_hop ? fa->nh : fa->pool;
+	unsigned int count = next_hop ? FA_NEXTHOPS : FA_POOLS;
+	u32 data[8] = {};
+	int i, free = -1, err;
+
+	for (i = 0; i < count; i++) {
+		if (!macs[i].refs) {
+			if (free < 0)
+				free = i;
+			continue;
+		}
+		if (!ether_addr_equal(addr, macs[i].addr))
+			continue;
+		if (!next_hop && external != macs[i].external)
+			return -EOPNOTSUPP;
+		macs[i].refs++;
+		return i;
+	}
+	if (free < 0)
+		return -ENOSPC;
+
+	fa_mac_encode(addr, external, next_hop, data);
+	err = fa_write(fa, next_hop ? FA_NH_TABLE : FA_POOL_TABLE, free, data);
+	if (err) {
+		fa_fail(fa);
+		return err;
+	}
+	ether_addr_copy(macs[free].addr, addr);
+	macs[free].external = external;
+	macs[free].refs = 1;
+	return free;
+}
+
+static int fa_mac_put(struct bcm_ns_fa *fa, unsigned int index, bool next_hop)
+{
+	struct fa_mac *mac = next_hop ? &fa->nh[index] : &fa->pool[index];
+	u32 data[8] = {};
+	int err;
+
+	if (--mac->refs)
+		return 0;
+	err = fa_write(fa, next_hop ? FA_NH_TABLE : FA_POOL_TABLE, index, data);
+	if (err)
+		fa_fail(fa);
+	return err;
+}
+
+static bool fa_receive_tcp_control(struct bcm_ns_fa *fa, const struct iphdr *ip,
+				   unsigned int total, unsigned int linear,
+				   unsigned int port)
+{
+	struct fa_tuple tuple;
+	const struct tcphdr *tcp;
+
+	tuple.src = get_unaligned(&ip->saddr);
+	tuple.dst = get_unaligned(&ip->daddr);
+	if (ip->ihl != 5 || (ip->frag_off & htons(IP_MF | IP_OFFSET))) {
+		fa_tcp_control(fa, &tuple, port, false);
+		return true;
+	}
+	tcp = (void *)(ip + 1);
+	if (total < sizeof(*ip) + sizeof(*tcp) || linear < sizeof(*ip) + sizeof(*tcp) ||
+	    tcp->doff < 5 || total < sizeof(*ip) + tcp->doff * 4)
+		return true;
+	if (!tcp->syn && !tcp->fin && !tcp->rst)
+		return false;
+	tuple.sport = get_unaligned(&tcp->source);
+	tuple.dport = get_unaligned(&tcp->dest);
+	fa_tcp_control(fa, &tuple, port, true);
+	return true;
+}
+
+static void fa_control_receive(void *priv, struct sk_buff *skb, unsigned int port)
+{
+	struct bcm_ns_fa *fa = priv;
+	const struct iphdr *ip = (void *)skb->data;
+	unsigned int ihl, total;
+
+	if (READ_ONCE(fa->stopping) || eth_hdr(skb)->h_proto != htons(ETH_P_IP) ||
+	    skb_headlen(skb) < sizeof(*ip))
+		return;
+	ihl = ip->ihl * 4;
+	total = ntohs(ip->tot_len);
+	if (ip->version != 4 || ip->protocol != IPPROTO_TCP || ihl < sizeof(*ip) ||
+	    total < ihl || total > skb->len || skb_headlen(skb) < ihl ||
+	    ip_compute_csum(ip, ihl))
+		return;
+	fa_receive_tcp_control(fa, ip, total, skb_headlen(skb), port);
+}
+
+static struct net_device *fa_control_conduit(struct bcm_ns_fa *fa)
+{
+	struct dsa_port *data_cpu = fa->conduit->dsa_ptr, *control_cpu;
+
+	if (!data_cpu)
+		return NULL;
+	control_cpu = dsa_to_port(data_cpu->ds, 5);
+	return control_cpu && dsa_port_is_cpu(control_cpu) ? control_cpu->conduit : NULL;
+}
+
+/* The hardware supplies the exact 97-bit tuple CRC in its miss tag. Learning
+ * it avoids assumptions about serial CRC bit order and seed endianness.
+ * Cache eviction only prevents new offloads; installed entries own their slots.
+ */
+void bcm_ns_fa_rx(struct bcm_ns_fa *fa, struct sk_buff *skb)
+{
+	struct fa_learned *learn;
+	const struct ethhdr *eth;
+	const struct iphdr *ip;
+	const __be16 *ports;
+	struct fa_tuple tuple;
+	unsigned int offset = FA_TAG_LEN + ETH_HLEN, ihl, total;
+	u8 *tag;
+
+	if (!fa || READ_ONCE(fa->stopping) || skb_headlen(skb) < offset + sizeof(*ip))
+		return;
+	tag = skb->data;
+	if (tag[0] >> 5 != FA_MISS_OPCODE && tag[0] >> 5 != 0)
+		return;
+	eth = (void *)(tag + FA_TAG_LEN);
+	ip = (void *)(tag + offset);
+	ihl = ip->ihl * 4;
+	total = ntohs(ip->tot_len);
+	if (eth->h_proto != htons(ETH_P_IP) || ip->version != 4 || ihl < sizeof(*ip) ||
+	    (ip->protocol != IPPROTO_TCP && ip->protocol != IPPROTO_UDP) ||
+	    total < ihl || total > skb->len - offset || skb_headlen(skb) < offset + ihl ||
+	    ip_compute_csum(ip, ihl))
+		return;
+	if (ip->protocol == IPPROTO_TCP &&
+	    fa_receive_tcp_control(fa, ip, total, skb_headlen(skb) - offset, tag[3] & 0x1f))
+		return;
+	if (ihl != sizeof(*ip) || (ip->frag_off & htons(IP_MF | IP_OFFSET)) ||
+	    total < ihl + sizeof(struct udphdr) ||
+	    skb_headlen(skb) < offset + ihl + sizeof(struct udphdr))
+		return;
+	tuple.src = get_unaligned(&ip->saddr);
+	tuple.dst = get_unaligned(&ip->daddr);
+	ports = (void *)(ip + 1);
+	tuple.sport = get_unaligned(ports);
+	tuple.dport = get_unaligned(ports + 1);
+	/* Exception tags are delivered unchanged and contain no usable hash. */
+	if (tag[0] >> 5 != FA_MISS_OPCODE || tag[2])
+		return;
+	spin_lock_bh(&fa->learn_lock);
+	if (fa->control_pending) {
+		spin_unlock_bh(&fa->learn_lock);
+		return;
+	}
+	learn = &fa->learned[fa->learn_next++ % FA_SLOTS];
+	learn->tuple = tuple;
+	learn->l4proto = ip->protocol;
+	learn->generation = ip->protocol == IPPROTO_TCP ? fa->control_generation :
+			    fa->invalidate_generation;
+	ether_addr_copy(learn->mac, eth->h_dest);
+	learn->hash = tag[1];
+	learn->port = tag[3] & 0x1f;
+	learn->valid = true;
+	spin_unlock_bh(&fa->learn_lock);
+}
+EXPORT_SYMBOL_GPL(bcm_ns_fa_rx);
+
+static bool fa_learn_matches(const struct fa_learned *learn,
+			     const struct fa_rule *rule, unsigned long generation)
+{
+	return learn->valid && learn->l4proto == rule->l4proto &&
+	       learn->generation == generation &&
+	       !memcmp(&learn->tuple, &rule->tuple, sizeof(learn->tuple));
+}
+
+static int fa_learn_lookup(struct bcm_ns_fa *fa, const struct fa_rule *rule,
+			   struct fa_learned *result)
+{
+	int i, err = -EAGAIN;
+
+	spin_lock_bh(&fa->learn_lock);
+	for (i = 0; i < FA_SLOTS; i++) {
+		const struct fa_learned *l = &fa->learned[i];
+
+		if (!fa_learn_matches(l, rule, rule->l4proto == IPPROTO_TCP ?
+				     fa->control_generation : fa->invalidate_generation))
+			continue;
+		if (l->port != dsa_port_from_netdev(rule->in)->index ||
+		    !ether_addr_equal(l->mac, rule->in->dev_addr))
+			continue;
+		*result = *l;
+		err = 0;
+	}
+	spin_unlock_bh(&fa->learn_lock);
+	return err;
+}
+
+static bool fa_port(struct bcm_ns_fa *fa, struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	if (!dev || !dsa_user_dev_check(dev) || dev_net(dev) != &init_net ||
+	    !netif_running(dev) || !netif_carrier_ok(dev) || fa_has_upper_dev_rcu(dev))
+		return false;
+	dp = dsa_port_from_netdev(dev);
+	return dp->ds->index == 0 && dp->index < 8 &&
+	       dsa_port_to_conduit(dp) == fa->conduit &&
+	       dp->cpu_dp->index == 8 &&
+	       dp->ds->dst->tag_ops->proto == DSA_TAG_PROTO_BRCM_FA;
+}
+
+static int fa_parse(struct bcm_ns_fa *fa, struct flow_cls_offload *cls,
+		    struct fa_rule *rule)
+{
+	struct flow_rule *flow = flow_cls_offload_flow_rule(cls);
+	struct flow_match_ipv4_addrs ipv4;
+	struct flow_match_control control;
+	struct flow_match_basic basic;
+	struct flow_match_ports ports;
+	struct flow_match_meta meta;
+	const struct flow_action_entry *act;
+	struct dsa_port *dp;
+	struct net_device *control_dev;
+	u64 allowed;
+	bool csum = false, is_tcp;
+	u32 csum_flags;
+	int i, err;
+
+	allowed = BIT_ULL(FLOW_DISSECTOR_KEY_META) | BIT_ULL(FLOW_DISSECTOR_KEY_CONTROL) |
+		  BIT_ULL(FLOW_DISSECTOR_KEY_BASIC) | BIT_ULL(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+		  BIT_ULL(FLOW_DISSECTOR_KEY_PORTS);
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp tcp;
+
+		allowed |= BIT_ULL(FLOW_DISSECTOR_KEY_TCP);
+		flow_rule_match_tcp(flow, &tcp);
+		if (tcp.key->flags || tcp.mask->flags !=
+		    cpu_to_be16(be32_to_cpu(TCP_FLAG_FIN | TCP_FLAG_RST) >> 16))
+			return -EOPNOTSUPP;
+	}
+	if (cls->common.chain_index || flow->match.dissector->used_keys != allowed)
+		return -EOPNOTSUPP;
+	flow_rule_match_control(flow, &control);
+	flow_rule_match_basic(flow, &basic);
+	flow_rule_match_ipv4_addrs(flow, &ipv4);
+	flow_rule_match_ports(flow, &ports);
+	flow_rule_match_meta(flow, &meta);
+	if (control.key->addr_type != FLOW_DISSECTOR_KEY_IPV4_ADDRS ||
+	    control.mask->addr_type != 0xffff || control.mask->flags ||
+	    basic.key->n_proto != htons(ETH_P_IP) ||
+	    basic.mask->n_proto != htons(0xffff) ||
+	    (basic.key->ip_proto != IPPROTO_UDP && basic.key->ip_proto != IPPROTO_TCP) ||
+	    basic.mask->ip_proto != 0xff ||
+	    ipv4.mask->src != htonl(~0U) || ipv4.mask->dst != htonl(~0U) ||
+	    ports.mask->src != htons(0xffff) || ports.mask->dst != htons(0xffff) ||
+	    meta.mask->ingress_ifindex != ~0U || meta.mask->ingress_iftype)
+		return -EOPNOTSUPP;
+
+	is_tcp = basic.key->ip_proto == IPPROTO_TCP;
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_TCP) != is_tcp)
+		return -EOPNOTSUPP;
+	control_dev = fa_control_conduit(fa);
+	if (!fa->tcp_ready || !control_dev || !netif_running(control_dev) ||
+	    !netif_carrier_ok(control_dev) || control_dev->mtu < ETH_DATA_LEN)
+		return -EOPNOTSUPP;
+	csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR |
+		     (is_tcp ? TCA_CSUM_UPDATE_FLAG_TCP : TCA_CSUM_UPDATE_FLAG_UDP);
+	rule->l4proto = basic.key->ip_proto;
+	rule->in = dev_get_by_index_rcu(&init_net, meta.key->ingress_ifindex);
+	if (!fa_port(fa, rule->in))
+		return -EOPNOTSUPP;
+	rule->tuple.src = ipv4.key->src;
+	rule->tuple.dst = ipv4.key->dst;
+	rule->tuple.sport = ports.key->src;
+	rule->tuple.dport = ports.key->dst;
+	rule->direction = FA_DIR_UNSET;
+
+	flow_action_for_each(i, act, &flow->action) {
+		switch (act->id) {
+		case FLOW_ACTION_MANGLE:
+			err = fa_mangle(rule, act);
+			if (err)
+				return err;
+			break;
+		case FLOW_ACTION_CSUM:
+			if (csum || act->csum_flags != csum_flags)
+				return -EOPNOTSUPP;
+			csum = true;
+			break;
+		case FLOW_ACTION_REDIRECT:
+			if (rule->out || i != flow->action.num_entries - 1)
+				return -EOPNOTSUPP;
+			rule->out = act->dev;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+	if (!rule->action || !csum || !fa_port(fa, rule->out) ||
+	    rule->in == rule->out || rule->in->mtu != rule->out->mtu ||
+	    rule->in->mtu != ETH_DATA_LEN ||
+	    ether_addr_equal(rule->in->dev_addr, rule->out->dev_addr) ||
+	    !ether_addr_equal(rule->out->dev_addr, rule->eth + ETH_ALEN) ||
+	    !is_valid_ether_addr(rule->eth) ||
+	    memchr_inv(rule->eth_mask, 0xff, sizeof(rule->eth_mask)))
+		return -EOPNOTSUPP;
+	if (dsa_port_from_netdev(rule->in)->ds != dsa_port_from_netdev(rule->out)->ds)
+		return -EOPNOTSUPP;
+
+	/* The lookup key has no input port or VLAN. Limit the initial driver
+	 * to two standalone router ports with distinct router MAC addresses.
+	 */
+	dsa_switch_for_each_user_port(dp, dsa_port_from_netdev(rule->in)->ds)
+		if (dsa_port_to_conduit(dp) == fa->conduit &&
+		    netif_running(dp->user) && dp->user != rule->in && dp->user != rule->out)
+			return -EOPNOTSUPP;
+	return 0;
+}
+
+static int fa_find(struct bcm_ns_fa *fa, unsigned long cookie)
+{
+	int i;
+
+	for (i = 0; i < FA_SLOTS; i++)
+		if (fa->flows[i] && fa->flows[i]->cookie == cookie)
+			return i;
+	return -ENOENT;
+}
+
+/* Hardware traffic must still drive Linux neighbour reachability probes. */
+static void fa_neighbour_activity(struct bcm_ns_fa *fa)
+{
+	unsigned int i, j;
+
+	if (fa->failed || fa->stopping || time_before(jiffies, fa->neighbour_check + HZ))
+		return;
+	fa->neighbour_check = jiffies;
+	for (i = 0; i < ARRAY_SIZE(fa->neighbours); i++) {
+		struct fa_neighbour cached;
+		struct net_device *dev;
+		struct neighbour *neigh;
+		netdevice_tracker tracker;
+		bool owned = false;
+
+		spin_lock_bh(&fa->learn_lock);
+		cached = fa->neighbours[i];
+		spin_unlock_bh(&fa->learn_lock);
+		if (!cached.valid)
+			continue;
+		for (j = 0; j < FA_NEXTHOPS; j++)
+			if (fa->nh[j].refs && ether_addr_equal(fa->nh[j].addr, cached.mac)) {
+				owned = true;
+				break;
+			}
+		if (!owned)
+			continue;
+		dev = netdev_get_by_index(&init_net, cached.ifindex, &tracker, GFP_KERNEL);
+		if (!dev)
+			continue;
+		rcu_read_lock();
+		owned = fa_port(fa, dev);
+		rcu_read_unlock();
+		if (owned) {
+			neigh = ipv4_neigh_lookup(dev, &cached.address);
+			if (neigh) {
+				neigh_event_send(neigh, NULL);
+				neigh_release(neigh);
+			}
+		}
+		netdev_put(dev, &tracker);
+	}
+}
+
+static u32 fa_hits(const u32 data[8])
+{
+	return FIELD_GET(FA_FLOW0_HITS_LO, data[0]) |
+	       FIELD_GET(FA_FLOW1_HITS_HI, data[1]) << 29;
+}
+
+static int fa_counter_read(struct bcm_ns_fa *fa, unsigned int index)
+{
+	struct fa_flow *entry = fa->flows[index];
+	u32 data[8], hits, delta;
+	int err;
+
+	err = fa_read(fa, FA_FLOW_TABLE, index, data);
+	if (err) {
+		fa_fail(fa);
+		return err;
+	}
+	hits = fa_hits(data);
+	delta = hits - entry->hits;
+	entry->hits = hits;
+	entry->pending_hits += delta;
+	if (delta) {
+		entry->lastused = jiffies;
+		fa_neighbour_activity(fa);
+	}
+	return 0;
+}
+
+static int fa_uninstall(struct bcm_ns_fa *fa, unsigned int index)
+{
+	struct fa_flow *entry = fa->flows[index];
+	u32 data[8] = {};
+	int err;
+
+	if (!entry->installed)
+		return 0;
+	if (!fa->failed) {
+		/* Preserve the final packet delta for the next flowtable poll. */
+		fa_counter_read(fa, index);
+		if (!fa->failed) {
+			err = fa_write(fa, FA_FLOW_TABLE, index, data);
+			if (err)
+				fa_fail(fa);
+		}
+		if (!fa->failed)
+			fa_mac_put(fa, entry->pool_in, false);
+		if (!fa->failed)
+			fa_mac_put(fa, entry->pool_out, false);
+		if (!fa->failed)
+			fa_mac_put(fa, entry->nh, true);
+	}
+	entry->installed = false;
+	if (!--fa->nr_flows && !fa->failed)
+		fa_control_update(fa, FA_CTL_NO_DA_CHECK, 0);
+	return fa->failed ? -EIO : 0;
+}
+
+static void fa_control_state_change(void *priv, bool ready)
+{
+	struct bcm_ns_fa *fa = priv;
+	unsigned int i;
+
+	mutex_lock(&fa->lock);
+	spin_lock_bh(&fa->learn_lock);
+	fa->tcp_ready = ready && !READ_ONCE(fa->stopping);
+	if (!fa->tcp_ready) {
+		fa->control_generation++;
+		fa->invalidate_generation++;
+		memset(fa->learned, 0, sizeof(*fa->learned) * FA_SLOTS);
+	}
+	fa_lookup_update(fa);
+	spin_unlock_bh(&fa->learn_lock);
+	if (!fa->tcp_ready)
+		for (i = 0; i < FA_SLOTS; i++) {
+			struct fa_flow *entry = fa->flows[i];
+
+			if (!entry)
+				continue;
+			set_bit(FA_FLOW_CLOSING, &entry->flags);
+			rcu_read_lock();
+			entry->invalidate(entry->cookie);
+			rcu_read_unlock();
+			fa_uninstall(fa, i);
+		}
+	mutex_unlock(&fa->lock);
+}
+
+static int fa_destroy(struct bcm_ns_fa *fa, unsigned int index)
+{
+	struct fa_flow *entry = fa->flows[index];
+	int err = fa_uninstall(fa, index);
+
+	if (entry->reverse)
+		entry->reverse->reverse = NULL;
+	spin_lock_bh(&fa->learn_lock);
+	list_del_rcu(&entry->list);
+	spin_unlock_bh(&fa->learn_lock);
+	netdev_put(entry->in, &entry->in_tracker);
+	netdev_put(entry->out, &entry->out_tracker);
+	fa->flows[index] = NULL;
+	kfree_rcu(entry, rcu);
+	return err;
+}
+
+/* FIB notifications identify the preferred alias for each table/prefix.
+ * Retain only low-MTU prefixes, rather than dumping the FIB after changes.
+ * All accesses, including the registration retry reset, hold learn_lock.
+ */
+static void fa_mtu_route_update(struct bcm_ns_fa *fa, unsigned long event,
+				const struct fib_entry_notifier_info *info)
+{
+	struct fa_mtu_route *route;
+	u32 key = info->dst ^ info->tb_id ^ info->dst_len;
+	bool low = event != FIB_EVENT_ENTRY_DEL && info->fi &&
+		   info->fi->fib_mtu && info->fi->fib_mtu < ETH_DATA_LEN;
+
+	hash_for_each_possible(fa->mtu_routes, route, node, key) {
+		if (route->dst != info->dst || route->tb_id != info->tb_id ||
+		    route->prefix_len != info->dst_len)
+			continue;
+		if (!low) {
+			hash_del(&route->node);
+			kfree(route);
+			fa->nr_mtu_routes--;
+		}
+		goto out;
+	}
+	if (!low)
+		goto out;
+	if (fa->nr_mtu_routes == FA_MTU_ROUTES_MAX) {
+		fa->mtu_tracking_failed = true;
+		goto out;
+	}
+	route = kzalloc_obj(*route, GFP_ATOMIC);
+	if (!route) {
+		/* Never reject a route because an optional offload ran out of memory. */
+		fa->mtu_tracking_failed = true;
+		goto out;
+	}
+	route->dst = info->dst;
+	route->tb_id = info->tb_id;
+	route->prefix_len = info->dst_len;
+	hash_add(fa->mtu_routes, &route->node, key);
+	fa->nr_mtu_routes++;
+out:
+	fa->route_mtu_ok = !fa->nr_mtu_routes && !fa->mtu_tracking_failed;
+}
+
+static void fa_fib_reset(struct notifier_block *nb)
+{
+	struct bcm_ns_fa *fa = container_of(nb, struct bcm_ns_fa, fib_nb);
+	struct fa_mtu_route *route;
+	struct hlist_node *tmp;
+	unsigned int bucket;
+
+	spin_lock_bh(&fa->learn_lock);
+	hash_for_each_safe(fa->mtu_routes, bucket, tmp, route, node) {
+		hash_del(&route->node);
+		kfree(route);
+	}
+	fa->nr_mtu_routes = 0;
+	fa->mtu_tracking_failed = false;
+	fa->route_mtu_ok = true;
+	spin_unlock_bh(&fa->learn_lock);
+}
+
+/* Caller holds RCU and learn_lock. Stop hardware before notifying owners. */
+static void fa_invalidate_locked(struct bcm_ns_fa *fa)
+{
+	struct fa_flow *entry;
+
+	fa->control_generation++;
+	fa->pending_generation++;
+	fa->control_pending = true;
+	fa->invalidations++;
+	fa->invalidate_generation++;
+	fa_lookup_update(fa);
+	list_for_each_entry_rcu(entry, &fa->entries, list) {
+		set_bit(FA_FLOW_CLOSING, &entry->flags);
+		entry->invalidate(entry->cookie);
+	}
+	queue_work(system_dfl_wq, &fa->control_work);
+}
+
+static void fa_invalidate(struct bcm_ns_fa *fa)
+{
+	rcu_read_lock();
+	spin_lock_bh(&fa->learn_lock);
+	if (!fa->stopping)
+		fa_invalidate_locked(fa);
+	spin_unlock_bh(&fa->learn_lock);
+	rcu_read_unlock();
+}
+
+static int fa_fib_event(struct notifier_block *nb, unsigned long event, void *ptr)
+{
+	struct bcm_ns_fa *fa = container_of(nb, struct bcm_ns_fa, fib_nb);
+	struct fib_notifier_info *info = ptr;
+	bool route = false;
+
+	if (info->family != AF_INET)
+		return NOTIFY_DONE;
+	/* Deliberately invalidate all FA-owned flows for every IPv4 route,
+	 * rule or nexthop change, including unrelated and local-table routes.
+	 * The offload rule lacks the complete policy context needed to prove
+	 * that an event cannot affect an installed path.
+	 */
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_APPEND:
+	case FIB_EVENT_ENTRY_DEL:
+		route = true;
+		break;
+	case FIB_EVENT_RULE_ADD:
+	case FIB_EVENT_RULE_DEL:
+	case FIB_EVENT_NH_ADD:
+	case FIB_EVENT_NH_DEL:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+	rcu_read_lock();
+	spin_lock_bh(&fa->learn_lock);
+	if (!fa->stopping) {
+		if (route)
+			fa_mtu_route_update(fa, event, ptr);
+		fa_invalidate_locked(fa);
+	}
+	spin_unlock_bh(&fa->learn_lock);
+	rcu_read_unlock();
+	return NOTIFY_DONE;
+}
+
+static int fa_netevent(struct notifier_block *nb, unsigned long event, void *ptr)
+{
+	struct bcm_ns_fa *fa = container_of(nb, struct bcm_ns_fa, netevent_nb);
+	struct fa_neighbour *cached = NULL;
+	struct neighbour *neighbour = ptr;
+	bool invalidate = false;
+	unsigned int i;
+	char mac[ETH_ALEN];
+	__be32 address;
+	u8 state;
+
+	if (event == NETEVENT_IPV4_MPATH_HASH_UPDATE ||
+	    event == NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE) {
+		if (ptr == &init_net)
+			fa_invalidate(fa);
+		return NOTIFY_DONE;
+	}
+	if (event == NETEVENT_REDIRECT) {
+		struct netevent_redirect *redirect = ptr;
+
+		if (net_eq(dev_net(redirect->new->dev), &init_net))
+			fa_invalidate(fa);
+		return NOTIFY_DONE;
+	}
+	if (event != NETEVENT_NEIGH_UPDATE || neighbour->tbl->family != AF_INET ||
+	    !fa_port(fa, neighbour->dev))
+		return NOTIFY_DONE;
+	state = READ_ONCE(neighbour->nud_state);
+	address = get_unaligned((__be32 *)neighbour->primary_key);
+	neigh_ha_snapshot(mac, neighbour, neighbour->dev);
+	spin_lock_bh(&fa->learn_lock);
+	for (i = 0; i < ARRAY_SIZE(fa->neighbours); i++) {
+		struct fa_neighbour *candidate = &fa->neighbours[i];
+
+		if (candidate->valid && candidate->ifindex == neighbour->dev->ifindex &&
+		    candidate->address == address) {
+			cached = candidate;
+			invalidate = !(state & NUD_VALID) || memcmp(candidate->mac, mac, ETH_ALEN);
+			break;
+		}
+	}
+	if (!cached) {
+		cached = &fa->neighbours[fa->neighbour_next++ % FA_NEXTHOPS];
+		invalidate = cached->valid || !(state & NUD_VALID) || !list_empty(&fa->entries);
+	}
+	*cached = (struct fa_neighbour) {
+		.address = address, .ifindex = neighbour->dev->ifindex,
+		.state = state, .valid = true,
+	};
+	memcpy(cached->mac, mac, ETH_ALEN);
+	spin_unlock_bh(&fa->learn_lock);
+	if (invalidate)
+		fa_invalidate(fa);
+	return NOTIFY_DONE;
+}
+
+static void fa_control_work(struct work_struct *work)
+{
+	struct bcm_ns_fa *fa = container_of(work, struct bcm_ns_fa, control_work);
+	unsigned long generation;
+	unsigned int i;
+
+	mutex_lock(&fa->lock);
+	for (;;) {
+		spin_lock_bh(&fa->learn_lock);
+		generation = fa->pending_generation;
+		spin_unlock_bh(&fa->learn_lock);
+		for (i = 0; i < FA_SLOTS; i++) {
+			struct fa_flow *entry = fa->flows[i];
+
+			if (entry && test_bit(FA_FLOW_CLOSING, &entry->flags) && entry->reverse)
+				set_bit(FA_FLOW_CLOSING, &entry->reverse->flags);
+		}
+		for (i = 0; i < FA_SLOTS; i++)
+			if (fa->flows[i] && test_bit(FA_FLOW_CLOSING, &fa->flows[i]->flags))
+				fa_uninstall(fa, i);
+		spin_lock_bh(&fa->learn_lock);
+		if (generation == fa->pending_generation) {
+			memset(fa->learned, 0, sizeof(*fa->learned) * FA_SLOTS);
+			fa->control_pending = false;
+			fa_lookup_update(fa);
+			spin_unlock_bh(&fa->learn_lock);
+			break;
+		}
+		spin_unlock_bh(&fa->learn_lock);
+	}
+	mutex_unlock(&fa->lock);
+}
+
+static void fa_encode(const struct fa_rule *rule, unsigned int pool,
+		      unsigned int nh, unsigned int port, u32 data[8])
+{
+	data[1] = FIELD_PREP(FA_FLOW1_ACTION, rule->action) |
+		  FIELD_PREP(FA_FLOW1_ROUTER_MAC, pool) |
+		  FIELD_PREP(FA_FLOW1_NEXT_HOP, nh) |
+		  FIELD_PREP(FA_FLOW1_REMAP_IP_LO,
+			     rule->remap_ip & FIELD_MAX(FA_FLOW1_REMAP_IP_LO));
+	data[2] = FIELD_PREP(FA_FLOW2_REMAP_IP_HI, rule->remap_ip >> 17) |
+		  FIELD_PREP(FA_FLOW2_REMAP_PORT, rule->remap_port) |
+		  FIELD_PREP(FA_FLOW2_DPORT_LO,
+			     be16_to_cpu(rule->tuple.dport) & FIELD_MAX(FA_FLOW2_DPORT_LO));
+	data[3] = FIELD_PREP(FA_FLOW3_DPORT_HI, be16_to_cpu(rule->tuple.dport) >> 1) |
+		  FIELD_PREP(FA_FLOW3_SPORT, be16_to_cpu(rule->tuple.sport)) |
+		  (rule->l4proto == IPPROTO_TCP ? FA_FLOW3_TCP : 0);
+	data[4] = be32_to_cpu(rule->tuple.dst);
+	data[5] = be32_to_cpu(rule->tuple.src);
+	/* Direct to UniMAC2; ingress opcode 1, one destination switch port. */
+	data[6] = FA_FLOW6_VALID | FIELD_PREP(FA_FLOW6_DIRECTION, rule->direction) |
+		  FIELD_PREP(FA_FLOW6_OPCODE, FA_FLOW6_OPCODE_INGRESS) |
+		  FIELD_PREP(FA_FLOW6_DEST_MAP, BIT(port));
+	data[7] = FA_FLOW7_IPV4;
+}
+
+static int fa_insert(struct bcm_ns_fa *fa, struct flow_cls_offload *cls,
+		     const struct fa_rule *parsed)
+{
+	struct fa_rule rule = *parsed;
+	struct fa_learned learned;
+	struct fa_flow *entry;
+	u32 data[8] = {};
+	int i, slot = -1, pi, po, nh, err;
+
+	if (fa->failed)
+		return -EIO;
+	/* A shared block may deliver the same cookie through both ports. */
+	i = fa_find(fa, cls->cookie);
+	if (i >= 0)
+		return test_bit(FA_FLOW_CLOSING, &fa->flows[i]->flags) ? -EOPNOTSUPP : 0;
+	err = fa_learn_lookup(fa, &rule, &learned);
+	if (err)
+		return err;
+	for (i = learned.hash * FA_WAYS; i < (learned.hash + 1) * FA_WAYS; i++) {
+		if (fa->flows[i]) {
+			if (fa->flows[i]->installed && fa->flows[i]->l4proto == rule.l4proto &&
+			    !memcmp(&fa->flows[i]->tuple, &rule.tuple, sizeof(rule.tuple)))
+				return -EEXIST;
+		} else if (slot < 0) {
+			slot = i;
+		}
+	}
+	if (slot < 0)
+		return -ENOSPC;
+	entry = kzalloc_obj(*entry);
+	if (!entry)
+		return -ENOMEM;
+	pi = fa_mac_get(fa, learned.mac, rule.direction, false);
+	if (pi < 0) {
+		err = pi;
+		goto free;
+	}
+	po = fa_mac_get(fa, rule.eth + ETH_ALEN, !rule.direction, false);
+	if (po < 0) {
+		err = po;
+		goto put_in;
+	}
+	nh = fa_mac_get(fa, rule.eth, false, true);
+	if (nh < 0) {
+		err = nh;
+		goto put_out;
+	}
+
+	entry->cookie = cls->cookie;
+	entry->invalidate = cls->invalidate;
+	entry->tuple = rule.tuple;
+	entry->l4proto = rule.l4proto;
+	entry->pool_in = pi;
+	entry->pool_out = po;
+	entry->nh = nh;
+	entry->in = rule.in;
+	entry->out = rule.out;
+	entry->in_port = dsa_port_from_netdev(rule.in)->index;
+	entry->out_port = dsa_port_from_netdev(rule.out)->index;
+	fa_reply_tuple(&rule, &entry->reply);
+	netdev_hold(entry->in, &entry->in_tracker, GFP_KERNEL);
+	netdev_hold(entry->out, &entry->out_tracker, GFP_KERNEL);
+	spin_lock_bh(&fa->learn_lock);
+	if (learned.generation != (rule.l4proto == IPPROTO_TCP ? fa->control_generation :
+				  fa->invalidate_generation) || fa->control_pending) {
+		spin_unlock_bh(&fa->learn_lock);
+		netdev_put(entry->in, &entry->in_tracker);
+		netdev_put(entry->out, &entry->out_tracker);
+		err = -EAGAIN;
+		goto put_nh;
+	}
+	list_add_rcu(&entry->list, &fa->entries);
+	spin_unlock_bh(&fa->learn_lock);
+	fa_encode(&rule, po, nh, entry->out_port, data);
+	/* Publish to NAPI before committing: a concurrent control trap must
+	 * stop lookups even if it arrives while this entry is being written.
+	 */
+	fa_control_update(fa, 0, FA_CTL_NO_DA_CHECK);
+	err = fa_write(fa, FA_FLOW_TABLE, slot, data);
+	if (err) {
+		fa_fail(fa);
+		list_del_rcu(&entry->list);
+		netdev_put(entry->in, &entry->in_tracker);
+		netdev_put(entry->out, &entry->out_tracker);
+		kfree_rcu(entry, rcu);
+		return err;
+	}
+	entry->installed = true;
+	if (rule.l4proto == IPPROTO_TCP) {
+		struct fa_flow *other;
+
+		list_for_each_entry(other, &fa->entries, list) {
+			if (other == entry || other->l4proto != IPPROTO_TCP || other->reverse ||
+			    test_bit(FA_FLOW_CLOSING, &other->flags) ||
+			    other->in_port != entry->out_port ||
+			    other->out_port != entry->in_port ||
+			    memcmp(&other->tuple, &entry->reply, sizeof(other->tuple)) ||
+			    memcmp(&other->reply, &entry->tuple, sizeof(other->reply)))
+				continue;
+			entry->reverse = other;
+			other->reverse = entry;
+			break;
+		}
+	}
+	entry->lastused = jiffies;
+	fa->flows[slot] = entry;
+	fa->nr_flows++;
+	return 0;
+put_nh:
+	if (!fa->failed)
+		fa_mac_put(fa, nh, true);
+put_out:
+	if (!fa->failed)
+		fa_mac_put(fa, po, false);
+put_in:
+	if (!fa->failed)
+		fa_mac_put(fa, pi, false);
+free:
+	kfree(entry);
+	return err;
+}
+
+static int fa_route_supported(const struct fa_rule *rule, const struct fib_result *res)
+{
+	const struct fib_nh_common *nhc;
+
+	if (res->type != RTN_UNICAST || !res->fi)
+		return -EOPNOTSUPP;
+	/* These paths may be valid software flowtable routes. Reject hardware
+	 * admission without tearing down their software owner on every retry.
+	 */
+	if (res->fi->nh || res->fi->fib_nhs != 1 ||
+	    (res->fi->fib_mtu && res->fi->fib_mtu < ETH_DATA_LEN))
+		return -EOPNOTSUPP;
+	nhc = FIB_RES_NHC(*res);
+	if (nhc->nhc_lwtstate || (nhc->nhc_gw_family && nhc->nhc_gw_family != AF_INET))
+		return -EOPNOTSUPP;
+	return FIB_RES_DEV(*res) == rule->out ? 0 : -EOPNOTSUPP;
+}
+
+/* This lookup is only a conservative hardware eligibility probe. The
+ * classifier lacks the owner's full mark/DSCP/oif context, so a mismatch
+ * cannot prove that a cached software path is stale. The owner validates
+ * its actual cached route separately. Caller holds RCU.
+ */
+static int fa_route_check(const struct fa_rule *rule)
+{
+	struct flowi4 fl4 = {
+		.flowi4_iif = rule->in->ifindex,
+		.flowi4_proto = rule->l4proto,
+		.saddr = rule->tuple.src,
+		.daddr = rule->tuple.dst,
+		.fl4_sport = rule->tuple.sport,
+		.fl4_dport = rule->tuple.dport,
+	};
+	struct fib_result res = {};
+	struct fib_nh_common *nhc;
+	struct neighbour *neigh;
+	u8 mac[ETH_ALEN];
+	bool valid;
+	__be32 gw;
+	int err;
+
+	if (rule->direction == FA_DIR_DNAT) {
+		if (rule->action & FA_ACT_REMAP_IP)
+			fl4.daddr = htonl(rule->remap_ip);
+		if (rule->action & FA_ACT_REMAP_PORT)
+			fl4.fl4_dport = htons(rule->remap_port);
+	}
+	if (fib_lookup(&init_net, &fl4, &res, 0))
+		return -EOPNOTSUPP;
+	err = fa_route_supported(rule, &res);
+	if (err)
+		return err;
+	nhc = FIB_RES_NHC(res);
+	gw = nhc->nhc_gw_family == AF_INET ? nhc->nhc_gw.ipv4 : fl4.daddr;
+	neigh = ipv4_neigh_lookup(rule->out, &gw);
+	if (!neigh)
+		return -EOPNOTSUPP;
+	neigh_ha_snapshot(mac, neigh, rule->out);
+	valid = (READ_ONCE(neigh->nud_state) & NUD_VALID) && ether_addr_equal(mac, rule->eth);
+	neigh_release(neigh);
+	return valid ? 0 : -EOPNOTSUPP;
+}
+
+static int fa_replace(struct bcm_ns_fa *fa, struct flow_cls_offload *cls)
+{
+	struct fa_rule rule = {};
+	netdevice_tracker in_tracker, out_tracker;
+	int err;
+
+	if (!cls->invalidate || !cls->validate || !fa->enabled ||
+	    !READ_ONCE(fa->route_mtu_ok) ||
+	    READ_ONCE(fa->control_pending))
+		return -EOPNOTSUPP;
+	rcu_read_lock();
+	err = fa_parse(fa, cls, &rule);
+	if (!err)
+		err = cls->validate(cls->cookie);
+	if (err == -ESTALE) {
+		cls->invalidate(cls->cookie);
+		err = -EOPNOTSUPP;
+	}
+	if (!err)
+		err = fa_route_check(&rule);
+	if (!err) {
+		netdev_hold(rule.in, &in_tracker, GFP_ATOMIC);
+		netdev_hold(rule.out, &out_tracker, GFP_ATOMIC);
+	}
+	rcu_read_unlock();
+	if (err) {
+		NL_SET_ERR_MSG_MOD(cls->common.extack,
+				   "FA requires IPv4 TCP/UDP NAT between two standalone ports");
+		return err;
+	}
+	err = fa_insert(fa, cls, &rule);
+	netdev_put(rule.in, &in_tracker);
+	netdev_put(rule.out, &out_tracker);
+	return err;
+}
+
+static int fa_stats(struct bcm_ns_fa *fa, struct flow_cls_offload *cls, int slot)
+{
+	struct fa_flow *entry = fa->flows[slot];
+	int err;
+
+	if (fa->failed)
+		return -EIO;
+	if (entry->installed) {
+		err = fa_counter_read(fa, slot);
+		if (err)
+			return err;
+	}
+	/* Hardware clear-on-read gives unreliable hit counts. Read cumulative
+	 * packet counters and compute wrapping deltas in fa_counter_read().
+	 * Retired TCP rows retain their final delta until it is reported here.
+	 */
+	flow_stats_update(&cls->stats, 0, entry->pending_hits, 0, entry->lastused,
+			  FLOW_ACTION_HW_STATS_DELAYED);
+	entry->pending_hits = 0;
+	return 0;
+}
+
+static int fa_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct bcm_ns_fa *fa = cb_priv;
+	struct flow_cls_offload *cls = type_data;
+	int slot, err;
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+	mutex_lock(&fa->lock);
+	slot = fa_find(fa, cls->cookie);
+	switch (cls->command) {
+	case FLOW_CLS_REPLACE:
+		err = fa_replace(fa, cls);
+		break;
+	case FLOW_CLS_DESTROY:
+		err = slot < 0 ? slot : fa_destroy(fa, slot);
+		break;
+	case FLOW_CLS_STATS:
+		err = slot < 0 ? slot : fa_stats(fa, cls, slot);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+	mutex_unlock(&fa->lock);
+	return err;
+}
+
+int bcm_ns_fa_setup_tc(struct bcm_ns_fa *fa, enum tc_setup_type type, void *data)
+{
+	struct flow_block_offload *block = data;
+	struct flow_block_cb *cb;
+
+	if (!fa || type != TC_SETUP_FT ||
+	    block->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+	block->driver_block_list = &fa->block_list;
+	/* DSA forwards each user-port bind to the same conduit. Keep one
+	 * callback per flowtable, with a reference for each bound user port.
+	 */
+	switch (block->command) {
+	case FLOW_BLOCK_BIND:
+		cb = flow_block_cb_lookup(block->block, fa_block_cb, fa);
+		if (cb) {
+			flow_block_cb_incref(cb);
+			return 0;
+		}
+		/* Different flowtables have independent cookies and policy. The
+		 * hardware cannot partition tables by ingress port or netns.
+		 */
+		if (!list_empty(&fa->block_list))
+			return -EBUSY;
+		cb = flow_block_cb_alloc(fa_block_cb, fa, fa, NULL);
+		if (IS_ERR(cb))
+			return PTR_ERR(cb);
+		flow_block_cb_incref(cb);
+		flow_block_cb_add(cb, block);
+		list_add_tail(&cb->driver_list, &fa->block_list);
+		return 0;
+	case FLOW_BLOCK_UNBIND:
+		cb = flow_block_cb_lookup(block->block, fa_block_cb, fa);
+		if (!cb)
+			return -ENOENT;
+		bcm_ns_fa_flush(fa);
+		if (!flow_block_cb_decref(cb)) {
+			flow_block_cb_remove(cb, block);
+			list_del(&cb->driver_list);
+		}
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(bcm_ns_fa_setup_tc);
+
+void bcm_ns_fa_flush(struct bcm_ns_fa *fa)
+{
+	int i;
+
+	if (!fa)
+		return;
+	mutex_lock(&fa->lock);
+	for (i = 0; i < FA_SLOTS; i++) {
+		if (fa->flows[i]) {
+			rcu_read_lock();
+			fa->flows[i]->invalidate(fa->flows[i]->cookie);
+			rcu_read_unlock();
+			fa_destroy(fa, i);
+		}
+	}
+	spin_lock_bh(&fa->learn_lock);
+	memset(fa->learned, 0, sizeof(*fa->learned) * FA_SLOTS);
+	spin_unlock_bh(&fa->learn_lock);
+	mutex_unlock(&fa->lock);
+}
+EXPORT_SYMBOL_GPL(bcm_ns_fa_flush);
+
+void bcm_ns_fa_set_offload(struct bcm_ns_fa *fa, bool enable)
+{
+	if (!fa)
+		return;
+	mutex_lock(&fa->lock);
+	fa->enabled = enable;
+	spin_lock_bh(&fa->learn_lock);
+	fa_lookup_update(fa);
+	spin_unlock_bh(&fa->learn_lock);
+	mutex_unlock(&fa->lock);
+	if (!enable)
+		bcm_ns_fa_flush(fa);
+}
+EXPORT_SYMBOL_GPL(bcm_ns_fa_set_offload);
+
+static int fa_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
+{
+	struct bcm_ns_fa *fa = container_of(nb, struct bcm_ns_fa, netdev_nb);
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	/* New active ports or upper devices change the lookup domain. Flush
+	 * synchronously before the new topology becomes usable.
+	 */
+	if (event != NETDEV_GOING_DOWN && event != NETDEV_DOWN &&
+	    event != NETDEV_PRE_CHANGEADDR &&
+	    event != NETDEV_CHANGEADDR &&
+	    event != NETDEV_CHANGE &&
+	    event != NETDEV_CHANGEMTU &&
+	    event != NETDEV_PRECHANGEUPPER && event != NETDEV_CHANGEUPPER &&
+	    event != NETDEV_UP && event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
+	if (dev == fa->conduit || dev == fa_control_conduit(fa) ||
+	    (dsa_user_dev_check(dev) &&
+	     dsa_port_to_conduit(dsa_port_from_netdev(dev)) == fa->conduit))
+		bcm_ns_fa_flush(fa);
+	return NOTIFY_DONE;
+}
+
+static int fa_debug_show(struct seq_file *s, void *unused)
+{
+	struct bcm_ns_fa *fa = s->private;
+	unsigned int count = 0;
+	int i;
+
+	mutex_lock(&fa->lock);
+	seq_printf(s, "failed %u\nhits %u\nmisses %u\nerrors %#x\n",
+		   fa->failed, readl(fa->regs + FA_HITS),
+		   readl(fa->regs + FA_MISSES), readl(fa->regs + FA_ERROR));
+	seq_printf(s, "tcp_ready %u\n", fa->tcp_ready);
+	seq_printf(s, "route_mtu_ok %u\ninvalidations %lu\n", fa->route_mtu_ok,
+		   READ_ONCE(fa->invalidations));
+	seq_printf(s, "mtu_routes %u\nmtu_tracking_failed %u\n",
+		   READ_ONCE(fa->nr_mtu_routes), READ_ONCE(fa->mtu_tracking_failed));
+	seq_printf(s, "fault_injections %lu\n", fa->fault_injections);
+	seq_puts(s, "slot cookie ingress egress packets\n");
+	for (i = 0; i < FA_SLOTS; i++) {
+		struct fa_flow *entry = fa->flows[i];
+		u32 data[8], hits = 0;
+
+		if (!entry || !entry->installed)
+			continue;
+		count++;
+		if (!fa->failed) {
+			if (fa_read(fa, FA_FLOW_TABLE, i, data))
+				fa_fail(fa);
+			else
+				hits = fa_hits(data);
+		}
+		seq_printf(s, "%u %#lx %s %s %u\n", i, entry->cookie,
+			   entry->in->name, entry->out->name, hits);
+	}
+	seq_printf(s, "entries %u\n", count);
+	mutex_unlock(&fa->lock);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(fa_debug);
+
+static int fa_table_show(struct seq_file *s, void *unused)
+{
+	struct bcm_ns_fa *fa = s->private;
+	unsigned int i;
+
+	mutex_lock(&fa->lock);
+	seq_printf(s, "control %#x napt %#x mem_control %#x\n",
+		   readl(fa->regs + FA_CTL), readl(fa->regs + FA_NAPT),
+		   readl(fa->regs + FA_MEM_CTL));
+	for (i = 0; i < FA_SLOTS; i++) {
+		struct fa_flow *entry = fa->flows[i];
+		u32 data[8] = {};
+
+		if (!entry || !entry->installed)
+			continue;
+		seq_printf(s, "%u cookie %#lx tuple %pI4:%u %pI4:%u proto %s\n", i,
+			   entry->cookie, &entry->tuple.src, ntohs(entry->tuple.sport),
+			   &entry->tuple.dst, ntohs(entry->tuple.dport),
+			   entry->l4proto == IPPROTO_TCP ? "tcp" : "udp");
+		if (fa->failed)
+			continue;
+		if (fa_read(fa, FA_FLOW_TABLE, i, data)) {
+			fa_fail(fa);
+			continue;
+		}
+		seq_printf(s, "raw %u %08x %08x %08x %08x %08x %08x %08x %08x\n",
+			   i, data[7], data[6], data[5], data[4], data[3], data[2],
+			   data[1], data[0]);
+	}
+	mutex_unlock(&fa->lock);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(fa_table);
+
+static void fa_release(void *ptr)
+{
+	struct bcm_ns_fa *fa = ptr;
+
+	spin_lock_bh(&fa->learn_lock);
+	fa->stopping = true;
+	writel(readl(fa->regs + FA_CTL) | FA_CTL_BYPASS, fa->regs + FA_CTL);
+	readl(fa->regs + FA_CTL);
+	spin_unlock_bh(&fa->learn_lock);
+	brcm_fa_control_unregister(&fa->control);
+	unregister_fib_notifier(&init_net, &fa->fib_nb);
+	fa_fib_reset(&fa->fib_nb);
+	unregister_netevent_notifier(&fa->netevent_nb);
+	cancel_work_sync(&fa->control_work);
+	debugfs_remove_recursive(fa->debugfs);
+	unregister_netdevice_notifier(&fa->netdev_nb);
+	bcm_ns_fa_flush(fa);
+}
+
+struct bcm_ns_fa *bcm_ns_fa_init(struct net_device *dev)
+{
+	struct device *parent = dev->dev.parent;
+	struct device_node *np;
+	struct resource res;
+	struct bcm_ns_fa *fa;
+	u32 val;
+	int err;
+
+	np = of_parse_phandle(parent->of_node, "brcm,flow-accelerator", 0);
+	if (!np)
+		return NULL;
+	if (!of_device_is_available(np)) {
+		of_node_put(np);
+		return NULL;
+	}
+	if (!of_device_is_compatible(np, "brcm,bcm4708-fa") &&
+	    !of_device_is_compatible(np, "brcm,bcm53011-fa") &&
+	    !of_device_is_compatible(np, "brcm,bcm53012-fa")) {
+		of_node_put(np);
+		return ERR_PTR(-ENODEV);
+	}
+	err = of_address_to_resource(np, 0, &res);
+	of_node_put(np);
+	if (err)
+		return ERR_PTR(err);
+	if (resource_size(&res) < FA_DATA(7) + sizeof(u32))
+		return ERR_PTR(-EINVAL);
+	fa = devm_kzalloc(parent, sizeof(*fa), GFP_KERNEL);
+	if (!fa)
+		return ERR_PTR(-ENOMEM);
+	fa->learned = devm_kcalloc(parent, FA_SLOTS, sizeof(*fa->learned), GFP_KERNEL);
+	if (!fa->learned)
+		return ERR_PTR(-ENOMEM);
+	fa->regs = devm_ioremap_resource(parent, &res);
+	if (IS_ERR(fa->regs))
+		return ERR_CAST(fa->regs);
+	fa->conduit = dev;
+	fa->fail_table = fa_fail_table_default;
+#ifdef CONFIG_FAULT_INJECTION
+	fa->fail_table.verbose = 0;
+#endif
+	fa->enabled = true;
+	fa->neighbour_check = jiffies - HZ;
+	mutex_init(&fa->lock);
+	spin_lock_init(&fa->learn_lock);
+	INIT_LIST_HEAD(&fa->block_list);
+	INIT_LIST_HEAD(&fa->entries);
+	INIT_WORK(&fa->control_work, fa_control_work);
+	hash_init(fa->mtu_routes);
+	fa->route_mtu_ok = true;
+
+	/* DA validation is enabled before publishing the first flow.
+	 * Mask interrupts: initialization and indirect accesses use bounded polls.
+	 */
+	writel(0, fa->regs + FA_STATUS_MASK);
+	writel(0, fa->regs + FA_ERROR_MASK);
+	writel(FA_INIT_DONE, fa->regs + FA_STATUS);
+	val = FA_CTL_BYPASS | FA_CTL_CRC_OVERWRITE |
+	      FIELD_PREP(FA_CTL_THRESHOLD, 0x140);
+	writel(val | FA_CTL_INIT, fa->regs + FA_CTL);
+	err = readl_poll_timeout(fa->regs + FA_STATUS, val,
+				 (val & FA_INIT_DONE) == FA_INIT_DONE, 100, 50000);
+	if (err)
+		return ERR_PTR(err);
+	/* The pool has no init command of its own. Clear stale firmware state. */
+	for (val = 0; val < FA_POOLS; val++) {
+		u32 zero[8] = {};
+
+		err = fa_write(fa, FA_POOL_TABLE, val, zero);
+		if (err)
+			return ERR_PTR(err);
+	}
+	/* Standalone traffic carries flooding reasons. TCP control packets
+	 * use the auxiliary CPU port and physically bypass this inline path.
+	 */
+	writel(FA_BRCM_HW | FA_BRCM_RX | FA_BRCM_TX | FA_BRCM_PARSE_EXCEPTIONS,
+	       fa->regs + FA_BRCM_HDR);
+	writel(0, fa->regs + FA_L2_SKIP);
+	/* Do not skip VLAN tags: tagged traffic must miss even if its inner
+	 * tuple equals an installed untagged flow.
+	 */
+	writel(0, fa->regs + FA_L2_TAG);
+	writel(ETH_P_IP | ETH_P_IPV6 << 16, fa->regs + FA_L2_ETHERTYPE);
+	writel(IPPROTO_TCP | IPPROTO_UDP << 8 | FA_IPV4_CSUM, fa->regs + FA_IPV4);
+	/* Zero seed, CCITT CRC; learned hashes are used for table placement. */
+	writel(FA_NAPT_DEC_TTL, fa->regs + FA_NAPT);
+	writel(0xff, fa->regs + FA_RX_STATUS);
+	fa->netdev_nb.notifier_call = fa_netdev_event;
+	err = register_netdevice_notifier(&fa->netdev_nb);
+	if (err)
+		return ERR_PTR(err);
+	fa->netevent_nb.notifier_call = fa_netevent;
+	err = register_netevent_notifier(&fa->netevent_nb);
+	if (err)
+		goto unregister_netdev;
+	fa->fib_nb.notifier_call = fa_fib_event;
+	err = register_fib_notifier(&init_net, &fa->fib_nb, fa_fib_reset, NULL);
+	if (err)
+		goto unregister_netevent;
+	/* Finish initial route replay before allowing hardware admission. */
+	fa_invalidate(fa);
+	fa->debugfs = debugfs_create_dir(dev_name(parent), NULL);
+	if (IS_ENABLED(CONFIG_BCM_NS_FA_FAULT_INJECTION)) {
+		fault_create_debugfs_attr("fail_table", fa->debugfs, &fa->fail_table);
+		debugfs_create_bool("fail_table_write_only", 0600, fa->debugfs,
+				    &fa->fail_table_write_only);
+	}
+	debugfs_create_file("fa", 0400, fa->debugfs, fa, &fa_debug_fops);
+	debugfs_create_file("fa_table", 0400, fa->debugfs, fa, &fa_table_fops);
+	fa->control.conduit = dev;
+	fa->control.priv = fa;
+	fa->control.receive = fa_control_receive;
+	fa->control.state_change = fa_control_state_change;
+	brcm_fa_control_register(&fa->control);
+	err = devm_add_action_or_reset(parent, fa_release, fa);
+	if (err)
+		return ERR_PTR(err);
+	writel(FA_CTL_NO_DA_CHECK | FA_CTL_CRC_OVERWRITE |
+	       FIELD_PREP(FA_CTL_THRESHOLD, 0x140),
+	       fa->regs + FA_CTL);
+	return fa;
+unregister_netevent:
+	fa_fib_reset(&fa->fib_nb);
+	WRITE_ONCE(fa->stopping, true);
+	unregister_netevent_notifier(&fa->netevent_nb);
+	cancel_work_sync(&fa->control_work);
+unregister_netdev:
+	unregister_netdevice_notifier(&fa->netdev_nb);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(bcm_ns_fa_init);
+
+MODULE_DESCRIPTION("Broadcom Northstar IPv4 TCP/UDP NAT flow accelerator");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa.h b/drivers/net/ethernet/broadcom/bcm-ns-fa.h
new file mode 100644
index 000000000000..825b019fb89f
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bcm-ns-fa.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _BCM_NS_FA_H
+#define _BCM_NS_FA_H
+
+#include <linux/netdevice.h>
+
+struct bcm_ns_fa;
+
+#if IS_REACHABLE(CONFIG_BCM_NS_FA)
+struct bcm_ns_fa *bcm_ns_fa_init(struct net_device *dev);
+void bcm_ns_fa_rx(struct bcm_ns_fa *fa, struct sk_buff *skb);
+int bcm_ns_fa_setup_tc(struct bcm_ns_fa *fa, enum tc_setup_type type, void *data);
+void bcm_ns_fa_flush(struct bcm_ns_fa *fa);
+void bcm_ns_fa_set_offload(struct bcm_ns_fa *fa, bool enable);
+#else
+static inline struct bcm_ns_fa *bcm_ns_fa_init(struct net_device *dev)
+{
+	return NULL;
+}
+
+static inline void bcm_ns_fa_rx(struct bcm_ns_fa *fa, struct sk_buff *skb) {}
+static inline void bcm_ns_fa_flush(struct bcm_ns_fa *fa) {}
+static inline void bcm_ns_fa_set_offload(struct bcm_ns_fa *fa, bool enable) {}
+static inline int bcm_ns_fa_setup_tc(struct bcm_ns_fa *fa,
+				     enum tc_setup_type type, void *data)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+#endif
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 36f9bad28e6a..87338e01a825 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -11,6 +11,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/brcmphy.h>
 #include <linux/etherdevice.h>
+#include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include "bgmac.h"
@@ -130,6 +131,10 @@ static int bgmac_probe(struct bcma_device *core)
 	const u8 *mac;
 	int err;
 
+	if (of_property_present(core->dev.of_node, "brcm,flow-accelerator") &&
+	    core->core_unit != 2)
+		return -EINVAL;
+
 	bgmac = bgmac_alloc(&core->dev);
 	if (!bgmac)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 1c502bd64d7d..527f9842eb83 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -486,6 +486,7 @@ static int bgmac_dma_rx_read(struct bgmac *bgmac, struct bgmac_dma_ring *ring,
 			skb_pull(skb, BGMAC_RX_FRAME_OFFSET +
 				 BGMAC_RX_BUF_OFFSET);
 
+			bcm_ns_fa_rx(bgmac->fa, skb);
 			skb_checksum_none_assert(skb);
 			skb->protocol = eth_type_trans(skb, bgmac->net_dev);
 			bgmac->net_dev->stats.rx_bytes += len;
@@ -1272,7 +1273,25 @@ static int bgmac_change_mtu(struct net_device *net_dev, int mtu)
 	return 0;
 }
 
+static int bgmac_set_features(struct net_device *dev, netdev_features_t features)
+{
+	struct bgmac *bgmac = netdev_priv(dev);
+
+	bcm_ns_fa_set_offload(bgmac->fa, features & NETIF_F_HW_TC);
+	return 0;
+}
+
+static int bgmac_setup_tc(struct net_device *dev, enum tc_setup_type type,
+			  void *data)
+{
+	struct bgmac *bgmac = netdev_priv(dev);
+
+	return bcm_ns_fa_setup_tc(bgmac->fa, type, data);
+}
+
 static const struct net_device_ops bgmac_netdev_ops = {
+	.ndo_set_features	= bgmac_set_features,
+	.ndo_setup_tc		= bgmac_setup_tc,
 	.ndo_open		= bgmac_open,
 	.ndo_stop		= bgmac_stop,
 	.ndo_start_xmit		= bgmac_start_xmit,
@@ -1560,6 +1579,17 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	net_dev->hw_features = net_dev->features;
 	net_dev->vlan_features = net_dev->features;
 
+	bgmac->fa = bcm_ns_fa_init(net_dev);
+	if (IS_ERR(bgmac->fa)) {
+		err = PTR_ERR(bgmac->fa);
+		bgmac->fa = NULL;
+		goto err_phy_disconnect;
+	}
+	if (bgmac->fa) {
+		net_dev->features |= NETIF_F_HW_TC;
+		net_dev->hw_features |= NETIF_F_HW_TC;
+	}
+
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
 
@@ -1610,6 +1640,7 @@ int bgmac_enet_suspend(struct bgmac *bgmac)
 	netif_tx_unlock(bgmac->net_dev);
 
 	bgmac_chip_intrs_off(bgmac);
+	bcm_ns_fa_flush(bgmac->fa);
 	bgmac_chip_reset(bgmac);
 	bgmac_dma_cleanup(bgmac);
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 6fee9a41839c..788d5ba9c9b5 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -5,6 +5,7 @@
 #include <linux/netdevice.h>
 
 #include "unimac.h"
+#include "bcm-ns-fa.h"
 
 #define BGMAC_DEV_CTL				0x000
 #define  BGMAC_DC_TSM				0x00000002
@@ -437,6 +438,7 @@ struct bgmac_rx_header {
 };
 
 struct bgmac {
+	struct bcm_ns_fa *fa;
 	union {
 		struct {
 			void __iomem *base;
-- 
2.53.0

