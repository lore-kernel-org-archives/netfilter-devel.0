Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10D320A27
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920191; cv=none; b=I/mQJ9JVfCnHsbiOLsD5WNqbPdwizi2C1Lbg2pPLwG0UORDVnhfH5x9Hxhv8nS9URqEOg+r06l4nf8ssXQO9V0yZ1oRaW4xYrhjlJbgP6DzUhT9xFTvlYR2ga9+aidEOk62+pRBbr4zmo3avSiM8Qr+MCxCDIHpblg0zjZYQL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920191; c=relaxed/simple;
	bh=GwpG4H5ur4h8WpqWo8b1CoU+Q5QuZFZUd8fdN5d2sg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+gb8BvkvNUfECMitVRODZnjvOqhnO3YWkK3nqz/Mvzfya1KSb18R2DnfASZLHzH+oIykDCWYzZunQ3OhMBOTegX+nYRyX2eIKNn9T/FMlLAkbu/aEGJ+qLeI0CbmT75cxNCSpRuuGqxw9B/cgSZJKLwx/BKluJioleEbCW+DwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JWWdYeWy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JWWdYeWy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=inw2XWOjOrIiplRsyzR5cEK0ls33Ophqcvd44/gcrJc=; b=JWWdYeWygz0HSqlR9op0K5gl1m
	4BhQCIF4PDH7dJ/PPjatM3gSSH80c3B6dwUBZNVE+deIh+JPTfS0RtylDDYcQzJaOUJk96q+zy2K3
	1uhWnochS8HoLogDeRgCjMQXOLgaQ/w7isUVaGfUdn8PkhitrCAPNr2piMgW7bdmpLiKAPQd5Q+FH
	6ziOJ0QlU/7xyLXnUV2bxttRaQq3tevg5Etxz0LT00q/Luy3Oslwu/Mr79miKWKeoF5svv4GQw0eX
	SXj7dxX2bvQjhlCGoHS6uDfyafSWeUSHjuTekQorb8kbgJ27vUirpgKp8VU/MyWcgiRZ0bSBtkIU1
	sKeay7Kw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCO-0000000080f-2YtS;
	Wed, 03 Sep 2025 19:23:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 02/11] tests: monitor: Fix regex collecting expected echo output
Date: Wed,  3 Sep 2025 19:22:50 +0200
Message-ID: <20250903172259.26266-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>
References: <20250903172259.26266-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No input triggered this bug, but the match would accept "insert" and
"replace" keywords anywhere in the line not just at the beginning as was
intended.

Fixes: b2506e5504fed ("tests: Merge monitor and echo test suites")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 03091d1745212..4cbdee587f47c 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -52,7 +52,7 @@ echo_output_append() {
 		grep '^\(add\|replace\|insert\)' $command_file >>$output_file
 		return
 	}
-	[[ "$*" =~ ^add|replace|insert ]] && echo "$*" >>$output_file
+	[[ "$*" =~ ^(add|replace|insert) ]] && echo "$*" >>$output_file
 }
 json_output_filter() { # (filename)
 	# unify handle values
-- 
2.51.0

