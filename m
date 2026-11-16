Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868014;
	b=bAuO/WRdeEZaesZhlaQOs6lbJMaRPeu7Rupa59TNoXw5tT2g3A5QJgcUp1ch1gVfxX+0
	 LdK41qB7QdAa7WWVpmBKKP7CaPRW1NEuAIDYMyuoPNZholmJWgIiaazXMPlLJVHkPAgdx
	 kZQv+waEnVparoGECkMf2t/PfUPKODRVmYgW4B3suiSfFYq7azwcC0afpra/cHtPli/kQ
	 b6kP+8aohrLxTVZP3IVhbBLzgTt+3JRkVEoS0FO/7w+0todSL8mIVGs+FDFAMSZ/n7MeC
	 EQSzCHV3Kkcsl6DBKk5wNI+S9bK+mqMilHmuW40aeBqgsIq/9lEOEq4z6a36InXPceQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868014;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=li4hDxbmbbiHSFMw7cXOofvlksN+B4sSXWcRWHEvsrQ=;
	b=ONiBn+0wxYtdQB8mNeSrxTr0EIjJ0FzApYEel7hZB/QAYSOq7GCxZJzFmTuU3DP5Ytmr
	 9cUb6hCfXYbcftyRHOxeGp573H2taHnhK9fbRUSPoR4dC1UOI0j0XvKcOyFHzYeoiCYqa
	 P4XA4HFt1hH4ncS/IW09DfxzTJgIQlZvprKsSgQdsIl6BaoNv8Tis2mvohpRrsIWIVVKN
	 ou255azZEb8iZD5aCzE+f3/BP1wez87G0hyUZZCbLB8D/kuUV0i3nFCqz8H7DvfSuPgn2
	 iWMpuMJCe1OJZvoOO0z0trruTMfeDmUcH7qJwq4SCvwtZewmNqY0iUCd0G/Upq+o/8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="JPZQF/gD";
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F3D606A886
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79F3D606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=JPZQF/gD
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3b12cb3c37bso2021085a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868007; x=1795472807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=li4hDxbmbbiHSFMw7cXOofvlksN+B4sSXWcRWHEvsrQ=;
        b=QN0TgULyfTw25UHYNIGlMst3j1JkIu0UOXQMKNZSlMc3D42/4K4Yth2nlHRHo7cyl9
         6I/j12r5/9l2OlzIL+NkxFLKoYZyNKqb+QDLezADYRcqHPmJN+1aBWJljbfMtuUpkyxu
         M1g0jVL8owMwL8TRxcgLq6JqXOMIzzZXEm9mITDquJ3vQdckL54MAlMVlAmz9WPZi/6A
         TvnSDgQXJfdbQ2kUcycFCgm4B8OHkBaIInaaR2gVF7SGrrUUs9L8YqreAnaCM5OVZU73
         vrKf7kVnkbzFIkfBQTJCJK6m/4zQli3XtojRH3SECKuBmmAfW9OmqLA1CSKmbzu/5XaZ
         1LhQ==
X-Forwarded-Encrypted: i=1; AL+hErEEBdfbRSkm3EfG1bHWBRJGyIj5zJRB1WCbkMdpvxAj+gK31D581xs7JrtIKqnE/9V3lSw1xNmHAP6Cf+Nl+8Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z9aUhjsmjkKhs9lBBNxrmY0Sps8Wlc46OtUbtL8g4PRor+8HJ8j
	wSYYTo1zo1r6pa01Is38QB2F868Iv5VLN4S2cVyL9exuE5g/oT8s7+FoyzUsS7kYZCj0OdbNplJ
	FSpQZRrYIWcofGVQbHkhd08mQx0IeSDOWIA0M2KCjYNHFidT08QVJw6DnRBfVbKduDEqtZ2ZnH6
	SMWDpTo55l1q5Ka+xu6AtyhMcNvqvrktw8lSuiz39fUoBzxQ6h7c6bFDDLAD7r7l8cxAr9I6TRD
	wzqozjmDIUCoaniQX3VSdo4e0q7
X-Gm-Gg: AZFdTZczphOegE2mKgilvkKUzpMr6UqF1cKoaNDnV3jrMvQeEdi03TCRrcUgl5G8oys
	pkwzG8cuHT8/yhO41Vvv9f/3Inki0GFyIyHkUXMmQwb1EeltvHzUgUVlGCeIjr2iAtvSwxbXKDL
	nTKNbdEgqQhzN9w/f/9w0L4aIsUGHAzlnBcz07JNhZrHlQx4HSKb39uRoDHgCIWXKAFItSiWXM/
	PO4pbdXHJoZQFU5vgJJ0BXZ1DzaOb3ZI8cSDWELuIz3rk39URkYJFChBZrsZqOwKLQIqsRz6rlE
	DRsEOmU3ivLf7n0+TgLF/Si2eyIQqXDZWf2gCC1HhoSFDlKpcEvX165qpuoS+6rvcjmzBrYahPF
	w8dflKkVV3f0sah8SNdqncHu7ZBsz+xwdFsX52UxRoUI+3z0cOFvzn92Xgy+wQbCEkVa4cq+muV
	UoWouFhKbHBB/IEWA389ELq3BrYCS5Tptf5eiA4bE1
X-Received: by 2002:a17:90b:4d8f:b0:3aa:fc22:8ab4 with SMTP id 98e67ed59e1d1-3b1b0a1ef17mr10707294a91.29.1794868006524;
        Mon, 16 Nov 2026 14:26:46 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abe7d05bsm515913a91.6.2026.11.16.14.26.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:46 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso3610048eec.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794868005; x=1795472805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=li4hDxbmbbiHSFMw7cXOofvlksN+B4sSXWcRWHEvsrQ=;
        b=JPZQF/gDbfnRwZ9IkE6ZShZAlpjTZ8ZxK3oXKH16dJL4ddZnzHKXmOVWgqar8Ow1wR
         BYRFbV4dXBECwhruWi+W8dEQzRK8m8jBHznPOe/+ZMf+GecWkveQzzmWxc5ao5Be3cwC
         U5W64qW6UlcNP9/5411V/ObeqxllQZgr3Bu3w=
X-Forwarded-Encrypted: i=1; AL+hErEFnQIDu9jgYEw2mvMtLRPN6d1FTBMPi3u5Ip+tzCGTgT56ZyY3rOQz3V8VxdTp5g/aLsIbzqC2LdBLhyEKMSQ=@vger.kernel.org
X-Received: by 2002:a05:7301:2a9c:b0:372:79a0:e8a3 with SMTP id 5a478bee46e88-37963374fdemr11871962eec.1.1794868003998;
        Mon, 16 Nov 2026 14:26:43 -0800 (PST)
X-Received: by 2002:a05:7301:2a9c:b0:372:79a0:e8a3 with SMTP id 5a478bee46e88-37963374fdemr11871924eec.1.1794868002757;
        Mon, 16 Nov 2026 14:26:42 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:42 -0800 (PST)
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
Subject: [PATCH net-next 8/9] net: add KUnit coverage for FA and flowtable path validation
Date: Mon, 16 Nov 2026 14:25:18 -0800
Message-ID: <20261116222519.1416501-9-florian.fainelli@broadcom.com>
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

Exercise Northstar NAT fields, byte order, protocol-aware hash learning,
TCP control identity, lookup gating, MTU tracking and owner
invalidation. Check B53 UDF layout and every IPv4 packet length, failed-
guard readiness, and FA/ordinary switch tags.

Test cached-route owner validation with route-cookie expiry, changed or
invalid neighbours, absent route context and unsupported stacked paths.
Require explicit owner validation to detect an expired validation-only
dst even though the generic packet/GC helper ignores that reference.

Add seven scenarios using real route initialization and the private GC
step: ordinary direct software forwarding, validation-only references,
direct tunnels with and without hardware requested, neighbour routes
with and without hardware requested, and XFRM. Check legacy validation
policy, GC teardown and balanced dst references. The validation-only
scenario fails both packet and GC expectations before the policy fix.

