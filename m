Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB92874ED
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104761; cv=none; b=SP6E8BqIahYaNpDhtFaS4wqcDBttweomEPZGIh5V+TdPiW3Lssh9FN+i2uVrMstLbKqU6GEiHwG/WgVwLgcc4rbneJWh8mkbnxQmeg4336yssJ8FBIdWGpusgWEr07KglnFklk0L9U1RhCEmDSZSIIqFHVp4CDd5NRrkGtIRevg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104761; c=relaxed/simple;
	bh=ie2GTJiubcueSxUU9yd8fXR8I/DPuGojJ3mMh90/rME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dywGQofgb5VjCWGUatsqiXYpJqQltLdD6o1MSS9XaeNn7sT3k7aYy8Gc0R3pFA+xiMmnwBw9oiVTqXT9fYfU/rIlldm+PYXL3W9I6x7zhKZ45gwzcrrlU/mzsOgI8NdtpxDt5+gF4wLqVDmcGZekOpEhGEPDJN3+ptGEqtLGVTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DvUPhDrW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DvUPhDrW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VJkT+HEG6PZWh42N/zPhkMiA1iyDJrLwemaEOA1gTYk=; b=DvUPhDrWRgTAopohDbtZcReZ+f
	z9L4eA5PW3D2bE9zRnrMq/OQcjVXzf0JfevzITRMb+yUGUwBS0AQnuMEaA2NaM2R040G4QGfl2/rh
	/KZFH3/gyjHCvx4zaeF4pwf/0X8dwRqhI9c2vnmOGj2BOGvMBdWaW/jcJhIDOIw9GqIog2YaApq0G
	ySGHfsok3KNxX4xPDlFS+XUvDg93W/pzCZycvJzdhQtLQd2yp2/E4GBZcHWHkOZtCIn3HCcesBjzC
	+9M0y3QwZbxwc0E6aI+vdt02HaJbNRGSDQFF9H/C5ptaRqsozAe+AZPRxtM33hnOAeaUou7XFkvmZ
	PCTXXuBw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvF-000000003np-4ARd;
	Wed, 13 Aug 2025 19:05:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 03/14] tests: py: Drop stale payload from any/rawpayload.t.payload
Date: Wed, 13 Aug 2025 19:05:38 +0200
Message-ID: <20250813170549.27880-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There never was a test corresponding to this payload.

Fixes: 857904bdfaf7a ("tests: py: extend raw payload match tests")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/rawpayload.t.payload | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index c093d5d8932f1..dfc651e2886a9 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -111,12 +111,6 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000060 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000040 ]
 
-# @ih,2,1 0x1
-inet test-inet input
-  [ payload load 1b @ inner header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000020 ]
-
 # @ih,35,3 0x2
 inet test-inet input
   [ payload load 1b @ inner header + 4 => reg 1 ]
-- 
2.49.0

