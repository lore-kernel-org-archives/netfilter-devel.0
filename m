Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924AF357D1E
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790945371; cv=none; b=DpsF97+6F8VVR2xEeClT6K/HUo03ncpbo+O2Zhm394MQxIKBwfkTm7ICYkwtki2OV+OQN6P2VZAEIhvWTQfG9zKCJXjXpHk+o2STFmRjytGwHz2/jRCfndQC2nRz2m80OxSwg5StH+lDB5JDEiWccy2BiPNhszV39AXHj4zVgKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790945371; c=relaxed/simple;
	bh=aDg/oEqPbjLqnZ/0L/CDQ1I7mnDPUcIUx+xRuV94dn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DKA6o5Z4x2mFFSIgjrvVcMto/+9tV336Q41aGl5KdgI4xU27wMsOujNahsOVJFWfzkzy7RRuwDXI4TuQcnsrWPLHeaDgz+MSr4MQft+fjcoYwnTjW10jaJuQetqXBkc6UOdgSEFwYEk8uk2y0ERFmRuucpjCg85PueOH0yWE6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=X1PvfejP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="X1PvfejP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0wwpiehvdZIpaObwPk3P/yuZugHCYmpKZ6f5oJ+Ov34=; b=X1PvfejPUrDZDzRG9bE8owhk8D
	Cq58aB/aAEH127on1ZS1n/aQyvKpLCBPpf9BY8+5rUqURfOlZ2/gjPfm9EPZzo5sjSADDz0mVb62A
	WMtSaA7ajx8u0n/DxgiL93DHadSlvsjDBwmx75dFOdRbMBNWdUt9FFSOvpN0HVCsZ5qWFWBOvzfzS
	BK8JrLJmf+IOlBRvCqyrRZubxwwG2knjMTtbqydRMBofvkbhWGCNQdeT6YRem/1Ega2cvPIbQbGAk
	CUJhESoU9YkCLCvmHWtIG9t/nUeomzB5fLZRJO4L8tWRDNatlzTyZfclGxCrKPQo/GhleT586TCAR
	GuvbZXYQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xCchV-000000007iF-3UCz;
	Fri, 02 Oct 2026 14:49:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Subject: [iptables PATCH 1/3] extensions: libxt_conntrack: Fix inverted ctstate translation
Date: Fri,  2 Oct 2026 14:49:14 +0200
Message-ID: <20261002124916.2264622-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Special casing for SNAT/DNAT conntrack states was broken with inverted
matches:

- Wrong bit in invert_flags checked (typo?)
- Missing space after operator (cosmetics!)

Reported-by: Balazs Gulacsi <m2gulbal@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.c      | 2 +-
 extensions/libxt_conntrack.txlate | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 04940154eb314..2b41213edb0e4 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1230,7 +1230,7 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 		if ((sinfo->state_mask & XT_CONNTRACK_STATE_SNAT) ||
 		    (sinfo->state_mask & XT_CONNTRACK_STATE_DNAT)) {
 			xt_xlate_add(xl, "%sct status %s%s", space,
-				     sinfo->invert_flags & XT_CONNTRACK_STATUS ? "!=" : "",
+				     sinfo->invert_flags & XT_CONNTRACK_STATE ? "!= " : "",
 				     sinfo->state_mask & XT_CONNTRACK_STATE_SNAT ? "snat" : "dnat");
 			space = " ";
 		} else {
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 0f44a957878e8..79b34df9e3586 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -55,6 +55,12 @@ nft 'add rule ip filter INPUT ct direction original ct original protocol 6 ct st
 iptables-translate -t filter -A INPUT -m conntrack --ctstate SNAT -j ACCEPT
 nft 'add rule ip filter INPUT ct status snat counter accept'
 
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstate SNAT -j ACCEPT
+nft 'add rule ip filter INPUT ct status != snat counter accept'
+
 iptables-translate -t filter -A INPUT -m conntrack --ctstate DNAT -j ACCEPT
 nft 'add rule ip filter INPUT ct status dnat counter accept'
 
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstate DNAT -j ACCEPT
+nft 'add rule ip filter INPUT ct status != dnat counter accept'
+
-- 
2.54.0

