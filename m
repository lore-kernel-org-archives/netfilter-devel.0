Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867998;
	b=iGRCdzxlG372Z9hMR2OLY9ww9i5/s+XAMreP8CbS81Yt6bP8QAXzZCaaStTQ10K26KYs
	 FIzOitSPoHZ8R+LWbnSzluKRIP0jjj4LXLoGbzFqvce3VrquTYD5fHA3qPV9lQb4Uj6em
	 r76TBWnglvQvVtiQCRARzbFgiVXwkzeOopm1G5m9EMaw9Hl7CEGCy0n+9mpr7L2t1+EWD
	 i4MbC78OblrksLXGrqe4zn+bdzNwO2lyS/Thasx+y+PtS2hMZYbWuo5kMTX6bHyytSODt
	 HO+NPz/fJftRIqdiqBM49zl+tHeUR80KX2oF1aHsm8ZCXZ7EVJ0pEYCvmfjHSU0/pVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867998;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=cVMKW7fB8h0SnQR2hp0PSgoEdY8qiS0OoOpSG4SZZnE=;
	b=sH2BOd0jk7ReMBTQ/YyYrdyqfdouFHD+c1NVfKrqlbSRJ8A++e/XzeDOpwrcifVZPXLv
	 y+R2XQ1guFTqPg0Bzpf3F5SwwpFsHzxGXDVuyDMuabn7wngOKEiKbB2yB+cOkAI5BXyiQ
	 I+EcN2J65zb+dieT2UTD6J60C0SIB1Cv0PW/0edbfi/sGtUE/5W6/CwLmyX0TvyMSY+71
	 9sHg1zyTFWOBS65pplhsOP6AOKDpeBVGEjjMNVHtCCxAPhtaFzcangiiKyQZDz5Zsc0fm
	 9a1Z2UsLgMz2obSkw12iMhPgEwr1iKjorgmvNXSureZ3U23X4i5GmtOCww2CkcTw90A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=GDdgrtPS;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD8606A89A
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70DD8606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=GDdgrtPS
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b3a914e4c8so346035a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867995; x=1795472795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cVMKW7fB8h0SnQR2hp0PSgoEdY8qiS0OoOpSG4SZZnE=;
        b=lznZP1wznQGUBKC3A7GXUIpvUX2fDLqmlPG5Kqg8RYE8fN95oJVaOaFee3GVQe4g1l
         yVLaSLC0j2CXrtFLk2lmbwrNrkbCMsld9W3x7GTkop1WStk4UxYjTXocSFZ2l5ovraLu
         gcEaa86ZWx1Gnb8X8sHoi0h5o4mk5kIAtNtg6bQZbYdLTcsygnyQtjBE1p+JKrIvhVBn
         t6W3bf6myHHVanKI4VTc+c3RuQpz6DdCyeeTN8C4IJPTDFoiPNHih7ow6tZEOj92jiQz
         g0GC1Lx3v2RwETBwmsHbbTU739My+JQMJAYaTmzEO9RZVd2146NxTxMLMdAt9THcz7aI
         eWrg==
X-Forwarded-Encrypted: i=1; AL+hErGO2xqdRgchD5xlENE9WojODoy88WVSveHzWXLo4RYC1otwxaklKMzEpOOyvi24o5UysgM/jG1KfXV+2Ksxcrg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9CcY1ezmtTbOFZgA2vNggLC4+6z16ppAXybgPRit35LZw55pj7
	wVuCZd+jRhJEozduVHd67rstkn0Q9nZt0M0K63bG7dRCZPBk93fTbt7HvjdoxC3FFG6bLvVzylV
	666sgOjUuUp+QolYKUh9FECucJArIE9gBqABd4F90SrdgbIDB5NbYWxdwePgw4vtgILBN+rwWJy
	s9hNpFLxgLkymcVvrzxthUU4/Apc22i7MNnXDLu/WhvozevROLyy5cok7CoxuZ20k9J38QTfVLl
	YhvZDr+90GSeLUS+iRDFND4rgux
