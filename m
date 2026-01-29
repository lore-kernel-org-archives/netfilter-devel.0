Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1A62DC79B
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769711341; cv=none; b=rhszEtbLiPA8r7qMWPQD3TFx6dcKQE7Zoj0fi6eda2fKF46Mf1e6pnq+3U/4o4lyDcyKSEvDrXWLMy5RZpdJvv91WOZjpzhuq76FRcES+gL7zacTxVGLYTKYcqlxVC8if57EPNUGcMErHiMA+aXvZelrKszxlWe0yHySflat0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769711341; c=relaxed/simple;
	bh=StcCfKkuBQbj6zFDBLs5+DSfJgQ49lMSNVALwpPlqdE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hkPMjs6E7k88he7pnNrINYVMVU0p80w5juI3OTatmEUsF/IWaPmqO3dCCUZSfWbv2pbT9oHTaA9siCGFqDvgv9bZdTfnSuK5N5cKvk2K3O6sB8N8IFpYQ35EvHa9yA6YAbk4cq5mBONimGeZxMwkIvhNkQQhAdsdBNKHq26pNSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FOBH7VWe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FOBH7VWe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PBGtJxww26rU9b88L0mTCtZbWE99kGVmQ6mkyw0Nb2g=; b=FOBH7VWeuvtDpAVH2QFXY6nEP/
	iRb4Ix+VCDGyjRI5iQvoOAWvEjOZkhBm19O0TZ08/m0hxTC72ge1fBucRF6R+1gOYoQVVJmbT7K+C
	73GsW7psV7TxTCQ7bo4OZgQExdiVMFwyATf9K4/rLqzMO9Qm/4s9KYdRR3PQQW2Mc/3eSmRG7HkAm
	X240BcLwhaiALpRHs8rJPWJDA9EFRobTwwAkvNfl2/jInX45dsNEC4mVFtOeu0OT1gfPOJ2mexzHU
	yf6xYjJgvkt6LbnbBOy22ShDwyrGOM+moS3sGlGNZCR1vouEfkv4GJhmfiymARbaxT1U1KRLHBs53
	3YKfcU/A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlWlD-0000000078m-2kGf
	for netfilter-devel@vger.kernel.org;
	Thu, 29 Jan 2026 19:28:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Review nft-only/0009-needless-bitwise_0
Date: Thu, 29 Jan 2026 19:28:50 +0100
Message-ID: <20260129182850.19927-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Avoid calling host's nft binary, use double-verbose mode with *tables
  tools instead
- Update expected payloads to match new byteorder-aware libnftnl output
- Drop '-x' flag from shell

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../nft-only/0009-needless-bitwise_0          | 195 +++++++++---------
 1 file changed, 101 insertions(+), 94 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
