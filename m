Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6EB30F957
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197299; cv=none; b=hwb7NtZm0IpV+Qw5AK61E7OhmQg0XBHrw3vxm76ukcdSnBiyqJsXGCPtoP1/ezomtnAR1G/prm7WOXhlIu8UgWu9RVT+OcN0q6ysDcqHlxlBu5Bm01+vjaysKnrkr1vvYLQ6fOXnGjG5JWGmihjO07raQu5zgXa8RxR0l1uCHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197299; c=relaxed/simple;
	bh=1/xVXZdKhAdlqMiTsVet9wqnGJk84XqklvnZCAnXSxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pe6MQeNGqOV1X8giawg8WkM835k32RJ/VufRK8nPQFRPPwE0vcjVXqxo85vB40WbPTpxoka1UpdBuKG7bZSfW5kKEbz9Y+godnvdOg9d+KU9o9NBtLh5u2P9cbs8ca6uInt6/0ba8qjbC8Be6UajVStolUI6IimL7PqtqYms1PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQRmhD+G; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQRmhD+G"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-899d6b7b073so45049096d6.2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 06:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779197296; x=1779802096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oKPSUbsZSmEbkWfEx2IzJ+tvdP/7UtkEfOkK4Ns846w=;
        b=WQRmhD+GsTxM99UctZQImKqgMss9hTw9l2MQazpvr3FZstGLz2SoF8aFCc7AEAmW2a
         K66b7mlGX5NmdLmSghSl3eHBuV/kyl6w09MMtWRB3y7B6yTSx4j+YA0R4JuXj1jZOpRa
         xt+qKay8QxXQtfMWkW5L6BZkb0v8H4PNimVFZtjFB1Md9YMgOwC0HXxVBS45BxGRUs4T
         DEmL/2SGsuyUZPOWkj+VQQ9+wKxdksWVVYDtt06lLOqEZHLpikMppckjokUWNRHvc++K
         JOlaZ+JqRouTaKqLGV671E9kCRL0eDIBYU5CPm9J3JFf7dEwtcQCWX8P8qXj+FcIO2oL
         8nRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779197296; x=1779802096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKPSUbsZSmEbkWfEx2IzJ+tvdP/7UtkEfOkK4Ns846w=;
        b=SpaJECeSBizzPWrJP7VIbZnkXcUwJoIT8jGKxSRSUJeL39mZbo93So+JIGTyCejEHC
         OhGuMeM2axP7jAP/a2ZOIJUYEUbRP6iJmeio9WpcW1g5j3deVM25JINiunpjP4o8NqDq
         4XTDZT/7ZBScipZ1zO3vlss2pCDRh8o0qf++b3xe5A5QB1uL4rjPRgKx3CKQGbU8sy6X
         R5W5ss9PMZO9ycPj9bkZcWs8FR5CLC5IdWDX5d/JEm/s/cgkOfaSFGgcpvoEto2bbc5X
         gzCkcldKLmNE+wo7h4uiIN4Kops2nX4R8ubNHjsBo5aJKIhkeBy0wFfabR/NvdQiFmyG
         /cmA==
X-Forwarded-Encrypted: i=1; AFNElJ/vuYZ4gNPfhXxmX8g/EHxO8o8TirutXwBw0pWN6a6m1W06dBI1P9RFvcGGqC/5UuN1T2RWDelkrkuDrmTiSgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwE/M/5zbNgJ7Xv49JVdccXpxQlw5SkNU2j1W2Lk83ARFZsLZ6G
	5oAnMb8q9rIBE/OvA8Y6LDcLKs/++yXHRNDRABfq5umAqZtvKF5c7E12
