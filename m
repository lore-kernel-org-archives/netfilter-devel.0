Received: from out-06.smtp.spacemail.com (out-06.smtp.spacemail.com [66.29.159.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341C231835;
	Fri,  1 May 2026 06:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.29.159.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777617131; cv=none; b=siORq22G5DX/Ms6lfhTBvgejiKm+e4whz99Mnd+1ZcBwbSywKnvCQ3okWH/RiEKc5ucAW3YCq3ck9TBL3FnubHCtlF/jA2yQMtt6aPBH6H2snjPMzfO1e0iw8l5l8vI9kP3iBA75t0xaf4VHD4HUDRTV1OQwFlkpPM2iVPmIipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777617131; c=relaxed/simple;
	bh=swLMH6pLURjgirL9xBadXFGC5E5pIa70YvFJGr2fQdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X65XMWRvEGK2TmW3VT28tN8DCiSoi4z+u8Y1XyYoy0N/ImILic4m8Zom3fXAKZYkQGo2BbNT1MWIig15vb0Ufi5oV1TJxuV98b/XcTK5JlSmYdBGH2xaSF6qjP+272YNZB8nPYaiV8pmKC2W+XFd0yzxxs78fwVI25SYBQUvbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=c/zswwmj reason="key not found in DNS"; arc=none smtp.client-ip=66.29.159.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="c/zswwmj"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g6Lmh6s8nz8sX2;
	Fri, 01 May 2026 06:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777617129;
	bh=Ug20lDJ3azlJTOlx8qs0QKzdbTa2xWSAosLLSGBJEeE=;
	h=From:To:Cc:Subject:Date:From;
	b=c/zswwmjIVlWn3FqubHmqqLDSTG6nntUulrx5tVCtAQmztwShYrJwB1nG5yzOFq1l
	 5zyZGdfFB9yKUb/OgWq0r70u6dnMem22uX5DWpBA3WZsvnHsoPwZ89NLWp3ZqC7Kjl
	 obcROkbree1s4BSZcsZaW9E8M0zqollaZj2yqKQtC/u0C9ttDNrntnTDn+2EsII4tI
	 /7/F0rOwfkRrCgsJ/80kfGvpejZkRwEqF/8rV3CJtWWONJtEWSeQ+Dc9OMpyUi9l5s
	 pHM8a0hb46ZsapslaCLMEk1vHPHqttB5dI8GpJjkDE7rA3lrRU/TPkL6mHx0X+0c+P
	 z4vDFa53gPtww==
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
Subject: [PATCH net-next v2 0/3] netfilter: conntrack: add shared port parser and use it in IRC and Amanda helpers
Date: Fri,  1 May 2026 12:01:53 +0530
Message-ID: <20260501063156.2520780-1-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Both nf_conntrack_irc and nf_conntrack_amanda parse port numbers
from application-layer protocol data using simple_strtoul(), which
relies on nul-terminated strings and returns unsigned long without
range checking. Port values above 65535 silently truncate when
stored in u16.

This v2 adds a shared nf_ct_helper_parse_port() function to the
conntrack helper core, modeled after the approach in 8cf6809cddcb
("netfilter: nf_conntrack_sip: don't use simple_strtoul"), then
converts both helpers to use it.

Changes since v1:
  - Added shared nf_ct_helper_parse_port() in the helper core
    instead of open-coding range checks in each helper (Pablo)
  - Parser does not rely on nul-terminated strings
  - Dropped simple_strtoul usage entirely for port parsing

HACKE-RC (3):
  netfilter: conntrack: add shared port parser for helpers
  netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
  netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()

 include/net/netfilter/nf_conntrack_helper.h |  3 +++
 net/netfilter/nf_conntrack_amanda.c         | 11 ++++----
 net/netfilter/nf_conntrack_helper.c         | 28 +++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  4 ++-
 4 files changed, 40 insertions(+), 6 deletions(-)

-- 
2.54.0

