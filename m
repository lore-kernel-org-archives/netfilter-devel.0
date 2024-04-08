Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C77C7482;
	Mon,  8 Apr 2024 21:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611126; cv=none; b=dhbn+0RXWPwdZD2odF4Q0hr+cbxkvYiFZAKgcOjO9u2/NKkjtP6N7vsScpxDK38bIVDcpIMe9NeT2zX8JvXUcJkIOGEqd6PVXsBOXgJOMZ7lUCoVH584dckYVs50G7F7qRsEvqN/VR+UHPtTPi1A5Yg+OtYU5mGT6n/5wTRcjY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611126; c=relaxed/simple;
	bh=/CWr52yAcLFZfVd7/0sVqogaWieMIAQlyCOgGSO5+xg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ri3p4A4r36A3tnS1lODpWnppZ7Tiv3WV+5iQiX2ElyoiiE3tvNNI3nqYrXjhFcNIIRqXg3Iw6hbNahTvj8JnpFfHZt/RnIm63An+V1GVHYYs5m67ujKHgKhLzs6Ck3NAM3JHqUkUMv4mLYcbOGi6dhygDzR/tPYIQodFBThbrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Subject: [PATCH -stable 6.1.x 0/3] Netfilter fixes for -stable
Date: Mon,  8 Apr 2024 23:18:31 +0200
Message-Id: <20240408211834.311982-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for recent fixes already upstream for 6.1.x,
to add them on top of enqueued patches:

a45e6889575c ("netfilter: nf_tables: release batch on table validation from abort path")
0d459e2ffb54 ("netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path")
1bc83a019bbe ("netfilter: nf_tables: discard table flag update with pending basechain deletion")

Please, apply, thanks.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: release batch on table validation from abort path
  netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
  netfilter: nf_tables: discard table flag update with pending basechain deletion

 net/netfilter/nf_tables_api.c | 47 +++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 11 deletions(-)

-- 
2.30.2

