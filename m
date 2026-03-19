Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8806D3D525E
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773927142; cv=none; b=kHtWYF+BK1ZYZcmH6VQOC5FwZGD12DVC4UePvm/L2LXaT2NfcOb6TAU6Nmi8lmwHS46lAyyNQ1fPUMM3WJLSSJxH6CxF5mF8Os811TvLbv+8hS8QcBgRY6FBq6XMoGcw5WWUfNsnf6RjXHOtfl1GHNK8RL15j2V1hgp4hDlgq4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773927142; c=relaxed/simple;
	bh=m8/hicYTxzxBdyPv2++8R1ncfLp2/PoQjd6v/USvuh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=upFyZyqkk0B8yFuPnRIGkQybDr9bThfkI+mASo5F+m++TT5cNurLd1UL5ci6dD5alVAThPZ1lhLYaroZ5hWyJPDBLvRmIj3hB3Ob2Tk9XPxkGQQEyBEpAUaJoUNmBPY1/2zd90OC7NxKfFBtWsd5egIg3JrMhIAdWU4uJDtoS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p1V4eNaR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p1V4eNaR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gqkq/GJyo94wOTaDLPj7UNSBFltTgXS8sRZIPDKFv/0=; b=p1V4eNaRWmGzQXEecscJcubJym
	tLklAEJhKvYwuik55D6aVJsPvSDNbGFvm4hchFVwty3L4ZiNRJ03Ti0NqmMuUienuX3OdE8rBYe0c
	qvDs93diDhSgVdcHrTXgatzs/ooX7cq9jg2MSfC8sL01lqX4QC5+ZvaJ1z2c89cp0/06WQl2Dh/v+
	+Up1OtJrl8ohNdo1sGqVN5f0qGzMfsK9+WISmz7pRL/aBrCo644r2s+mw5Cw2MbdjflcKfcLYfC7C
	u4+m3SgyRDxElNyIziJRKwyZiZUq9ZyxG5Lrj0NIQVjwI1h3fbj3MyL5fMFQule83Tui1udETHFOb
	8O+KAV+g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3DTx-000000004AG-1Hlz;
	Thu, 19 Mar 2026 14:32:13 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Winship <danw@redhat.com>
Subject: [nft PATCH] segtree: Fix for variable-sized object may not be initialized
Date: Thu, 19 Mar 2026 14:32:08 +0100
Message-ID: <20260319133208.19823-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Seen with gcc-11.5.0 on an aarch64 machine, build failed. Looking at the
code, r1len (or r1->len, actually) really seems variable. So use
memset() and fix build for that older compiler version at least.

Fixes: e8b17865833b8 ("segtree: Fix range aggregation on Big Endian")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index bfea2f64ed812..a12820bcf1ece 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -426,8 +426,9 @@ void concat_range_aggregate(struct expr *set)
 			    string_type) {
 				unsigned int r1len = div_round_up(r1->len, BITS_PER_BYTE);
 				unsigned int str_len = prefix_len / BITS_PER_BYTE;
-				char data[r1len + 1] = {};
+				char data[r1len + 1];
 
+				memset(data, 0, r1len + 1);
 				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, r1len);
 				data[str_len] = '*';
 
-- 
2.51.0

