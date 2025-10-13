Received: from 3gy.de (3gy.de [202.61.255.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522192ECE8A
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.255.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760376286; cv=none; b=aKOY3IRTIi60CxurIhcn+L/HQ5NnZvsw59cwMmWdEYvtCXV8FGV4ShUZM7iErBniD2SHyNYfckDRU7hN6OsUGI5cboXoVJRgbwOpSObQ7F5RX3cNh07jlI+n1ehCuzYajodm/MRIMnmHdE4SOPQUXFDcBzfKV540waNq9jvhsNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760376286; c=relaxed/simple;
	bh=AwjUALjxczaNvvgjIekcoXU8A+wAoOjQdoXpHDQLr3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k7i04EWxsTdzrQG6hV8VWmnlWAxzt6mkwn0kZfHRgutB3IlpOtgq/MoCBP0nX+n3gvNcCLW3AiSu6oh++i6v8g4ZuCRZsPlAmCId+BvS7fimNIER0qSPUgIJ8i/SycbS0ubvVd9B6JLcPI6v8yha/2snDObyRh6yP1X5scwDhWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=syscid.com; spf=pass smtp.mailfrom=syscid.com; dkim=pass (2048-bit key) header.d=syscid.com header.i=@syscid.com header.b=J1NUyUP9; arc=none smtp.client-ip=202.61.255.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=syscid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=syscid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=syscid.com header.i=@syscid.com header.b="J1NUyUP9"
Received: from bittersuse.home.lysergic.dev (unknown [IPv6:2a02:1748:f7df:9c80:c412:abff:fef2:22ae])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	(Authenticated sender: georg@syscid.com)
	by 3gy.de (FREEDOM) with ESMTPSA id 6DD804320E84;
	Mon, 13 Oct 2025 19:18:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syscid.com; s=light;
	t=1760375939; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=MU03XsjZtw1vGqQ5hLhc/uxDlfO0jxjxJYRfriuLWd4=;
	b=J1NUyUP9PCHTJ+ffKrI7lgdDzjd+85SycHPZbZaJpHQBt+w2MDQU1BgNqN7vexHnYkynWw
	fdexxyYHBGTBEe6NEMGUGGX6Rrg6SAm846og/wxxYyFOkRSR2W3Q2XfqFvKiADOy3l4cUw
	6tZ5DOcLORjeKVpdOW+s2LoXxWPF5e3FSIb5479kMW+YkdZORd/XhWqo0p5+bfbkHWNaSC
	7PXadNXzsQPkuI0rNzNuP3nyPO/FE56JcB3DboNxPJx/DvNJxEUL7dnrWdL2d+KOxNrY5I
	SzO65RIZFvkVuyfR1om1Hk7Eo363f7pWPsu5kZTnynkMhW5zHeAWjGFC1kOWXw==
From: georg@syscid.com
To: netfilter-devel@vger.kernel.org
Cc: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
Subject: [nftables PATCH] doc: fix tcpdump example
Date: Mon, 13 Oct 2025 19:17:31 +0200
Message-ID: <20251013171730.1447005-2-georg@syscid.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

From: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>

The expression needs to be enclosed in a single string and combined with
a logical AND to have the desired effect.

Fixes: 1188a69604c3 ("src: introduce SYNPROXY matching")
Signed-off-by: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
---
 doc/statements.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6226713ba389..834f95fbb2a8 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -691,8 +691,7 @@ needed for selective acknowledgement and window scaling).
 ---------------------------------------
 Determine tcp options used by backend, from an external system
 
-              tcpdump -pni eth0 -c 1 'tcp[tcpflags] == (tcp-syn|tcp-ack)'
-                  port 80 &
+              tcpdump -pni eth0 -c 1 'tcp[tcpflags] == (tcp-syn|tcp-ack) && port 80' &
               telnet 192.0.2.42 80
               18:57:24.693307 IP 192.0.2.42.80 > 192.0.2.43.48757:
                   Flags [S.], seq 360414582, ack 788841994, win 14480,
-- 
2.50.1