X-Gm-Gg: Acq92OEPVq9OnLxwT9+DxbokmHNCQxZqCbHdtQUn1FxPcI8W0u16wywt174PXWerKTB
	0zx/KQigd5rDSX9uo9F/B7kYiOpqf2FljL80W5LBQ1DpdGD/VwQkZjyc0riVjrNgmU1Iy6gqEEz
	ORZNILBzBWFO80SOy8A77wwf6ogDTo1QAJD5HaXnEteu0UuyoT+YhjhN2BfGmRwfpIkNMtdjP/5
	9av/TU0iXAMypO5Md76zTu5ScNZ9sMj8OWR3xNtHLSN5oYvtBZkIWuC+rJw0e0i5uTVrQQaUoeO
	fNZNnRKmkiWlrQ8uZeCxEdcjuiuXJojb6ceFt2ac+Z7PBWZrqV1NNj8QX7nWVijXm1K+wodP8vG
	2mQf9N5qi2IibQV6HWOF/Tkc4dYJj2bk804yojPoW+Q9zeFOMRGTDJXy5DrZnArHMJG2q/lRGa9
	KWn/Bu2Bo5VQJjOXXlWPaLr3GU/gzImPex0FrXq/patxRNHZRFuEkbV/LBeSOoSkTzg6hHOHaQ+
	gJEz+qYKqtPG7qy9ZIgKRIeraFbHnY=
X-Received: by 2002:a05:6214:8085:b0:8b0:2017:958e with SMTP id 6a1803df08f44-8ca0f5eab0emr293198356d6.13.1779197295866;
        Tue, 19 May 2026 06:28:15 -0700 (PDT)
Received: from hunt.homenet.telecomitalia.it (host-79-3-197-232.business.telecomitalia.it. [79.3.197.232])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3609784bsm90218616d6.16.2026.05.19.06.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:28:15 -0700 (PDT)
From: Federico Brasili <federico.brasili@gmail.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [net] AF_PACKET PACKET_VNET_HDR CHECKSUM_PARTIAL packets bypass ct invalid classification
Date: Tue, 19 May 2026 15:25:35 +0200
Message-ID: <20260519132535.3806659-1-federico.brasili@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I would like to ask for feedback on a possible checksum/conntrack inconsistency in the AF_PACKET PACKET_VNET_HDR transmit path.

A locally injected IPv4/UDP packet with an invalid raw UDP checksum is classified as ct state invalid when sent as a normal AF_PACKET raw frame. However, an otherwise equivalent packet sent through AF_PACKET with PACKET_VNET_HDR and VIRTIO_NET_HDR_F_NEEDS_CSUM is not classified as invalid and is delivered to a UDP socket, even though packet sockets still observe the UDP checksum field unchanged and report CSUMNOTREADY.

Minimal behavior observed:

1. RAW_BAD

AF_PACKET raw frame
UDP checksum field: 0x1111

nft:
ct state invalid counter packets 1 drop
udp dport 12345 counter packets 0 accept

UDP socket:
no packet received

2. VNET_BAD

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

A trace of the VNET case shows the packet being converted to CHECKSUM_PARTIAL and reaching conntrack/UDP in that state:

skb_partial_csum_set(... arg_start=34 arg_off=6) = 1
XMIT      ip_summed=3 csum_start=36 csum_offset=6
NF_CT_UDP ip_summed=3 csum_start=36 csum_offset=6
UDP_RCV   ip_summed=3 csum_start=36 csum_offset=6
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

An explicit nftables rule such as udp dport 12345 drop still works correctly, so this is not a general firewall bypass. The observed difference is specifically around checksum-invalid classification: raw invalid packets are treated as ct state invalid, while PACKET_VNET_HDR/NEEDS_CSUM packets with the same invalid raw checksum are not.

My question is whether this is considered intended behavior for locally injected CHECKSUM_PARTIAL skbs, or whether AF_PACKET should reject or normalize this case before the packet reaches conntrack/UDP.

I can provide the minimal reproducer and full logs privately if useful.

Tested on:

Linux 6.19.14+kali-amd64 x86_64

Thanks,
Federico
