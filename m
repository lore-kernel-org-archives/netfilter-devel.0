Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532498;
	b=a7X5VvSDCqC7HwP3o43w8tKoxlnPPl+orCogrmrT6yEMRhdrANBnb4a2hjMSriRaTSFo
	 v6hncFc71NLmuzbgOwJwwRdTJ2rmH3WBxLgq66hONO1EBfANw6DaKtAbWC6ZiePOm46ob
	 vjnyq+gu0BBJKXNt6ih8a3j2QJsatghSIcTE5bh8sOlnYTnxPGuCOGOPL9phUnjMaTnPr
	 3ZncZ0Z1PSYn+rt3fpewGX4GS3+7BYWcJ4LvTVdn4l99YmlOpQLAy2NpY5VZ+DLTZLLKD
	 r0akIuOuisstgvfSsm38VD8JEmxfduq3jA5zNJ3eA/P64N3iNgL+ujGjq68+6VHflQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532498;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=IOhpMrHiqwvzQOFzgMunwEOVkFowBtszwQ+dcMbylmQ=;
	b=EOLRg+0REDqXOFhAOrmL+Qt4+XiVkPEj6WbWU9KBtpkPzZz9KTCkikvMQVirF4j4sZDL
	 HmHDumLDYKudCEIA8RpOOQ8Vfa3uXMnfi39XqP1JWtyYrT5tXnm1gDQjDZb6hdDjq/UKf
	 tDIO5CP6nDRgXCjgcOldwYY9/fINttpJY1q9d2F99WqHjq36b3TRmWesz+xYB6gU7Siuu
	 /A9NJYbL5j3AHoUDwNv2N6kuxNQWLPD9H/1uG8gr63YnpppYhBRi2zb+DDeUhX0JBEF3n
	 snyqpoqjVlMJ+vvj4OlUWU30bvLCUJOpjucXCNTK4B90+dX1vjg5nfcKREZFDNvtShg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="s/ki8f7x";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0F606A323;
	Fri, 13 Nov 2026 01:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4F0F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=s/ki8f7x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532495;
	bh=IOhpMrHiqwvzQOFzgMunwEOVkFowBtszwQ+dcMbylmQ=;
	h=From:To:Cc:Subject:Date:From;
	b=s/ki8f7xzKIeOGF2yIIQa7fwU7qdGQMMXj2IuApqEo/d3VS7+uOlLg62zO1O+YmOt
	 jAVUC3vYnx5LW6aZq883zqL+/Jkd4MIsBUT5kCEeHksjiqBU6g95on0cenyi42maIP
	 cX8wYwMV5JSo/iF8g5aQibSoA42lAESwaKmPSELolGiiitZt5tg1EhwltovC1bP3IC
	 u6V3cI8erxSbt9C4fBoMu37APfRQJ7Rl/xfr305HfWXTOK9IyXTmjZ2Xn/HVtm0TbX
	 Qaw5og1ybtsZrcVsIijm7Ktl6kwmNnOT2GxrSVJprdEpY4RLKIs+7cWm4Vv2wmfCKr
	 sKK7I30T/4/dQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 84B3060058;
	Fri, 13 Nov 2026 02:14:54 +0100 (CET)
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
Subject: [PATCH net 00/15] IPVS fixes for net
Date: Fri, 13 Nov 2026 02:14:32 +0100
Message-ID: <20261113011447.2357709-1-pablo@netfilter.org>
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

Hi,

The following patchset contains IPVS fixes for net:

1)  Avoid out-of-bounds write in ip_vs_nat_icmp_v6() when an ICMPv6
    error embeds a non-first ESP fragment, from Axel Mierczuk.

2)  Update *offset for non-first fragments in ipv6_find_hdr(), so
    callers no longer use the initial offset as if it had been
    updated. Also from Axel.

3)  Rework connection refcounting so the pending and running timer
    hold a reference. This fixes a use-after-free race between
    connection deletion and a concurrent timer callback, from
    Julian Anastasov.

4)  Expire controlled connection chains iteratively instead of
    recursively to avoid kernel stack exhaustion, from Zihan Xi.

