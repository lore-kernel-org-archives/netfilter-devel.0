Received: from mvsmtppost17.nm.naver.com (mvsmtppost17.nm.naver.com [61.247.196.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A6A3612E7
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.247.196.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927558; cv=none; b=b3pcQDTIyxrsmk1nVRJ5ojXh1BUDqsYqT7OxGNTDuPDHCtFW8q+fVDmpwCbXDEgffyDaQhJLDn6yfDAGJxuv5SqMCbi7P/NsvWiUL4CIinB3ftm+vAUmlRaHBE608wKuoWEcZyaMMApZ5R1jwRnwPHeX53Kapxz+8AZw/X9SDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927558; c=relaxed/simple;
	bh=JUFspoQNePCu3sx+33YwcWSfxBGfUaqgfYRMvB92U5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNfOc7hfiLcSSdvi6t9iKjD+ESjyMNNvwrrAbSh27mX+cgL5mLZYgzyJKj6INCUv52b6Y6CWE+2T7Z7bU3eINGZELjz1h/tbVxH+8zXtz66KiQHq9y2VXsbSOvn4j/j5fYOwS3wgx+Y2FlRuvdr1tZsw8apDxs+2yEthBdCgweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=M/SAF4ZV; arc=none smtp.client-ip=61.247.196.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="M/SAF4ZV"
Received: from cvsendbo022.nm ([10.112.20.47])
  by mvsmtppost17.nm.naver.com with ESMTP id K+h4fLczRJy68pzOn1gQNg
  for <netfilter-devel@vger.kernel.org>;
  Fri, 02 Oct 2026 07:42:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1790926946; bh=JUFspoQNePCu3sx+33YwcWSfxBGfUaqgfYRMvB92U5s=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=M/SAF4ZVfrGwM2YufxsBhUbE8wYrHQUZPGKLmWapRtSQoOdPdVFMrq4HhZbh5oZ8Y
	 EQmrcqugBmNoDvU7P/fN+o04+PIxb5lW/1/qE1mLaS8QMGId1PAr4X5tZrA0keOynH
	 n9W/WdZSxtJeWqFIgpZYAQuAhxrJBIwi8CnxAK1/9SGlAGY8jZNw5tq+HYhdLdS1ZD
	 bKNcDoHjp8QMNek7ke6bHBdu02pYHzt0Q6VEvdstVirwXllVadVVSTzZFtrAVzBJSn
	 cqkfvvTi22XoEIJY1bafL3q2oQ9Vc3jNWXOPdIjWheMKQYDdPQnWljKXxswSnTacYt
	 /MslqwQ/DxlqQ==
X-Session-ID: yBsmHpcKQJ2JXoj+LyXm0A
X-Works-Send-Opt: OsFwpzGdjHmdKHFOMr39Ko3YKHm/jAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: VqYlaAglFqJZ+HmrFAEd+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp003.nm.naver.com with ESMTP id yBsmHpcKQJ2JXoj+LyXm0A
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Fri, 02 Oct 2026 07:42:26 -0000
From: tjdqudcks0424@naver.com
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	kuba@kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_reasm: avoid truncating header offset
Date: Fri,  2 Oct 2026 16:42:10 +0900
Message-ID: <20261002074210.140795-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179089937913.434549.5874493628033954656@kernel.org>
References: <20260929090027.200041-1-tjdqudcks0424@naver.com> <179089937913.434549.5874493628033954656@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sung Byeongchan <tjdqudcks0424@naver.com>

Hi,

Resending in plain text because my previous webmail reply was rejected by
the mailing lists for containing an HTML part.

I independently tested the 16-bit header-offset concern raised in this
review. The concern is valid and can cause a local kernel panic.

This is separate from the existing prev_nhoff u8 truncation issue. To
isolate the two issues, I tested a current-mainline-based kernel at:

  ce1e0223d8ad4211275c82a17ed6d43ab81e13d9

with only the already-public u8-to-int prev_nhoff fix applied.

The reproducer sends a 65536-byte IPV6_HDRINCL packet to ::1 with the
real Fragment Header at fhoff=65528. The loopback raw-output path
reserves 16 bytes of headroom, so:

  headroom + fhoff = 16 + 65528 = 65544

This value is stored in the u16 skb->transport_header field and wraps
to 8.

With init_on_alloc=1, the wrapped pointer reads the zeroed headroom as
a Fragment Header with offset 0 and MF clear. Reassembly completes,
advances network_header from 16 to 24 while skb->data remains at 16,
and inet_frag_reasm_finish() passes -8 as the unsigned length to
skb_push().

The resulting diagnostic is:

  skbuff: skb_under_panic: ... len:65520 put:-8 ...
  kernel BUG at net/core/skbuff.c
  skb_push
  inet_frag_reasm_finish
  nf_ct_frag6_gather
  ipv6_defrag
  rawv6_sendmsg
  Kernel panic - not syncing: Fatal exception in interrupt

I reproduced the panic in three isolated QEMU runs:

  1. Linux v7.2.8 as root
  2. The mainline-based u8-fixed baseline as root
  3. The same mainline-based baseline from outer UID 65534 after
     entering a new user and network namespace

In the third case, the process had CAP_NET_RAW only inside its new
user and network namespace. No loopback MTU change was required.

The crash runs used nf_conntrack.enable_hooks=1 to activate IPv6
conntrack defragmentation. I confirmed from the source that an nftables
ct expression can also acquire the IPv6 defrag hook in the caller's
network namespace, but I did not perform an additional crash run using
only that activation method.

I tested the following minimal guard on top of the public u8 fix:

  if (nhoff != (u16)nhoff ||
      !skb_set_transport_header_careful(skb, fhoff))
          return -EINVAL;

With an otherwise identical KASAN configuration:

  - the exact crash packet was safely rejected in 3/3 runs;
  - short fragmented packets passed in 3/3 runs;
  - the previous offset-248 and offset-256 cases passed in 3/3 runs;
  - ordinary IPv6 UDP and TCP passed in 3/3 runs;
  - no KASAN, WARNING, BUG, Oops, or panic was observed.

I searched current mainline history, lore, Patchwork, and
linux-cve-announce. I found the existing prev_nhoff u8 fix, but did not
find an existing patch or commit that checks the u16 nhoff storage or
uses skb_set_transport_header_careful() in this path.

The demonstrated impact is a local kernel-wide denial of service when
IPv6 conntrack defragmentation is active. The panic occurs before
packet delivery, so I found no evidence of information disclosure,
privilege escalation, arbitrary memory corruption, or remote
reachability.

Would you prefer this check to be folded into the existing prev_nhoff
patch, or should I submit it as a separate follow-up patch on top of
that change? I have the reproducer, serial logs, A/B results, and an
applyable follow-up patch ready.

Regards,
Sung Byeongchan
