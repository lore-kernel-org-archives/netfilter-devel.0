Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37251E442
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 10:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861786; cv=none; b=k+7bGqL+ona8+E+n7GKqI7hLTrCuLznlPwy/y+GwdBhGDjbEy51FHXu3y2OVQCEPAaMXD4UH6pAOer758BfWK05y3f6Yod4YiasxsScurdpFAVtEaXiO0cG9P9tPrp1sSADgLV//bFivdm9QRRUz4HVRK5or3dYv/W6mgdAdBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861786; c=relaxed/simple;
	bh=saOuamlvLzL6uvDFnkHewRpyOWyOxWOljMAaDAWY0Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CG/P+ftFAeQYLBhIxXfLD7Xv8riNRaFRSyz81GWUIRhB8VpCfycPKSiXeoDL7dFnCTOuY70BSfj/mKBQeDuBWM40kzt7BQbqO+WclDsC8RnPUfsVWrezZuhZEBS4Ecii1RYDCVciTEJjAqK3KdkLjkNzPk2b0Ksbhn/jTpmu0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cC0y1l5h; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cC0y1l5h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ypBQ6BcnOFsTGnfA9V6G8+/NPVd2+vCgi/M+miMyqq4=; b=cC0y1l5hx7wIZWK6y7G+2RstWl
	OHv9JqK6Fg0f0UWHhyk8apiVHTlTFx873y7zdrPnPg0wn0MPJMbG+cJCYw1tOs9tJV6fxogbU9JtT
	CB7U/Ip/n+S2vETS4X5R190H5WIvaCRjag96dtxdxLNQd6ApBSuLIIiamu+Oxddli5qMd6o+dI2T0
	2X5S+YnncSGo6Fh0Gkxh87VxhrysyyVE8HrS54YvxDLQ9yf+EhjntovOgiVDRj6mAMr3PipUxXlrm
	7fXvs2kWq8GehXt+zZesiB/mvlFW/jI9QULJi6Ef7PcPxKKdyGraA8nhtAyLPiZPA+94Z8buaQVK5
	GP77oAVg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3sfN-000000005S6-3MLq;
	Tue, 08 Sep 2026 12:03:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/4] netfilter: Conntrack counter review
Date: Tue,  8 Sep 2026 12:02:52 +0200
Message-ID: <20260908100256.2648175-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intention behind the various conntrack counters was recently
discussed as part of a conntrack-tools.8 man page update review.

This series adjusts counters accordingly.

Phil Sutter (4):
  netfilter: conntrack: Untangle insert_failed counter from others
  netfilter: conntrack: Untangle drop and invalid counters
  netfilter: conntrack: nf_ct_seq_adjust to return error cause
  netfilter: conntrack: Improve invalid packet stats

 net/netfilter/nf_conntrack_core.c   | 12 ++++++++----
 net/netfilter/nf_conntrack_ovs.c    |  2 +-
 net/netfilter/nf_conntrack_proto.c  | 14 ++++++++++----
 net/netfilter/nf_conntrack_seqadj.c | 24 +++++++++++-------------
 4 files changed, 30 insertions(+), 22 deletions(-)

-- 
2.54.0