5)  Reject zero and configured FTP control ports as data ports in
    the FTP helper, from Zihan Xi.

6)  Skip conntrack templates in ip_vs_ftp_out() to fix a UAF in the
    expectation list after the CT rule is removed, from Theodor
    Arsenij Larionov Trichkine.

7)  Add the seqadj extension before linking the FTP expectation, since
    krealloc() of ct->ext can otherwise leave the expectation pointing
    to freed memory. Also from Theodor.

8)  Update conn flags, seqs and related fields in the backup server
    under cp->lock, from Julian Anastasov.

9)  Read conn flags and seqs atomically in the master when building
    sync messages, from Julian Anastasov.

10) Fix a race that can leave a destination in the overload state
    forever. Also make the LBLC/LBLCR schedulers honor the overload
    state for cached destinations, from Julian Anastasov.

11) Validate cport and IP_VS_CONN_F_NO_CPORT in received sync records.
    This rejects templates and connections that incoming lookups
    cannot match, from Axel Mierczuk.

12) Skip cport 0 connections in ip_vs_conn_out_get(), using the same
    rule as __ip_vs_conn_in_get(). Also from Axel.

13) Do not create connections from packets with client or virtual
    port 0, which could create a duplicate connection for every
    packet, from Julian Anastasov.

14) Wait for an RCU grace period before reusing a destination from
    dest_trash, and before restarting its estimator, from Darong Lu.

15) Pass the netfilter hook's state->sk to the update_pmtu handler,
    and pass a NULL sk to ip_local_out() when forwarding through an
    IPVS tunnel, from Julian Anastasov.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-13

Thanks.

----------------------------------------------------------------

The following changes since commit d1bb235aa409a4e5aeba6c748d953d948625b1e9:

  netfilter: nat: zero newrange before filling it in (2026-11-05 13:31:11 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-13

for you to fetch changes up to 937b060406a547e4d931525e600540726ea26532:

  ipvs: pass correct sk to update_pmtu and on tunneling (2026-11-13 02:08:35 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-13

----------------------------------------------------------------
Axel Mierczuk (4):
      ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
      ipv6: update *offset for non-first fragments in ipv6_find_hdr()
      ipvs: validate cport in received sync records
      ipvs: skip cport 0 connections in ip_vs_conn_out_get()

Darong Lu (1):
      ipvs: wait grace period before reusing destinations

Julian Anastasov (6):
      ipvs: fix problems during connection deletion
      ipvs: update flags and seqs in backup server under lock
      ipvs: read flags and seqs in master atomically
      ipvs: honor the overload state and do not enter it forever
      ipvs: do not create conns from packets with port 0
      ipvs: pass correct sk to update_pmtu and on tunneling

Theodor Arsenij Larionov Trichkine (2):
      ipvs: ftp: skip conntrack templates in ip_vs_ftp_out
      ipvs: ftp: add seqadj extension before linking the expectation

Zihan Xi (2):
      ipvs: avoid stack overflow from recursive connection expiration
      ipvs: reject FTP control ports as data ports

 include/net/ip_vs.h                     |  52 ++++++++----
 net/ipv6/exthdrs_core.c                 |   6 +-
 net/netfilter/ipvs/ip_vs_conn.c         | 133 ++++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_core.c         |  58 +++++++++----
 net/netfilter/ipvs/ip_vs_ctl.c          | 140 ++++++++++++++++++++++++--------
 net/netfilter/ipvs/ip_vs_ftp.c          |  39 +++++++--
 net/netfilter/ipvs/ip_vs_lblc.c         |   8 +-
 net/netfilter/ipvs/ip_vs_lblcr.c        |  13 +--
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c |   2 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c   |  12 ++-
 net/netfilter/ipvs/ip_vs_proto_tcp.c    |  12 ++-
 net/netfilter/ipvs/ip_vs_proto_udp.c    |  11 ++-
 net/netfilter/ipvs/ip_vs_sync.c         |  53 ++++++++++--
 net/netfilter/ipvs/ip_vs_xmit.c         | 114 +++++++++++++++++---------
 14 files changed, 462 insertions(+), 191 deletions(-)
