Received: from out-13.smtp.spacemail.com (out-13.smtp.spacemail.com [63.250.43.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C733382FC;
	Thu, 30 Apr 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566003; cv=none; b=p4YASj4Ed3HFrZ1mOhB+7ll5ygsS9eBbZ8cUtVnIgvmbewjxKK9DOgFru8nwk2eMgONp4Qnzn0r6zR0Xjr8Mq0yUihWhr7i+YSvr6qAVzOTc/MXWjZBa27xNvH3ykD42+h8GTgDkqEskeUXhHdaJoLWDXXdtOgm5Dcp3mp7rQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566003; c=relaxed/simple;
	bh=qcWpcofcD5xQONZRCZG2JVsf06Gg8/Szb89ksk12cPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EOfdTe/nCzb38XWdJL28Vb/zKCPar62jUw/0LtdN+sxkgYCj28yoskoIpY82JLoCRTcdu88M3lk8NLJiIHIdJVL0utq/cnNHDdiDwWVV0SKKY/BunZb38t5t9sqpq3X2IC00tOFeFVJadg5SflfmlkDmnUgfC07Qbo+7s8eiXWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=XuWIc38a reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="XuWIc38a"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g5zhy2N22z2x9M;
	Thu, 30 Apr 2026 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777565558;
	bh=6pgjt9PVUYpaS1esvDnc3/NQF+deIy8NLJHpEbltOuU=;
	h=From:To:Cc:Subject:Date:From;
	b=XuWIc38aDBqengf1KoqK6026kkWGm61ataZV36C7HzK24FQkNQQwbp9t8G5urljI7
	 pc05NVEyrXCk/ZbMm9+ztAn8+xgdxqBdDLA+53dsf5yw6YrhmDeUILe7Q11T1d2unN
	 2oN3kiFrewLAibblDAabMffJ+9Crep6ThLZ8vMCB7Se3jUDrUK8bJhEg+LISg6PO6K
	 xOz7Swy5AqMqu12/Ba5tqe0F1ZtRYImpUKViuH0pelA0/6Clh6EUJLEb1Ig/RnwnB9
	 +FCgZWfFI6ocpC3IHoTjsje9Xs2E/VfYokxQDF9ZIQjxmXpWc/fkF+ni1j90sGaxdz
	 tAYnufDxflWGg==
From: HACKE-RC <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HACKE-RC <rc@rexion.ai>
Subject: [PATCH net-next 0/2] netfilter: conntrack: validate parsed port values in IRC and Amanda helpers
Date: Thu, 30 Apr 2026 21:42:28 +0530
Message-ID: <20260430161230.3438973-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Both nf_conntrack_irc and nf_conntrack_amanda parse port numbers from
application-layer protocol data using simple_strtoul(), which returns
unsigned long. The results are stored in u16 variables without range
checks, silently truncating values above 65535.

This series adds explicit upper-bound validation in both helpers.

Note: checkpatch warns about simple_strtoul being obsolete. Both
call sites use the endptr output parameter to advance the parse
position, which kstrtoul does not provide. Converting to kstrtoul
would require restructuring the parsers, which is out of scope for
this fix.

HACKE-RC (2):
  netfilter: nf_conntrack_irc: reject DCC port values above 65535
  netfilter: nf_conntrack_amanda: reject port values above 65535

 net/netfilter/nf_conntrack_amanda.c | 10 ++++++----
 net/netfilter/nf_conntrack_irc.c    |  7 ++++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.54.0

