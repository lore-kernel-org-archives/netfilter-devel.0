Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9962F9992
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 11:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207053; cv=none; b=dOZ9TW0SWeyz4UmxvtK+31Dvqgtl3/sv4dqQU1WBUE/9z/KNFbAHST/W2l7P7atSWOvB4dzNSWf1sbHyLkua13XHZxediBZwHwio0ZHIWOEiGtRb/Tk7kLjn1TP7aDJoscOujM614V9LHv1MnKH9f4mFi9miZVFNVUtl/ESM0/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207053; c=relaxed/simple;
	bh=Q0PKmyrY0ijWdJjPgfXjYvLIYdZRhsHfDb8Xqc+jcdY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZVvweQ2lMCNdOjfHrs6YN767bfg1P84aA2cziQXODR/L8MEymkNrdTJ8W75RJvvq0a3BmuIIAYywqjP09va7a200WncDSXgpTIbM+RAufBPq5aw6qekvygi1DXJ/1Ngsj3Qw2seDTXWQIofkkXlzwqCi7cSrCZkmKDuGWP066N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=doHb/dTo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="doHb/dTo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ryxoj9WgL7+S99FdRkBiSW5frTSFEQUa4Uk81rm78S8=; b=doHb/dToYk8eUqjJyn9QOwJ+zK
	0zCN/cjsskjvXdzC5sihmXK0lYkENDmoCS75xNupoNzr2e6RGs5/A4hHiSje2mHkFrj6SmB7DzVvv
	hpJR8RP2bkMAZn6227lwBOGxsIoiAlQxQ5qHAox6/G4+s2W+z5kqP+E9INQNqVoha041J+UL2s+ru
	7zCALx5sLmDroPFC7BH6E7PjjOs5/tlh+9KYsfKyhkzvCAqHq7P4yTJtXK6TRbLw0CZANKCP+ua6F
	U3GsFKk4ZrnGieXGiWO5ZlyhFlsrnWxgTkZMlbttmOlFJ4y08f7IVis0hKEW9WbeM6Jh4DT8635FH
	NpprejdQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uqrN0-000000002r5-2kJe
	for netfilter-devel@vger.kernel.org;
	Tue, 26 Aug 2025 12:57:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] trace: Fix for memleak in trace_alloc_list() error path
Date: Tue, 26 Aug 2025 12:57:37 +0200
Message-ID: <20250826105737.32345-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The allocated 'list_expr' may leak.

Fixes: cfd768615235b ("src: add conntrack information to trace monitor mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/trace.c b/src/trace.c
index b270951025b88..47f4c2159421e 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -258,6 +258,7 @@ static struct expr *trace_alloc_list(const struct datatype *dtype,
 	v = mpz_get_uint32(value);
 	if (v == 0) {
 		mpz_clear(value);
+		expr_free(list_expr);
 		return NULL;
 	}
 
-- 
2.51.0

