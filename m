Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB677DA7F;
	Tue,  7 Jan 2025 02:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218118; cv=none; b=pBT5exWeGVrNaeSJ4J3mN/14pwfac/04TKzg8RfoHnvBmB6ChQp88pJ8xbBTNHRdIGQ9rQuVXiec9S9De9SJbYZzL88StKAdtgqZN+diCJ5FWUJFygNbEEuAljs8Ai1+XKcJYYxWyI0lLmla8322x4c1e8jvPSZRILqefmRIfQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218118; c=relaxed/simple;
	bh=CsJqmawYyqnxHTiXy242Zz9tN6G7GT6XQ0ck7e14tlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I72Seq6NQxqRDr5yp8+3mqv2EUbvDWMPzs+0kTz/BFLaoMaSf1GZlzjlcEZvx2oGF9Uw2PKj3OUVEfBoSKYUOKleWyX044yRhghT5mHJgpyBGI4exyc82HcnlfbkW0qCaU2srwwI9UEkB5W4CLkfQItKVSy93RMi8Ewubd44qN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=W24JK0u6 reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="W24JK0u6"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwKk13pPzTPp;
	Tue, 07 Jan 2025 03:41:30 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 00/10] netfilter: x_tables: Merge xt_*.h and ipt_*.h files which has same name.
Date: Tue,  7 Jan 2025 03:41:10 +0100
Message-ID: <20250107024120.98288-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217690;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2121; bh=sIIMyzJyGRet4460JjQArHk4FyFryfxqBXq3t4I/W5k=;
	b=W24JK0u6Xzfdf+tNOJXlRpJTWl3KpthQGTjWuTC0pwSlLTKNQxDxIgd/nKXAkKt2
	zLbcDrjQiuK31qLgOLpYjpFjUNwxwCyk7c8SUv8/wGWTFqBauMphIIBC9Ru4yxDfR7l
	B8u3YyZFfV6snws0vF4PfXWs++dJZ3TCR6Moge8awH+WELrT3rS6oWU92iops53mZpw
	iWwiQKCMZ+nfUkAz6/pyCpFtBo7GtZa5AygothfmzApPvr2IeOjDQdTiKnp8u0opyrs
	BohPXxEoJSpk/Bv2TpMrhwrFmDUiSuPJV2TSOzAE0UBvYqDwSPP8hLs9YzVxUR7cq2x
	MbGarP0PZA==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
same upper and lowercase name format.

Display information about deprecated xt_*.h, ipt_*.h files
at compile time. Recommended to use header files with
lowercase name format in the future.

Benjamin Szőke (10):
  netfilter: x_tables: Merge xt_DSCP.h to xt_dscp.h
  netfilter: x_tables: Merge xt_RATEEST.h to xt_rateest.h
  netfilter: x_tables: Merge xt_TCPMSS.h to xt_tcpmss.h
  netfilter: x_tables: Use consistent header guard
  netfilter: iptables: Merge ipt_ECN.h to ipt_ecn.h
  netfilter: iptables: Merge ipt_TTL.h to ipt_ttl.h
  netfilter: iptables: Merge ip6t_HL.h to ip6t_hl.h
  netfilter: Adjust code style of xt_*.h, ipt_*.h files.
  netfilter: Add message pragma for deprecated xt_*.h, ipt_*.h.
  netfilter: Use merged xt_*.h, ipt_*.h headers.

 include/uapi/linux/netfilter/xt_CONNMARK.h  |  8 +++---
 include/uapi/linux/netfilter/xt_DSCP.h      | 22 ++--------------
 include/uapi/linux/netfilter/xt_MARK.h      |  8 +++---
 include/uapi/linux/netfilter/xt_RATEEST.h   | 12 ++-------
 include/uapi/linux/netfilter/xt_TCPMSS.h    | 14 ++++------
 include/uapi/linux/netfilter/xt_connmark.h  |  7 +++--
 include/uapi/linux/netfilter/xt_dscp.h      | 26 +++++++++++++-----
 include/uapi/linux/netfilter/xt_mark.h      |  6 ++---
 include/uapi/linux/netfilter/xt_rateest.h   | 19 ++++++++++----
 include/uapi/linux/netfilter/xt_tcpmss.h    | 16 ++++++++----
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 ++-------------------
 include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++--------------
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 24 ++++++++++++-----
 include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++--------------
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 23 +++++++++++-----
 net/ipv4/netfilter/ipt_ECN.c                |  2 +-
 net/netfilter/xt_DSCP.c                     |  2 +-
 net/netfilter/xt_HL.c                       |  4 +--
 net/netfilter/xt_RATEEST.c                  |  2 +-
 net/netfilter/xt_TCPMSS.c                   |  2 +-
 21 files changed, 148 insertions(+), 155 deletions(-)

-- 
2.43.5

