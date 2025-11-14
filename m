Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA0821B1BC
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079956; cv=none; b=aO6g0T6YO3EZpbwU5AXe0/oidjCl/GuVbaUh7X8nXV2eAIK3tgQqfl1aMbzpkMzjO6OW+riPXdGJrjpMRgh7wBokzWIG/7m4YKuu/nkKaMYsAbj1/jPrqVvSpdPm0AqO5Vg+IK6R64W+drBMd7pP270Rvq16xQ8JKVCXWeA3lmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079956; c=relaxed/simple;
	bh=qoFGnSXp5RBnXkFf5REuo2m8HV73cbncX5HN2dMHU0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQkfw+X8xCsEy4qklfx2zCBvW8zh67htpDbOJWEEwvQGv+a/OA8FIHaqX/TNNm9B03YM4wHUPRafDGTXY14X0WvaGh4wyEHMNgQFeKBjmsuIGxSuDeGoxdYbvYhBOqTaVRmDPo2Bgx/ZbQWeOAZ9yW6nJNLyH4iVBvW5PkUDzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Cet2ITMk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Cet2ITMk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tCkNPu/YLXpx1sJDhRRTQNeE08i3WW5Li/zQ9DbRBrI=; b=Cet2ITMk3XAv0HjErGzzUI++UZ
	B+S0TrXjswAfexPiY6y5kMxv8dninXugbxK2JYG8rnzHQwN6dNkCl9ovwk75Rkrr8e3f+U5MzzyaF
	I6C9QzdjBuY0jbbCDLDv4o+7UngYzW9FiKQTqUzFbt03ZSd+055APq9zUCvxqbGURHo2PTIguGqIk
	//jokSAjkclDAvUuUvmVIOWFHIX3E5stL/SaWndjeSpVW+aqOKaectpy9DBIyNCGs3M4zOmQpUhyR
	RHd5FuBfYE87/SQ7FvrfOlKbDYd4UEkm58p/keg7N57I3I/9fpFx7ozchtMRGPecezXyHbA0AviBB
	6mIUyU+A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdO-000000005jy-0CSL;
	Fri, 14 Nov 2025 01:25:52 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 01/11] segtree: Fix range aggregation on Big Endian
Date: Fri, 14 Nov 2025 01:25:32 +0100
Message-ID: <20251114002542.22667-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Interface name wildcards are received as ranges from prefix with zero
padding to prefix with ones padding. E.g. with "abcd*" (in hex):

61626364000000000000000000000000 - 61626364ffffffffffffffffffffffff

The faulty code tries to export the prefix from the lower boundary (r1)
into a buffer, append "*" and allocate a constant expression from the
resulting string. This does not work on Big Endian though:
mpz_export_data() seems to zero-pad data upon export and not necessarily
respect the passed length value. Moreover, this padding appears in the
first bytes of the buffer. The amount of padding seems illogical, too:
While a 6B prefix causes 2B padding and 8B prefix no padding, 10B prefix
causes 4B padding and 12B prefix even 8B padding.

Work around the odd behaviour by exporting the full data into a larger
buffer.

A similar issue is caused by increasing the constant expression's length
to match the upper boundary data length: Data export when printing puts
the padding upfront, so the resulting string starts with NUL-chars.
Since this length adjustment seems not to have any effect in practice,
just drop it.

Fixes: 88b2345a215ef ("segtree: add pretty-print support for wildcard strings in concatenated sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index cf2b4f129096f..b9d6891e4b8f6 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -409,16 +409,16 @@ void concat_range_aggregate(struct expr *set)
 			if (prefix_len >= 0 &&
 			    (prefix_len % BITS_PER_BYTE) == 0 &&
 			    string_type) {
+				unsigned int r1len = div_round_up(r1->len, BITS_PER_BYTE);
 				unsigned int str_len = prefix_len / BITS_PER_BYTE;
-				char data[str_len + 2];
+				char data[r1len + 1] = {};
 
-				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, str_len);
+				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, r1len);
 				data[str_len] = '*';
 
 				tmp = constant_expr_alloc(&r1->location, r1->dtype,
 							  BYTEORDER_HOST_ENDIAN,
 							  (str_len + 1) * BITS_PER_BYTE, data);
-				tmp->len = r2->len;
 				list_replace(&r2->list, &tmp->list);
 				r2_next = tmp->list.next;
 				expr_free(r2);
-- 
2.51.0

