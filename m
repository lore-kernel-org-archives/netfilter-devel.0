Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789854;
	b=mpqx0GY1gaiQjClPWDAIUABXZznjk49V5mJ2P1wyD+dkj5NuNZGt87osqt02e+GzIeje
	 0Fc8fD5XgnhIaPusJm5rVv1kvCD+i/RMhOcqckcj941n2liufJZPgRmOmEvw6BNKhHbuL
	 TAGaijLHD05uFzeZGkJbvsL3UmhORVmHwM56FGodLInMzQ00MXwbXARfD/g7Fj0pE4nrt
	 J03jj5lU1hRzaQ5ZJRBFasvBNNzw+6wyZRitgnAmT4N4LSiMedGnDrNWENTCXbTrOwaXk
	 CDthRSfD8vqlajAcNTLKdk9idOXf1/Nm8GPLiVgFro9jxbin+NEKnbmiuU4drHV785g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789854;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=K/2OJ4+lphTlUg2pVXCiDwDlPx39y0pPkGf1hDNxxQA=;
	b=Nuua5SvhCCNzUN74WJx909/pMuZkqbFx8nCH0Jy36z1Y7gU2cLf2lPEnJV/UfGrKP8Gp
	 /+jp3FWphVUIjrzzxW88JqSeiXIx6B617QCj60T8ghldZa76RN461xsndxVbGS04VlGP7
	 JZmvFD6RaBzj5Ne5mpOkon0/6lw+YKUGPpk8eOyrptDa+voq2Q1LbBEy487VAdzkZ5bBg
	 S2zyg8bJ55up0HffEZcthp/iUKf+N7vT6SJW8iGbBcIF7RAAwWNWn0JxW29aTDkdgVkMK
	 LERxaz5Lyg/I8gFcuAUAdUCoD7J39sUYybRAxtYJJRaSdl2slz3ZkYSuAfmiVCyZZNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="Uk2D/Njp";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89882606A323;
	Mon, 16 Nov 2026 00:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89882606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Uk2D/Njp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789851;
	bh=K/2OJ4+lphTlUg2pVXCiDwDlPx39y0pPkGf1hDNxxQA=;
	h=From:To:Cc:Subject:Date:From;
	b=Uk2D/NjpJsEMkQtnReUkrIqddmgqNvSR3Bma+2p2GXCFxwrUtuQgLnFW/9aMDM++D
	 57bdxYWz6pA1u1xsyJ1p+N9rKyI0EuD5DvuUtbpV4wIGJcGLjFG2mDwwh0LGVcMQDq
	 nVft+snHD2uiT0fWFvaJOPZqsbddovm53Obq99juvIOXlLf5QKR+WrKB4WAzEAm7+y
	 KHrWYOvm7q3um8jmUfEkyqG/My5cvvxCQMbhYkuldtIWkGSR1HJzk2IqfWW/g6lQiB
	 t8zo63SJWZ35a7VM5U5cSqdIkLuUFkYBbA74UeMYBEqZqBqoa7uYtvg5oKSH++fsAB
	 7AaxFNTtuKgzw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A8E616005B;
	Mon, 16 Nov 2026 01:44:10 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net,v2 00/11] IPVS fixes for net
Date: Mon, 16 Nov 2026 01:43:53 +0100
Message-ID: <20261116004404.2821183-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: keeping back previous 1, 2, 7 and 15 as discussed with Julian.

-o-

Hi,

The following patchset contains IPVS fixes for net:
 
1)  Rework connection refcounting so the pending and running timer
    hold a reference. This fixes a use-after-free race between
    connection deletion and a concurrent timer callback, from
    Julian Anastasov.
 
2)  Expire controlled connection chains iteratively instead of
    recursively to avoid kernel stack exhaustion, from Zihan Xi.
 
3)  Reject zero and configured FTP control ports as data ports in
    the FTP helper, from Zihan Xi.
 
4)  Skip conntrack templates in ip_vs_ftp_out() to fix a UAF in the
    expectation list after the CT rule is removed, from Theodor
    Arsenij Larionov Trichkine.
 
5)  Update conn flags, seqs and related fields in the backup server
    under cp->lock, from Julian Anastasov.
 
6)  Read conn flags and seqs atomically in the master when building
    sync messages, from Julian Anastasov.
 
7) Fix a race that can leave a destination in the overload state
   forever. Also make the LBLC/LBLCR schedulers honor the overload
   state for cached destinations, from Julian Anastasov.

8) Validate cport and IP_VS_CONN_F_NO_CPORT in received sync records.
   This rejects templates and connections that incoming lookups
   cannot match, from Axel Mierczuk.
 
9) Skip cport 0 connections in ip_vs_conn_out_get(), using the same
   rule as __ip_vs_conn_in_get(). Also from Axel.
 
10) Do not create connections from packets with client or virtual
    port 0, which could create a duplicate connection for every
    packet, from Julian Anastasov.
 
11) Wait for an RCU grace period before reusing a destination from
    dest_trash, and before restarting its estimator, from Darong Lu.
 
Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-16

Thanks.

----------------------------------------------------------------

The following changes since commit d1bb235aa409a4e5aeba6c748d953d948625b1e9:

  netfilter: nat: zero newrange before filling it in (2026-11-05 13:31:11 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-16

for you to fetch changes up to 5367e14e92bbb0779612d36cce7c6e95d3bc5e68:

  ipvs: wait grace period before reusing destinations (2026-11-16 01:40:31 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-16

----------------------------------------------------------------
Axel Mierczuk (2):
      ipvs: validate cport in received sync records
      ipvs: skip cport 0 connections in ip_vs_conn_out_get()

Darong Lu (1):
      ipvs: wait grace period before reusing destinations

Julian Anastasov (5):
      ipvs: fix problems during connection deletion
      ipvs: update flags and seqs in backup server under lock
      ipvs: read flags and seqs in master atomically
      ipvs: honor the overload state and do not enter it forever
      ipvs: do not create conns from packets with port 0

Theodor Arsenij Larionov Trichkine (1):
      ipvs: ftp: skip conntrack templates in ip_vs_ftp_out

Zihan Xi (2):
      ipvs: avoid stack overflow from recursive connection expiration
      ipvs: reject FTP control ports as data ports

 include/net/ip_vs.h                   |   7 +-
 net/netfilter/ipvs/ip_vs_conn.c       | 131 ++++++++++++++++++-------------
 net/netfilter/ipvs/ip_vs_core.c       |   3 +-
 net/netfilter/ipvs/ip_vs_ctl.c        | 140 +++++++++++++++++++++++++---------
 net/netfilter/ipvs/ip_vs_ftp.c        |  20 ++++-
 net/netfilter/ipvs/ip_vs_lblc.c       |   8 +-
 net/netfilter/ipvs/ip_vs_lblcr.c      |  13 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |   7 ++
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |   7 ++
 net/netfilter/ipvs/ip_vs_proto_udp.c  |   6 ++
 net/netfilter/ipvs/ip_vs_sync.c       |  53 +++++++++++--
 11 files changed, 289 insertions(+), 106 deletions(-)
