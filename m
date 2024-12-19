Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231971853
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2024 23:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651736; cv=none; b=mdUseZtHF2ogByl9GdYTNgyp2x/z0nr4EtIM9WGtEnGP4xjzG+OB5awGYPw4tEwy2Q/V+UvUgROJMCHRnQx6hBzaOU0xJR3yQiZ3zlqGSNpzGdXkhRF2/Te9Q5aSUshzMJWmDYj/7MKbwij8V/8fAlON4KlXKlmxHYz4CQkHtXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651736; c=relaxed/simple;
	bh=R+egoJtSZx+LkcVSxQAmTgaTSDNhRQHLw8npln470YI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W/U/xONWzX3QUL2ETTmUGOzVchIPDYGyzkenNLmU1h4Ui43hSi+RDgbdLA/BlvtL1uEFJ8Cr8c6C5flC1H3eiYptPWLbahV/k7hRs2IRnMCT1mdqI40dqnRRCSB8FyV2X7JX4B9kmTGsX+w3Wk0+7dfl8I4LO4SqleQkbD9ulQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=ET0TH4AI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=10dls7ey; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="ET0TH4AI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="10dls7ey"
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1855125400AD;
	Thu, 19 Dec 2024 18:14:32 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 19 Dec 2024 18:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1734650071; x=1734736471; bh=Dz
	5bHaVD2UHJoky675Kv+o3jemjmAAczQTnooD/ZsBw=; b=ET0TH4AIxQhOLZOJSV
	qhuLyqWTqtJasK4EScuqNFnCN49Ei2Yj1MnWuAOCBIjPS46xyJqKxg5cG8snFZ2B
	QZZ9yY3meknjppz03T3BY7Q1g5Nts0fljmK9xXo5Nl3Q3UKAE5rGNB4f+kb6WLou
	Qemb8qtLsod33mcM7Zk8sDpNSPLeMaURSLeNc5mQm5wGqCl0CsQLRsXL3FuM4hoU
	/ph62fB2Ui8vQ318sb7iTb01ZFP3heO1VyHVeMc6GcRPhc+uY/ypERHd7AzzGnoN
	o3sQ0r6zSsl745qVnmp3zaVRhDSPRRpSrZXKeWeCereIp2cBKMuxXo+efgAAMqWH
	kHgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1734650071; x=1734736471; bh=Dz5bHaVD2UHJoky675Kv+o3jemjm
	AAczQTnooD/ZsBw=; b=10dls7eyrZXcSCP5cwmUg868kvoaVHNO1gY8ydDW5/hi
	Mas9pr+jhM53Xdxq8aSQ+J1+TbuUWy9XKzNPKiDDqrXh2BqvV14ld20BqlcKvjnL
	rU9Eh6TmLmd2T0T18jScmK8ObwW23GoquipcqW6zEafSyAW4idtJ7ebpnKUbgCBs
	5PHhkdmomuc/ZwdI41HyPcyKcLySXQQ8vRiRf8/M0kOFZxT0YhC4KkyaqyTgsGg1
	d+ke2r3n1UvWAN04L3bOhuHxut4q4+KOFXV7d1sK3RFiuij7PJXNb9kMvNyADdt3
	p6rEHskr0Badzbneq2UpOD4pqWj3A8pXPf2ZOcVlAA==
X-ME-Sender: <xms:1qhkZxC3PJYrQ3QK4-zF_wyCVYX8sGuKZHc5Dz74sdImxo5fytgv9A>
    <xme:1qhkZ_htCG81m58OFrcLRfSyZ2c3YCrcQ-2ikXCs9sOX8xHRxIDVc6U8bV1ACIgHo
    7BDo86PpriRrdu3yw>
X-ME-Received: <xmr:1qhkZ8n6Y0FL9uaRWGde8A9dnL-L5at7kuBR1dZfOdt0o0plot77e9K2LCOLSgbKp66bmNhbczrJpZs2aRPp1Bptqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddruddtuddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffvvefufffkofggtgfgsehtkeertdertdejnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeejfeehffehjeejgfdtffetkedtgfefgfefjeegffekjeejgedtveej
    leehleelhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepjhhoshhhuhgrlhgrnhhtsehgohhoghhlvghmrghilhdrtg
    homhdprhgtphhtthhopehphhhilhesnhiflhdrtggtpdhrtghpthhtohepnhgvthhfihhl
    thgvrhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:16hkZ7zJEW9aZncCX3TEI_Xggq6K_KvuHdylnB-ASkf5cboKjuR6aA>
    <xmx:16hkZ2SRZYMLvxcQmHeCB6FidhHLl7-41cz8g5OhPAEGdykN4HtqJw>
    <xmx:16hkZ-Zb9XN0y3paa6SMNDShKhwYWlixpR9J1xHxH7DG5C0vRKj3lQ>
    <xmx:16hkZ3RWrm4CEh2-DiYEINgnOYSrFp-L-dfaNKeCHWOiWBC-1La1jg>
    <xmx:16hkZ0cYm14Ba7cYXRNJt3_gWRVd04Xi0UGgBKZ0yVvfdafkZuooLjEn>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Dec 2024 18:14:30 -0500 (EST)
Received: by mbp.qyliss.net (Postfix, from userid 1000)
	id 29A7BC950; Fri, 20 Dec 2024 00:14:28 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: netfilter-devel@vger.kernel.org
Cc: Phil Sutter <phil@nwl.cc>,
	Joshua Lant <joshualant@googlemail.com>
Subject: [PATCH nftables] include: fix for musl with iptables v1.8.11
Date: Fri, 20 Dec 2024 00:10:02 +0100
Message-ID: <20241219231001.1166085-2-hi@alyssa.is>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since iptables commit 810f8568 (libxtables: xtoptions: Implement
XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:

	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/et…
	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-iptables-1.8.10-de…
	                 from src/xt.c:30:
	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
	  115 | struct ethhdr {
	      |        ^~~~~~
	In file included from ./include/linux/netfilter_bridge.h:8,
	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
	                 from src/xt.c:27:
	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
	  173 | struct ethhdr {
	      |        ^~~~~~

The fix is to use libc's version of if_ether.h before any kernel
headers, which takes care of conflicts with the kernel's struct ethhdr
definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
header not to define its own version.

Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
A similar fix would solve the problem properly in iptables, which was 
worked around with 76fce228 ("configure: Determine if musl is used for build").
The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h, 
rather than manually by users.

 include/linux/netfilter_bridge.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 6187a558..78ec2cde 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -4,8 +4,9 @@
 /* bridge-specific defines for netfilter. 
  */
 
+#include <netinet/if_ether.h>
+
 #include <linux/netfilter.h>
-#include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/if_pppox.h>
 

base-commit: 3271d78e70ec75246e8a61a6791fe22b8d89c2c1
-- 
2.47.0

