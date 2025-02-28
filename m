Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7492717A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776994; cv=none; b=GFy83tFb+tdcYty6f8HDMVFPDBSa3a92ukNG+mkZnowkM89cewlRPdTJtY8/p4t2AeO6hj5Vcm6rDyFsbhcpJqwxqraqDj/Ox6x/ZwcI8v+UixwKbxDKStCfZS6RA/uIzMZxBRR7vv+4mVZv7K9rn87brHjiBPlnYcqMExs+JnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776994; c=relaxed/simple;
	bh=ocmlUg1DqNu0YjevI4iXcpFrBXTZyqv7TcsGMJExJwM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=cFCNpQizllEQv0//OxxXzY9CaWRdsrC/OisHc41USfXA6UIu7iCA81UVDCWTNHqAsWW7OaCuRnsoHaUSmBWQvNhmiqiJbFXxsr53w0PleosCHJ0ladpJ0GcQxRqH5oEmet9ZVEEPUt6hxeW+qoTByZhNjVLHvH36LkFCAsf1C6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MiDj7Yl2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MiDj7Yl2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MiDj7Yl2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MiDj7Yl2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5323660311; Fri, 28 Feb 2025 22:09:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776983;
	bh=lIljgY+tCoPP7DbIRkm+xV6S2lAUE/vzhWT7dhyY1X4=;
	h=From:To:Subject:Date:From;
	b=MiDj7Yl2aO6gBLCe/6lp/W9jbc5iHMFgZkneX3NJQiByyO1z8SA2NjHUFRzXqrLcQ
	 xbx+Wv6ex1AtprSzM8Pwj5yluafG6WSmciLO2dbVwosveWzQ6KEthJ8WchkqNlRJx1
	 nV8HcApeACu5advBSboDjBbzHbSwgqI/QIITtry2VIIVkUnZ/fX45XocgXNuDY/7Td
	 HTJDfdrWOq2NvYK+Liv5e6sMgP0iqgOfChB6jqcjXChvsjMRrrJ+9bbJd4228iYuB+
	 pYId707bH7baH9OQgD0Dtxvkvx1TkY5oOfyEAKjwc8ZLV4BblnAmeA476aorKFzDQe
	 GPqFfo4P8XJdg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DBED86030A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:09:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776983;
	bh=lIljgY+tCoPP7DbIRkm+xV6S2lAUE/vzhWT7dhyY1X4=;
	h=From:To:Subject:Date:From;
	b=MiDj7Yl2aO6gBLCe/6lp/W9jbc5iHMFgZkneX3NJQiByyO1z8SA2NjHUFRzXqrLcQ
	 xbx+Wv6ex1AtprSzM8Pwj5yluafG6WSmciLO2dbVwosveWzQ6KEthJ8WchkqNlRJx1
	 nV8HcApeACu5advBSboDjBbzHbSwgqI/QIITtry2VIIVkUnZ/fX45XocgXNuDY/7Td
	 HTJDfdrWOq2NvYK+Liv5e6sMgP0iqgOfChB6jqcjXChvsjMRrrJ+9bbJd4228iYuB+
	 pYId707bH7baH9OQgD0Dtxvkvx1TkY5oOfyEAKjwc8ZLV4BblnAmeA476aorKFzDQe
	 GPqFfo4P8XJdg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] payload mangling enhancements
Date: Fri, 28 Feb 2025 22:09:35 +0100
Message-Id: <20250228210939.3319333-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series improves payload statement support for mangling bitfields, eg.

 # nft add rule x y tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 12 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]

This requires no kernel upgrade.

Related to: https://bugzilla.netfilter.org/show_bug.cgi?id=1698

I did not implement the shortcut to compact flags as described by
the bugzilla ticket.

Pablo Neira Ayuso (4):
  evaluate: payload statement evaluation for bitfields
  evaluate: reject unsupported expressions in payload statement for bitfields
  evaluate: support for bitfield payload statement with binary operation
  netlink_delinearize: support for bitfield payload statement with
    binary operation

 include/payload.h               |   2 +
 src/evaluate.c                  |  81 +++++--
 src/netlink_delinearize.c       |  15 +-
 src/payload.c                   | 168 +++++++++++++++
 tests/py/ip/ip.t                |  17 ++
 tests/py/ip/ip.t.json           | 336 +++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        |  82 +++++++
 tests/py/ip/ip.t.payload.bridge | 365 ++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 280 ++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev |  88 ++++++++
 10 files changed, 1419 insertions(+), 15 deletions(-)

-- 
2.30.2

