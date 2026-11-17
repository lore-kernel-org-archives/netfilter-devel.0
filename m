Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932160;
	b=nhA3J10iOBmQ6vG9CxgwTKP12+B+p63xrxAkCCsfJ1Fz8FljMzQZneIt4zONSQ4Cvqxu
	 t2ZthYaJDB/bnBDlOGkrpKAstdLxH5MIzttVJaB+lUvRg0PJoEwNH7tuCKzwdKDRlAokV
	 hR6ZCeKmq3zUBqHdnTOX9Q85pNJdhDNokscYUqzrGYxclP1tZPKFGmwA1Wtvjg63bNPHR
	 oP7carE7KZ2/xBEepGL4vDWgTQc0QNQluSaDyHWICBfvm/GIsrECreQjpDjZBXz1vB517
	 bN9Ecd+zI99RQlA89QdPXxaGbLmkIaqIWmJIMJcIAsiTBg+tbOlI/N/djqjCqBF8ojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932160;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=soJLaeLZf9Tb6wBK/4xWGL9XM6cfHsPUP5XIGdbZe3o=;
	b=ZLSLM0++C6r/b92+r/xNmTIQb13GLJ5lbK3TMXDXQZ3jN7tQ3q5Avoq8+o0nXSKu4Lmp
	 USnnCNM99bV0jHma5SP/RxrsORBP/Hiv82BpsnlmNqqsaWIdRX+WR/KU21B6wUEgg2yC5
	 M9vzYCJ4V5+iSHN5odj1lkRfYmja8py3UgMokJXJUxVl2JTyXelVU+GlvV92Rnf85PMYB
	 A97jSUUxGkpR9agmYOKgDctPuXI3FR/fv5LxQwEpuJ8oplPWFv27dIGOjs+s6kDI+dqlB
	 8xMpYfLIZsjzsgK349dBcmM6cXqwYcfnsbJOOW0sgeh28NjU6HcjLu3vVQGA/eJzA9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qmuLsZPE;
	arc=none smtp.remote-ip=203.205.221.149
Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E5606A32C;
	Tue, 17 Nov 2026 16:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 767E5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qmuLsZPE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794932150; bh=soJLaeLZf9Tb6wBK/4xWGL9XM6cfHsPUP5XIGdbZe3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmuLsZPEAIslRsTDGllgnOYy769ujsFnXwIzA72KwxFxR1pPnkPCIqdSaZfqEeHcR
	 IImpYa6BHyAL3SHP1yCprhr8WgV2x8UeTClW5a4qozTvqPbsXgb3X0FkHejE4pYXEj
	 STxLwOai214/RR0CSyfqUCTvnWL1cRJR7kl5AQRk=
Received: from localhost.localdomain ([182.239.117.117])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 3E6A5A2C; Wed, 18 Nov 2026 00:15:38 +0800
X-QQ-mid: xmsmtpt1794932146tssi6ks9f
Message-ID: <tencent_65062E982D816637E41FE6F24B678214DF09@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GxMGZDqfby7PlH8VJf2Ee/3dmI7Iy17d61pDpaF9m4bFOpclpPV
	 HKSIQxAKUREJOb8+4OyjG/N5viRREZQz+fitQHfnvTlS5IIfOOkCdKwMhaYaTjFISgXpnDgwD9zy
	 v/F8786p1C660IKx++MjG2Baao0ACqcXwGEQSaUOMJJRgxYaz76AoP6UDCyltInXpc/nTdGmPixV
	 lZcQOmscxcBSODQtb1U/OHQSbm0QOLnAXFc+48pOAI8NvO+doq1/q+S9clUSwkju/LFgB9w3PXjx
	 3N8boClTPM8hfMDkbxboUIAEmihjPThs9oOfIXaBx/VfGEXE1TMiXImwMM5izR+1G4SdJvElbkN2
	 8gSmk8D4kg3RteeihksOAEGFvloi1ezyl8aafGE25ndETAnnnZniMp+EyKt2kaTbd0fiauwo5wIS
	 QAp8J/HA2QLCnVGQWeN8avGTFLV116J7fWjAsgRyVreCMHygju5QV7GPoBtz9mtlfbh4Rgk2K88w
	 +YxC2+Fz53bKQ+VPFfk2zRgDuf6g78yklZxFPHUg8RN0/30FhpeqaUr15Ho72SN+rrJCK61qLpFo
	 06iVvHo9hpot7tp56Qis28ypxu2CB6d2Wax8SMqNqmuUpoCNLEGO+EASgOskYyHBjMVN7Gg+bqXD
	 1RvfCQWh3ssBhknlidI0Fe0ahPpbj94VGgxRiifia1UJHHjopKLXg5JOPQDxMO+J7mX2Mhd+UjqP
	 KlEjbjCNHAQ64iOex8gVo4QztQ/iTIW001TYZL0KVPPxBW2g76wS+cxGjHC4SCIZ+sMfqHYSmR+u
	 59SzqspFGBmhu846waE3KjlFI1+gveggpGgQUi3qbgA2FzcFuBAJNbKlTCN74+CyMLJv6ofTC1n+
	 pOVVjtw+W0WKrIOds3SMX0bzVVIIqQInish+UpCMB1mQ0AKrWhEOChYaHPDyxoLGaEXj1v6mX4Gm
	 69JEpIxHdvjOWfx0J9PhQCll+4RKqU5nZhoq+i5CbKUOKTAArElKiYmxi6M31Da2/rUYeq6uiHQt
	 m4KYXy1vsSboPpU0oi8Hw+Bhhov94W7vSFWEbfMA5fxo6dnfkXsIuqZ+P2hoDEOo/Bnd7CJtmnVY
	 XDjrrt9z6dmso8fdMQB7HNzIk2pQ==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf v2 2/2] selftests: netfilter: test re-owning an already dormant table
