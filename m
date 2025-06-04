Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7E4C98;
	Wed,  4 Jun 2025 23:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749080038; cv=none; b=P0MDhe5E8iMHv28TjVP3j/sN+5jxD8PbR+pEogc8Bo/+GTd7wXgtlYZNbIV2SSxKS3ESoL0bVO3CTN9kW0xV5YzaFPrBUzTw+pCnuPofRSfpDANW+ZtpBEEEF9rpnJTtqSjGPvp4QRXtN5lXEHQ78BxLEjzqLCyg+v1Gjo6ISv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749080038; c=relaxed/simple;
	bh=R/gk/V5O7uvQDzIVoHggvdrNUfTHKI5VPF5p2VflzMM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WsC59zNvZ6jM7gbrx/UfS8v9EkHtrhBECQxGcTPgPjsRooJTCkGjQcZ1im0DG8dVaR1pW6lxEm2aLlCusFBDoyHopyy9+Y7ColcunJdIIbQCB+7zgsCgz0r3ykTKtYAmPiSWa3R1s9IT+AYSWXX2SNfAbe93RayKsbY4l/eIrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fSEntWgZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gW6Cs0vv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fSEntWgZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gW6Cs0vv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 76C8A6074D; Thu,  5 Jun 2025 01:33:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749080035;
	bh=Hpv5MRJ0CvarW/GRm+1GxKFKkgkvnILf04Qb6CuRlgU=;
	h=From:To:Cc:Subject:Date:From;
	b=fSEntWgZnu2QuhGZ21wDKeJZ3pS0KFQGsEawRLgaim81cvaB28vljgk9Vu/cei6Kz
	 kTFWMLycJJw3/ObTa56XHHC9ZHzAv6FD1MLIjIg3rmDz9XgY4OfIRNEy/OohIORI2O
	 4EPhaFbm85TNLY+wrvztQ76KUIXznBBXfhq5+ff0TNLWdV6HdxasJgbYAaolqKwJ48
	 s7Vt71XVQoxFwM3WP/idud0lEz50PtoHYE9CRoEyX45hT1ETruoMS6zavJpAiZPXZD
	 t7mzrQdhaATIBKHW+oYsd5UQAEdw2Hb/jcHnbqaMfN8BMJIaaeA44a66PAdfCxFYNg
	 6O2dLHzo5Mj7A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B837E6068D;
	Thu,  5 Jun 2025 01:33:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749080034;
	bh=Hpv5MRJ0CvarW/GRm+1GxKFKkgkvnILf04Qb6CuRlgU=;
	h=From:To:Cc:Subject:Date:From;
	b=gW6Cs0vvC4U3eCG0lkfMpRrpbFwTkA/B3CtfkC+EL1P8igfxYZgZ0/NfnlA3F+BiQ
	 WN5/+LcJrheevKaDwRslnqq4U1ZM0DmZV4Oaf7op9c/aj7RieQQmNWdVycmLAtcfXr
	 Zr6C6DVF+/4YzI9ltcC29YefxslZ9di2w1Mgsrs7rW9Vc/lBxvKHgqgjmTP3HrhaDx
	 /H6TvERt/P1Cs8L6v6JHShwfJAq6Yd2m0YNPG94t/xqGOLTCCOPqSu6PsDCH2P+QiO
	 jnqnt2R2aCVcbvxPjxtv15tzlFrPyAcMizLQhgHIkwvoXIdzjGz4SwV/lUT6Fs3fC0
	 qc36aetv0+F1Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 0/1] Netfilter fix for -stable
Date: Thu,  5 Jun 2025 01:33:49 +0200
Message-Id: <20250604233350.46965-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains backported fixes for 5.10 -stable.

The following list shows the backported patch, I am using original commit
IDs for reference:

1) 8b26ff7af8c3 ("netfilter: nft_socket: fix sk refcount leaks")

   This is to fix a sk memleak, backport patch posted by Denis Arefev.

Please, apply,
Thanks

Florian Westphal (1):
  netfilter: nft_socket: fix sk refcount leaks

 net/netfilter/nft_socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.30.2