The independent netfilter prerequisite already carries its two lifetime
tests and standalone configuration. Extend that test configuration's
help for these path cases, embed private tests in their parent units,
and keep the combined FA configuration beside the backend.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 MAINTAINERS                                   |   3 +
 drivers/net/dsa/b53/Kconfig                   |  11 +
 drivers/net/dsa/b53/b53_common.c              |   4 +
 drivers/net/dsa/b53/b53_fa_test.c             | 102 +++
 drivers/net/ethernet/broadcom/.kunitconfig    |  21 +
 drivers/net/ethernet/broadcom/Kconfig         |  11 +
 .../net/ethernet/broadcom/bcm-ns-fa-test.c    | 661 ++++++++++++++++++
 drivers/net/ethernet/broadcom/bcm-ns-fa.c     |   4 +
 net/dsa/Kconfig                               |  11 +
 net/dsa/tag_brcm.c                            |   4 +
 net/dsa/tag_brcm_test.c                       | 199 ++++++
 net/netfilter/Kconfig                         |  10 +-
 net/netfilter/nf_flow_table_core_test.c       |  85 +++
 net/netfilter/nf_flow_table_offload.c         |   4 +
 net/netfilter/nf_flow_table_offload_test.c    | 129 ++++
 15 files changed, 1254 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/dsa/b53/b53_fa_test.c
 create mode 100644 drivers/net/ethernet/broadcom/.kunitconfig
 create mode 100644 drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
 create mode 100644 net/dsa/tag_brcm_test.c
 create mode 100644 net/netfilter/nf_flow_table_offload_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 80969b91af40..c05ac2258889 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5305,6 +5305,7 @@ F:	drivers/net/dsa/bcm_sf2*
 F:	include/linux/dsa/brcm.h
 F:	include/linux/platform_data/b53.h
 F:	net/dsa/tag_brcm.c
+F:	net/dsa/tag_brcm_test.c
 
 BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE
 M:	Florian Fainelli <florian.fainelli@broadcom.com>
@@ -5671,6 +5672,8 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
 F:	Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
+F:	drivers/net/dsa/b53/b53_fa_test.c
+F:	drivers/net/ethernet/broadcom/.kunitconfig
 F:	drivers/net/ethernet/broadcom/bcm-ns-fa*
 F:	drivers/net/ethernet/broadcom/bgmac*
 F:	drivers/net/ethernet/broadcom/unimac.h
diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index 8e2a8c20bc4a..5a03bacef2e5 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -13,6 +13,17 @@ menuconfig B53
 	  BCM5325E, BCM5365, BCM539x, BCM53115 and BCM53125 as well as BCM63XX
 	  integrated switches.
 
+config B53_FA_KUNIT_TEST
+	bool "KUnit tests for B53 FA exception guards" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && B53
+	default KUNIT_ALL_TESTS
+	help
+	  Tests are compiled into the parent driver and require built-in KUnit.
+	  Verify the original FA classifier field layout and complete packet
+	  length range used to divert unsafe packets around the accelerator.
+	  Check cross-word destination MAC encoding and every 16-bit IPv4
+	  packet length against the standard MTU without accessing hardware.
+
 config B53_SPI_DRIVER
 	tristate "B53 SPI connected switch driver"
 	depends on B53 && SPI
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3e8c9679836d..25bb23a51952 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -3802,6 +3802,10 @@ int b53_switch_register(struct b53_device *dev)
 }
 EXPORT_SYMBOL(b53_switch_register);
 
+#if IS_ENABLED(CONFIG_B53_FA_KUNIT_TEST)
+#include "b53_fa_test.c"
+#endif
+
 MODULE_AUTHOR("Jonas Gorski <jogo@openwrt.org>");
 MODULE_DESCRIPTION("B53 switch library");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/dsa/b53/b53_fa_test.c b/drivers/net/dsa/b53/b53_fa_test.c
new file mode 100644
index 000000000000..1806c87a54fb
--- /dev/null
+++ b/drivers/net/dsa/b53/b53_fa_test.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+
+static int b53_fa_test_write16(struct b53_device *dev, u8 page, u8 reg, u16 value)
+{
+	u16 *control = dev->priv;
+
+	if (page != B53_CFP_PAGE || reg != B53_CFP_CTRL)
+		return -EINVAL;
+	*control = value;
+	return 0;
+}
+
+static void b53_fa_test_port_guards(struct kunit *test)
+{
+	static const struct b53_io_ops ops = { .write16 = b53_fa_test_write16 };
+	struct b53_device *dev = kunit_kzalloc(test, sizeof(*dev), GFP_KERNEL);
+	struct dsa_switch_tree tree = {};
+	struct dsa_switch ds = { .dst = &tree };
+	struct dsa_port control = {
+		.ds = &ds, .index = 5, .type = DSA_PORT_TYPE_CPU,
+		.conduit_admin_up = true, .conduit_oper_up = true,
+	};
+	u16 map = 0;
+
+	KUNIT_ASSERT_NOT_NULL(test, dev);
+	INIT_LIST_HEAD(&tree.ports);
+	list_add(&control.list, &tree.ports);
+	dev->ds = &ds;
+	dev->ops = &ops;
+	dev->priv = &map;
+	dev->fa_cfp_enabled = true;
+	dev->fa_cfp_ports = BIT(0) | BIT(1);
+	mutex_init(&dev->reg_mutex);
+
+	/* Bridge changes must not resurrect incomplete or failed guards. */
+	KUNIT_ASSERT_EQ(test, b53_fa_port(dev, 0, false), 0);
+	KUNIT_EXPECT_EQ(test, map, (u16)0);
+	dev->fa_guards_ready = true;
+	KUNIT_ASSERT_EQ(test, b53_fa_port(dev, 0, true), 0);
+	KUNIT_EXPECT_EQ(test, map, (u16)(BIT(0) | BIT(1)));
+	dev->fa_guards_failed = true;
+	KUNIT_ASSERT_EQ(test, b53_fa_port(dev, 0, false), 0);
+	KUNIT_EXPECT_EQ(test, map, (u16)0);
+	KUNIT_ASSERT_EQ(test, b53_fa_port(dev, 0, true), 0);
+	KUNIT_EXPECT_EQ(test, map, (u16)0);
+	KUNIT_EXPECT_EQ(test, dev->fa_cfp_ports, (u16)(BIT(0) | BIT(1)));
+	dev->fa_guards_failed = false;
+	control.conduit_oper_up = false;
+	KUNIT_ASSERT_EQ(test, b53_fa_port(dev, 0, false), 0);
+	KUNIT_EXPECT_EQ(test, map, (u16)0);
+}
+
+static void b53_fa_test_length_range(struct kunit *test)
+{
+	unsigned int length, i;
+
+	for (length = 0; length <= U16_MAX; length++) {
+		bool trap = false;
+
+		for (i = 0; i < ARRAY_SIZE(b53_fa_lengths); i++)
+			if ((length & b53_fa_lengths[i][1]) == b53_fa_lengths[i][0])
+				trap = true;
+		KUNIT_ASSERT_EQ_MSG(test, trap, length > ETH_DATA_LEN, "length %u", length);
+	}
+}
+
+static void b53_fa_test_udf_layout(struct kunit *test)
+{
+	u32 data[8] = {}, mask[8] = {};
+
+	b53_fa_udf(data, mask, 2, 1501, 0xffff);
+	KUNIT_EXPECT_EQ(test, data[1], 0x0005dd00U);
+	KUNIT_EXPECT_EQ(test, mask[1], 0x00ffff00U);
+	KUNIT_EXPECT_EQ(test, mask[5], (u32)BIT(26));
+	memset(data, 0, sizeof(data));
+	memset(mask, 0, sizeof(mask));
+	b53_fa_udf(data, mask, 3, 0x0200, 0xffff);
+	b53_fa_udf(data, mask, 4, 0x0000, 0xffff);
+	b53_fa_udf(data, mask, 5, 0x0101, 0xffff);
+	KUNIT_EXPECT_EQ(test, data[1], 0U);
+	KUNIT_EXPECT_EQ(test, data[2], 0x01000002U);
+	KUNIT_EXPECT_EQ(test, data[3], 1U);
+	KUNIT_EXPECT_EQ(test, mask[1], 0xff000000U);
+	KUNIT_EXPECT_EQ(test, mask[2], 0xffffffffU);
+	KUNIT_EXPECT_EQ(test, mask[3], 0x000000ffU);
+	KUNIT_EXPECT_EQ(test, mask[5], (u32)(BIT(27) | BIT(28) | BIT(29)));
+}
+
+static struct kunit_case b53_fa_cases[] = {
+	KUNIT_CASE(b53_fa_test_port_guards),
+	KUNIT_CASE(b53_fa_test_length_range),
+	KUNIT_CASE(b53_fa_test_udf_layout),
+	{}
+};
+
+static struct kunit_suite b53_fa_suite = {
+	.name = "b53-fa-guards",
+	.test_cases = b53_fa_cases,
+};
+
+kunit_test_suite(b53_fa_suite);
diff --git a/drivers/net/ethernet/broadcom/.kunitconfig b/drivers/net/ethernet/broadcom/.kunitconfig
new file mode 100644
index 000000000000..9772432ffc32
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/.kunitconfig
@@ -0,0 +1,21 @@
+CONFIG_KUNIT=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_NET_DEV_REFCNT_TRACKER=y
+CONFIG_COMPILE_TEST=y
+CONFIG_NET=y
+CONFIG_INET=y
+CONFIG_NETDEVICES=y
+CONFIG_NET_VENDOR_BROADCOM=y
+CONFIG_NETFILTER=y
+CONFIG_NF_CONNTRACK=y
+CONFIG_NF_TABLES=y
+CONFIG_NF_FLOW_TABLE=y
+CONFIG_NF_FLOW_TABLE_KUNIT_TEST=y
+CONFIG_NET_DSA=y
+CONFIG_OF=y
+CONFIG_BCM_NS_FA=y
+CONFIG_BCM_NS_FA_KUNIT_TEST=y
+CONFIG_NET_DSA_TAG_BRCM_FA=y
+CONFIG_NET_DSA_TAG_BRCM_FA_KUNIT_TEST=y
+CONFIG_B53=y
+CONFIG_B53_FA_KUNIT_TEST=y
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 865b346a7249..f6cbe63b576b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -190,6 +190,17 @@ config BCM_NS_FA_FAULT_INJECTION
 	  reprobe and leaves forwarding to software. Intended for driver testing.
 	  Injection is disabled by default and can be armed through debugfs.
 
