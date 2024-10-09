Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE39C18FC80
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471052; cv=none; b=LINwPEGrFzoURcr5os2KSZ3ooWZ3PHBHBCiZ1Ghjt/SzyAzGJzvlXBo+91FVUw/oKiKeGqlFwct6ndsOvr3qS07Ei8R73TqRvcox/6DoDoL+CZ2QShkxlcOx4npSp9W7HKCSlhYDjFGUBeDT39KNq91VTUBaYGSeaRirERo2x/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471052; c=relaxed/simple;
	bh=Q67xt6+sh/W2uvcqWYF+FsycwyS451FId+sFUqgkouA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROV41ZeJpCRUt7gS4qliT8cs/hK17qIxnrt4B5x5wUwvO5Zh8GUlCjYsv/hTNOn6ueBw8NnwPn/EfajXhRgNDiCEcXTrRLbB2aTIJwmxP8+Q5H3tE4enO+9IlKifHahxDgCL7wClCm6H3/POXAxtKOdBX0jJkCFNdWdJc/Il8rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=M4TLwxgo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="M4TLwxgo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d0oB95qNqMDTHziMIMuSyCYcjQGdxjjHgmoEeHLgpC4=; b=M4TLwxgozjByoiIYvhJ0kop/Wx
	c6M/GaoFm5kUf5MWS/WOVaDQ1Ls2Y5iSkK+dYbR51p5ZDuWFN7XcS9MzS+erJS8+lZbsz8abbdfqu
	0/Qu2w2zfycVVJO4jh1yskj1q3uIfe3rAZCDuNRYYSC5fw5w8RqZFBcujRwzxP46raQJ/YcjX+Ikn
	E5ZbODj3LV6OUoE6Mha+jpOyMhRT6n25prU/bH/RmNnmvTU0BIkEjVfW+SSiMZZxZXQFpxVFvh/HR
	XK6+w/Gp3mWmfbqMma6ChSFMHBvTaivovbL/TBT4LGqihhJNGddKABBYpAbw9hYkkerwq6nBgEyHP
	f+9aNtFQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHD-000000007QU-0lDV
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] man: ebtables-nft.8: Note that --concurrent is a NOP
Date: Wed,  9 Oct 2024 12:50:35 +0200
Message-ID: <20241009105037.30114-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For obvious reasons, ebtables-nft does not need file-based locking to
prevent concurrency.

Fixes: 1939cbc25e6f5 ("doc: Adjust ebtables man page")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ebtables-nft.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 29c7d9faf8106..8698165024de1 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -358,7 +358,8 @@ When talking to the kernel, use this
 to try to automatically load missing kernel modules.
 .TP
 .B --concurrent
-Use a file lock to support concurrent scripts updating the ebtables kernel tables.
+This would use a file lock to support concurrent scripts updating the ebtables
+kernel tables. It is not needed with \fBebtables-nft\fP though and thus ignored.
 
 .SS
 RULE SPECIFICATIONS
-- 
2.43.0

