Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=31.154.135.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565518;
	b=kPiM3BqGMBJQlaIAJPZrPe7UgTAcIUOEGbCkWClSEU2+v1U7RZdmo47xcjGlwA+eOoRc
	 qECJbAXlbb6ygP3mdYCwAaU5S7syEbdwITmII7lBfS6zDYUTPX9zPKibbESfGsOrC+r8M
	 LaSurpXSBKtGRYNEK6TQR+ToczoP0DVOx2Lkng4Z42avDhQpq9NJlOW8M1jyAwc7HPusF
	 RSQS7Lhw+qxhOaZ4HCpeKFFjMuqGp+Nc6+1NXti9KIkfTbVBLf9RtXEWvlNnqDCUQlHwr
	 dyHf4IgGCUIR9TmizlQs1QyKio4w0x1DtJ5GGELtSPqhzYVq1ZyZE8jSWquXuUtr70g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565518;
	h=DMARC-Filter:Received:Received:Received:Received:Received:
	 DKIM-Filter:DKIM-Signature:X-Virus-Scanned:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FnrqULfI6CxtTlOcsF1R0zdisw/Ss/aYDt79zlSdFFA=;
	b=D62+m9azCfcuXk3Ph23xewQhjZnSII5/rhSNMeSN2bFbBBFIf1sO6Pc5e35C/E1O9kk3
	 7NkGCWjQwpEM4Xq9i403o1m88AhnXt0mTH4Y1xdCeD3nXPsRLizAQfoyN0udiB0Iqo4CO
	 9zXC/+x7IErtz1wQYEIAlXnU3HAxJzJ65at0hJPhR1evQpqXTbDaRuXBblOmBbfGahTvb
	 olaHZVMSVTI2ztxJyltHiRLMdxTFj5auaw7ntw/DaqyrMMim3UANREQhH6upEKpgRPDTs
	 WSNqtL8a87kuM3ybYhnfpa4aAn/SwKtZsFDpieFyclBsfEr86knN4wzvLRyQs/rBtDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inango-systems.com;
	spf=pass smtp.mailfrom=inango-systems.com;
	dkim=pass header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=LuLtQD3l;
	arc=none smtp.remote-ip=31.154.135.10
Received: from ksserv.inango.com (ksserv.inango.com [31.154.135.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D618606A325;
	Sun,  1 Nov 2026 20:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D618606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=LuLtQD3l
Received: from ksserv.inango.com (localhost [127.0.0.1])
	by ksserv.inango.com (Proxmox) with ESMTP id 81E502296B;
	Sun,  1 Nov 2026 22:38:35 +0200 (IST)
Received: from mail.inango-systems.com (unknown [192.168.70.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ksserv.inango.com (Proxmox) with ESMTPS id 52707229E2;
	Sun,  1 Nov 2026 22:38:35 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id 9F95FD645A5;
	Sun,  1 Nov 2026 22:38:24 +0200 (IST)
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10032)
 with ESMTP id 6gqVRTePtBzA; Sun,  1 Nov 2026 22:38:24 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id 5E7B4D645B0;
	Sun,  1 Nov 2026 22:38:24 +0200 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.inango-systems.com 5E7B4D645B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inango-systems.com;
	s=45A440E0-D841-11E8-B985-5FCC721607E0; t=1793565504;
	bh=FnrqULfI6CxtTlOcsF1R0zdisw/Ss/aYDt79zlSdFFA=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=LuLtQD3lSUgBR7gUye8LTm5etpUqfbRlxowBE0K4WNvcODPDU/IVcN4ADjsz8EZmH
	 66bLMlijJPuAFXHPevIBqqKcS+aUIQQ84SwzFIoFz/BGJFx5sQlqMdbCXL40VJlg0h
	 ZmCP9Fb9IotMD8CBKg6pCujSybsmtcSLcILIrJ/3WKQuyR2Vk4wdu7smyYvqhaNs8W
	 GxNkc317CrkJdVx53/aO298Gu/pSjwSbdA1Rtkk8PyRl21fdxZmqCkSLFMhJaUYK31
	 HmE8JPiwlBgi5KhEQ+xydbOofuQejD5UH43A8Pt8MXn87Za27SVbnl5dkJ/Un1ZSDH
	 csH63hniMmsmg==
X-Virus-Scanned: amavis at inango-systems.com
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10026)
 with ESMTP id lFvyGayHBQwW; Sun,  1 Nov 2026 22:38:24 +0200 (IST)
Received: from steamdeck.inango.loc (unknown [193.37.156.111])
	by mail.inango-systems.com (Postfix) with ESMTPSA id 8F964D645A5;
	Sun,  1 Nov 2026 22:38:09 +0200 (IST)
From: Nikolai Merinov <n.merinov@inango-systems.com>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolai Merinov <n.merinov@inango-systems.com>
Subject: [PATCH 0/3] netfilter: ip6t_NPT: improve NPTv6 implementation for gateway usage scenario
Date: Mon,  2 Nov 2026 00:37:13 +0400
Message-ID: <20261101203716.269343-1-n.merinov@inango-systems.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

My team, together with the prplFoundation, is working on NPTv6 support
in prplOS distribution for home gateways. During this work, we
encountered two issues with the current NPTv6 implemetnation:

1. Edge cases described in RFC 6296 are not handled.
2. A NPTv6 implementation requires integration with a connection
   tracking, since home gateways use stateful IPv6 firewall.

The integration with the connection tracking mechanism was inspired by
the IPVS implementation.

Andrey Kuznetsov (3):
  netfilter: ip6t_NPT: Align not mapped packets processing with RFC 6296
    requirements
  netfilter: ip6t_NPT: Align ICMPv6 error messages with RFC 6296
    requirements
  netfilter: ip6t_NPT: Adding conntrack compatibility to NPT sessions

 net/ipv6/netfilter/Kconfig    |   1 +
 net/ipv6/netfilter/ip6t_NPT.c | 107 +++++++++++++++++++++++++++++-----
 2 files changed, 92 insertions(+), 16 deletions(-)

--=20
2.55.0


