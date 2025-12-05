Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB876026
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Dec 2025 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764978251; cv=none; b=HpXsRrhryCL6vYdadpUaUgGFJq0aTI042YaBOABxllBPjLq8VHaxfYhV+MQpgUzlaiIHnzHYZpQfZMZz/VCIVbxJfs9HMCaN/h91VUz/3pDI1HmAJSGGlmomRcmLHAt6TLU6ex/owtWSCt3y8eaq1HBAs/tew0/MIuOXdOmjMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764978251; c=relaxed/simple;
	bh=T+5ulhOLZghuUPPx83kYzTwpqjEjhfmt8rraXVTuRp8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B4csTJuGGIrxI6QSq/z11wMURqv+HFlS6eKVXegI88RDsxT2kY8bnrjSLrBXHzZV1W45vdaBxXLolPI1NbeynTfP6f8fBAtadRpErGEja72ZhvIBNkl2zpd+ummd7bjFpdS2z386ovvNKeGJVfbHDrv2/R4TAaSV6Blg6Z/7bzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=cNDjEEWL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yv5VkgmI; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="cNDjEEWL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yv5VkgmI"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 3F2EF1D000AE;
	Fri,  5 Dec 2025 18:44:07 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 05 Dec 2025 18:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1764978247; x=1765064647; bh=rIMmCEjK0cmd1bbPi8qm+
	bRVVuMTDde99XLwDumKUHg=; b=cNDjEEWLKkCKgcLT8EH1IpBBE0WOECnSPZUAD
	d9TuQ9Tzm5Tn2kuLlQK62d17jgjNAfb7npKI7Vb7INCFbjdXFYnc9DgpbmMkg0nb
	jeo85p4eM6Um2GNBKspcbmBZwxARwkqLjC/VDNnjloM5tU4HFjXQLNagX+UQ67Bj
	HkE/SuVMqPgrAe0i6/mETczKE78qJALmI5sSZbxpBBbqVKEo4Ekqitmwmbakk6Wz
	eTgyAfYeNsv+Bnc1vOIoNc/eIC0LxoZCkRfnVLQRPU921uB9c38vzhWml8u1eYvY
	+DfGpmOF09irEF+VSJ3u7d+0OeKz+ZSkJ2tg6CjeizrRK5YvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1764978247; x=1765064647; bh=rIMmCEjK0cmd1bbPi8qm+bRVVuMTDde99XL
	wDumKUHg=; b=yv5VkgmI+LQeH+J8SBBddaBmk+agXRsJ7HbzSnmy+8cswQZUmG+
	EStZ7P/+4stlCC8w75mLMvjvb9UAy6KV2VS1x5Tx6ccI/Nyr/8Gb074GIxEMtoVD
	W1huqJHVlwhwXEgnqHeR/MgEwLqKCzfh+ZbkbYZQvLTmZHJTTNW3DrJujCXzoRTz
	1+lXc511GPglU0n+gkrfPmT+TKaKAfOYP4Luz/JzaGoBFviBvsufLYDZImxuxSNn
	6pqWcsz5N9Blb/dvH4n82MoghCqK885Mg3/oC70fiVrcrEDgvZwXclGNIyAt3kXB
	W9+kLnYG7BLOMHNMV9yJ7e7MgBLImg7I18w==
X-ME-Sender: <xms:R24zafRWc31PWMbjZS1GVHmZL1kdLnx25fPtsEbDCjto9pfZ4Qyw0w>
    <xme:R24zaWzdvqNXfkLhPIEcMU_553UTqX08_hnaS7WHkx_sd0x5DtMbg5RSGN5fLmcfE
    IUaqjvyddVcOKjoXb-znEghfVs6jmAxGvo92uj3nlXFvZw98cnF8A>
X-ME-Received: <xmr:R24zaSdFDC9WLHv-pOEksVbLLqulkhreKiFu6sG0S-pO79EBqckiR-yJfDi0G5lbhAezDhXr0aFy8ZmRvqYzwaRbUEAXqxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeflrghnucfrrghluhhsuceojhhprghluhhssehfrghsthhmrghilhdrtgho
    mheqnecuggftrfgrthhtvghrnhephfekvddvgeekhfejudeiveeuiefhudekheejhfelhe
    duhffhleeggfettdetuedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepjhhprghluhhssehfrghsthhmrghilhdrtghomhdpnhgspghrtghpth
    htohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhgvthhfihhlthgvrhdq
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjphgrlhhush
    esfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:R24zaaLEKMix7I-wluwcZsErZ5kGB8Y78Gcq0blQNhBembvah7ZCFA>
    <xmx:R24zabHCI4UcXcGOOvmQEqpFLZHiwTgUrZIaw0tXUUc69rAtkKM2dQ>
    <xmx:R24zacrW6GfWX2Cb9j4sKTj9cKHLS6WSzn0VHP2tt56DfYVb_jLOsA>
    <xmx:R24zacSi6XgILEuIegmKytEoSfqO-ndHUo1gOMC7bOcFafQkubqblw>
    <xmx:R24zaSrvIugWP6g-Udk4bQXkzOAZ6vpOrfh0JvUEt1bBx2EoNtJzq49J>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 18:44:06 -0500 (EST)
From: Jan Palus <jpalus@fastmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Jan Palus <jpalus@fastmail.com>
Subject: [PATCH] build: avoid bashism in configure
Date: Sat,  6 Dec 2025 00:43:58 +0100
Message-ID: <20251205234358.29622-1-jpalus@fastmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Jan Palus <jpalus@fastmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 6825474b..dd172e88 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,7 +157,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
 	echo "	${STABLE_RELEASE}"
 	echo "};"
 	echo "static char nftbuildstamp[[]] = {"
-	for ((i = 56; i >= 0; i-= 8)); do
+	for i in `seq 56 -8 0`; do
 		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
 	done
 	echo "};"
-- 
2.52.0