+config BCM_NS_FA_KUNIT_TEST
+	bool "KUnit tests for the Northstar flow accelerator" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && BCM_NS_FA
+	default KUNIT_ALL_TESTS
+	help
+	  Test NAT action validation, table field encoding, and RX hash learning.
+	  Exercise upper-device inspection under RCU with real netdevices.
+	  Tests are compiled into the parent driver and require built-in KUnit.
+	  These tests run without an accelerator and do not simulate table I/O.
+	  Use the hardware validation plan to check actual forwarding.
+
 config BGMAC_BCMA
 	tristate "Broadcom iProc GBit BCMA support"
 	depends on BCM_NS_FA || !BCM_NS_FA
diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
new file mode 100644
index 000000000000..59406f84809e
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
@@ -0,0 +1,661 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Included in bcm-ns-fa.c to exercise private table formats and validation. */
+#include <kunit/test.h>
+#include <net/lwtunnel.h>
+#include <net/nexthop.h>
+#include <linux/rtnetlink.h>
+
+static const struct net_device_ops fa_test_netdev_ops;
+
+static void fa_test_free_netdev(void *data)
+{
+	struct net_device *dev = data;
+
+	if (dev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(dev);
+	free_netdev(dev);
+}
+
+static void fa_test_upper_device_rcu(struct kunit *test)
+{
+	struct net_device *lower, *upper;
+	bool has_upper;
+	int err;
+
+	lower = alloc_etherdev(0);
+	KUNIT_ASSERT_NOT_NULL(test, lower);
+	err = kunit_add_action_or_reset(test, fa_test_free_netdev, lower);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	upper = alloc_etherdev(0);
+	KUNIT_ASSERT_NOT_NULL(test, upper);
+	err = kunit_add_action_or_reset(test, fa_test_free_netdev, upper);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	lower->netdev_ops = &fa_test_netdev_ops;
+	upper->netdev_ops = &fa_test_netdev_ops;
+	eth_hw_addr_random(lower);
+	eth_hw_addr_random(upper);
+	KUNIT_ASSERT_EQ(test, register_netdev(lower), 0);
+	KUNIT_ASSERT_EQ(test, register_netdev(upper), 0);
+
+	/* Rule workers inspect topology under RCU without taking RTNL. */
+	rcu_read_lock();
+	has_upper = fa_has_upper_dev_rcu(lower);
+	rcu_read_unlock();
+	KUNIT_EXPECT_FALSE(test, has_upper);
+
+	rtnl_lock();
+	err = netdev_upper_dev_link(lower, upper, NULL);
+	rtnl_unlock();
+	KUNIT_ASSERT_EQ(test, err, 0);
+	rcu_read_lock();
+	has_upper = fa_has_upper_dev_rcu(lower);
+	rcu_read_unlock();
+	KUNIT_EXPECT_TRUE(test, has_upper);
+
+	rtnl_lock();
+	netdev_upper_dev_unlink(lower, upper);
+	rtnl_unlock();
+	rcu_read_lock();
+	has_upper = fa_has_upper_dev_rcu(lower);
+	rcu_read_unlock();
+	KUNIT_EXPECT_FALSE(test, has_upper);
+}
+
+static u64 fa_test_bits(const u32 *data, unsigned int low, unsigned int width)
+{
+	u64 val = 0;
+	unsigned int i;
+
+	for (i = 0; i < width; i++)
+		if (data[(low + i) / 32] & BIT((low + i) % 32))
+			val |= BIT_ULL(i);
+	return val;
+}
+
+static void fa_test_encode(struct kunit *test)
+{
+	struct fa_rule rule = {
+		.tuple = { cpu_to_be32(0xc0000202), cpu_to_be32(0xc6336402),
+			   cpu_to_be16(0x1234), cpu_to_be16(0xabcd) },
+		.remap_ip = 0xcb007109,
+		.remap_port = 0x5678,
+		.action = FA_ACT_REMAP_IP | FA_ACT_REMAP_PORT,
+		.direction = FA_DIR_DNAT,
+	};
+	u32 data[8] = {};
+
+	fa_encode(&rule, 3, 127, 4, data);
+	/* Compare against the bit ranges in the hardware table definition,
+	 * including fields that straddle words and host/network byte order.
+	 */
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 0, 35), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 35, 2), 3ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 37, 1), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 38, 2), 3ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 40, 7), 127ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 47, 32), 0xcb007109ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 79, 16), 0x5678ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 95, 16), 0xabcdULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 111, 16), 0x1234ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 127, 1), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 128, 32), 0xc6336402ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 160, 32), 0xc0000202ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 192, 1), 1ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 193, 10), 16ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 209, 3), 1ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 212, 1), 1ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 255, 1), 1ULL);
+}
+
+static void fa_test_mac_encode(struct kunit *test)
+{
+	const u8 addr[ETH_ALEN] = { 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54 };
+	u32 data[8] = {};
+
+	fa_mac_encode(addr, true, false, data);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 0, 1), 1ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 1, 48), 0xfedcba987654ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 49, 15), 0ULL);
+	memset(data, 0, sizeof(data));
+	fa_mac_encode(addr, false, false, data);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 0, 1), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 1, 48), 0xfedcba987654ULL);
+	memset(data, 0, sizeof(data));
+	fa_mac_encode(addr, false, true, data);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 0, 1), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 1, 2), 2ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 3, 16), 0ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 19, 48), 0xfedcba987654ULL);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 67, 29), 0ULL);
+	/* Hit-count bits must exclude the adjacent timestamp and action bits. */
+	data[0] = U32_MAX;
+	data[1] = U32_MAX;
+	KUNIT_EXPECT_EQ(test, fa_hits(data), U32_MAX);
+	data[0] = 7;
+	data[1] = ~7U;
+	KUNIT_EXPECT_EQ(test, fa_hits(data), 0U);
+}
+
+static void fa_test_nat_actions(struct kunit *test)
+{
+	struct fa_rule rule = { .direction = FA_DIR_UNSET, .l4proto = IPPROTO_UDP };
+	struct flow_action_entry act = {
+		.mangle = {
+			.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4,
+			.offset = offsetof(struct iphdr, saddr),
+			.val = (__force u32)cpu_to_be32(0xc0000201),
+		},
+	};
+
+	KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
+	KUNIT_EXPECT_EQ(test, rule.remap_ip, 0xc0000201U);
+	KUNIT_EXPECT_EQ(test, rule.direction, 0);
+	act.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+	act.mangle.offset = 0;
+	act.mangle.mask = (__force u32)cpu_to_be32(0x0000ffff);
+	act.mangle.val = (__force u32)cpu_to_be32(0xabcd0000);
+	KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
+	KUNIT_EXPECT_EQ(test, rule.remap_port, (u16)0xabcd);
+	KUNIT_EXPECT_EQ(test, rule.action, (u8)3);
+	/* Opposite-side rewrites cannot share a hardware entry. */
+	act.mangle.mask = (__force u32)cpu_to_be32(0xffff0000);
+	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
+	/* Partial IPv4 masks and arbitrary offsets must not be accepted. */
+	act.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
+	act.mangle.offset = offsetof(struct iphdr, daddr);
+	act.mangle.mask = 1;
+	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
+	act.mangle.mask = 0;
+	act.mangle.offset = offsetof(struct iphdr, ttl);
+	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
+}
+
+static void fa_test_ethernet_actions(struct kunit *test)
+{
+	const u8 expected[12] = { 0x02, 1, 2, 3, 4, 5, 0x02, 6, 7, 8, 9, 10 };
+	struct fa_rule rule = {};
+	struct flow_action_entry act = {
+		.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH,
+	};
+	int i;
+
+	for (i = 0; i < sizeof(expected); i += 4) {
+		act.mangle.offset = i;
+		memcpy(&act.mangle.val, expected + i, 4);
+		KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
+	}
+	KUNIT_EXPECT_MEMEQ(test, rule.eth, expected, sizeof(expected));
+	KUNIT_EXPECT_PTR_EQ(test, memchr_inv(rule.eth_mask, 0xff, 12), NULL);
+	act.mangle.offset = 9;
+	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
+}
+
+static void fa_test_rx_learning(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	struct iphdr *ip;
+	struct udphdr *udp;
+	u8 *tag;
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	fa->learned = kunit_kcalloc(test, FA_SLOTS, sizeof(*fa->learned), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fa->learned);
+	spin_lock_init(&fa->learn_lock);
+	INIT_LIST_HEAD(&fa->entries);
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	tag = skb_put_zero(skb, 4 + ETH_HLEN + sizeof(*ip) + sizeof(*udp));
+	tag[0] = FA_MISS_OPCODE << 5;
+	tag[1] = 0xfe;
+	tag[3] = 3;
+	eth = (void *)(tag + 4);
+	eth->h_proto = htons(ETH_P_IP);
+	eth->h_dest[0] = 2;
+	ip = (void *)(eth + 1);
+	ip->version = 4;
+	ip->ihl = 5;
+	ip->protocol = IPPROTO_UDP;
+	ip->tot_len = htons(sizeof(*ip) + sizeof(*udp));
+	ip->saddr = htonl(0xc0000201);
+	ip->daddr = htonl(0xc6336402);
+	udp = (void *)(ip + 1);
+	udp->source = htons(1234);
+	udp->dest = htons(5678);
+	ip->check = ip_fast_csum(ip, ip->ihl);
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	KUNIT_EXPECT_TRUE(test, fa->learned[0].valid);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].hash, (u8)0xfe);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].port, (u8)3);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].tuple.src, htonl(0xc0000201));
+	KUNIT_EXPECT_EQ(test, fa->learned[0].tuple.dport, htons(5678));
+	/* Preserve metadata for the brcm-fa DSA tagger. */
+	KUNIT_EXPECT_EQ(test, tag[0], (u8)(FA_MISS_OPCODE << 5));
+	ip->frag_off = htons(IP_MF);
+	ip->check = 0;
+	ip->check = ip_fast_csum(ip, ip->ihl);
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	ip->frag_off = 0;
+	ip->check = 0;
+	ip->check = ip_fast_csum(ip, ip->ihl);
+	tag[2] = 1;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	tag[2] = 0;
+	ip->protocol = IPPROTO_TCP;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	ip->protocol = IPPROTO_UDP;
+	eth->h_proto = htons(ETH_P_8021Q);
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	skb_trim(skb, 3);
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	kfree_skb(skb);
+}
+
+static void fa_test_tcp_encode_and_mangle(struct kunit *test)
+{
+	struct fa_rule rule = { .l4proto = IPPROTO_TCP, .direction = FA_DIR_UNSET };
+	struct flow_action_entry act = {
+		.mangle = {
+			.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+			.mask = (__force u32)cpu_to_be32(0xffff0000),
+			.val = (__force u32)cpu_to_be32(0x00001234),
+		},
+	};
+	u32 data[8] = {};
+
+	KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
+	KUNIT_EXPECT_EQ(test, rule.remap_port, (u16)0x1234);
+	KUNIT_EXPECT_EQ(test, rule.direction, 1);
+	act.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
+	fa_encode(&rule, 1, 2, 3, data);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 127, 1), 1ULL);
+	rule.l4proto = IPPROTO_UDP;
+	fa_encode(&rule, 1, 2, 3, data);
+	KUNIT_EXPECT_EQ(test, fa_test_bits(data, 127, 1), 0ULL);
+}
+
+static void fa_test_tcp_identity(struct kunit *test)
+{
+	struct fa_rule rule = {
+		.tuple = { cpu_to_be32(0xc0000202), cpu_to_be32(0xc6336402),
+			   cpu_to_be16(40000), cpu_to_be16(5001) },
+		.l4proto = IPPROTO_TCP,
+		.remap_ip = 0xcb007101,
+		.remap_port = 45000,
+		.action = FA_ACT_REMAP_IP | FA_ACT_REMAP_PORT,
+	};
+	struct fa_flow entry = { .l4proto = IPPROTO_TCP, .in_port = 3 };
+	struct fa_learned learn = { .valid = true, .l4proto = IPPROTO_UDP };
+	struct fa_tuple reply, control;
+
+	fa_reply_tuple(&rule, &reply);
+	KUNIT_EXPECT_EQ(test, reply.src, rule.tuple.dst);
+	KUNIT_EXPECT_EQ(test, reply.dst, htonl(rule.remap_ip));
+	KUNIT_EXPECT_EQ(test, reply.sport, rule.tuple.dport);
+	KUNIT_EXPECT_EQ(test, reply.dport, htons(rule.remap_port));
+	rule.direction = FA_DIR_DNAT;
+	fa_reply_tuple(&rule, &reply);
+	KUNIT_EXPECT_EQ(test, reply.src, htonl(rule.remap_ip));
+	KUNIT_EXPECT_EQ(test, reply.dst, rule.tuple.src);
+	KUNIT_EXPECT_EQ(test, reply.sport, htons(rule.remap_port));
+	KUNIT_EXPECT_EQ(test, reply.dport, rule.tuple.sport);
+
+	entry.tuple = rule.tuple;
+	control = rule.tuple;
+	KUNIT_EXPECT_TRUE(test, fa_control_match(&entry, &control, 3, true));
+	KUNIT_EXPECT_FALSE(test, fa_control_match(&entry, &control, 2, true));
+	control.sport++;
+	KUNIT_EXPECT_FALSE(test, fa_control_match(&entry, &control, 3, true));
+	KUNIT_EXPECT_TRUE(test, fa_control_match(&entry, &control, 3, false));
+	entry.l4proto = IPPROTO_UDP;
+	KUNIT_EXPECT_FALSE(test, fa_control_match(&entry, &control, 3, false));
+
+	/* Equal TCP/UDP four-tuples must never share a learned hash. A TCP
+	 * control packet also invalidates observations from the old lifetime.
+	 */
+	learn.tuple = rule.tuple;
+	KUNIT_EXPECT_FALSE(test, fa_learn_matches(&learn, &rule, 0));
+	learn.l4proto = IPPROTO_TCP;
+	KUNIT_EXPECT_TRUE(test, fa_learn_matches(&learn, &rule, 0));
+	KUNIT_EXPECT_FALSE(test, fa_learn_matches(&learn, &rule, 1));
+	rule.l4proto = IPPROTO_UDP;
+	learn.l4proto = IPPROTO_UDP;
+	/* UDP uses the route/neighbour epoch, independent of TCP controls. */
+	KUNIT_EXPECT_TRUE(test, fa_learn_matches(&learn, &rule, 0));
+	KUNIT_EXPECT_FALSE(test, fa_learn_matches(&learn, &rule, 1));
+}
+
+static void fa_test_tcp_rx_control(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	struct iphdr *ip;
+	struct tcphdr *tcp;
+	u8 *tag;
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	fa->learned = kunit_kcalloc(test, FA_SLOTS, sizeof(*fa->learned), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fa->learned);
+	INIT_LIST_HEAD(&fa->entries);
+	spin_lock_init(&fa->learn_lock);
+	skb = alloc_skb(128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	tag = skb_put_zero(skb, FA_TAG_LEN + ETH_HLEN + sizeof(*ip) + sizeof(*tcp));
+	tag[0] = FA_MISS_OPCODE << 5;
+	tag[1] = 0xab;
+	tag[3] = 2;
+	eth = (void *)(tag + FA_TAG_LEN);
+	eth->h_proto = htons(ETH_P_IP);
+	ip = (void *)(eth + 1);
+	ip->version = 4;
+	ip->ihl = 5;
+	ip->protocol = IPPROTO_TCP;
+	ip->tot_len = htons(sizeof(*ip) + sizeof(*tcp));
+	ip->saddr = htonl(0xc0000202);
+	ip->daddr = htonl(0xc6336402);
+	ip->check = ip_fast_csum(ip, ip->ihl);
+	tcp = (void *)(ip + 1);
+	tcp->doff = 5;
+	tcp->source = htons(40000);
+	tcp->dest = htons(5001);
+	tcp->syn = 1;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 0U);
+	KUNIT_EXPECT_EQ(test, fa->control_generation, 1UL);
+	tcp->syn = 0;
+	tcp->ack = 1;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].l4proto, (u8)IPPROTO_TCP);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].hash, (u8)0xab);
+	KUNIT_EXPECT_EQ(test, fa->learned[0].generation, 1UL);
+	/* Opcode-zero switch traps contain no hash, but still retire TCP. */
+	tag[0] = 0;
+	tag[1] = 1;
+	tag[2] = BIT(3);
+	tcp->fin = 1;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
+	KUNIT_EXPECT_EQ(test, fa->control_generation, 2UL);
+	tcp->fin = 0;
+	tcp->rst = 1;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->control_generation, 3UL);
+	tcp->doff = 4;
+	bcm_ns_fa_rx(fa, skb);
+	KUNIT_EXPECT_EQ(test, fa->control_generation, 3UL);
+	kfree_skb(skb);
+}
+
+static void fa_test_tcp_control_readiness(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	fa->regs = (void __iomem *)kunit_kzalloc(test, 0xc0, GFP_KERNEL);
+	fa->learned = kunit_kcalloc(test, FA_SLOTS, sizeof(*fa->learned), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fa->regs);
+	KUNIT_ASSERT_NOT_NULL(test, fa->learned);
+	mutex_init(&fa->lock);
+	spin_lock_init(&fa->learn_lock);
+	fa_control_state_change(fa, true);
+	KUNIT_EXPECT_TRUE(test, fa->tcp_ready);
+	fa_control_state_change(fa, false);
+	KUNIT_EXPECT_FALSE(test, fa->tcp_ready);
+	fa->stopping = true;
+	fa_control_state_change(fa, true);
+	KUNIT_EXPECT_FALSE(test, fa->tcp_ready);
+}
+
+static void fa_test_lookup_gate_preserves_tags(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	u32 *regs = kunit_kzalloc(test, 0xc0, GFP_KERNEL);
+	u32 control = FA_CTL_CRC_OVERWRITE | FA_CTL_NO_DA_CHECK;
+	u32 header = FA_BRCM_HW | FA_BRCM_RX | FA_BRCM_TX | FA_BRCM_PARSE_EXCEPTIONS;
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	KUNIT_ASSERT_NOT_NULL(test, regs);
+	fa->regs = (void __iomem *)regs;
+	writel(control, fa->regs + FA_CTL);
+	writel(header, fa->regs + FA_BRCM_HDR);
+	fa->enabled = true;
+	fa->tcp_ready = true;
+	fa->route_mtu_ok = true;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_L2_ETHERTYPE),
+			(u32)(ETH_P_IP | ETH_P_IPV6 << 16));
+	fa->control_pending = true;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_L2_ETHERTYPE), 0U);
+	fa->control_pending = false;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_NE(test, readl(fa->regs + FA_L2_ETHERTYPE), 0U);
+	fa->route_mtu_ok = false;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_L2_ETHERTYPE), 0U);
+	fa->route_mtu_ok = true;
+	fa->tcp_ready = false;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_L2_ETHERTYPE), 0U);
+	fa->tcp_ready = true;
+	fa->enabled = false;
+	fa_lookup_update(fa);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_L2_ETHERTYPE), 0U);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_CTL), control);
+	KUNIT_EXPECT_EQ(test, readl(fa->regs + FA_BRCM_HDR), header);
+}
+
+static void fa_test_mtu_cleanup(void *ptr)
+{
+	struct bcm_ns_fa *fa = ptr;
+
+	fa_fib_reset(&fa->fib_nb);
+}
+
+static void fa_test_route_mtu(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	struct dst_metrics metrics = {};
+	struct fib_info fi = { .fib_metrics = &metrics };
+	struct fib_entry_notifier_info entry = {
+		.info.family = AF_INET, .fi = &fi, .tb_id = RT_TABLE_MAIN,
+		.dst = 0xc0000200, .dst_len = 24,
+	};
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	spin_lock_init(&fa->learn_lock);
+	hash_init(fa->mtu_routes);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, fa_test_mtu_cleanup, fa), 0);
+
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+	metrics.metrics[RTAX_MTU - 1] = 1500;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+	metrics.metrics[RTAX_MTU - 1] = 1200;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_FALSE(test, fa->route_mtu_ok);
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 1U);
+	/* Replays/replacements are idempotent; tables and prefixes are distinct. */
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 1U);
+	entry.tb_id++;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	entry.dst_len++;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 3U);
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_DEL, &entry);
+	entry.dst_len--;
+	metrics.metrics[RTAX_MTU - 1] = 1500;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_FALSE(test, fa->route_mtu_ok);
+	entry.tb_id--;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 0U);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+	/* A registration retry must discard a partial replay before starting over. */
+	metrics.metrics[RTAX_MTU - 1] = 1000;
+	fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	fa_fib_reset(&fa->fib_nb);
+	KUNIT_EXPECT_TRUE(test, hash_empty(fa->mtu_routes));
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+}
+
+static void fa_test_route_mtu_capacity(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	struct dst_metrics metrics = {};
+	struct fib_info fi = { .fib_metrics = &metrics };
+	struct fib_entry_notifier_info entry = {
+		.info.family = AF_INET, .fi = &fi, .tb_id = RT_TABLE_MAIN, .dst_len = 32,
+	};
+	unsigned int i;
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	spin_lock_init(&fa->learn_lock);
+	hash_init(fa->mtu_routes);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, fa_test_mtu_cleanup, fa), 0);
+	/* Ordinary routes consume no tracking memory, regardless of FIB size. */
+	for (i = 0; i < 10000; i++) {
+		entry.dst = i;
+		fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	}
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 0U);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+	metrics.metrics[RTAX_MTU - 1] = 1200;
+	for (i = 0; i <= FA_MTU_ROUTES_MAX; i++) {
+		entry.dst = i;
+		fa_mtu_route_update(fa, FIB_EVENT_ENTRY_REPLACE, &entry);
+	}
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, (unsigned int)FA_MTU_ROUTES_MAX);
+	KUNIT_EXPECT_TRUE(test, fa->mtu_tracking_failed);
+	for (i = 0; i < FA_MTU_ROUTES_MAX; i++) {
+		entry.dst = i;
+		fa_mtu_route_update(fa, FIB_EVENT_ENTRY_DEL, &entry);
+	}
+	KUNIT_EXPECT_EQ(test, fa->nr_mtu_routes, 0U);
+	KUNIT_EXPECT_FALSE(test, fa->route_mtu_ok);
+	fa_fib_reset(&fa->fib_nb);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+}
+
+static void fa_test_route_suitability(struct kunit *test)
+{
+	struct dst_metrics metrics = {};
+	struct fib_info fi = { .fib_metrics = &metrics, .fib_nhs = 1 };
+	struct fib_nh_common nhc = {};
+	struct fib_result res = { .fi = &fi, .nhc = &nhc, .type = RTN_UNICAST };
+	struct fa_rule rule = {};
+
+	rule.out = kunit_kzalloc(test, sizeof(*rule.out), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, rule.out);
+	nhc.nhc_dev = rule.out;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), 0);
+	/* A partial driver-side lookup cannot establish a stale owner. */
+	fi.fib_nhs = 2;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	fi.fib_nhs = 1;
+	fi.nh = kunit_kzalloc(test, sizeof(*fi.nh), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fi.nh);
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	fi.nh = NULL;
+	nhc.nhc_lwtstate = kunit_kzalloc(test, sizeof(*nhc.nhc_lwtstate), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, nhc.nhc_lwtstate);
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	nhc.nhc_lwtstate = NULL;
+	metrics.metrics[RTAX_MTU - 1] = 1200;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	metrics.metrics[RTAX_MTU - 1] = 0;
+	nhc.nhc_gw_family = AF_INET6;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	nhc.nhc_gw_family = 0;
+	nhc.nhc_dev = NULL;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+	nhc.nhc_dev = rule.out;
+	res.type = RTN_BLACKHOLE;
+	KUNIT_EXPECT_EQ(test, fa_route_supported(&rule, &res), -EOPNOTSUPP);
+}
+
+struct fa_test_owner {
+	struct bcm_ns_fa *fa;
+	unsigned int calls;
+	bool lookup_stopped;
+};
+
+static void fa_test_owner_invalidate(unsigned long cookie)
+{
+	struct fa_test_owner *owner = (struct fa_test_owner *)cookie;
+
+	owner->calls++;
+	owner->lookup_stopped = !readl(owner->fa->regs + FA_L2_ETHERTYPE);
+}
+
+static void fa_test_empty_work(struct work_struct *work)
+{
+}
+
+static void fa_test_invalidation(struct kunit *test)
+{
+	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
+	struct fa_test_owner owner = { .fa = fa };
+	struct fa_flow entry = {
+		.cookie = (unsigned long)&owner,
+		.invalidate = fa_test_owner_invalidate,
+	};
+
+	KUNIT_ASSERT_NOT_NULL(test, fa);
+	fa->regs = (void __iomem *)kunit_kzalloc(test, 0xc0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fa->regs);
+	spin_lock_init(&fa->learn_lock);
+	INIT_WORK(&fa->control_work, fa_test_empty_work);
+	INIT_LIST_HEAD(&fa->entries);
+	list_add(&entry.list, &fa->entries);
+	fa->enabled = true;
+	fa->tcp_ready = true;
+	fa->route_mtu_ok = true;
+	fa_lookup_update(fa);
+	fa_invalidate(fa);
+	flush_work(&fa->control_work);
+	KUNIT_EXPECT_EQ(test, owner.calls, 1U);
+	KUNIT_EXPECT_TRUE(test, owner.lookup_stopped);
+	KUNIT_EXPECT_TRUE(test, test_bit(FA_FLOW_CLOSING, &entry.flags));
+	KUNIT_EXPECT_TRUE(test, fa->control_pending);
+	KUNIT_EXPECT_TRUE(test, fa->route_mtu_ok);
+	KUNIT_EXPECT_EQ(test, fa->invalidate_generation, 1UL);
+}
+
+static struct kunit_case fa_test_cases[] = {
+	KUNIT_CASE(fa_test_upper_device_rcu),
+	KUNIT_CASE(fa_test_encode),
+	KUNIT_CASE(fa_test_mac_encode),
+	KUNIT_CASE(fa_test_nat_actions),
+	KUNIT_CASE(fa_test_ethernet_actions),
+	KUNIT_CASE(fa_test_rx_learning),
+	KUNIT_CASE(fa_test_tcp_encode_and_mangle),
+	KUNIT_CASE(fa_test_tcp_identity),
+	KUNIT_CASE(fa_test_tcp_rx_control),
+	KUNIT_CASE(fa_test_tcp_control_readiness),
+	KUNIT_CASE(fa_test_lookup_gate_preserves_tags),
+	KUNIT_CASE(fa_test_route_mtu),
+	KUNIT_CASE(fa_test_route_mtu_capacity),
+	KUNIT_CASE(fa_test_route_suitability),
+	KUNIT_CASE(fa_test_invalidation),
+	{}
+};
+
+static struct kunit_suite fa_test_suite = {
+	.name = "bcm-ns-fa",
+	.test_cases = fa_test_cases,
+};
+
+kunit_test_suite(fa_test_suite);
diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa.c b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
index 8665ba94cbab..4ee8e5c18bb8 100644
--- a/drivers/net/ethernet/broadcom/bcm-ns-fa.c
+++ b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
@@ -1893,5 +1893,9 @@ struct bcm_ns_fa *bcm_ns_fa_init(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(bcm_ns_fa_init);
 
+#if IS_ENABLED(CONFIG_BCM_NS_FA_KUNIT_TEST)
+#include "bcm-ns-fa-test.c"
+#endif
+
 MODULE_DESCRIPTION("Broadcom Northstar IPv4 TCP/UDP NAT flow accelerator");
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2dffff2f6c34..33fa69d3f216 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -78,6 +78,17 @@ config NET_DSA_TAG_BRCM_FA
 	  switch port. Transmit uses the ordinary prepended Broadcom tag.
 	  Enable this for a B53 switch explicitly connected to an accelerator.
 
+config NET_DSA_TAG_BRCM_FA_KUNIT_TEST
+	bool "KUnit tests for Broadcom FA tags" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && NET_DSA_TAG_BRCM_FA
+	default KUNIT_ALL_TESTS
+	help
+	  Tests are compiled into the parent driver and require built-in KUnit.
+	  Verify FA miss demultiplexing, parser-status handling, and rejection
+	  of unsupported opcodes without changing ordinary Broadcom tagging.
+	  Exercise source-port demultiplexing and consumption of the metadata
+	  tag through the receive path, without requiring a physical switch.
+
 config NET_DSA_TAG_HELLCREEK
 	tristate "Tag driver for Hirschmann Hellcreek TSN switches"
 	help
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 8d13a3c7de5e..4a2c0a51db97 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -526,5 +526,9 @@ static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
 
 module_dsa_tag_drivers(dsa_tag_driver_array);
 
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA_KUNIT_TEST)
+#include "tag_brcm_test.c"
+#endif
+
 MODULE_DESCRIPTION("DSA tag driver for Broadcom switches using in-frame headers");
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_brcm_test.c b/net/dsa/tag_brcm_test.c
new file mode 100644
index 000000000000..85499461e86b
--- /dev/null
+++ b/net/dsa/tag_brcm_test.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Included in tag_brcm.c: test the real receive path with a minimal DSA tree. */
+#include <kunit/test.h>
+
+struct brcm_fa_test_ctx {
+	struct dsa_switch_tree tree;
+	struct dsa_switch ds;
+	struct dsa_port cpu, user;
+	struct net_device *conduit, *port;
+};
+
+static void brcm_fa_test_free_netdev(void *ptr)
+{
+	free_netdev(ptr);
+}
+
+static int brcm_fa_test_init(struct kunit *test)
+{
+	struct brcm_fa_test_ctx *ctx;
+	struct dsa_user_priv *priv;
+	int err;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	ctx->conduit = alloc_etherdev(0);
+	KUNIT_ASSERT_NOT_NULL(test, ctx->conduit);
+	err = kunit_add_action_or_reset(test, brcm_fa_test_free_netdev, ctx->conduit);
+	if (err)
+		return err;
+	ctx->port = alloc_etherdev(sizeof(*priv));
+	KUNIT_ASSERT_NOT_NULL(test, ctx->port);
+	err = kunit_add_action_or_reset(test, brcm_fa_test_free_netdev, ctx->port);
+	if (err)
+		return err;
+	INIT_LIST_HEAD(&ctx->tree.ports);
+	ctx->ds.dst = &ctx->tree;
+	ctx->cpu.index = 8;
+	ctx->cpu.type = DSA_PORT_TYPE_CPU;
+	ctx->cpu.ds = &ctx->ds;
+	ctx->cpu.dst = &ctx->tree;
+	ctx->user.ds = &ctx->ds;
+	ctx->user.dst = &ctx->tree;
+	ctx->user.index = 3;
+	ctx->user.type = DSA_PORT_TYPE_USER;
+	ctx->user.user = ctx->port;
+	list_add(&ctx->user.list, &ctx->tree.ports);
+	ctx->conduit->dsa_ptr = &ctx->cpu;
+	priv = netdev_priv(ctx->port);
+	priv->dp = &ctx->user;
+	test->priv = ctx;
+	return 0;
+}
+
+static struct sk_buff *brcm_fa_test_skb(u8 opcode, u8 status, u8 port)
+{
+	struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
+	u8 *data;
+
+	if (!skb)
+		return NULL;
+	data = skb_put_zero(skb, 64);
+	data[0] = opcode << BRCM_OPCODE_SHIFT;
+	data[1] = 0xff; /* Hash: not a classification identifier. */
+	data[2] = status;
+	data[3] = port;
+	/* Reproduce eth_type_trans(): the tagger gets data after ETH_HLEN. */
+	skb_reset_mac_header(skb);
+	skb_pull(skb, ETH_HLEN);
+	return skb;
+}
+
+static void brcm_fa_test_miss(struct kunit *test)
+{
+	struct brcm_fa_test_ctx *ctx = test->priv;
+	struct sk_buff *skb, *result;
+	u8 *start;
+
+	/* A parser failure is for the software IP stack to handle; it must
+	 * not be confused with the reserved bits in a normal switch reason.
+	 */
+	skb = brcm_fa_test_skb(BRCM_FA_OPCODE_MISS, 0xff, 3);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	start = skb->data;
+	result = brcm_fa_tag_rcv(skb, ctx->conduit);
+	KUNIT_ASSERT_NOT_NULL(test, result);
+	KUNIT_EXPECT_PTR_EQ(test, result->dev, ctx->port);
+	KUNIT_EXPECT_PTR_EQ(test, result->data, start + BRCM_TAG_LEN);
+	KUNIT_EXPECT_EQ(test, result->len, 64U - ETH_HLEN - BRCM_TAG_LEN);
+	kfree_skb(result);
+}
+
+static void brcm_fa_test_opcodes(struct kunit *test)
+{
+	struct brcm_fa_test_ctx *ctx = test->priv;
+	struct sk_buff *skb, *result;
+	int opcode;
+
+	for (opcode = 0; opcode < 8; opcode++) {
+		skb = brcm_fa_test_skb(opcode, 0, 3);
+		KUNIT_ASSERT_NOT_NULL(test, skb);
+		result = brcm_fa_tag_rcv(skb, ctx->conduit);
+		if (!opcode || opcode == BRCM_FA_OPCODE_MISS) {
+			KUNIT_ASSERT_NOT_NULL(test, result);
+			kfree_skb(result);
+		} else {
+			KUNIT_EXPECT_PTR_EQ(test, result, NULL);
+		}
+	}
+}
+
+static void brcm_fa_test_strict_normal_tag(struct kunit *test)
+{
+	struct brcm_fa_test_ctx *ctx = test->priv;
+	struct sk_buff *skb;
+
+	skb = brcm_fa_test_skb(BRCM_FA_OPCODE_MISS, 0, 3);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_EXPECT_PTR_EQ(test, brcm_tag_rcv_ll(skb, ctx->conduit, ETH_HLEN, false), NULL);
+	skb = brcm_fa_test_skb(0, BRCM_EG_RC_RSVD, 3);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_EXPECT_PTR_EQ(test, brcm_fa_tag_rcv(skb, ctx->conduit), NULL);
+	skb = brcm_fa_test_skb(BRCM_FA_OPCODE_MISS, 0, 7);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_EXPECT_PTR_EQ(test, brcm_fa_tag_rcv(skb, ctx->conduit), NULL);
+}
+
+struct brcm_fa_control_test {
+	unsigned int calls, port;
+	__be16 protocol;
+};
+
+static void brcm_fa_test_receive(void *priv, struct sk_buff *skb, unsigned int port)
+{
+	struct brcm_fa_control_test *state = priv;
+
+	state->calls++;
+	state->port = port;
+	state->protocol = eth_hdr(skb)->h_proto;
+}
+
+static void brcm_fa_test_auxiliary_control(struct kunit *test)
+{
+	struct brcm_fa_test_ctx *ctx = test->priv;
+	struct brcm_fa_control_test state = {};
+	struct brcm_fa_control control = {
+		.conduit = ctx->port,
+		.receive = brcm_fa_test_receive,
+		.priv = &state,
+	};
+	struct dsa_port *data_cpu;
+	struct sk_buff *skb, *result;
+	u8 *data;
+
+	data_cpu = kunit_kzalloc(test, sizeof(*data_cpu), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, data_cpu);
+	data_cpu->ds = &ctx->ds;
+	data_cpu->type = DSA_PORT_TYPE_CPU;
+	data_cpu->index = 8;
+	data_cpu->conduit = ctx->port;
+	list_add(&data_cpu->list, &ctx->tree.ports);
+	ctx->cpu.index = 5;
+	skb = alloc_skb(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	data = skb_put_zero(skb, 64);
+	data[0] = 2;
+	data[6] = 2;
+	data[13] = 1; /* Classification ID. */
+	data[14] = BRCM_EG_RC_PROT_TERM;
+	data[15] = 3;
+	put_unaligned_be16(ETH_P_IP, data + 16);
+	skb_reset_mac_header(skb);
+	skb_pull(skb, ETH_HLEN);
+	brcm_fa_control_register(&control);
+	result = brcm_fa_tag_rcv(skb, ctx->conduit);
+	brcm_fa_control_unregister(&control);
+	KUNIT_ASSERT_NOT_NULL(test, result);
+	KUNIT_EXPECT_PTR_EQ(test, result->dev, ctx->port);
+	KUNIT_EXPECT_EQ(test, result->len, 64U - ETH_HLEN - BRCM_TAG_LEN);
+	KUNIT_EXPECT_EQ(test, state.calls, 1U);
+	KUNIT_EXPECT_EQ(test, state.port, 3U);
+	KUNIT_EXPECT_EQ(test, state.protocol, htons(ETH_P_IP));
+	kfree_skb(result);
+}
+
+static struct kunit_case brcm_fa_test_cases[] = {
+	KUNIT_CASE(brcm_fa_test_miss),
+	KUNIT_CASE(brcm_fa_test_auxiliary_control),
+	KUNIT_CASE(brcm_fa_test_opcodes),
+	KUNIT_CASE(brcm_fa_test_strict_normal_tag),
+	{}
+};
+
+static struct kunit_suite brcm_fa_test_suite = {
+	.name = "brcm-fa-tag",
+	.init = brcm_fa_test_init,
+	.test_cases = brcm_fa_test_cases,
+};
+
+kunit_test_suite(brcm_fa_test_suite);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f565f87b3a6c..311a1910f6be 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -719,14 +719,14 @@ config NF_FLOW_TABLE
 	  To compile it as a module, choose M here.
 
 config NF_FLOW_TABLE_KUNIT_TEST
-	bool "KUnit tests for flowtable ownership" if !KUNIT_ALL_TESTS
+	bool "KUnit tests for flowtable ownership and cached paths" if !KUNIT_ALL_TESTS
 	depends on KUNIT=y && NF_FLOW_TABLE
 	default KUNIT_ALL_TESTS
 	help
-	  Test conntrack offload ownership during flowtable teardown.
-	  Require hash and asynchronous hardware deletion before re-enrolment.
-	  Verify that late notifications cannot release a replacement owner.
-	  These private tests are embedded in the flowtable core.
+	  Test flowtable ownership during asynchronous hardware deletion and
+	  repeated teardown notifications, and validate cached forwarding paths.
+	  Tests cover route expiry, neighbour changes and unsupported contexts.
+	  The tests are embedded in their parent translation units.
 
 config NF_FLOW_TABLE_PROCFS
 	bool "Supply flow table statistics in procfs"
diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
index 378a1c60b50b..5c7645239d2e 100644
--- a/net/netfilter/nf_flow_table_core_test.c
+++ b/net/netfilter/nf_flow_table_core_test.c
@@ -72,9 +72,94 @@ static void nf_flow_test_hardware_retirement(struct kunit *test)
 	rhashtable_destroy(&table.rhashtable);
 }
 
