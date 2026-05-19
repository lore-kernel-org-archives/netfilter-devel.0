Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78C2690EC
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196414; cv=pass; b=UoTLcv5bWLDulvOgxJseoh8KOa4fqkHDlyENHaKGcOR/r7i1i9j86Ta+LbtwxBPSoa3onxEf/cFSyEMqV2uGOyoUoEPT7VwBGxEF0QooIqAqwemocXucrUB+k1pSPH4500xg92wSPHmdV4mmc00Yw+jbBP1UG2rLFAzxYrfHPFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196414; c=relaxed/simple;
	bh=Uq8Uv76VoSqgu2Xxy7jY5UaQBqn/xykEQFsH3kw+DnM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Pl2ZDi2Vp9u6WAOnArXxDykZrH+3X5XJCz1ev0TpFfiRQJr62dm7ip1XzxN3B4cqBIb6mxkptpRYpIUnmzfJsC3kTeDwpvK9sytBEEIf24yvQ2Nf1IAq8jpDT6gTn6la851on0O+mkcrL0HVghFzNi95mRTx4nYsfWC9/xUN9EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sImQ2+3L; arc=pass smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sImQ2+3L"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-479d9b155deso1032926b6e.3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 06:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779196412; cv=none;
        d=google.com; s=arc-20240605;
        b=O+8kf3UDzf5wn1FfphHk6TfK6rLXVWy3+QjOi4h7wN6PjVAc+VUJln9pjtjq30yHcG
         TI6ekUrXkFesPkXEgls/o5k3ZPhUSqMyecaqGwthwRepxxhkiBBNqHJM6dkdMfZqwquY
         NgoLGLdyckX3t9aYoGY4NP7pBkD1gqj5nr2PgGJBjwnAD2sUOdFKLkAAbqqQa1Xggr+W
         XddWo/Bqx2KfhV8t+B2VMQf62dgl+VJLbm46j3pYagjXdXR7QTYyzHmjtqWQ/56pC9on
         WalKxCrK1AeRmiBSQfmJ0vW5F9IhI94kObGq+d1ugC5iqwffMHkpYVCoAcaxFd5w3rrs
         FAQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Uq8Uv76VoSqgu2Xxy7jY5UaQBqn/xykEQFsH3kw+DnM=;
        fh=+xku+NwDVD9G+O5tNrwkR++oEpvVqdeDnU9pkd2HbEs=;
        b=TXpczRHSPmBDWSLPAd+OtOFc0gJ33RyT0SZg5j05d5aGkOsmVlIJy+avwkk6yK8oKW
         MmHVn4schnVrQqZsz5Zoqq4Pa0fjI1vHHL5Ab8TLMgz9yFO5ZNsQfNyfoTbm9VBKbrXB
         7gBO72XSRaQturcVxy/PC5+hbWm0Z901sNr3j6F36Pw/baSgxqQUSXhZpb8ifL45mPkE
         yGdflYuiCgtcQof5DWn/zYDWiqHMJyTIKIVMFoANr3MtRoDf6sQOKIsUYGUarpHUzjTO
         vmM2EeBw+nA1mSLxUylgRTmq1WYHLhzjlZ+nxyq2LDshvU5XW+qLaMBFcXHB6X7BWNpg
         7rNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779196412; x=1779801212; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Uq8Uv76VoSqgu2Xxy7jY5UaQBqn/xykEQFsH3kw+DnM=;
        b=sImQ2+3LBj4tN1tLtKeZtlLXXtH+gIo1drsLy3GRBRyqeKCK4VYKElxx/7fqMdTJ51
         zxIUzHjWqDb7Ot3X07lNj2Ve3Afz5WzJLn+Cyh8Fw0N7UFJZHEI78xx+rCwydrpDNck2
         UOFTkeTqyn4z/UPJd5m0Ho+WZlfEHQhpl+qKW4j6XjY3y31heZmg9C4op2Oe73rxeKkS
         3WsPOOiCY28KVTDOU+tHQ8W/DU3bJlQPIE6D7CuCX9ijIjB8Ra4t1hodY4y8oaRbTybn
         q9y5yAaW5s3XySmwNDBd1hWzMzrKsVEeSnhenI8QNuDSFS2rLHV74hU86kWN0+roZpth
         9kBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196412; x=1779801212;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uq8Uv76VoSqgu2Xxy7jY5UaQBqn/xykEQFsH3kw+DnM=;
        b=BOBlrn/DW1d0fM7ogNohxBoReFJ82D6yc0Gx/t6z8oo7/jTCnzAZW/4dkdnePZBJ4w
         liCpuOeCOQWbvaaz5DSeMK+f8Zg84ay5LLB+sg80Kk+hRXfD5LjyFM+HH4m8OpcxxrgR
         DrcUG2GUt7nKebJduBSz/GKaXDjFLm1x5D6gsd7nxZ60pzRq2fUVWYBDdvXkdrnNwMTV
         l8qSBM+ZfTHrCFiLL6SXrqgmDhqjQFmakZ60wqVzmft1VWlSSG2m2FLMmdDjUDVWpPad
         DkCCGkgUZ++WQlXq4L0zHqO3vXY5J/AgNdMJxxJIyF+0q4d1KyjU0DBg1UOfTdcA3cGf
         lnJA==
