Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83957137E
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jul 2024 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721435202; cv=none; b=Wo7o+ySocDseBfHZ+wmc4jSuXr4yWLuIOI3Ss7yYf3TID3q30rwytqD+4mNHgP4PAND/23+DAUt93zmNf5ZdTjUomOT9F8ZSz6RdLjUJ7wdqtPLoxyh81hH7QcNcTjE3izrKxnmUnPgJY6lcqipXdjKDnQV/K3sef8hi7Q2C2FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721435202; c=relaxed/simple;
	bh=9fdgu0Vw7J8YEyDUalsRwtuB/XjIW6UKOjb/JKJ0+sA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lvdkcSVJgmNpCGoXDtkmFYcragG5eW8V3YGvJ+gCYQFSPWX/uGjivlLeZxseRsASR0R0h2Bm+8EMjJIxM+uWqGfk0E1TLPQ/LVva7WjD8GpEgOIzwoE+mMOnYd45yZ/EIC94dHfjbC8euQ41Z6/90lcjfu7ZevgDVa5V6qjqFQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UBl/idAq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UBl/idAq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i0hZnZ9ub6Ak8l8tc9dVd2ezdzCDpPQjjHej8AIUj+E=; b=UBl/idAqilCChlpHvq0cDekD80
	n7gPqjme943imiCjVOcKF5hbadp3yMIMrc9uUI96ojOxVhDcW1uWsIjL20gDVnxSATNAviCMRVGLh
	8eNbz6pq0+9VWEvDZ8FrvCkyYrhdF2kU3oZ2qBWmlxixjhyDuvpiJ2qX/FA3QexSqetF4QdBfVita
	K7YfwWXWbPoiO7vxuBCfaME9VD8QpEuJtRBdp1Q67HriiFWaXMS7Kar5XSaY92PNXi1CHkaoIx34N
	gTkHfG4zhMMHnzJ/FaiNPB4wEJD23NyqJ4sj533ujst1IRKBTZr4cn1FiK6qgpXvCDuCFh2UCSmJE
	JJPR47qw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sUxvi-000000000hO-43Z6
	for netfilter-devel@vger.kernel.org;
	Sat, 20 Jul 2024 02:26:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: recent: New kernels support 999 hits
Date: Sat, 20 Jul 2024 02:26:27 +0200
Message-ID: <20240720002627.14556-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since kernel commit f4ebd03496f6 ("netfilter: xt_recent: Lift
restrictions on max hitcount value"), the max supported hitcount value
has increased significantly. Adjust the test to use a value which fails
on old as well as new kernels.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index cf23aabc6e63b..3b0dd9fa29c94 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -4,7 +4,7 @@
 -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
 -m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
 -m recent --set --rttl;;FAIL
--m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;;FAIL
+-m recent --rcheck --hitcount 65536 --name foo --mask 255.255.255.255 --rsource;;FAIL
 # nonsensical, but all should load successfully:
 -m recent --rcheck --hitcount 3 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
 -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
-- 
2.43.0

