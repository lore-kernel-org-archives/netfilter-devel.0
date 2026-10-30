Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375085;
	b=LGV6+TfhE8PItuYOv0cSj4xj4LdeJLx/y8KON9bWHxKFRbOqUjs6pxrM4y8QY5JYAX+2
	 zzBDXtm7qF7wmkmXKGqvgNSQakfc1QawdAgtN86Gs95AwNykdU3UCrRgXLv919PbbuRQM
	 JxOllnVQpHyyxnabX5FwCbK3DKlIYUimQz1eGqQySLURqrMiCqGGePJtQ+aSCmVzyVMfg
	 DHHHGQhin63KqjKEri5M4NS9UAQKxg0Wy314Ssv2QTJTkofMEA3DMFpGJg7Soe9lHYGwN
	 GFU7fClgVeLPAQ9UAMPpohpK6XXjr/r0BPIKBBXXlKsK1OIsSqTAo/JQHT1h4qVRiqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375085;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+wjZIMNWbjKJif6iUEXuCY3LRprjO4ICzoebbczBPvQ=;
	b=uE4DsxYG3JiqLtrZ0i1b79iLSKti12pxaoH2KdS488pe8nj3Tk/tilFGnkjkHIE1NpaR
	 hLLCGGZwtl96a1A90snljw+xuEYXxSXQ1u5X7WyoLDosHyov/fJgT+GsPi4nvLvAs+kKO
	 WzPZ2KZ64QpCWaR56FCFaIkjFrf/KHcgm2+gJLIiK4IcpAua0lYi4zOSHE4zhkrpAEiBI
	 PVbs0U9RUN4E9PeqYhiWOajXprxISuuhmM/XXkbwfcUU4yA6NIBgXxIu6Yly03vih6C8k
	 7NmxOkKMJPiakzMmRNe7/ctTkvwODhuSr5DFl+dkCRkl+MJhDkEzwF2ajQRNZkEFRSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A44606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89A44606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 55296609D0; Fri, 30 Oct 2026 16:44:42 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/4] netfilter: logging cleanups
Date: Fri, 30 Oct 2026 16:44:29 +0100
Message-ID: <20261030154433.13601-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
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

A few patches to address LLM-reported issues.

While working on those LLM also reported that ARPHRD_SIT is dead
code, so:

1) Remove dead ARPHRD_SIT branches from MAC/HW header logging in
nf_log_syslog.c and nfnetlink_log.c. The paths are unreachable ever
since SIT tunnel hard_header_len was set to zero 6 years ago.

Then there are the originally reported issues:

2) Fix MAC header dump in nf_log_syslog to base the byte count on
skb_mac_header_len() clamped to dev->hard_header_len. Prevent logging
IP/IPv6 header bytes as part of the MAC address when the actual MAC header
is shorter than the device's hard header.

3) Extract dev_parse_header usage into a shared helper for nfnetlink_log and
nfnetlink_queue, clamping hw addresses to 8 bytes and validating the skb
mac header. Add BUILD_BUG_ON checks to assert identical container struct
layouts.

4) Use skb_mac_header_len when dumping mac headers in nfnetlink_log and
clamp to hard_header_len.

Skip mac header logging at POST_ROUTING where the header still belongs
to the ingress device.  Originally POST_ROUTING never had incoming
device handed to it, but that changed.   Make it stricter again.

Florian Westphal (4):
  netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header
    logging
  netfilter: nf_log_syslog: fix MAC header dump to use real header
    length
  netfilter: nfnetlink_log: fix up dev_parse_header usage
  netfilter: nfnetlink_log: rework mac header logging

 net/netfilter/nf_log_syslog.c        | 24 ++-----
 net/netfilter/nfnetlink_log.c        | 90 ++++++++++++++++---------
 net/netfilter/nfnetlink_log_common.h | 99 ++++++++++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      | 18 ++---
 4 files changed, 167 insertions(+), 64 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h
-- 
2.56.0