+static struct dst_entry *nf_flow_test_gc_dst_check(struct dst_entry *dst, u32 cookie)
+{
+	return dst->error ? NULL : dst;
+}
+
+static void nf_flow_test_gc_routes(struct kunit *test)
+{
+	static const struct {
+		const char *name;
+		enum flow_offload_xmit_type type;
+		bool keep_dst;
+		bool tunnel;
+		bool check;
+	} cases[] = {
+		{ "software direct", FLOW_OFFLOAD_XMIT_DIRECT, false, false, false },
+		{ "validation only", FLOW_OFFLOAD_XMIT_DIRECT, true, false, false },
+		{ "direct tunnel", FLOW_OFFLOAD_XMIT_DIRECT, false, true, true },
+		{ "HW direct tunnel", FLOW_OFFLOAD_XMIT_DIRECT, true, true, true },
+		{ "neighbour", FLOW_OFFLOAD_XMIT_NEIGH, false, false, true },
+		{ "HW neighbour", FLOW_OFFLOAD_XMIT_NEIGH, true, false, true },
+		{ "XFRM", FLOW_OFFLOAD_XMIT_XFRM, true, false, true },
+	};
+	static struct dst_ops ops = {
+		.family = AF_INET,
+		.check = nf_flow_test_gc_dst_check,
+	};
+	static struct nf_flowtable_type type;
+	unsigned int i, dir;
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		struct nf_flowtable table = { .type = &type };
+		struct nf_flow_route route = {};
+		struct flow_offload *flow;
+		struct net_device *dev;
+		struct rtable *rt;
+		struct nf_conn *ct;
+
+		flow = kunit_kzalloc(test, sizeof(*flow), GFP_KERNEL);
+		dev = kunit_kzalloc(test, sizeof(*dev), GFP_KERNEL);
+		rt = kunit_kcalloc(test, FLOW_OFFLOAD_DIR_MAX, sizeof(*rt), GFP_KERNEL);
+		ct = kunit_kzalloc(test, sizeof(*ct), GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, flow);
+		KUNIT_ASSERT_NOT_NULL(test, dev);
+		KUNIT_ASSERT_NOT_NULL(test, rt);
+		KUNIT_ASSERT_NOT_NULL(test, ct);
+		dev_net_set(dev, &init_net);
+		dev->mtu = 1500;
+		ct->tuplehash[0].tuple.dst.protonum = IPPROTO_ICMP;
+		refcount_set(&ct->ct_general.use, 2);
+		flow->ct = ct;
+		flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+		/* Avoid queuing real DELETE/STATS work from this private GC test. */
+		set_bit(NF_FLOW_HW, &flow->flags);
+		set_bit(NF_FLOW_HW_DYING, &flow->flags);
+		set_bit(IPS_OFFLOAD_BIT, &ct->status);
+		for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
+			struct dst_entry *dst = &rt[dir].dst;
+
+			dst->dev = dev;
+			dst->ops = &ops;
+			dst->obsolete = DST_OBSOLETE_FORCE_CHK;
+			dst_init_metrics(dst, dst_default_metrics.metrics, true);
+			/* One fixture reference and one transferred route reference. */
+			rcuref_init(&dst->__rcuref, 2);
+			flow->tuplehash[dir].tuple.l3proto = NFPROTO_IPV4;
+			route.tuple[dir].dst = dst;
+			route.tuple[dir].xmit_type = cases[i].type;
+			route.tuple[dir].in.num_tuns = cases[i].tunnel;
+		}
+		flow_offload_route_init(flow, &route, cases[i].keep_dst);
+		/* Simulate the expired dst returned after an IPv4 generation change. */
+		rt[0].dst.error = ENETUNREACH;
+		KUNIT_EXPECT_EQ_MSG(test,
+				    !nf_flow_dst_check(&flow->tuplehash[0].tuple), cases[i].check,
+				    "packet path: %s", cases[i].name);
+		nf_flow_offload_gc_step(&table, flow, NULL);
+		KUNIT_EXPECT_EQ_MSG(test, test_bit(NF_FLOW_TEARDOWN, &flow->flags),
+				    cases[i].check, "GC path: %s", cases[i].name);
+		flow_offload_route_release(flow);
+		for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++)
+			KUNIT_EXPECT_EQ(test, rcuref_read(&rt[dir].dst.__rcuref), 1);
+	}
+}
+
 static struct kunit_case nf_flow_lifetime_cases[] = {
 	KUNIT_CASE(nf_flow_test_teardown_repeat),
 	KUNIT_CASE(nf_flow_test_hardware_retirement),
+	KUNIT_CASE(nf_flow_test_gc_routes),
 	{}
 };
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 1f3adf70f598..272e96fa466b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1382,3 +1382,7 @@ void nf_flow_table_offload_exit(void)
 	destroy_workqueue(nf_flow_offload_del_wq);
 	destroy_workqueue(nf_flow_offload_stats_wq);
 }
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE_KUNIT_TEST)
+#include "nf_flow_table_offload_test.c"
+#endif
diff --git a/net/netfilter/nf_flow_table_offload_test.c b/net/netfilter/nf_flow_table_offload_test.c
new file mode 100644
index 000000000000..7e1764a8298a
--- /dev/null
+++ b/net/netfilter/nf_flow_table_offload_test.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+
+struct nf_flow_test_path {
+	struct dst_entry dst;
+	struct neighbour neigh;
+};
+
+struct nf_flow_test_ctx {
+	struct flow_offload flow;
+	struct nf_flow_test_path paths[FLOW_OFFLOAD_DIR_MAX];
+	struct net_device *dev;
+};
+
+static struct dst_entry *nf_flow_test_dst_check(struct dst_entry *dst, u32 cookie)
+{
+	return !dst->error && cookie == 42 ? dst : NULL;
+}
+
+static struct neighbour *nf_flow_test_neigh(const struct dst_entry *dst,
+					    struct sk_buff *skb, const void *address)
+{
+	struct nf_flow_test_path *path = container_of(dst, struct nf_flow_test_path, dst);
+
+	return neigh_clone(&path->neigh);
+}
+
+static int nf_flow_test_init(struct kunit *test)
+{
+	static struct dst_ops ops = {
+		.family = AF_INET,
+		.check = nf_flow_test_dst_check,
+		.neigh_lookup = nf_flow_test_neigh,
+	};
+	const u8 mac[ETH_ALEN] = { 2, 0, 0, 0, 0, 1 };
+	struct nf_flow_test_ctx *ctx;
+	unsigned int dir;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->dev = kunit_kzalloc(test, sizeof(*ctx->dev), GFP_KERNEL);
+	if (!ctx->dev)
+		return -ENOMEM;
+	ctx->dev->ifindex = 10;
+	ctx->dev->addr_len = ETH_ALEN;
+	for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
+		struct flow_offload_tuple *tuple = &ctx->flow.tuplehash[dir].tuple;
+		struct nf_flow_test_path *path = &ctx->paths[dir];
+
+		path->dst.dev = ctx->dev;
+		path->dst.ops = &ops;
+		path->dst.obsolete = DST_OBSOLETE_FORCE_CHK;
+		path->neigh.dev = ctx->dev;
+		path->neigh.nud_state = NUD_REACHABLE;
+		refcount_set(&path->neigh.refcnt, 1);
+		seqlock_init(&path->neigh.ha_lock);
+		ether_addr_copy(path->neigh.ha, mac);
+		tuple->dir = dir;
+		tuple->dst_cache = &path->dst;
+		tuple->dst_cookie = 42;
+		tuple->dst_validation_only = true;
+		tuple->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+		tuple->out.ifidx = ctx->dev->ifindex;
+		ether_addr_copy(tuple->out.h_dest, mac);
+	}
+	test->priv = ctx;
+	return 0;
+}
+
+static void nf_flow_test_cached_path(struct kunit *test)
+{
+	struct nf_flow_test_ctx *ctx = test->priv;
+	unsigned long cookie = (unsigned long)&ctx->flow.tuplehash[0].tuple;
+
+	/* Validation uses the selected dst and its cookie, without a new FIB
+	 * lookup that could omit mark/DSCP/oif from the owner's routing context.
+	 */
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), 0);
+	ctx->paths[1].dst.error = ENETUNREACH;
+	/* On-demand validation still checks a driver-only reference. */
+	KUNIT_EXPECT_TRUE(test, nf_flow_dst_check(&ctx->flow.tuplehash[1].tuple));
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -ESTALE);
+	ctx->paths[1].dst.error = 0;
+	ctx->flow.tuplehash[1].tuple.dst_cookie = 41;
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -ESTALE);
+	KUNIT_EXPECT_EQ(test, refcount_read(&ctx->paths[0].neigh.refcnt), 1);
+}
+
+static void nf_flow_test_neighbour_change(struct kunit *test)
+{
+	struct nf_flow_test_ctx *ctx = test->priv;
+	unsigned long cookie = (unsigned long)&ctx->flow.tuplehash[1].tuple;
+
+	ctx->paths[0].neigh.ha[5]++;
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -ESTALE);
+	ctx->paths[0].neigh.ha[5]--;
+	ctx->paths[0].neigh.nud_state = NUD_FAILED;
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -ESTALE);
+	KUNIT_EXPECT_EQ(test, refcount_read(&ctx->paths[0].neigh.refcnt), 1);
+}
+
+static void nf_flow_test_unsupported_context(struct kunit *test)
+{
+	struct nf_flow_test_ctx *ctx = test->priv;
+	unsigned long cookie = (unsigned long)&ctx->flow.tuplehash[0].tuple;
+	struct dst_entry *dst = ctx->flow.tuplehash[0].tuple.dst_cache;
+
+	ctx->flow.tuplehash[0].tuple.dst_cache = NULL;
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -EOPNOTSUPP);
+	ctx->flow.tuplehash[0].tuple.dst_cache = dst;
+	ctx->flow.tuplehash[0].tuple.out.ifidx++;
+	KUNIT_EXPECT_EQ(test, nf_flow_offload_validate(cookie), -EOPNOTSUPP);
+}
+
+static struct kunit_case nf_flow_path_cases[] = {
+	KUNIT_CASE(nf_flow_test_cached_path),
+	KUNIT_CASE(nf_flow_test_neighbour_change),
+	KUNIT_CASE(nf_flow_test_unsupported_context),
+	{}
+};
+
+static struct kunit_suite nf_flow_path_suite = {
+	.name = "nf-flow-path",
+	.init = nf_flow_test_init,
+	.test_cases = nf_flow_path_cases,
+};
+
+kunit_test_suite(nf_flow_path_suite);
-- 
2.53.0