X-Gm-Gg: AZFdTZcjJWkeVsnOgRMNlxih0uiPwqQXguJ76f7mEVwRl0fT/nUx+wl7dHvvArYryVw
	a82xTs27hL3P68lzS+PXj2cD5XHXSzHTtbU65ZwHSpDbev6j6dQksbuiMVzG3nNRh23WWidunRO
	UTBXo8uTm/tO3YMF3UnWXPEyKdOZjT80t0Ev5twg7vGsX9rqD/nccg2xQ1c0HMLuX4q0tit6aqY
	vTsbcIbOjxWQXXVcsvBLj+59dDZfxslKYe+pTkZ/o00VG6YkRS1S2GKSBA0rHf+Sc9T6vV4IOIO
	zGlodkOx4ghxKY78HKXbY3O8HVAPoqd9GG8N66r/QZ6c5Io/eK2cpl78SstmXMvZtlcmjrWsJNN
	BGGa1OJRO5l+H/2Y0HkxPOT+eakeqd3mybvIUMslrNk67eXDJ4K9+te0sUaX0cBs287+D0dDDew
	yX//+gu0q8n6ZkJDdFlL3HchHN2ycEr7mTLVHlraCbpHA=
X-Received: by 2002:a17:90b:4ad0:b0:3b0:ada3:b505 with SMTP id 98e67ed59e1d1-3b1b09f3fa7mr12443988a91.19.1794867993239;
        Mon, 16 Nov 2026 14:26:33 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cddc18d0ff2sm196774a12.24.2026.11.16.14.26.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:33 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36efb506f29so4051065eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794867990; x=1795472790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVMKW7fB8h0SnQR2hp0PSgoEdY8qiS0OoOpSG4SZZnE=;
        b=GDdgrtPSd1A//IcT5eYJN7ELhJmZHj6CaZY8PbDuGhKTQ/Ny1TPsXW3dBR1RqTY/q3
         SppgckwO4LBEoMHB0cJEDUXFPEI9d91o1JTXPSogva4ccX8/g5wDzIecehf05QtV3P6F
         X0cVF3ubcRC0or/0ACDYXFYOHMrwDWmo57mTA=
X-Forwarded-Encrypted: i=1; AL+hErHyfc0k8v99xEWZdemnHAuJlY70BIG4AS3ZavwzeWeN0ElA5/2ogJDGO5Zo9NY8/unJzDpmYJSOR92Lmp8S+mI=@vger.kernel.org
X-Received: by 2002:a05:7300:7952:b0:381:3b6:6c3d with SMTP id 5a478bee46e88-38103b682f6mr849621eec.35.1794867990163;
        Mon, 16 Nov 2026 14:26:30 -0800 (PST)
X-Received: by 2002:a05:7300:7952:b0:381:3b6:6c3d with SMTP id 5a478bee46e88-38103b682f6mr849591eec.35.1794867989331;
        Mon, 16 Nov 2026 14:26:29 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:28 -0800 (PST)
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
Subject: [PATCH net-next 3/9] netfilter: flowtable: retain offload ownership until deletion completes
Date: Mon, 16 Nov 2026 14:25:13 -0800
Message-ID: <20261116222519.1416501-4-florian.fainelli@broadcom.com>
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

Teardown clears IPS_OFFLOAD before asynchronous hardware deletion and
hash removal. A new packet can therefore create a replacement flow on
the same conntrack while the old owner still exists. Repeated teardown
can clear the replacement's IPS_OFFLOAD, and the old hardware delete
worker can clear its IPS_HW_OFFLOAD after a new hardware rule was
installed.

The FA route-change reproducer observed four fresh hardware rows but
only one of two connections still carrying HW_OFFLOAD. Two deterministic
KUnit cases also fail before this change: repeated notification releases
a new claim, and hardware retirement admits a new claim before deletion
finishes.

Release IPS_OFFLOAD after both hash entries have been removed. For
hardware flows, GC reaches this point only after hardware deletion is
complete. NF_FLOW_TEARDOWN immediately excludes the old software fast
path. Packets reaching software still use normal conntrack and
forwarding; TCP state and timeout repair run at first teardown. Hardware
deletion may remain pending. Holding the admission bit prevents
overlapping owners.

The delayed release is observable: conntrack dumps may temporarily
report OFFLOAD or HW_OFFLOAD and omit TCP state after a FIN or RST has
returned to the slow path. The status covers ownership pending cleanup
during the GC and asynchronous delete interval, rather than guaranteeing
acceleration. This trades transient reporting for correct ownership
serialization and prevents an old cleanup from clearing its
replacement's status. Document the interval and use packet
captures/counters to identify the packet path.

