Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794609299;
	b=KrYLbUIBEs7ewUj1HnJUhcedFbLLMHoZQkGlzBFieXQCcaf9PMF6i80wU+2GO9kAaOhl
	 /AaqG38ckN/hPZPX1nNBypEPg/QfDh95m8f/rZS0jzfEcKrbqxCeZG3eQ6TTK2NvkECCT
	 5ocNIeEUmmDduHHlAiAqpw7SBMQoqhmO9aAOkiJXA40u3AN0q88f1lmXWozb1XXVwqG5z
	 sjhN2lRc73X6UrabdwN4+yyNGTvVqqDS6YoSx3TPiUKykS0Td15U98+S9J6d0N5yThdwp
	 InYDFv5qzR5HjxxXAVpp/7t6zBdA8CdKJFQrsHdOfmXUj/egI56xWwhpVQKHlpzo6RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794609299;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=n6gsk06Q/ZLkqrH++zBWhddiCHI+IJ0ggdABLE93hj0=;
	b=lHyH/5E//O9MSGH/Og3mBVwx7uaNnPBxma3qLMvBkoSPhJGHnuCZWQSzq8MDg5i/jsm8
	 CVLwLwrt0CgRuasLMtDuaYBlPgGloDKaM5ye+K1W+QM1z5hoagptWVbdYj0TayFrBkto0
	 INwI1b5g/ZwgEod1is3FEdOasirr/E6lz3kgLnVC9dSFYuWmFkPPOk06HKD465YE74hcE
	 u8cuMaUpiyWCxMwl/GohFqKSJps+2ogdzMwapsPuzgxka+gn4QpFSnWSl+9MYOQnCIiof
	 QLvUI0B1Y0vgvQs5uZD5kc74kmuTc0v3rk41eNB0YN0shor5DN7GbMSL7gd+p6Wxz7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="v0/cM6Aa";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9CC37606A8A0;
	Fri, 13 Nov 2026 22:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CC37606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=v0/cM6Aa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794609280;
	bh=n6gsk06Q/ZLkqrH++zBWhddiCHI+IJ0ggdABLE93hj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v0/cM6AaYTzAZ5ET/oEYN7zdnDQdrdkn2x/Hq7VregG7dVWy235JzOCuymiNxcBq8
	 y+rfJ49sTUl6dXLnHWfwgDHR1hnkyiAhwpPzbER+sYd+KpbuMUHeAyG2ShoE9/+/Rc
	 bVEYQJ0KkiBEytwx9q+XvNIvotZTf1M4wIJE6wiXoT57AYzg50N9JIUixQXI1x7Wly
	 KgJH95/PsDWywq1W90uu53xEO6AqKgpviBpCs4gXBtAeu3Nkr6hitBmP3tnBxraQkk
	 Pcd2+RQRN23im6acVB9dI/5ReetD9jAtpZrDKiyxB8JDglPR8G7iiSWVblKzdy0n/3
	 tAPwHImeKCQzA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DE02760056;
	Fri, 13 Nov 2026 23:34:39 +0100 (CET)
Date: Fri, 13 Nov 2026 23:34:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org,
	fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/15] IPVS fixes for net
Message-ID: <aveQfaTYqu8toT3E@chamomile>
References: <20261113011447.2357709-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>

Hi,

I'm preparing a v2 of this batch with IPVS fixes, we have identified a
few issues in this batch. I plan to submit it by tomorrow.

Apologies and thanks.