index bfceed4976f18..a8068964c6db0 100755
--- a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
+++ b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
@@ -1,4 +1,4 @@
-#!/bin/bash -x
+#!/bin/bash
 
 [[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
 set -e
@@ -52,287 +52,287 @@ ff:00:00:00:00:00
 	echo "COMMIT"
 ) | $XT_MULTI ebtables-restore
 
-EXPECT="ip filter OUTPUT 4
+EXPECT_IP4="ip filter OUTPUT 4
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ cmp eq reg 1 0x0a010203 ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 5 4
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ cmp eq reg 1 0x0a010203 ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 6 5
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a010200 ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 7 6
   [ payload load 3b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ cmp eq reg 1 0x0a0102 ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 8 7
   [ payload load 2b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000010a ]
+  [ cmp eq reg 1 0x0a01 ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 9 8
   [ payload load 1b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ counter pkts 0 bytes 0 ]
 
 ip filter OUTPUT 10 9
   [ counter pkts 0 bytes 0 ]
-
-ip6 filter OUTPUT 4
+"
+EXPECT_IP6="ip6 filter OUTPUT 4
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x03040506 0x0708090a ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 5 4
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x03040506 0x0708090a ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 6 5
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xf0ffffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xfffffff0 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x03040506 0x07080900 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 7 6
   [ payload load 15b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x03040506 0x070809 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 8 7
   [ payload load 14b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00000807 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x03040506 0x0708 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 9 8
   [ payload load 11b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00050403 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x030405 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 10 9
   [ payload load 10b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00000403 ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 0x0304 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 11 10
   [ payload load 8b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee000102 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 12 11
   [ payload load 6b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x000000ee ]
+  [ cmp eq reg 1 0xfeedc0ff 0xee00 ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 13 12
   [ payload load 2b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ cmp eq reg 1 0xfeed ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 14 13
   [ payload load 1b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
+  [ cmp eq reg 1 0xfe ]
   [ counter pkts 0 bytes 0 ]
 
 ip6 filter OUTPUT 15 14
   [ counter pkts 0 bytes 0 ]
-
-arp filter OUTPUT 3
+"
+EXPECT_ARP="arp filter OUTPUT 3
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ cmp eq reg 1 0x0a010203 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 4 3
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
+  [ cmp eq reg 1 0x0a010203 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 5 4
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 4b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0a010200 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 6 5
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 3b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0002010a ]
+  [ cmp eq reg 1 0x0a0102 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 7 6
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 2b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000010a ]
+  [ cmp eq reg 1 0x0a01 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 8 7
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 1b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
+  [ cmp eq reg 1 0x0a ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 9 8
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 10 9
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 6b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
+  [ cmp eq reg 1 0xfeed00c0 0xffee ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 11 10
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 6b @ network header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xfff0 ) ^ 0x00000000 0x0000 ]
+  [ cmp eq reg 1 0xfeed00c0 0xffe0 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 12 11
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 5b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
+  [ cmp eq reg 1 0xfeed00c0 0xff ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 13 12
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 4b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe ]
+  [ cmp eq reg 1 0xfeed00c0 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 14 13
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 3b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ cmp eq reg 1 0xfeed00 ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 15 14
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 2b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ cmp eq reg 1 0xfeed ]
   [ counter pkts 0 bytes 0 ]
 
 arp filter OUTPUT 16 15
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
+  [ cmp eq reg 1 0x0001 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
+  [ cmp eq reg 1 0x06 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
+  [ cmp eq reg 1 0x04 ]
   [ payload load 1b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
+  [ cmp eq reg 1 0xfe ]
   [ counter pkts 0 bytes 0 ]
-
-bridge filter OUTPUT 4
+"
+EXPECT_EBT="bridge filter OUTPUT 4
   [ payload load 6b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
+  [ cmp eq reg 1 0xfeed00c0 0xffee ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 5 4
   [ payload load 6b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xfff0 ) ^ 0x00000000 0x0000 ]
+  [ cmp eq reg 1 0xfeed00c0 0xffe0 ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 6 5
   [ payload load 5b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
+  [ cmp eq reg 1 0xfeed00c0 0xff ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 7 6
   [ payload load 4b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe ]
+  [ cmp eq reg 1 0xfeed00c0 ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 8 7
   [ payload load 3b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ cmp eq reg 1 0xfeed00 ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 9 8
   [ payload load 2b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
+  [ cmp eq reg 1 0xfeed ]
   [ counter pkts 0 bytes 0 ]
 
 bridge filter OUTPUT 10 9
   [ payload load 1b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
+  [ cmp eq reg 1 0xfe ]
   [ counter pkts 0 bytes 0 ]
 "
 
@@ -340,7 +340,14 @@ bridge filter OUTPUT 10 9
 # - lines with bytecode (starting with '  [')
 # - empty lines (so printed diff is not a complete mess)
 filter() {
-	awk '/^table /{exit} /^(  \[|$)/{print}'
+	awk '/^(table|-P) /{exit} /^(  \[|$)/{print}'
 }
 
-diff -u -Z -B <(filter <<< "$EXPECT") <(nft --debug=netlink list ruleset | filter)
+do_check() { # (expect, ipt)
+	diff -u -Z -B --label "$2 expected" --label "$2 got" \
+		<(filter <<< "$1") <($XT_MULTI $2 -vvS | filter)
+}
+do_check "$EXPECT_IP4" iptables
+do_check "$EXPECT_IP6" ip6tables
+do_check "$EXPECT_ARP" arptables
+do_check "$EXPECT_EBT" ebtables
-- 
2.51.0