Include the private lifetime tests and their KUnit configuration here,
independently of the FA series. They cover real hash removal, deferred
hardware retirement, late RCU notification and balanced conntrack
references. The nf_flow_table.config configuration runs these two cases
on its own.

Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 Documentation/networking/nf_flowtable.rst     | 13 +++
 MAINTAINERS                                   |  1 +
 net/netfilter/Kconfig                         | 10 +++
 net/netfilter/nf_flow_table_core.c            |  9 +-
 net/netfilter/nf_flow_table_core_test.c       | 86 +++++++++++++++++++
 .../kunit/configs/nf_flow_table.config        |  9 ++
 6 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nf_flow_table_core_test.c
 create mode 100644 tools/testing/kunit/configs/nf_flow_table.config

diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
index d757c21c10f2..b9b444435775 100644
--- a/Documentation/networking/nf_flowtable.rst
+++ b/Documentation/networking/nf_flowtable.rst
@@ -205,6 +205,19 @@ refers to the software offload mode, so there is a distinction between [OFFLOAD]
 which refers to the software flowtable fastpath and [HW_OFFLOAD] which refers
 to the hardware offload datapath being used by the flow.
 
+During teardown, software fastpath lookups immediately stop matching the
+flow. Packets reaching software follow the classic forwarding path, while
+hardware deletion may still be pending. The OFFLOAD status
+bit remains set until hash removal and asynchronous hardware deletion are
+complete, preventing a new owner from racing the old owner's cleanup. As a
+result, conntrack dumps can temporarily retain [OFFLOAD] or [HW_OFFLOAD]
+and omit the TCP state after a FIN or RST has returned to the slow path.
+TCP state and timeout repair still run at first teardown. The transient
+status describes ownership pending cleanup, rather than guaranteeing that
+packets are still accelerated. It clears when garbage collection finishes
+the deletion; packet captures and forwarding counters identify the actual
+forwarding path during that interval.
+
 The flowtable hardware offload infrastructure also supports for the DSA
 (Distributed Switch Architecture).
 
diff --git a/MAINTAINERS b/MAINTAINERS
index c583367c88bc..56212dbc9a0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19396,6 +19396,7 @@ F:	net/*/netfilter.c
 F:	net/*/netfilter/
 F:	net/bridge/br_netfilter*.c
 F:	net/netfilter/
+F:	tools/testing/kunit/configs/nf_flow_table.config
 F:	tools/testing/selftests/net/netfilter/
 
 NETRONIX EMBEDDED CONTROLLER
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 09874c26fd13..f565f87b3a6c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -718,6 +718,16 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_KUNIT_TEST
+	bool "KUnit tests for flowtable ownership" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && NF_FLOW_TABLE
+	default KUNIT_ALL_TESTS
+	help
+	  Test conntrack offload ownership during flowtable teardown.
+	  Require hash and asynchronous hardware deletion before re-enrolment.
+	  Verify that late notifications cannot release a replacement owner.
+	  These private tests are embedded in the flowtable core.
+
 config NF_FLOW_TABLE_PROCFS
 	bool "Supply flow table statistics in procfs"
 	depends on NF_FLOW_TABLE
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9df..4c82097cd50b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -393,12 +393,15 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
+	/* Release admission only after both hashes and async hardware state
+	 * have gone. An older owner must not clear its replacement's status.
+	 */
+	clear_bit_unlock(IPS_OFFLOAD_BIT, &flow->ct->status);
 	flow_offload_free(flow);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
 		flow_offload_fixup_ct(flow);
 }
