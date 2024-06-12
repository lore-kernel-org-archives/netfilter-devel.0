Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779A1802A2
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718205210; cv=none; b=Quk+XhrwJxgDiBbCf19DZGdrOGCNCOz93Hd9CAfvJhW3+Nz8zEv3BAY0k+1MoDUnwTcX8wN7tfJMqhKd+VsTzK8FL8iTvf+3oDQStnR+Ro0X9Qk4ZK6QJ2cEt5rIqTNsDZqJAHKzzXbG49OwXgJzg5NyVpEsrhl6UKm1B4UfHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718205210; c=relaxed/simple;
	bh=8K1CjMjI/P//HvHDQVbJI2WPPoVl3SN8Dx2p16nMnFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SEFWoPXE0nNReU57QDRYhCYTdUnFcjxR+hnL02dF9utdy6AJ0DRz201A8GtoCUDBbydLK7Z9uTiSTV7y30KiDkPoeaoXPlsu7OC9OU4HRkpV8KSib0t/vtricbY55mREMFxzxXBdgZwpdEjEJF56/YUHN8roGcqYRii5RZl9viU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YH9iYpxB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YH9iYpxB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JfZgZ7lftpNYLOQwhAOxtI9Iw8KcrEAeP5ttCzJ+Bv4=; b=YH9iYpxB9B2ZCdcdnysV6wb3jU
	O63CpHtcE/7Z+wP2s1iHYpCHNbSXxf3Txu0Is1pW2ME+VxM9KhtkB13dwtt4PMoixOKvQifgtKzo5
	nYdAy7ZTz64/M4Qof8805PTrh+7Auq8qzo5n1zVc79VyhgxBo4ETd5jO3W7m7QsObwSjPEg3TpUMd
	3KRy4503zC9VGRwFT3HSf3FJJ8yS4fDjuc6vheH860SFW9nfhr+i44lkyCidDq14zmA1gQHXjGAna
	dGONuWDRSY5Gww4jC7PpFWqJKbVWi/HQ25fM/4U+ISxn24p34g5I1wDyY1EzQWqEmJ/KoXgLRA2SG
	lnGunymw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHPfB-000000003M9-0TsN;
	Wed, 12 Jun 2024 17:13:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Fabio <pedretti.fabio@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH] man: recent: Adjust to changes around ip_pkt_list_tot parameter
Date: Wed, 12 Jun 2024 17:13:28 +0200
Message-ID: <20240612151328.2193-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The parameter became obsolete in kernel commit abc86d0f9924 ("netfilter:
xt_recent: relax ip_pkt_list_tot restrictions").

Reported-by: Fabio <pedretti.fabio@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.man | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 82537fab9846f..e0305f9857e29 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -55,9 +55,7 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 address is in the list and packets had been received greater than or equal to
 the given value. This option may be used along with \fB\-\-seconds\fP to create
 an even narrower match requiring a certain number of hits within a specific
-time frame. The maximum value for the hitcount parameter is given by the
-"ip_pkt_list_tot" parameter of the xt_recent kernel module. Exceeding this
-value on the command line will cause the rule to be rejected.
+time frame.
 .TP
 \fB\-\-rttl\fP
 This option may only be used in conjunction with one of \fB\-\-rcheck\fP or
@@ -93,8 +91,10 @@ to flush the DEFAULT list (remove all entries).
 \fBip_list_tot\fP=\fI100\fP
 Number of addresses remembered per table.
 .TP
-\fBip_pkt_list_tot\fP=\fI20\fP
-Number of packets per address remembered.
+\fBip_pkt_list_tot\fP=\fI0\fP
+Number of packets per address remembered. This parameter is obsolete since
+kernel version 3.19 which started to calculate the table size based on given
+\fB\-\-hitcount\fP parameter.
 .TP
 \fBip_list_hash_size\fP=\fI0\fP
 Hash table size. 0 means to calculate it based on ip_list_tot by rounding it up
-- 
2.43.0

