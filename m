Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867999;
	b=lnvoVWJCX5D81Kflj1eWwYqekI+9oOxwGlSeSs07r9MRHx4wGeGqKsjqQvF10n27SuCo
	 K3VA1Gi1alQiflUtJ3MXL8haWDzb0vKZ3PPGCG3q5qZasawCBwvCW4Lh6NrjG/S4fD8yX
	 AuRTqw+m8PHNRC6neWxH+JLOCCr9ax0twcSaYLdlimtZpyT/8Cw8fkujS61pZ+SuRDICT
	 ReGgVfGsoMJZ5YaVdDvXv4Rhg+lXbt4GhLbf4tCEclw1oKCgJMmaByP/GghNYZAoPTwfc
	 tiveJyoq3sbBFm5x1/zl1urhSuxmYZydP8qflhzT7gosN/jl/xtCLHVRhEJF4pnquDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867999;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=V3wZFfi8ysQ6Ok1PCACbsrquVcIk7f7cYNcZ/2x7GgA=;
	b=HQmxCAWfLKZnKR0Z/3p53CcFMS2fkOAUtcvZ01KsnhVGjAeHokL2rDMUlkCSKDR74JJ2
	 8Ga7ELRYZ7aj0L92rZf+qNx63aP90Rd6sF3NiMhn7XE9iCREr816UhG+ccBBnbpw4yCnU
	 jlmzTNwICq3YuaqU8bunLLcg9pUQlOMGYSnkNF0HrY7OoHdPpC1X1d3+cgUoD2MQm0+yd
	 Wbo+K1bHdWHwERyrbjo6vUUBxN1sPwitHI3bBv8AbmOWdaZdPsOJ71R9aXk3IoNoPrI79
	 GZ5px149SSI9vIpbe5jwCOp69moJGmpGGhIWaPVTBj4qOi1GNWIUmp7He8rxF0UuwuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="ZY/ImITZ";
	arc=none smtp.remote-ip=209.85.217.99
Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863B560A2608
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 863B560A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZY/ImITZ
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-7cc2bb73cd9so1106691137.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867997; x=1795472797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V3wZFfi8ysQ6Ok1PCACbsrquVcIk7f7cYNcZ/2x7GgA=;
        b=uyqJMOfRGtuERZRvKzwACI36sJJHbfcieIpaYnHYe8Cgj4o0KSN8UXJd61ikwpS3nT
         QtNHwq5Qg0PDtv4nFPuec+AG0MLzY7LAEqfHA/1Caen1/rVKghSyxX4oVsNLfWdpKqrH
         x2tppUEyAQNWvHDJ9p8gQq6QV+cGG07T1uzPXAimx5NVmE+E0iOHwwDYi1A88Ds7uqMY
         SrFiJEl944wv0MGMZnXzkv043GMx4jHQSmK0qegM+el7pdV0U6sXnw9I0JcO4PDdttMS
         Q8NmQ8Gi8a8ILXa0Yooi6ByUoYTDiot3P7niDKpQqH/xSrg/khKv9d2cc4cROCS1s9yO
         t19g==
X-Forwarded-Encrypted: i=1; AL+hErG1HD1NFluGBSKr782/SKsLCtjco7P5SSzTCd/gctRrAayNdBj1FAKy2ShTjNzsfcM/Jkb4TM2gb6LSMrpQA/0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/0f1WNu6SRyB0+CZALcX4Rncy9+kncWg6cMbbcG/Ojyg/vc2dQ
	xvGJBcudvU5TJO0IH8z7Kt1+eGYd1kidq5HCaSU+/fFr9UU1A0TEfp85h4SVqgQakBAgrwBqB7E
	KsY0XnlLeE4T+sSIsJTBMAaAn1fvDYnAtQ29oK9BAyXF/GHlincHpByNLm4uYPCcmA75nG6Z0Uc
	dVyoRrrgdTLI3N4O634ysDt07OMtn3PTDxivq4pKfu7eWlU/p4vXz2oMoTT0SAy+YEfsMgVj/wV
	u06Ae1P6VfQNzn23R/rYhSBoLPz
X-Gm-Gg: AYBFou3g2wh42ZHI+CUquEfJ5PQJFBKI8vhP90LAUBQEx/Y4nkvBjhyOsCbvhrAK5nb
	pUJUtRiTvHSmfQgZTC1qtyL1OQ4FO5V2CCtJPz2JL3yRAh6XXS9HgpFqK/+abUmDPB9P2Gn4Gfr
	7nPVoq4pEv0x6AYOlnxhOuOuzzN46fTf72niU3t4gSAI/qqUrNmMFcUqp+7x1vAKEUBvdhyJakU
	VgDLMr/e+scU0M4PYNlJh+Y0Cs4M6Z0dHUHA8t0pxnn01u1HfL8tPxJOnrfQyxxXfqO82a30D1w
	FQOzMhoMb+bjuVlyRv5p8LocN9ou8byS7CY97+3P7tEKW+l8VKXIxnpT0edcWcbnBh8WkC8+Utt
	iPRHqcWFrOUlJiBHqfV+JHTWgbstqS5486r4sjvxS4abPi/yAbu8S6QDcISUlxwMwiC4REbU+34
	hHgc9WgwyMSyaB7T913LmlbUY4V7fX6vGLp56z3pjW