@@ -876,3 +879,7 @@ module_exit(nf_flow_table_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_DESCRIPTION("Netfilter flow table module");
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE_KUNIT_TEST)
+#include "nf_flow_table_core_test.c"
+#endif
diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
new file mode 100644
index 000000000000..378a1c60b50b
--- /dev/null
+++ b/net/netfilter/nf_flow_table_core_test.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+
+static void nf_flow_test_teardown_repeat(struct kunit *test)
+{
+	struct flow_offload flow = {};
+	struct nf_conn *ct;
+
+	ct = kunit_kzalloc(test, sizeof(*ct), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ct);
+	ct->tuplehash[0].tuple.dst.protonum = IPPROTO_ICMP;
+	flow.ct = ct;
+	set_bit(IPS_OFFLOAD_BIT, &ct->status);
+	flow_offload_teardown(&flow);
+	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
+	/* A late notification for this retired flow cannot clear a new claim. */
+	set_bit(IPS_OFFLOAD_BIT, &ct->status);
+	flow_offload_teardown(&flow);
+	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
+}
+
+static void nf_flow_test_hardware_retirement(struct kunit *test)
+{
+	struct nf_flowtable table = {};
+	struct flow_offload *flow;
+	struct nf_conn *ct;
+	unsigned int dir;
+	int err;
+
+	ct = kunit_kzalloc(test, sizeof(*ct), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ct);
+	err = rhashtable_init(&table.rhashtable, &nf_flow_offload_rhash_params);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	flow = kzalloc_obj(*flow);
+	if (!flow) {
+		rhashtable_destroy(&table.rhashtable);
+		KUNIT_FAIL(test, "flow allocation failed");
+		return;
+	}
+	ct->tuplehash[0].tuple.dst.protonum = IPPROTO_ICMP;
+	refcount_set(&ct->ct_general.use, 2);
+	flow->ct = ct;
+	set_bit(NF_FLOW_HW, &flow->flags);
+	set_bit(IPS_OFFLOAD_BIT, &ct->status);
+	set_bit(IPS_HW_OFFLOAD_BIT, &ct->status);
+	for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
+		flow->tuplehash[dir].tuple.src_port = htons(10000 + dir);
+		err = rhashtable_insert_fast(&table.rhashtable,
+					     &flow->tuplehash[dir].node,
+					     nf_flow_offload_rhash_params);
+		KUNIT_EXPECT_EQ(test, err, 0);
+	}
+	flow_offload_teardown(flow);
+	/* nft_flow_offload must not admit another owner during async DESTROY. */
+	KUNIT_EXPECT_TRUE(test, test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status));
+	flow_offload_teardown(flow);
+	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
+	/* Model completed hardware deletion before the GC removes the hashes. */
+	clear_bit(IPS_HW_OFFLOAD_BIT, &ct->status);
+	set_bit(NF_FLOW_HW_DEAD, &flow->flags);
+	rcu_read_lock();
+	flow_offload_del(&table, flow);
+	KUNIT_EXPECT_FALSE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
+	/* Re-enrolment is safe now; an old RCU reader still cannot undo it. */
+	set_bit(IPS_OFFLOAD_BIT, &ct->status);
+	flow_offload_teardown(flow);
+	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
+	rcu_read_unlock();
+	rcu_barrier();
+	KUNIT_EXPECT_EQ(test, refcount_read(&ct->ct_general.use), 1);
+	rhashtable_destroy(&table.rhashtable);
+}
+
+static struct kunit_case nf_flow_lifetime_cases[] = {
+	KUNIT_CASE(nf_flow_test_teardown_repeat),
+	KUNIT_CASE(nf_flow_test_hardware_retirement),
+	{}
+};
+
+static struct kunit_suite nf_flow_lifetime_suite = {
+	.name = "nf-flow-lifetime",
+	.test_cases = nf_flow_lifetime_cases,
+};
+
+kunit_test_suite(nf_flow_lifetime_suite);
diff --git a/tools/testing/kunit/configs/nf_flow_table.config b/tools/testing/kunit/configs/nf_flow_table.config
new file mode 100644
index 000000000000..7f2aa55190c2
--- /dev/null
+++ b/tools/testing/kunit/configs/nf_flow_table.config
@@ -0,0 +1,9 @@
+CONFIG_KUNIT=y
+CONFIG_NET=y
+CONFIG_INET=y
+CONFIG_NETFILTER=y
+CONFIG_NETFILTER_INGRESS=y
+CONFIG_NF_CONNTRACK=y
+CONFIG_NF_TABLES=y
+CONFIG_NF_FLOW_TABLE=y
+CONFIG_NF_FLOW_TABLE_KUNIT_TEST=y
-- 
2.53.0

