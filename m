Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9C6383
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730842398; cv=none; b=Wm98G5OcCPOqfD6FJMSSySm4NRMHlOw+ioo5++9R4ReYd8O4hV+LMTXyqYNIWwuZuZ8MKHmYBHCeDGrM//MFC1UP8YmUEfU2Mm4xYsK8Zh4kAEzzlpnsCWg7aazFyRhmKaXuSZzq2Z0K3PS1yROz1vOtyMa1Tiq2bfuGmWi8I/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730842398; c=relaxed/simple;
	bh=Un78mYqrHze5CoW2QMyt4SQdCHdeEfgbvp723NFrHUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VuAc3ARWjNe89PijfM2He/gBQa9xBeRiyJ5QpL5egvMnHPN7Rheyg1rvDgwMzm2yUmBzvyOFslpxPqcNjNBZO0tIhZd+XdXvP/4pia5UCP4L+Os4+YgwGogPpfFqQY5/WjBHYMvEZptdsacIBVnpe36B3nEHzKwOKvqsdhxSifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=P8F9wIfJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="P8F9wIfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TVF9fP0CVMHrirgEY3GKN+Fg8Ly6kYJejd4UDRF/HW4=; b=P8F9wIfJJc65PG/oW3nNU/dofW
	cJvfLg1/QhiNF2ps5AjMv4eMADp6UM28279rVwDtcZprp7s2MIZG5+/ZQN9cSD6uhbO/nzbCty7N0
	niPcBmqLkl14fZaIPJWQoxM4U1pMr3XZX+iHCkXPjQlzEj0nNxJ+Qqrv8DbPcW5CUzx/OwC6LPfFE
	8RQ8U7NYSmibdZjphhbrudrhxE0ev2sc8ZnPiP12ToDYMkjLGevJwhv01Zjwnf7q6bouVXrcFZJCI
	fOwiMJSgQguQX9JRnOwm6cp2DcOZVmg5xcP0KZWKh2ylL9C1c5i/W8VRlWycHkN+4veovjBSplsMn
	UOBpAwEg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8RAo-000000003sw-1OAf;
	Tue, 05 Nov 2024 22:33:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] conntrack: Fix for ENOENT in mnl_nfct_delete_cb()
Date: Tue,  5 Nov 2024 22:33:10 +0100
Message-ID: <20241105213310.24726-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Align behaviour with that of mnl_nfct_update_cb(): Just free the
nf_conntrack object and return. Do not increment counter variable, and
certainly do not try to print an uninitialized buffer.

Fixes: a7abf3f5dc7c4 ("conntrack: skip ENOENT when -U/-D finds a stale conntrack entry")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a51a3ef82fcfc..52ba4ac5e44f7 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2030,7 +2030,7 @@ static int mnl_nfct_delete_cb(const struct nlmsghdr *nlh, void *data)
 	if (res < 0) {
 		/* the entry has vanish in middle of the delete */
 		if (errno == ENOENT)
-			goto done;
+			goto destroy_ok;
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
-- 
2.47.0

