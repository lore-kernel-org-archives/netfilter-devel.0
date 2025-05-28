Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CE328641B;
	Wed, 28 May 2025 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748436744; cv=none; b=PYunkI7+QE9LglcHY1LtcsbAZfNDAJ3GI7aoNoKOisqP04PZD7SuZUIovWgvRSMnhgqt56GOzL3fZhkrPRj+7wRe7g0sp3meRrEHGCeEZ0TggOZZiTfc/dkjwz1dZ1ldn4OE1DqT2VpAKyKSQ0wvcKmHaVasMo3qQuT6o7pv/vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748436744; c=relaxed/simple;
	bh=rSHnMm/I4ZVMAQknHKeTSE6S/3hkTR9sAaQ2wgg/3GU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=aZpYyNMDXSvoRNJ8G7DNn8tRPe+Dgwgv1/8xkhAyuqCSfNPsWY/Hg2D3Z5lPkVDQo/K0EQycZk16SxIf2c4mDOcOt6vSvLw8CsgEmz5sd220WyWgiwnax/SxdPAcVbZNJdl5XNDoBq6abDhzbd9jzbHzFwovCjeXanUn3HZ5FTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qyq82CRO; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qyq82CRO"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-ad5740dd20eso683777466b.0;
        Wed, 28 May 2025 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748436741; x=1749041541; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q6gUi0f9uAatD/UfV5AR0D8k7xuPtA+o2t8ZNTCP0J4=;
        b=Qyq82CROaBL21M2MwV+P90fTXoOJGXXa1D8VBiCp+HPSFf+gYxoZVoaMsjflyAyJmU
         ViEdmU3pCGKnsGi9qSW4Q6AGH8zO6sZhdSDSSIoYgIQV9nYxwZUAbPnv93FO8r98qG0y
         xTqLt8CPxWnOQwA6iOMUzCsHo37WLK5eKGT8+WjH9N44cjn01ug44+8V+24oYyITXk6X
         Nr+XOOphLEDEhLiRCFt2moru0Amd1+1uyteZfvytHlmr1WT7LYOUBHsQ0POUGk2VSCly
         oJsan4PFdRA4E+z+edTICDULIvU+ypjw10SOUPX0NiWqWQlDXB5ETy9oYWW0RwMC96vo
         kSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748436741; x=1749041541;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6gUi0f9uAatD/UfV5AR0D8k7xuPtA+o2t8ZNTCP0J4=;
        b=WfsXzF826uT+7P8pVNJnS0jAzSt3BXLRSQbl3JiNKRVWYr95VvA2aJcPvlYB/PzSn5
         eAn1xIoXrtRsOuGtgvgQrZImT21kiKt1KwNzPuQD9xxZ4TI6a+NbA+T2xc1ddSOwCW0p
         VXfKRmSTylHlaywn+JxS8Qkust4KltTyIFB1vJMld9iPFkezsPTiSvCxlxBiYsILH98g
         KABzCWrf9BHBH4SDNK4Hq6N/ktdNy11itkPyGv/L+eOlJlSr3j86Yn4fUuDMEdGEb1EW
         ZAMgU+L1DdEzH/DmN6LKaUpgyHlWBVnXp4vPxL78sV4gE6bi7uFWB2A2v+EAH/+Hq/Tl
         C4+w==
X-Forwarded-Encrypted: i=1; AJvYcCUuqWGr9RO5R7caYCiuit7q1r8JWXo7pGXDb9PkQHs+WcQWCUiwXCONsHXga611GRs2WYfYMXoBDdP/Fbo=@vger.kernel.org, AJvYcCWXJfsD7Ayhsr43DENRGlfe1BKCsoXhDcZdFTbVoQlau+Ga7IzVfBKaGlxg+D09vAWoDXAKs29r@vger.kernel.org, AJvYcCX9eLg3KDReupqtxyaeE1Ufc9wxEPzW9U5hsGkY2/Es1fqgEpoI56G0OR33d6xw8tNQP8Kiguu1ZRlha1uxqPZ1@vger.kernel.org
X-Gm-Message-State: AOJu0YxRXFTGc/95UhCpis7ctIwmKGRfxQqx/xbUqOgaG6ozx336P+KO
	k+zeOQiwADWT48jCJnq1orAcvrOzELCe5w8ItTTXQOEcSF2c6oGZFa7gX/LSUVlpPlx2mmjqZr4
	Gbr+iotN2sD2BydLoHxbviRdYuhDnZYe2VM7B+5I=
X-Gm-Gg: ASbGncsz1o3xzk/g6HPZZbvTBkUG+xC7hf7AysvENqOVOqxcGvSkNeBWkMt3y0q7tuU
	z9qgvPfv/qTKBxdfVZvtnRdeV5W41db8RUSBK5zmWotVywz2RcKOJKtkZYYk9p33jvPfrWK5VDQ
	NQMUkIIVTe1a3tsgrSQUT+iPb8fk+TGZr0BSnU2EtyaK21
X-Google-Smtp-Source: AGHT+IH3Z8+NTchkkrhzXIRW9XhN78aZiIFMRJuj2GxLRE0a/FSnwoZZ/z81gAnvkQOnuGdnHPKq/HcUz08E8e439B8=
X-Received: by 2002:a17:907:2da0:b0:ad8:8d3c:8a73 with SMTP id
 a640c23a62f3a-ad88d3c8d43mr640644366b.17.1748436741125; Wed, 28 May 2025
 05:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 20:52:09 +0800
X-Gm-Features: AX0GCFvcMRe9eaU2zLXLzQ3AXlGsNYT_X_RyAVlEYp0RSgrVDkCPnVNhzQh1ogQ
Message-ID: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
Subject: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello all,

I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4.
Running cat /proc/net/nf_conntrack showed a large number of
connections in the SYN_SENT state.
As is well known, if we attempt to connect to a non-existent port, the
system will respond with an RST and then delete the conntrack entry.
However, when we frequently connect to non-existent ports, the
conntrack entries are not deleted, eventually causing the nf_conntrack
table to fill up.

The problem can be reproduced using the following command:
hping3 -S -V -p 9007 --flood xx.x.xxx.xxx

~$ cat /proc/net/nf_conntrack
ipv4     2 tcp      6 112 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=2642 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=2642 mark=0 zone=0 use=2
ipv4     2 tcp      6 111 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=11510 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=11510 mark=0 zone=0 use=2
ipv4     2 tcp      6 111 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=28611 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=28611 mark=0 zone=0 use=2
ipv4     2 tcp      6 112 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=62849 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=62849 mark=0 zone=0 use=2
ipv4     2 tcp      6 111 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=3410 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=3410 mark=0 zone=0 use=2
ipv4     2 tcp      6 111 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=44185 dport=9007 [UNREPLIED] src=xx.xx.xx.xx dst=xx.x.xxx.xxx
sport=9007 dport=44185 mark=0 zone=0 use=2
ipv4     2 tcp      6 111 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=51099 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=51099 mark=0 zone=0 use=2
ipv4     2 tcp      6 112 SYN_SENT src=xx.x.xxx.xxx dst=xx.xx.xx.xx
sport=23609 dport=9007 src=xx.xx.xx.xx dst=xx.x.xxx.xxx sport=9007
dport=23609 mark=0 zone=0 use=2
