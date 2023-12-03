Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPDJxVi2"
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D4BDB
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Dec 2023 04:24:29 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-a1a496a73ceso284439866b.2
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Dec 2023 04:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701606267; x=1702211067; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9BimG78WOT6Y/nFfwPomjU70P6JQxprdNY0B/XvwPQ0=;
        b=NPDJxVi2T9YgClWHDVCyhyFYU7roqtGWFxIUn3i5bHHUa6OlaetRdb8sEjzThwK6sq
         k9JBT36IEMnDgAWrTQYIdNTL9ywc0vOsMFxSR59sRR70FmeMMZEEMJV8/n8pCOzTRMho
         0Y96+L9FFVwJXy4EkT64RwnJKWimTQ3etu3wl942DAjud59Ab16iuAeoIg0HDTJR0N1h
         RkTvRCO7pSdRKfKbaKQUaczw7jRv7kodA2BfmUCaAR2jVeHoZnAfVeIPVtjOziEmpJQj
         MFPMkLl8igmovCYRRyAglNrrxUKK7XTbL7XyLHm9vcpvdNR75fKNpBB7ZKsUFCnaPlIX
         tsJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701606267; x=1702211067;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9BimG78WOT6Y/nFfwPomjU70P6JQxprdNY0B/XvwPQ0=;
        b=CyqLt8ew7eD0avkluUmGmEOMKjBeDhsursHavYRx1ijMC+ZCSZ7qz522AO6g/RPzjw
         8zZvHJ99W+3cwvZQxbSCaNTlPwz/sqs6BEWh25aLoJh/IuBvJWsI6vpsE9kzwPY+wVlF
         F0RjDfI++53LXCG1seIfiFJiEZSNASlw8dXbKMOBYRWGHrqyy7uAe9vimlenOtY/EUGa
         rpHI6L5VkZhZFxUTpcIS+z9nOZgMh7f8Uzx5r+9LKGDyc/fVvykap550ul7Tt/x+CFnq
         sJ3z72gUe+XT7jilpAfDqKmzfgds+GQuonYDKFOJzbCbVWxbmRrk7kJJpqAOBnOCkT2d
         0ASw==
X-Gm-Message-State: AOJu0Yyqx+LiGUWqF8kviMP2TpVmo3Gwf8ZgXUJmnAw3s4XJtxeykFGp
	e53vQAy1/eysz+0TW2SMxhqv7FEX99kL0ErB7Am8N4CHJxIU3g==
X-Google-Smtp-Source: AGHT+IFRT3fT/rC4mHO/OtF5XLwtFmUB+Ntc0zER1V0L7VEkTqd8u9UR0B51RYvXdVNfY2IiR76NXo3+ypBXHFVDpBU=
X-Received: by 2002:a17:906:103:b0:9e5:cef:6ff with SMTP id
 3-20020a170906010300b009e50cef06ffmr2622136eje.33.1701606266826; Sun, 03 Dec
 2023 04:24:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Sun, 3 Dec 2023 04:24:15 -0800
Message-ID: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
Subject: does nft 'tcp option ... exists' work?
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"

(ran into this while debugging
https://bugzilla.redhat.com/show_bug.cgi?id=2252550 &
https://forum.openwrt.org/t/how-to-block-outbound-ipv4-tcp-fast-open/179518
)

CC'ing Florian directly based on:
https://lore.kernel.org/all/20211119152847.18118-6-fw@strlen.de/

f39vm# tcpdump -i eth0 -nn 'ip and tcp and dst port 853 and
(tcp[tcpflags] & (tcp-syn|tcp-ack|tcp-fin|tcp-rst) == tcp-syn)'
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes

03:59:51.539225 IP 192.168.10.2.34324 > 8.8.4.4.853: Flags [S], seq
2804210339:2804210653, win 32120, options [mss 1460,sackOK,TS val
417951723 ecr 0,nop,wscale 7,tfo  cookie d2f9ee39dc952129,nop,nop],
length 314

and yet on the OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router I see:

meta nfproto ipv4 oifname "464-xlat" tcp flags syn / fin,syn,rst,ack
counter packets 1 bytes 386 tcp option fastopen exists counter packets
0 bytes 0 drop comment "Drop Outbound IPv4 TCP FastOpen"

so AFAICT it sees the SYN, but not the option.

(and yes, if I run it longer the first counter increments exactly when
tcpdump shows an outbound syn with fastopen, the second counter never
increments)

btw. this doesn't appear to be limited to the fastopen option.
Changing 'fastopen' to 'mss'/'maxseg' or 'sack-perm' or 'nop' also
does not appear to result in it matching and the post match counter
does not increment...

I understand "tcp option fastopen exists" translates to:
inet
  [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
(but I don't know how to read that)

Is there perhaps some minimal kernel version dependency for the above?
(but if so... why does the ruleset even load into the kernel)

- Maciej