Date: Wed, 18 Nov 2026 00:14:58 +0800
X-OQ-MSGID: <20261117161520.1031-3-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20261117161520.1031-1-1564938642@qq.com>
References: <20261117161520.1031-1-1564938642@qq.com>
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

Add a regression test for the nftables table-adoption path.  The test
creates a dormant PERSIST OWNER table, lets the owning nft process exit
so the table becomes an orphan, adds a basechain while the table is still
dormant, and re-owns the orphan.

On the buggy tree this calls nf_tables_table_disable() and unregisters a
hook that was never registered, which triggers WARN_ONCE("hook not
found") and taints the kernel.  The test checks the taint state so it
fails on the unfixed kernel and passes once the commit path only
disables a table on a real awake-to-dormant transition.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 .../testing/selftests/net/netfilter/Makefile  |  1 +
 .../net/netfilter/nft_table_dormant_adopt.sh  | 57 +++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index df3c20c90..3ca562a0a 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -37,6 +37,7 @@ TEST_PROGS := \
 	nft_offload.sh \
 	nft_queue.sh \
 	nft_synproxy.sh \
+	nft_table_dormant_adopt.sh \
 	nft_tproxy_tcp.sh \
 	nft_tproxy_udp.sh \
 	nft_zones_many.sh \
diff --git a/tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh b/tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh
new file mode 100755
index 000000000..b1e1bb4fe
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Re-owning an already dormant PERSIST table used to call
+# nf_tables_table_disable() from nf_tables_commit(), which unregistered a
+# basechain hook that was never registered and triggered
+# WARN_ONCE("hook not found") in __nf_unregister_net_hook().
+#
+# The WARN taints the kernel, so this test checks the taint state instead
+# of parsing dmesg.
+
+source "$(dirname "$0")/lib.sh"
+
+checktool "nft --version" "run nft"
+
+if [ "$(id -u)" -ne 0 ]; then
+	echo "SKIP: root is required to create an owner table"
+	exit $ksft_skip
+fi
+
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ]; then
+	echo "SKIP: kernel is already tainted"
+	exit $ksft_skip
+fi
+
+cleanup()
+{
+	nft delete table ip nft_dormant_rt 2>/dev/null || true
+}
+trap cleanup EXIT
+
+nft delete table ip nft_dormant_rt 2>/dev/null || true
+
+# The nft process exits after this command, leaving a dormant PERSIST
+# orphan table behind.
+if ! nft add table ip nft_dormant_rt '{ flags dormant,persist,owner; }'; then
+	echo "SKIP: nft does not support table owner/persist flags"
+	exit $ksft_skip
+fi
+
+# A basechain added while the table is dormant does not register its hook.
+nft add chain ip nft_dormant_rt c '{ type filter hook output priority 0; }' || exit 1
+
+# Re-own the orphan with DORMANT still set.  On the buggy tree this calls
+# nf_tables_table_disable() and unregisters the never-registered hook.
+nft add table ip nft_dormant_rt '{ flags dormant,persist,owner; }' || exit 1
+
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ]; then
+	echo "FAIL: re-owning an already dormant table tainted the kernel"
+	dmesg | tail -n 20
+	exit 1
+fi
+
+echo "PASS"
+exit 0
-- 
2.56.0.windows.4.niugit

