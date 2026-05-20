Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42463438A4
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779240567; cv=none; b=JI51wjaH1Y1dzsuncDlMzbxFbU8kV7Bx137C6wcupv8dwilQ2xzWq+Mie9OxBYdjVgPZYR8wdYV2yNJbQ9HaCgC5uiKmrdtAy9coGYmRmeLpGVIM+dWzgZovzGALTkE7E8pASDyPnZpgQTuXIeoTDSctw7oTFYkBM2PYy3vMVOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779240567; c=relaxed/simple;
	bh=Hu8zDtNMBrc+5wbcvkAIfyDm9uV2mGXXKMSxc6qL+20=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=hKqIbRO8OpF66M98+UMvrYeMbgtAWCMnHXs2cxxyFYyqn0lVOIu9FMNrOV5sMYiXrqqieQmoVPkClZL73EIplPBuyiwzA1EF5sSp5ZC+qT7anpjwAFfoQ5EQiDEvU2DUoPOdw3uePQozDQdRpQPSeJTcubFLMpakKD+UkRJkA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EX6wOPGa; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX6wOPGa"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-65c09c1d000so4677719d50.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 18:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779240565; x=1779845365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sfqAEdhlbXdhpv1B5LAHbRnjd4l+/snCkCwOb+8Uak=;
        b=EX6wOPGavDrsdCuR63gKKcnoevZM++5ttJL3BPMRqMuXwBh5VnYTeTpSTETXaYSjya
         Mg8fP2F1ZfaCvLXO3T+atC/yVZ8EdZBkYKR+RmfiES2DkwGk8W3nd0w6aRvq05qYqc99
         1HdhZqD/KGoU+8w+Sfez3blZNgNgzwPRBco1RPzOTB1Z2zZbw0ckCnc6QvBgRxHKEyyz
         X66pDDbYynNMTTvLfS7MVryxKXxTkVn5tmVWd1N21sonFoIBTdNwKeZKS0nwQlI4lQ5/
         Np6V77T87qrcKNPSP1FSEyJo76JYLu+Dnm3zd4ORznPf/v77UZ2nemn/lrg7nEbsSONP
         WKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779240565; x=1779845365;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0sfqAEdhlbXdhpv1B5LAHbRnjd4l+/snCkCwOb+8Uak=;
        b=Smk3ReWxFap+POSfMPTM6ltQLocJxLi4oJmkOhisDgse7NdNj50DzdiT/CD2tAmvxW
         SvFP1DuKnB1pps0YzeDMFxZn5pyKKhGIDI/0RHM2q1n4opdNgw/8wZ2e6+ORSzDtJuLc
         C5OxnIECLB2fRT3W7xWOp5jPDLaRPb/JBqyO7hmhiHRxIapJEFK+KAHc7A0p0uUhL0h8
         IICIgBIIs8XRnIdtigfkCouuYNSTwkYNDXPgYCUf+TSNKS0Tl2/1Mp9s2ugid/iJeYxJ
         N8LTnUWpaBkx4McaH370bd6Wf0WK41a8AYkpfYAJPXiqA0V92LYMNU0S5mTFMejD2U1V
         n/kg==
X-Forwarded-Encrypted: i=1; AFNElJ/3/JOekc2AS+i3voctlnQXRBeYgUzy/W8s2IxnMjfssd9F/MMjLcjnRTBn5ou7wBIOfLxS4UZr57citYsNlJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlhtZBnxcC8ms6rGtIqs4ly9GG75YQt+biMsdZvRqlvGg+3FLA
	UdhG4n6AN2cqbFrG56eixp248OV5efGkaKemQg/FH/wXcGF66xNBncXe
X-Gm-Gg: Acq92OEvrbQv1eIB3i7y565MhqGW+FdBoRNS3lSNIvluMDVM3fcbUio4tgEPEyq1sZf
	+I1IXu6a42C6cD/weNxda1alIJ00IRPh/P0gzDfoaPSpBOCp6WaqsbgwajKuMFdGP6jqKQlko9F
	RzcR4aifWa02CEEWP8YCd/ywhqmmyhHawH79Zb4RK2nTvA98jFP2XSnpwBwX3rrFPZnfJ2PYDZK
	Qb53B3gofIBR/TiFMTH/qWsyENv8lD0kGlKx5nxpY3H2J8pxduw5nIlmzrJvvrmSLdqvxH21ZAZ
	a3R2O4odyvR2ELfJzQsR/S8cUrrwk7uGL8XrJIyp0J8WfLGpX0lsMRrIfmI8+TeoyaJKq+woOC9
	RUU+9Lz2qKusi59wdD6Qgotw8SVcrDQB5nSEmZGzmcExIKbMFFRCnDDaRYaMZU8KtISZK8IJ+4q
	4EXaQUon0PzEWcPpfPaaweprYhzGIzwTzAje+Z+rX4slzVmSrDGohxR42+bUwIqXduF1Alg1JO6
	mFjW9fSi53RwzE=
