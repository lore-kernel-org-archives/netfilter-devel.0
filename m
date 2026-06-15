Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A253F4126;
	Mon, 15 Jun 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530775; cv=pass; b=vBqYCRPLbZDGIBxBLO8kfBogafFd4luK3WXRmXIWzCzxIYE2+9CcFVJQEme0AEkCGWHaS5a9GvkSShsl94ZB53zFg2vLqtFU6x5kFTbIXwSpvNpVGiFtv/FKHb+zY7ra+IP/KtMmFi3Y1Wd4EagY1X29Hn47ixQsOEg+elcNK1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530775; c=relaxed/simple;
	bh=ASGtZodxLV3FO64zH6r3PhGdLFkZRDXhr6OZzYY2y4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nOQYNAccoBrUaTqCeeTLORnp9RrI9eFUt1jl4DlRlntpjL/ArUueo7u5iBRoVyt15Xy7EoXeR5+gA34j0ohIbWLafUXZYnqKz70dYLoG2uWTWIYUmHaOSIuSM/SP+liVPDoaRci9u8oPtJIvqZSF/0HGeK21l+Rf+fTD0oaqvCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=hriYTGoR; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="hriYTGoR"
ARC-Seal: i=1; a=rsa-sha256; t=1781530743; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=dTVAfJNQeKYgmrIcTtNzo8NQu9NCsfGI6Xfv2f9RpQhAkhDnHYeD/VoUH6Kqem5UwR7j8t/5sO8SAjmOLB+OGrMUhQVfuknwO/YhJHdPnZvMD0Xj11SA3wqPVgjQ6L3AodKrswx3aeO4zpTWd5YIVJ+AUaqCB+LOmCvgD7qiN0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781530743; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dJfCvLHvQSghos3e6oW9Re3wWcWe+lXCS1XystogHFA=; 
	b=F35xH8OwB2qh7kmPKmbJlHoDUQqAFWpYkdfmugFeFkTGo8qadZ82gYtgtirsWN8y6aN6gT226ibYjpYysvE6S/glWowSKH5Cffy8ajYsgtI+7RNIQkJkBXxWddhUrwI1R7B/oNl84KEPnvTwfqJUeAayJv7RXPSa0K3Xa+H+l9w=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781530743;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=dJfCvLHvQSghos3e6oW9Re3wWcWe+lXCS1XystogHFA=;
	b=hriYTGoRgNNVUWYT5IaXyyuFE+mQvRUC7wnOPmm1B5uqwD1hQBwFcaEaNoJs2KP2
	PUzKDSBJvPCQaqHpxLQpk4ymG3nwi7877NLbm6flu92kmXCzBnwr3LfcRk16PX0bW27
	TAiq/ubKwjVb4AL5tRSXiOnHqM2nioWOROuIPHwE=
Received: by mx.zoho.eu with SMTPS id 1781530741417740.5121897517076;
	Mon, 15 Jun 2026 15:39:01 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v2 0/6] netfilter: replace u_int*_t with kernel int types
Date: Mon, 15 Jun 2026 15:38:25 +0200
Message-ID: <20260615133835.51273-1-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi all! This is my first patch series of many, I hope :)
I'd like to start contributing by helping out with janitor work,
standardizing code and cleaning up.

This patch series replaces POSIX u_int8_t/u_int16_t with the preferred
kernel types u8/u16 across several netfilter files.

u_int*_t appears in many other files, 48 more to be precise, but I wanted
to keep this series small, unless advised otherwise.

No functional changes.

Changes in v2:
- addresses sashiko comments https://sashiko.dev/#/patchset/32368
  - nf_sockopt: update function prototypes and struct definitions
  - nf_log: update the corresponding function declarations and the 
    nf_logfn typedef
- link to v1: https://lore.kernel.org/all/20260612125146.75672-1-carlos@carlosgrillet.me

Carlos Grillet (6):
  netfilter: nf_nat_ftp: replace u_int16_t with u16
  netfilter: nf_nat_irc: replace u_int16_t with u16
  netfilter: nf_sockopt: replace u_int8_t with u8
  netfilter: xt_DSCP: replace u_int8_t with u8
  netfilter: xt_TCPOPTSTRIP: replace u_int8_t and u_int16_t with u8 and u16
  netfilter: nf_log: replace u_int8_t with u8

 include/linux/netfilter.h      |  6 +++---
 include/net/netfilter/nf_log.h | 16 ++++++++--------
 net/netfilter/nf_log.c         | 14 +++++++-------
 net/netfilter/nf_nat_ftp.c     |  2 +-
 net/netfilter/nf_nat_irc.c     |  2 +-
 net/netfilter/nf_sockopt.c     |  8 ++++----
 net/netfilter/xt_DSCP.c        |  8 ++++----
 net/netfilter/xt_TCPOPTSTRIP.c |  8 ++++----
 8 files changed, 32 insertions(+), 32 deletions(-)

-- 
2.54.0