X-Received: by 2002:a05:6102:370d:b0:7d2:d159:f425 with SMTP id ada2fe7eead31-7d64d75ce42mr3691585137.19.1794867997196;
        Mon, 16 Nov 2026 14:26:37 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-99e3387e34asm104191241.11.2026.11.16.14.26.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:37 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so6094535eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794867996; x=1795472796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V3wZFfi8ysQ6Ok1PCACbsrquVcIk7f7cYNcZ/2x7GgA=;
        b=ZY/ImITZLgF2sGx4ovrhGDf/MOr6Uvss1KTwsJPGVzUpxFMX3g/JYeVHNvFTTZBNiY
         yKP5oy3zeqwfeZuEdbmWq1LVlPUOi5g12MMTx5eL123yMEXk9iecHou964tI5c/v1IBf
         1KPoEtH8EE6E9AfCe5yq/pTXfD7DLMNznYjnI=
X-Forwarded-Encrypted: i=1; AL+hErHS43IAD/UaxQUJ0KFDx/OgbcY2UR0SKNOEGTlYGiFdUkQRZc2qVrfywyt23X24U8d8VLtf7S7zxiqUYmU0MAc=@vger.kernel.org
X-Received: by 2002:a05:7300:d0a2:b0:36e:ff7e:e57f with SMTP id 5a478bee46e88-3796628f98fmr11580064eec.19.1794867995312;
        Mon, 16 Nov 2026 14:26:35 -0800 (PST)
X-Received: by 2002:a05:7300:d0a2:b0:36e:ff7e:e57f with SMTP id 5a478bee46e88-3796628f98fmr11580026eec.19.1794867994411;
        Mon, 16 Nov 2026 14:26:34 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:33 -0800 (PST)
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
Subject: [PATCH net-next 5/9] net: dsa: add Broadcom FA metadata and IPv4 exception paths
Date: Mon, 16 Nov 2026 14:25:15 -0800
Message-ID: <20261116222519.1416501-6-florian.fainelli@broadcom.com>
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

Add a brcm-fa tagger for the prepended Northstar miss descriptor, with
hash, bucket and parser status fields distinct from ordinary switch
tags. Select it only for an explicitly connected accelerator on
GMAC2/port 8.

Original FA ignores standalone switch exceptions and its key lacks input
port, TTL, packet length and TCP flags. Reserve B53 CFP rules to
redirect SYN/FIN/RST, TTL 0/1 and lengths above 1500 through port
5/GMAC0, outside FA. Per-port router-MAC allow rules and a default IPv4
trap prevent a live tuple from bypassing Linux ingress policy on another
switch port. Nine masked length prefixes cover 1501 through 65535.
Preserve VLAN, EAP and STP filtering, and keep ordinary data flooding
off the auxiliary CPU.

Update MAC guards through a netdevice notifier after DSA registration.
Coordinate guard and conduit readiness with an RCU-protected backend
registry. Disable admission and retire entries before removing any
exception path. Keep incomplete or failed guards disabled across bridge
join and leave, using the same readiness checks as conduit changes.
Decode embedded auxiliary tags before delivering those packets to Linux;
retain strict validation of ordinary Broadcom tags.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/dsa/b53/Kconfig      |   1 +
 drivers/net/dsa/b53/b53_common.c | 423 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/b53/b53_priv.h   |   6 +
 drivers/net/dsa/b53/b53_regs.h   |  39 +++
 include/linux/dsa/brcm.h         |  19 ++
 include/net/dsa.h                |   2 +
 net/dsa/Kconfig                  |   9 +
 net/dsa/tag_brcm.c               | 116 ++++++++-
 8 files changed, 603 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index 915008e8eff5..8e2a8c20bc4a 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -7,6 +7,7 @@ menuconfig B53
 	select NET_DSA_TAG_BRCM_LEGACY
 	select NET_DSA_TAG_BRCM_LEGACY_FCS
 	select NET_DSA_TAG_BRCM_PREPEND
+	select NET_DSA_TAG_BRCM_FA
 	help
 	  This driver adds support for Broadcom managed switch chips. It supports
 	  BCM5325E, BCM5365, BCM539x, BCM53115 and BCM53125 as well as BCM63XX
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index b7aff5e238e8..3e8c9679836d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -17,19 +17,25 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
+#include <linux/dsa/brcm.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
+#include <linux/in.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/math.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_data/b53.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
+#include <linux/unaligned.h>
 #include <net/dsa.h>
 
 #include "b53_regs.h"