On Fri, Nov 13, 2026 at 02:14:32AM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains IPVS fixes for net:
> 
> 1)  Avoid out-of-bounds write in ip_vs_nat_icmp_v6() when an ICMPv6
>     error embeds a non-first ESP fragment, from Axel Mierczuk.
> 
> 2)  Update *offset for non-first fragments in ipv6_find_hdr(), so
>     callers no longer use the initial offset as if it had been
>     updated. Also from Axel.
> 
> 3)  Rework connection refcounting so the pending and running timer
>     hold a reference. This fixes a use-after-free race between
>     connection deletion and a concurrent timer callback, from
>     Julian Anastasov.
> 
> 4)  Expire controlled connection chains iteratively instead of
>     recursively to avoid kernel stack exhaustion, from Zihan Xi.
> 
> 5)  Reject zero and configured FTP control ports as data ports in
>     the FTP helper, from Zihan Xi.
> 
> 6)  Skip conntrack templates in ip_vs_ftp_out() to fix a UAF in the
>     expectation list after the CT rule is removed, from Theodor
>     Arsenij Larionov Trichkine.
> 
> 7)  Add the seqadj extension before linking the FTP expectation, since
>     krealloc() of ct->ext can otherwise leave the expectation pointing
>     to freed memory. Also from Theodor.
> 
> 8)  Update conn flags, seqs and related fields in the backup server
>     under cp->lock, from Julian Anastasov.
> 
> 9)  Read conn flags and seqs atomically in the master when building
>     sync messages, from Julian Anastasov.
> 
> 10) Fix a race that can leave a destination in the overload state
>     forever. Also make the LBLC/LBLCR schedulers honor the overload
>     state for cached destinations, from Julian Anastasov.
> 
> 11) Validate cport and IP_VS_CONN_F_NO_CPORT in received sync records.
>     This rejects templates and connections that incoming lookups
>     cannot match, from Axel Mierczuk.
> 
> 12) Skip cport 0 connections in ip_vs_conn_out_get(), using the same
>     rule as __ip_vs_conn_in_get(). Also from Axel.
> 
> 13) Do not create connections from packets with client or virtual
>     port 0, which could create a duplicate connection for every
>     packet, from Julian Anastasov.
> 
> 14) Wait for an RCU grace period before reusing a destination from
>     dest_trash, and before restarting its estimator, from Darong Lu.
> 
> 15) Pass the netfilter hook's state->sk to the update_pmtu handler,
>     and pass a NULL sk to ip_local_out() when forwarding through an
>     IPVS tunnel, from Julian Anastasov.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-13
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit d1bb235aa409a4e5aeba6c748d953d948625b1e9:
> 
>   netfilter: nat: zero newrange before filling it in (2026-11-05 13:31:11 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-13
> 
> for you to fetch changes up to 937b060406a547e4d931525e600540726ea26532:
> 
>   ipvs: pass correct sk to update_pmtu and on tunneling (2026-11-13 02:08:35 +0100)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-11-13
> 
> ----------------------------------------------------------------
> Axel Mierczuk (4):
>       ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
>       ipv6: update *offset for non-first fragments in ipv6_find_hdr()
>       ipvs: validate cport in received sync records
>       ipvs: skip cport 0 connections in ip_vs_conn_out_get()
> 
> Darong Lu (1):
>       ipvs: wait grace period before reusing destinations
> 
> Julian Anastasov (6):
>       ipvs: fix problems during connection deletion
>       ipvs: update flags and seqs in backup server under lock
>       ipvs: read flags and seqs in master atomically
>       ipvs: honor the overload state and do not enter it forever
>       ipvs: do not create conns from packets with port 0
>       ipvs: pass correct sk to update_pmtu and on tunneling
> 
> Theodor Arsenij Larionov Trichkine (2):
>       ipvs: ftp: skip conntrack templates in ip_vs_ftp_out
>       ipvs: ftp: add seqadj extension before linking the expectation
> 
> Zihan Xi (2):
>       ipvs: avoid stack overflow from recursive connection expiration
>       ipvs: reject FTP control ports as data ports
> 
>  include/net/ip_vs.h                     |  52 ++++++++----
>  net/ipv6/exthdrs_core.c                 |   6 +-
>  net/netfilter/ipvs/ip_vs_conn.c         | 133 ++++++++++++++++++------------
>  net/netfilter/ipvs/ip_vs_core.c         |  58 +++++++++----
>  net/netfilter/ipvs/ip_vs_ctl.c          | 140 ++++++++++++++++++++++++--------
>  net/netfilter/ipvs/ip_vs_ftp.c          |  39 +++++++--
>  net/netfilter/ipvs/ip_vs_lblc.c         |   8 +-
>  net/netfilter/ipvs/ip_vs_lblcr.c        |  13 +--
>  net/netfilter/ipvs/ip_vs_proto_ah_esp.c |   2 +-
>  net/netfilter/ipvs/ip_vs_proto_sctp.c   |  12 ++-
>  net/netfilter/ipvs/ip_vs_proto_tcp.c    |  12 ++-
>  net/netfilter/ipvs/ip_vs_proto_udp.c    |  11 ++-
>  net/netfilter/ipvs/ip_vs_sync.c         |  53 ++++++++++--
>  net/netfilter/ipvs/ip_vs_xmit.c         | 114 +++++++++++++++++---------
>  14 files changed, 462 insertions(+), 191 deletions(-)
> 