X-Received: by 2002:a05:690e:134c:b0:65d:5702:3383 with SMTP id 956f58d0204a3-65e0b2f68f1mr20974182d50.43.1779240564832;
        Tue, 19 May 2026 18:29:24 -0700 (PDT)
Received: from gmail.com (172.235.85.34.bc.googleusercontent.com. [34.85.235.172])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0d89b124sm8657617d50.6.2026.05.19.18.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 18:29:23 -0700 (PDT)
Date: Tue, 19 May 2026 21:29:23 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Federico Brasili <federico.brasili@gmail.com>, 
 netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, 
 netfilter-devel@vger.kernel.org
Message-ID: <willemdebruijn.kernel.fc94e94f7ffd@gmail.com>
In-Reply-To: <20260519132535.3806659-1-federico.brasili@gmail.com>
References: <20260519132535.3806659-1-federico.brasili@gmail.com>
Subject: Re: [net] AF_PACKET PACKET_VNET_HDR CHECKSUM_PARTIAL packets bypass
 ct invalid classification
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Federico Brasili wrote:
> Hello,
> 
> I would like to ask for feedback on a possible checksum/conntrack inconsistency in the AF_PACKET PACKET_VNET_HDR transmit path.
> 
> A locally injected IPv4/UDP packet with an invalid raw UDP checksum is classified as ct state invalid when sent as a normal AF_PACKET raw frame. However, an otherwise equivalent packet sent through AF_PACKET with PACKET_VNET_HDR and VIRTIO_NET_HDR_F_NEEDS_CSUM is not classified as invalid and is delivered to a UDP socket, even though packet sockets still observe the UDP checksum field unchanged and report CSUMNOTREADY.
> 
> Minimal behavior observed:
> 
> 1. RAW_BAD
> 
> AF_PACKET raw frame
> UDP checksum field: 0x1111
> 
> nft:
> ct state invalid counter packets 1 drop
> udp dport 12345 counter packets 0 accept
> 
> UDP socket:
> no packet received
> 
> 2. VNET_BAD
> 
> AF_PACKET + PACKET_VNET_HDR
> VIRTIO_NET_HDR_F_NEEDS_CSUM
> csum_start = 34
> csum_offset = 6
> UDP checksum field: 0x1111
> 
> packet socket:
> PACKET_AUXDATA reports CSUMNOTREADY
> UDP header still contains checksum 0x1111
> 
> nft:
> ct state invalid counter packets 0 drop
> udp dport 12345 counter packets 1 accept
> 
> UDP socket:
> packet received
> 
> A trace of the VNET case shows the packet being converted to CHECKSUM_PARTIAL and reaching conntrack/UDP in that state:
> 
> skb_partial_csum_set(... arg_start=34 arg_off=6) = 1
> XMIT      ip_summed=3 csum_start=36 csum_offset=6
> NF_CT_UDP ip_summed=3 csum_start=36 csum_offset=6
> UDP_RCV   ip_summed=3 csum_start=36 csum_offset=6
> UDP_QUEUE ip_summed=3 csum_start=36 csum_offset=6
> 
> The relevant path appears to be:
> 
> net/packet/af_packet.c
>   packet_snd()
>   tpacket_snd()
>   __packet_snd_vnet_parse()
>   virtio_net_hdr_to_skb()
> 
> include/linux/virtio_net.h
>   __virtio_net_hdr_to_skb()
>   skb_partial_csum_set()
> 
> The same behavior was also reproduced through PACKET_TX_RING + PACKET_VNET_HDR.
> 
> An explicit nftables rule such as udp dport 12345 drop still works correctly, so this is not a general firewall bypass. The observed difference is specifically around checksum-invalid classification: raw invalid packets are treated as ct state invalid, while PACKET_VNET_HDR/NEEDS_CSUM packets with the same invalid raw checksum are not.
> 
> My question is whether this is considered intended behavior for locally injected CHECKSUM_PARTIAL skbs, or whether AF_PACKET should reject or normalize this case before the packet reaches conntrack/UDP.

This is expected.

The VIRTIO_NET_HDR_F_NEEDS_CSUM flag on transmit indicates that a
checksum hardware offload (CHECKSUM_PARTIAL) is to be programmed.
The sender will include checksum start and offset instructions.

Handling of CHECKSUM_PARTIAL skbuffs inside the kernel is described at
the top of skbuff.h. Note the section on receive processing, the point
about "are considered verified":

 * - %CHECKSUM_PARTIAL
 *
 *   A checksum is set up to be offloaded to a device as described in the
 *   output description for CHECKSUM_PARTIAL. This may occur on a packet
 *   received directly from another Linux OS, e.g., a virtualized Linux kernel
 *   on the same host, or it may be set in the input path in GRO or remote
 *   checksum offload. For the purposes of checksum verification, the checksum
 *   referred to by skb->csum_start + skb->csum_offset and any preceding
 *   checksums in the packet are considered verified. Any checksums in the
 *   packet that are after the checksum being offloaded are not considered to
 *   be verified.