@@ -667,9 +673,10 @@ static void b53_eee_enable_set(struct dsa_switch *ds, int port, bool enable)
 int b53_setup_port(struct dsa_switch *ds, int port)
 {
 	struct b53_device *dev = ds->priv;
+	bool auxiliary = dev->fa_cfp_enabled && port == 5;
 
-	b53_port_set_ucast_flood(dev, port, true);
-	b53_port_set_mcast_flood(dev, port, true);
+	b53_port_set_ucast_flood(dev, port, !auxiliary);
+	b53_port_set_mcast_flood(dev, port, !auxiliary);
 	b53_port_set_learning(dev, port, false);
 	b53_port_set_isolated(dev, port, false);
 
@@ -678,7 +685,8 @@ int b53_setup_port(struct dsa_switch *ds, int port)
 	 * dropping frames because it isn't allowed to forward there.
 	 */
 	if (dsa_is_user_port(ds, port))
-		b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
+		b53_set_eap_mode(dev, port, dev->fa_cfp_enabled ? EAP_MODE_BASIC :
+			 EAP_MODE_SIMPLIFIED);
 
 	if (is5325(dev) &&
 	    in_range(port, 1, 4)) {
@@ -728,6 +736,8 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 	pvlan &= ~0x1ff;
 	pvlan |= BIT(port);
 	pvlan |= dev->ports[port].vlan_ctl_mask;
+	if (dev->fa_cfp_enabled && (dev->fa_cfp_ports & BIT(port)))
+		pvlan |= BIT(5);
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 
 	b53_imp_vlan_setup(ds, cpu_port);
@@ -1326,6 +1336,315 @@ int b53_setup_devlink_resources(struct dsa_switch *ds)
 }
 EXPORT_SYMBOL(b53_setup_devlink_resources);
 
+static int b53_fa_cfp_wait(struct b53_device *dev, u32 mask)
+{
+	u32 val;
+	int ret, err;
+
+	ret = read_poll_timeout(b53_read32, err, err || !(val & mask),
+				10, 10000, false, dev, B53_CFP_TCAM_PAGE,
+				B53_CFP_ACC, &val);
+	return ret ?: err;
+}
+
+static int b53_fa_cfp_write(struct b53_device *dev, unsigned int index, u32 ram)
+{
+	int err;
+
+	err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACC,
+			  CFP_ACC_INDEX(index) | ram | CFP_ACC_WRITE | CFP_ACC_START);
+	return err ?: b53_fa_cfp_wait(dev, CFP_ACC_START);
+}
+
+#define B53_FA_ALLOW_BASE 16
+#define B53_FA_DEFAULT_RULE 24
+
+static void b53_fa_udf(u32 data[8], u32 mask[8], unsigned int udf,
+		       u16 value, u16 bits)
+{
+	unsigned int bit = CFP_TCAM_UDF_OFFSET + 16 * udf;
+	unsigned int word = bit / 32;
+	unsigned int shift = bit % 32;
+
+	data[word] |= (u32)value << shift;
+	mask[word] |= (u32)bits << shift;
+	if (shift > 16) {
+		data[word + 1] |= value >> (32 - shift);
+		mask[word + 1] |= bits >> (32 - shift);
+	}
+	data[5] |= CFP_TCAM5_UDF_VALID(udf);
+	mask[5] |= CFP_TCAM5_UDF_VALID(udf);
+}
+
+static int b53_fa_rule(struct b53_device *dev, unsigned int index,
+		       const u32 data[8], const u32 mask[8], bool trap)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < 8; i++) {
+		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_DATA(i), data[i]);
+		if (!err)
+			err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_MASK(i), mask[i]);
+		if (err)
+			return err;
+	}
+	err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(0),
+			  trap ? CFP_ACT0_FWD_MAP_REPLACE | CFP_ACT0_DST_PORT5 |
+				CFP_ACT0_REASON_TERMINATION : 0);
+	if (!err)
+		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(1),
+				  trap ? CFP_ACT1_CLASS_ID(1) | CFP_ACT1_FWD_MAP_REPLACE |
+				  CFP_ACT1_DST_PORT5 : 0);
+	if (!err)
+		err = b53_fa_cfp_write(dev, index, CFP_ACC_ACTION);
+	if (!err)
+		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER, 0);
+	if (!err)
+		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER + 4, 0);
+	if (!err)
+		err = b53_fa_cfp_write(dev, index, CFP_ACC_METER);
+	return err ?: b53_fa_cfp_write(dev, index, CFP_ACC_TCAM);
+}
+
+static const u16 b53_fa_lengths[][2] = {
+	{ 1501, 0xffff }, { 1502, 0xfffe }, { 1504, 0xffe0 },
+	{ 1536, 0xfe00 }, { 2048, 0xf800 }, { 4096, 0xf000 },
+	{ 8192, 0xe000 }, { 16384, 0xc000 }, { 32768, 0x8000 },
+};
+
+static int b53_fa_guards(struct b53_device *dev)
+{
+	u32 data[8] = {}, mask[8] = {};
+	unsigned int i;
+	int err;
+
+	/* UDF A1: IPv4 TTL/protocol; A2: IPv4 total length. */
+	err = b53_write8(dev, B53_CFP_PAGE, B53_CFP_UDF1_A0 + 1,
+			 CFP_UDF_BASE_END_L2 | CFP_UDF_OFFSET(4));
+	if (!err)
+		err = b53_write8(dev, B53_CFP_PAGE, B53_CFP_UDF1_A0 + 2,
+				 CFP_UDF_BASE_END_L2 | CFP_UDF_OFFSET(1));
+	for (i = 0; !err && i < 3; i++)
+		err = b53_write8(dev, B53_CFP_PAGE, B53_CFP_UDF1_A0 + 3 + i, i);
+	if (err)
+		return err;
+	data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1;
+	mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK;
+	mask[6] = CFP_TCAM6_L3_FRAMING; /* IPv4, including options and fragments. */
+	b53_fa_udf(data, mask, 1, 0, 0xfe00); /* TTL 0 or 1. */
+	err = b53_fa_rule(dev, 3, data, mask, true);
+	for (i = 0; !err && i < ARRAY_SIZE(b53_fa_lengths); i++) {
+		memset(data, 0, sizeof(data));
+		memset(mask, 0, sizeof(mask));
+		data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1;
+		mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK;
+		mask[6] = CFP_TCAM6_L3_FRAMING;
+		b53_fa_udf(data, mask, 2, b53_fa_lengths[i][0], b53_fa_lengths[i][1]);
+		err = b53_fa_rule(dev, 4 + i, data, mask, true);
+	}
+	if (err)
+		return err;
+	/* Only a port's own router MAC may take the inline data path. These
+	 * allow rules are populated after DSA has registered its user devices.
+	 */
+	memset(data, 0, sizeof(data));
+	memset(mask, 0, sizeof(mask));
+	data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1;
+	mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK;
+	mask[6] = CFP_TCAM6_L3_FRAMING;
+	return b53_fa_rule(dev, B53_FA_DEFAULT_RULE, data, mask, true);
+}
+
+/* Original FA ignores switch exceptions on its inline port. Redirect IPv4
+ * exceptions through GMAC0/IMP5, outside FA, while GMAC2/IMP8 carries data.
+ * Reserve classifier rules only when the board describes both CPU paths.
+ */
+static int b53_fa_setup(struct b53_device *dev)
+{
+	struct dsa_port *dp;
+	unsigned int rule, i;
+	u32 data[8], mask[8];
+	int err;
+
+	if (!is5301x(dev) || dev->tag_protocol != DSA_TAG_PROTO_BRCM_FA ||
+	    !dsa_is_cpu_port(dev->ds, 5) || !dsa_is_cpu_port(dev->ds, 8))
+		return 0;
+
+	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL, 0);
+	if (err)
+		return err;
+	err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACC, CFP_ACC_RESET);
+	if (!err)
+		err = b53_fa_cfp_wait(dev, CFP_ACC_RESET);
+	if (err)
+		return err;
+	/* Slice 1 UDF A0 extracts TCP bytes 12..13, relative to the parsed end of L3.
+	 * This also works with IP options. Match the individual
+	 * FIN/SYN/RST bits, never payload bytes in UDP packets. Slice 0
+	 * with a nonzero class ID would request a chained search instead.
+	 */
+	err = b53_write8(dev, B53_CFP_PAGE, B53_CFP_UDF1_A0,
+			 CFP_UDF_BASE_END_L3 | CFP_UDF_OFFSET(6));
+	if (err)
+		return err;
+	for (rule = 0; rule < 3; rule++) {
+		memset(data, 0, sizeof(data));
+		memset(mask, 0, sizeof(mask));
+		data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1 | CFP_TCAM0_UDF0_FLAG(rule);
+		/* Slice 1; FIN, SYN or RST. */
+		mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK | CFP_TCAM0_UDF0_FLAG(rule);
+		data[5] = CFP_TCAM5_UDF_VALID(0); /* UDF A0 valid. */
+		mask[5] = CFP_TCAM5_UDF_VALID(0);
+		data[6] = FIELD_PREP(CFP_TCAM6_IP_PROTOCOL, IPPROTO_TCP);
+		mask[6] = CFP_TCAM6_L3_FRAMING | CFP_TCAM6_IP_PROTOCOL | CFP_TCAM6_IP_FRAGMENT;
+		for (i = 0; i < ARRAY_SIZE(data); i++) {
+			err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_DATA(i), data[i]);
+			if (!err)
+				err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_MASK(i), mask[i]);
+			if (err)
+				return err;
+		}
+		/* Both meter outcomes redirect to IMP5, with class 1 and a
+		 * termination reason. Preserve VLAN, EAP and STP filtering.
+		 */
+		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(0),
+				  CFP_ACT0_FWD_MAP_REPLACE | CFP_ACT0_DST_PORT5 |
+				CFP_ACT0_REASON_TERMINATION);
+		if (!err)
+			err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(1),
+					  CFP_ACT1_CLASS_ID(1) | CFP_ACT1_FWD_MAP_REPLACE |
+					  CFP_ACT1_DST_PORT5);
+		if (!err)
+			err = b53_fa_cfp_write(dev, rule, CFP_ACC_ACTION);
+		if (!err)
+			err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER, 0);
+		if (!err)
+			err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER + 4, 0);
+		if (!err)
+			err = b53_fa_cfp_write(dev, rule, CFP_ACC_METER);
+		if (!err)
+			err = b53_fa_cfp_write(dev, rule, CFP_ACC_TCAM);
+		if (err)
+			return err;
+	}
+	err = b53_fa_guards(dev);
+	if (err)
+		return err;
+	/* Ordinary flooding must reach only the data CPU, not both MACs. */
+	b53_port_set_ucast_flood(dev, 5, false);
+	b53_port_set_mcast_flood(dev, 5, false);
+	err = b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(5), PORT_CTRL_RX_UCST_EN);
+	if (err)
+		return err;
+	dev->fa_cfp_ports = 0;
+	dsa_switch_for_each_user_port(dp, dev->ds)
+		dev->fa_cfp_ports |= BIT(dp->index);
+	/* The conduit state callback enables these rules after GMAC0 is up. */
+	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL, 0);
+	if (!err)
+		dev->fa_cfp_enabled = true;
+	return err;
+}
+
+static bool b53_fa_ready(struct b53_device *dev, bool operational)
+{
+	return operational && dev->fa_guards_ready && !dev->fa_guards_failed;
+}
+
+static int b53_fa_port(struct b53_device *dev, int port, bool standalone)
+{
+	struct dsa_port *control = dsa_to_port(dev->ds, 5);
+	bool ready;
+	u16 ports;
+	int err;
+
+	if (!dev->fa_cfp_enabled)
+		return 0;
+	ports = dev->fa_cfp_ports & ~BIT(port);
+	if (standalone)
+		ports |= BIT(port);
+	ready = b53_fa_ready(dev, dsa_port_conduit_is_operational(control));
+	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL,
+			  ready ? ports : 0);
+	if (!err)
+		dev->fa_cfp_ports = ports;
+	return err;
+}
+
+static void b53_fa_conduit_state_change(struct dsa_switch *ds,
+					const struct net_device *conduit, bool operational)
+{
+	struct b53_device *dev = ds->priv;
+	struct dsa_port *control, *data;
+	bool ready;
+	int err;
+
+	if (!dev->fa_cfp_enabled)
+		return;
+	control = dsa_to_port(ds, 5);
+	data = dsa_to_port(ds, 8);
+	if (conduit != control->conduit)
+		return;
+	ready = b53_fa_ready(dev, operational);
+	/* Retire offloads before removing any of the physical exception paths. */
+	brcm_fa_control_set_ready(data->conduit, false);
+	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL, ready ? dev->fa_cfp_ports : 0);
+	if (err) {
+		dev_err(ds->dev, "failed to update FA exception path: %d\n", err);
+		return;
+	}
+	if (ready)
+		brcm_fa_control_set_ready(data->conduit, true);
+}
+
+static int b53_fa_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
+{
+	struct b53_device *dev = container_of(nb, struct b53_device, fa_netdev_nb);
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct dsa_port *dp, *control, *data_cpu;
+	u32 data[8] = {}, mask[8] = {};
+	unsigned int i;
+	int err;
+
+	if (dev->fa_stopping || !dsa_user_dev_check(netdev) ||
+	    (event != NETDEV_REGISTER && event != NETDEV_UP &&
+	     event != NETDEV_PRE_CHANGEADDR && event != NETDEV_CHANGEADDR))
+		return NOTIFY_DONE;
+	dp = dsa_port_from_netdev(netdev);
+	if (dp->ds != dev->ds || dp->index >= 8)
+		return NOTIFY_DONE;
+	control = dsa_to_port(dev->ds, 5);
+	data_cpu = dsa_to_port(dev->ds, 8);
+	brcm_fa_control_set_ready(data_cpu->conduit, false);
+	if (event != NETDEV_PRE_CHANGEADDR) {
+		data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1;
+		mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK;
+		mask[6] = CFP_TCAM6_L3_FRAMING;
+		data[7] = BIT(dp->index);
+		mask[7] = CFP_TCAM7_SOURCE_PORTS;
+		for (i = 0; i < 3; i++)
+			b53_fa_udf(data, mask, 3 + i, get_unaligned_be16(netdev->dev_addr + 2 * i),
+				   0xffff);
+	}
+	err = b53_fa_rule(dev, B53_FA_ALLOW_BASE + dp->index, data, mask, false);
+	if (err) {
+		dev->fa_guards_failed = true;
+		dev_err(dev->dev, "failed to update FA ingress guard: %d\n", err);
+	} else if (event != NETDEV_PRE_CHANGEADDR) {
+		b53_fa_conduit_state_change(dev->ds, control->conduit,
+					    dsa_port_conduit_is_operational(control));
+	}
+	return NOTIFY_DONE;
+}
+
+static void b53_fa_unregister_notifier(void *ptr)
+{
+	struct b53_device *dev = ptr;
+
+	unregister_netdevice_notifier(&dev->fa_netdev_nb);
+}
+
 static int b53_setup(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -1391,11 +1710,20 @@ static int b53_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = b53_fa_setup(dev);
+	if (ret)
+		return ret;
+
 	return b53_setup_devlink_resources(ds);
 }
 
 static void b53_teardown(struct dsa_switch *ds)
 {
+	struct b53_device *dev = ds->priv;
+
+	dev->fa_stopping = true;
+	if (dev->fa_cfp_enabled)
+		b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL, 0);
 	dsa_devlink_resources_unregister(ds);
 }
 
