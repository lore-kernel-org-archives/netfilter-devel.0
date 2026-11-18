Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023562;
	b=16/4M1p+fYpWyr91lQQh80BC83e4+9iqp+NXMBYOBNqSUzWlgUIXC/jwdkcv3pznxoKd
	 Xpfu50u6OqAtTjSgj+UufjtJKMLpwvPgik5WqjpzY2/RVlFurrYA1gNmmjIR4KFJkGq69
	 /TxOOfKfUiXU6qXJZb4PXf/1rABGahSznbWNJccbqdb7+3cLFbh+9Nnm1QY168O3KAxHA
	 ImRPWSDn1Ev7yU7UDDf4VU8lYP57VclKlzi7G5pHMgZ2oB/OhGkvIjBq6LGTdbjF4SJxU
	 T4KgN3WLy3DC1+9mig3K4KKp1F0TAV7Hn0qa0rIczGTMgoPPapz7NRUXJ6bBeyU5mvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023562;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nE567zI2datQpik537EF4KkcKp8M7q7qBSG4HUQko5s=;
	b=qxBUFvI53/ugn+v56IbbQ2KSwBgq14oeJTyqgKsvlnE9Ro2bP6N9OSYq/gokap3APQZf
	 SoqvSM1id8ytm5Aml/U+b2Lorn5bVnrk2H701kp0LAVBM0M03DJ5wZX7l+YcXqaWqhs2b
	 YH6u2IDspZSfsLiQy0/trL2ONsadgy/0ShMAOzebSU2rjPE5QNfqPYHHCki7dEAjsSyoV
	 Op9ORz/+XF7rob1B0TuO5ra+PMVX44E3nsY+JLqirtUJ1Gal5hLWqBHXHmJFzbPG2W+HU
	 SV6toEpUegdxSPpXcTMNhwf1hbftsv1CiBZ4BM8MGMfDJvuqTi9AlwwrKaT6303n1/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88112606A334
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 17:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88112606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 351D760225; Wed, 18 Nov 2026 18:39:19 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 0/6] netfilter: logging cleanups
Date: Wed, 18 Nov 2026 18:39:07 +0100
Message-ID: <20261118173913.22592-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
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

v3: more LLM cargo-culting: add a random READ_ONCE() in patch 3.
As a result, changelog of patch 3 become even more unreadable LLM
text wall.

At this point I am seriously considering 'TL;AI'
as the new default commit changelog; no human will ever read these.

Patches other than 3 are unchanged.

v2: LLM cargo-culting and more paranoia checks.
Couldn't find any place where skb->dev == NULL && indev != NULL, but
I consider logging slowpath so I just gave up and had LLM blindly
follow AI/sashiko "advice".

See patches for details.

1) Remove dead ARPHRD_SIT special-casing from MAC/HW header logging in
nf_log_syslog and nfnetlink_log. The branch became unreachable once SIT
tunnel hard_header_len was zeroed.

2) Fix MAC header dump in nf_log_syslog to use skb_mac_header_len() clamped
to dev->hard_header_len instead of unconditionally logging hard_header_len
bytes, preventing reads into the IP/IPv6 header.

3) Refactor hw address extraction into a shared helper for nfnetlink_log and
nfnetlink_queue. Clamp dev_parse_header() result to 8 bytes and validate
skb preconditions in the common helper. Add BUILD_BUG_ON assertions for
identical container struct layouts.

4) Use skb_mac_header_len() from indev instead of hard_header_len from
skb->dev for NFULA_HWHEADER length. Omit the NFULA_HWHEADER attribute when
the computed length is zero.

5) Skip hwheader logging on output hooks where the MAC header is stale. Gate
emission with a family-and-hook aware nfulnl_pre_egress() check.

6) Emit the nfnetlink_log timestamp only on the input path, since output-path
skb->tstamp may carry an SO_TXTIME delivery deadline rather than an
observation time. Replace the broken raw hooknum comparison with
nfulnl_pre_egress() so ARP and NETDEV families no longer emit timestamps
at their output hooks.

Florian Westphal (6):
  netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header logging
  netfilter: nf_log_syslog: fix MAC header dump to use real header length
  netfilter: nfnetlink_log: fix up dev_parse_header usage
  netfilter: nfnetlink_log: use real mac header length for hwheader
  netfilter: nfnetlink: don't log hwaddr/hwheader on output hooks
  netfilter: nfnetlink_log: only add timestamp on the input path

 net/netfilter/nf_log_syslog.c        |  28 ++---
 net/netfilter/nfnetlink_log.c        | 151 ++++++++++++++++++++-------
 net/netfilter/nfnetlink_log_common.h | 121 +++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      |  19 +---
 4 files changed, 248 insertions(+), 71 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h

-- 
2.56.1