X-Gm-Message-State: AOJu0YzJw1tcobRO/imfppdc5y/16i14ZjDLtuDlgc5TwZxR7i/hddHq
	LMEZSjqTtT5MpQ+Js9ULrJLM1CubXxVz8qyoVcFzcOFfeNCkiFYnhsE2oRycJZvFwxhSWCzZRQv
	0JJy3DQRlgGjGsgnzY6jJGWyloVsbFE0TICoR+C8=
X-Gm-Gg: Acq92OEtZwcaygiM94hyEpAhkgQe6tBqqKFURIaEno+E1dua3ifpJghSqGB8bRRN2VQ
	zehAYO8LCMf95T50ekE9tiiwq/HgtAEN1l5KJ9gR09yxSyaocrrhxDdmweamk2VBCFRxurJ1VWJ
	hhogJJBNgTfr9CJvfcXn6qFYsjzKaFM4iQUhgI7gsDfHB40hFqre91XuvqLn9yXsYwYN4qxeouQ
	+pSZvtrYdDPmkmCoVBQRlRVbftzvS53W20dIPZPEZhfi0KOHi8goGUVW7XNu9VNBQMrSs75EbVo
	9hbrLw==
X-Received: by 2002:a05:6808:124e:b0:479:ac7d:6da8 with SMTP id
 5614622812f47-482e56310e9mr11580479b6e.18.1779196412539; Tue, 19 May 2026
 06:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Federico Brasili <federico.brasili@gmail.com>
Date: Tue, 19 May 2026 15:13:22 +0200
X-Gm-Features: AVHnY4K2s5mNKsvcTMCldiaF7FozFvwcgzBTCP_F_3U_m1StpUhvC6KUAc_DFjo
Message-ID: <CAAEr8jbV+e5SM_GZqqbiV0zwoA5EH=eH_L+8Lg0w5RPmBPeekA@mail.gmail.com>
Subject: [net] AF_PACKET PACKET_VNET_HDR CHECKSUM_PARTIAL packets bypass ct
 invalid classification
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, davem@davemloft.net, 
	"edumazet@google.com" <edumazet@google.com>, kuba@kernel.org, 
	"pabeni@redhat.com" <pabeni@redhat.com>, "fw@strlen.de" <fw@strlen.de>, 
	"pablo@netfilter.org" <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to ask for feedback on a possible checksum/conntrack
inconsistency in the AF_PACKET PACKET_VNET_HDR transmit path.

A locally injected IPv4/UDP packet with an invalid raw UDP checksum is
classified as ct state invalid when sent as a normal AF_PACKET raw
frame. However, an otherwise equivalent packet sent through AF_PACKET
with PACKET_VNET_HDR and VIRTIO_NET_HDR_F_NEEDS_CSUM is not classified
as invalid and is delivered to a UDP socket, even though packet
sockets still observe the UDP checksum field unchanged and report
CSUMNOTREADY.

Minimal behavior observed:

RAW_BAD

AF_PACKET raw frame
UDP checksum field: 0x1111

nft:
ct state invalid counter packets 1 drop
udp dport 12345 counter packets 0 accept

UDP socket:
no packet received

VNET_BAD

AF_PACKET + PACKET_VNET_HDR
VIRTIO_NET_HDR_F_NEEDS_CSUM
csum_start = 34
csum_offset = 6
UDP checksum field: 0x1111

packet socket:
PACKET_AUXDATA reports CSUMNOTREADY
UDP header still contains checksum 0x1111

nft:
ct state invalid counter packets 0 drop
udp dport 12345 counter packets 1 accept

UDP socket:
packet received

A trace of the VNET case shows the packet being converted to
CHECKSUM_PARTIAL and reaching conntrack/UDP in that state:

skb_partial_csum_set(... arg_start=34 arg_off=6) = 1
XMIT ip_summed=3 csum_start=36 csum_offset=6
NF_CT_UDP ip_summed=3 csum_start=36 csum_offset=6
UDP_RCV ip_summed=3 csum_start=36 csum_offset=6
UDP_QUEUE ip_summed=3 csum_start=36 csum_offset=6

The relevant path appears to be:

net/packet/af_packet.c
packet_snd()
tpacket_snd()
__packet_snd_vnet_parse()
virtio_net_hdr_to_skb()

include/linux/virtio_net.h
__virtio_net_hdr_to_skb()
skb_partial_csum_set()

The same behavior was also reproduced through PACKET_TX_RING + PACKET_VNET_HDR.

An explicit nftables rule such as udp dport 12345 drop still works
correctly, so this is not a general firewall bypass. The observed
difference is specifically around checksum-invalid classification: raw
invalid packets are treated as ct state invalid, while
PACKET_VNET_HDR/NEEDS_CSUM packets with the same invalid raw checksum
are not.

My question is whether this is considered intended behavior for
locally injected CHECKSUM_PARTIAL skbs, or whether AF_PACKET should
reject or normalize this case before the packet reaches conntrack/UDP.

I can provide the minimal reproducer and full logs privately if useful.

Tested on:

Linux 6.19.14+kali-amd64 x86_64

Thanks,
Federico