@@ -2332,6 +2660,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	u16 pvlan, reg, pvid;
 	unsigned int i;
+	int err;
 
 	/* On 7278, port 7 which connects to the ASP should only receive
 	 * traffic from matching CFP rules.
@@ -2339,6 +2668,10 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7)
 		return -EINVAL;
 
+	err = b53_fa_port(dev, port, false);
+	if (err)
+		return err;
+
 	pvid = b53_default_pvid(dev);
 	vl = &dev->vlans[pvid];
 
@@ -2417,8 +2750,11 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 	}
 
 	/* Enable redirection of unknown SA to the CPU port */
-	b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
+	b53_set_eap_mode(dev, port, dev->fa_cfp_enabled ? EAP_MODE_BASIC :
+			 EAP_MODE_SIMPLIFIED);
 
+	if (dev->fa_cfp_enabled)
+		pvlan |= BIT(5);
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
@@ -2439,6 +2775,10 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 		vl->members |= BIT(port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	if (b53_fa_port(dev, port, true)) {
+		dev_err(ds->dev, "failed to restore FA classification on port %d\n", port);
+		b53_disable_port(ds, port);
+	}
 }
 EXPORT_SYMBOL(b53_br_leave);
 
@@ -2552,6 +2892,7 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
 	switch (tag_protocol) {
 	case DSA_TAG_PROTO_BRCM:
 	case DSA_TAG_PROTO_BRCM_PREPEND:
+	case DSA_TAG_PROTO_BRCM_FA:
 		dev_warn(ds->dev,
 			 "Port %d is stacked to Broadcom tag switch\n", port);
 		ret = false;
@@ -2564,6 +2905,46 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static bool b53_uses_fa_tag(struct dsa_switch *ds, int port)
+{
+	struct device_node *ports, *node, *ethernet = NULL, *fa = NULL;
+	struct b53_device *dev = ds->priv;
+	bool enabled = false;
+	u32 index;
+
+	if (port != B53_CPU_PORT)
+		return false;
+	/* CPU5 may be parsed before CPU8 has a dsa_port firmware node. */
+	ports = of_get_child_by_name(ds->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(ds->dev->of_node, "ethernet-ports");
+	for_each_available_child_of_node(ports, node) {
+		if (of_property_read_u32(node, "reg", &index) || index != B53_CPU_PORT)
+			continue;
+		ethernet = of_parse_phandle(node, "ethernet", 0);
+		fa = of_parse_phandle(ethernet, "brcm,flow-accelerator", 0);
+		enabled = IS_ENABLED(CONFIG_BCM_NS_FA) && of_device_is_available(fa) &&
+			  (dev->chip_id == BCM53011_DEVICE_ID ||
+			   dev->chip_id == BCM53012_DEVICE_ID ||
+			   (is5301x(dev) && of_device_is_compatible(fa, "brcm,bcm4708-fa")));
+		of_node_put(node);
+		break;
+	}
+	of_node_put(ports);
+	of_node_put(fa);
+	of_node_put(ethernet);
+	return enabled;
+}
+
+static struct dsa_port *b53_preferred_cpu_port(struct dsa_switch *ds)
+{
+	struct b53_device *dev = ds->priv;
+
+	if (is5301x(dev) && dsa_is_cpu_port(ds, B53_CPU_PORT) && b53_uses_fa_tag(ds, B53_CPU_PORT))
+		return dsa_to_port(ds, B53_CPU_PORT);
+	return NULL;
+}
+
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 					   enum dsa_tag_protocol mprot)
 {
@@ -2583,6 +2964,11 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 		goto out;
 	}
 
+	if (b53_uses_fa_tag(ds, B53_CPU_PORT)) {
+		dev->tag_protocol = DSA_TAG_PROTO_BRCM_FA;
+		goto out;
+	}
+
 	/* Broadcom BCM58xx chips have a flow accelerator on Port 8
 	 * which requires us to use the prepended Broadcom tag type
 	 */
@@ -2763,6 +3149,8 @@ static const struct phylink_mac_ops b53_phylink_mac_ops = {
 
 static const struct dsa_switch_ops b53_switch_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
+	.preferred_default_local_cpu_port = b53_preferred_cpu_port,
+	.conduit_state_change = b53_fa_conduit_state_change,
 	.setup			= b53_setup,
 	.teardown		= b53_teardown,
 	.get_strings		= b53_get_strings,
@@ -3385,7 +3773,32 @@ int b53_switch_register(struct b53_device *dev)
 	dev_info(dev->dev, "found switch: %s, rev %i\n",
 		 dev->name, dev->core_rev);
 
-	return dsa_register_switch(dev->ds);
+	ret = dsa_register_switch(dev->ds);
+	if (ret || !dev->fa_cfp_enabled)
+		return ret;
+	/* Registration replays existing user devices, after their MACs and
+	 * DSA private data are initialized. Keep lookup gated until it finishes.
+	 */
+	dev->fa_netdev_nb.notifier_call = b53_fa_netdev_event;
+	ret = register_netdevice_notifier(&dev->fa_netdev_nb);
+	if (ret)
+		goto unregister_switch;
+	ret = devm_add_action_or_reset(dev->dev, b53_fa_unregister_notifier, dev);
+	if (ret)
+		goto unregister_switch;
+	dev->fa_guards_ready = true;
+	if (!dev->fa_guards_failed) {
+		struct dsa_port *control = dsa_to_port(dev->ds, 5);
+
+		rtnl_lock();
+		b53_fa_conduit_state_change(dev->ds, control->conduit,
+					    dsa_port_conduit_is_operational(control));
+		rtnl_unlock();
+	}
+	return 0;
+unregister_switch:
+	dsa_unregister_switch(dev->ds);
+	return ret;
 }
 EXPORT_SYMBOL(b53_switch_register);
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index c4d2a41c714f..ed663067a865 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -153,6 +153,12 @@ struct b53_device {
 	u8 num_arl_bins;
 	u16 num_arl_buckets;
 	enum dsa_tag_protocol tag_protocol;
+	u16 fa_cfp_ports;
+	bool fa_cfp_enabled;
+	bool fa_guards_ready;
+	bool fa_guards_failed;
+	bool fa_stopping;
+	struct notifier_block fa_netdev_nb;
 
 	/* used ports mask */
 	u16 enabled_ports;
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index cfdb5ed38326..4ca7ea64efc6 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -614,4 +614,43 @@
 /* CFP Control Register with ports map (8 bit) */
 #define B53_CFP_CTRL			0x00
 
+/* Northstar CFP indirect table port. */
+#define B53_CFP_TCAM_PAGE		0xa0
+#define B53_CFP_ACC			0x00
+#define  CFP_ACC_START			BIT(0)
+#define  CFP_ACC_WRITE			(2 << 1)
+#define  CFP_ACC_TCAM			BIT(10)
+#define  CFP_ACC_ACTION			(2 << 10)
+#define  CFP_ACC_METER			(4 << 10)
+#define  CFP_ACC_RESET			BIT(15)
+#define  CFP_ACC_INDEX(n)		((n) << 16)
+#define B53_CFP_DATA(n)			(0x10 + (n) * 4)
+#define B53_CFP_MASK(n)			(0x30 + (n) * 4)
+#define B53_CFP_ACTION(n)		(0x50 + (n) * 4)
+#define B53_CFP_METER			0x60
+#define B53_CFP_UDF1_A0			0x20
+#define  CFP_UDF_BASE_END_L2		(2 << 5)
+#define  CFP_UDF_BASE_END_L3		(3 << 5)
+#define  CFP_UDF_OFFSET(n)		(n)
+
+/* Slice 1 IPv4 key fields, indexed by DATA/MASK word. */
+#define CFP_TCAM0_VALID			GENMASK(1, 0)
+#define CFP_TCAM0_SLICE1			BIT(2)
+#define CFP_TCAM0_SLICE_MASK		GENMASK(3, 2)
+#define CFP_TCAM0_UDF0_FLAG(n)		BIT(8 + (n))
+#define CFP_TCAM_UDF_OFFSET		8
+#define CFP_TCAM5_UDF_VALID(n)		BIT(24 + (n))
+#define CFP_TCAM6_L3_FRAMING		GENMASK(25, 24)
+#define CFP_TCAM6_IP_PROTOCOL		GENMASK(15, 8)
+#define CFP_TCAM6_IP_FRAGMENT		BIT(7)
+#define CFP_TCAM7_SOURCE_PORTS		GENMASK(7, 0)
+
+/* Both meter outcomes replace the destination map with CPU port 5. */
+#define CFP_ACT0_FWD_MAP_REPLACE		(2 << 24)
+#define CFP_ACT0_DST_PORT5		BIT(19)
+#define CFP_ACT0_REASON_TERMINATION	BIT(6)
+#define CFP_ACT1_CLASS_ID(n)		((n) << 20)
+#define CFP_ACT1_FWD_MAP_REPLACE		(2 << 11)
+#define CFP_ACT1_DST_PORT5		BIT(6)
+
 #endif /* !__B53_REGS_H */
diff --git a/include/linux/dsa/brcm.h b/include/linux/dsa/brcm.h
index 47545a948784..9bfba22b4977 100644
--- a/include/linux/dsa/brcm.h
+++ b/include/linux/dsa/brcm.h
@@ -8,6 +8,25 @@
 #ifndef _NET_DSA_BRCM_H
 #define _NET_DSA_BRCM_H
 
+#include <linux/list.h>
+#include <linux/types.h>
+
+struct net_device;
+struct sk_buff;
+
+/* Original FA control packets arrive through the auxiliary CPU port. */
+struct brcm_fa_control {
+	struct list_head list;
+	struct net_device *conduit;
+	void (*receive)(void *priv, struct sk_buff *skb, unsigned int port);
+	void (*state_change)(void *priv, bool ready);
+	void *priv;
+};
+
+void brcm_fa_control_register(struct brcm_fa_control *control);
+void brcm_fa_control_unregister(struct brcm_fa_control *control);
+void brcm_fa_control_set_ready(struct net_device *conduit, bool ready);
+
 /* Broadcom tag specific helpers to insert and extract queue/port number */
 #define BRCM_TAG_SET_PORT_QUEUE(p, q)	((p) << 8 | q)
 #define BRCM_TAG_GET_PORT(v)		((v) >> 8)
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5d12191b6f6f..5f926b7fde5b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -62,6 +62,7 @@ struct tc_action;
 #define DSA_TAG_PROTO_KSZ8463_VALUE		34
 #define DSA_TAG_PROTO_MT7628_VALUE		35
 #define DSA_TAG_PROTO_KS8995_VALUE		36
+#define DSA_TAG_PROTO_BRCM_FA_VALUE		37
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
@@ -69,6 +70,7 @@ enum dsa_tag_protocol {
 	DSA_TAG_PROTO_BRCM_LEGACY	= DSA_TAG_PROTO_BRCM_LEGACY_VALUE,
 	DSA_TAG_PROTO_BRCM_LEGACY_FCS	= DSA_TAG_PROTO_BRCM_LEGACY_FCS_VALUE,
 	DSA_TAG_PROTO_BRCM_PREPEND	= DSA_TAG_PROTO_BRCM_PREPEND_VALUE,
+	DSA_TAG_PROTO_BRCM_FA		= DSA_TAG_PROTO_BRCM_FA_VALUE,
 	DSA_TAG_PROTO_DSA		= DSA_TAG_PROTO_DSA_VALUE,
 	DSA_TAG_PROTO_EDSA		= DSA_TAG_PROTO_EDSA_VALUE,
 	DSA_TAG_PROTO_GSWIP		= DSA_TAG_PROTO_GSWIP_VALUE,
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 4f44bf3ede23..2dffff2f6c34 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -69,6 +69,15 @@ config NET_DSA_TAG_BRCM_PREPEND
 	  Broadcom switches which places the tag before the Ethernet header
 	  (prepended).
 
+config NET_DSA_TAG_BRCM_FA
+	tristate "Tag driver for the Broadcom Northstar flow accelerator"
+	select NET_DSA_TAG_BRCM_COMMON
+	help
+	  Support the prepended four-byte FA metadata tag on Northstar GMAC2.
+	  The receive format includes a hash, bucket, parser status, and input
+	  switch port. Transmit uses the ordinary prepended Broadcom tag.
+	  Enable this for a B53 switch explicitly connected to an accelerator.
+
 config NET_DSA_TAG_HELLCREEK
 	tristate "Tag driver for Hirschmann Hellcreek TSN switches"
 	help
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index b7c49822ca88..8d13a3c7de5e 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include "tag.h"
@@ -17,6 +18,8 @@
 #define BRCM_LEGACY_NAME	"brcm-legacy"
 #define BRCM_LEGACY_FCS_NAME	"brcm-legacy-fcs"
 #define BRCM_PREPEND_NAME	"brcm-prepend"
+#define BRCM_FA_NAME		"brcm-fa"
+#define BRCM_FA_OPCODE_MISS	2
 
 /* Legacy Broadcom tag (6 bytes) */
 #define BRCM_LEG_TAG_LEN	6
@@ -84,7 +87,8 @@
 #define BRCM_EG_PID_MASK	0x1f
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM) || \
-	IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
+	IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND) || \
+	IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
 
 static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 					struct net_device *dev,
@@ -146,9 +150,10 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
  */
 static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       struct net_device *dev,
-				       unsigned int offset)
+				       unsigned int offset, bool fa)
 {
 	int source_port;
+	u8 opcode;
 	u8 *brcm_tag;
 
 	if (unlikely(!pskb_may_pull(skb, BRCM_TAG_LEN))) {
@@ -158,8 +163,12 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 
 	brcm_tag = skb->data - offset;
 
-	/* The opcode should never be different than 0b000 */
-	if (unlikely((brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK)) {
+	/* Opcode 2 is a four-byte FA miss descriptor. Its middle bytes
+	 * contain the flow hash and parser status, not classification/reason.
+	 * Timestamp descriptors (opcode 1, eight bytes) are not supported.
+	 */
+	opcode = (brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK;
+	if (unlikely(opcode && !(fa && opcode == BRCM_FA_OPCODE_MISS))) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -167,7 +176,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* We should never see a reserved reason code without knowing how to
 	 * handle it
 	 */
-	if (unlikely(brcm_tag[2] & BRCM_EG_RC_RSVD)) {
+	if (unlikely(!opcode && (brcm_tag[2] & BRCM_EG_RC_RSVD))) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -205,7 +214,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	struct sk_buff *nskb;
 
 	/* skb->data points to the EtherType, the tag is right before it */
-	nskb = brcm_tag_rcv_ll(skb, dev, 2);
+	nskb = brcm_tag_rcv_ll(skb, dev, 2, false);
 	if (!nskb)
 		return nskb;
 
@@ -392,7 +401,7 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
 					    struct net_device *dev)
 {
 	/* tag is prepended to the packet */
-	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN);
+	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, false);
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
@@ -407,7 +416,100 @@ DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_PREPEND, BRCM_PREPEND_NAME);
 #endif
 
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
+static LIST_HEAD(brcm_fa_controls);
+static DEFINE_MUTEX(brcm_fa_control_lock);
+
+void brcm_fa_control_register(struct brcm_fa_control *control)
+{
+	mutex_lock(&brcm_fa_control_lock);
+	list_add_rcu(&control->list, &brcm_fa_controls);
+	mutex_unlock(&brcm_fa_control_lock);
+}
+EXPORT_SYMBOL_GPL(brcm_fa_control_register);
+
+void brcm_fa_control_unregister(struct brcm_fa_control *control)
+{
+	mutex_lock(&brcm_fa_control_lock);
+	list_del_rcu(&control->list);
+	mutex_unlock(&brcm_fa_control_lock);
+	synchronize_net();
+}
+EXPORT_SYMBOL_GPL(brcm_fa_control_unregister);
+
+void brcm_fa_control_set_ready(struct net_device *conduit, bool ready)
+{
+	struct brcm_fa_control *control;
+
+	/* State callbacks can sleep while retiring hardware entries. */
+	mutex_lock(&brcm_fa_control_lock);
+	list_for_each_entry(control, &brcm_fa_controls, list)
+		if (control->conduit == conduit && control->state_change)
+			control->state_change(control->priv, ready);
+	mutex_unlock(&brcm_fa_control_lock);
+}
+EXPORT_SYMBOL_GPL(brcm_fa_control_set_ready);
+
+static struct sk_buff *brcm_fa_tag_xmit(struct sk_buff *skb,
+					struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_user_to_port(dev);
+
+	return brcm_tag_xmit_ll(skb, dev, dp->cpu_dp->index == 5 ? 2 * ETH_ALEN : 0);
+}
+
+static struct sk_buff *brcm_fa_tag_rcv(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *cpu = dev->dsa_ptr;
+	struct brcm_fa_control *control;
+	struct dsa_port *data_cpu;
+	unsigned int port;
+	u8 reason;
+
+	if (cpu->index != 5)
+		return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, true);
+	if (!pskb_may_pull(skb, BRCM_TAG_LEN))
+		goto drop;
+	reason = skb->data[0]; /* Embedded tag byte 2 after eth_type_trans(). */
+	port = skb->data[1] & BRCM_EG_PID_MASK;
+	skb = brcm_tag_rcv_ll(skb, dev, 2, false);
+	if (!skb)
+		return NULL;
+	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
+	skb_set_mac_header(skb, -ETH_HLEN);
+	if (!(reason & BRCM_EG_RC_PROT_TERM))
+		return skb;
+	data_cpu = dsa_to_port(cpu->ds, 8);
+	if (!data_cpu || !dsa_port_is_cpu(data_cpu))
+		return skb;
+	rcu_read_lock();
+	list_for_each_entry_rcu(control, &brcm_fa_controls, list)
+		if (control->conduit == data_cpu->conduit)
+			control->receive(control->priv, skb, port);
+	rcu_read_unlock();
+	return skb;
+drop:
+	kfree_skb(skb);
+	return NULL;
+}
+
+static const struct dsa_device_ops brcm_fa_netdev_ops = {
+	.name = BRCM_FA_NAME,
+	.proto = DSA_TAG_PROTO_BRCM_FA,
+	.xmit = brcm_fa_tag_xmit,
+	.rcv = brcm_fa_tag_rcv,
+	.needed_headroom = BRCM_TAG_LEN,
+	.promisc_on_conduit = true,
+};
+
+DSA_TAG_DRIVER(brcm_fa_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_FA, BRCM_FA_NAME);
+#endif
+
 static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
+	&DSA_TAG_DRIVER_NAME(brcm_fa_netdev_ops),
+#endif
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
 	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
 #endif
-- 
2.53.0

