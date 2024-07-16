Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3DC3224
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721162817; cv=none; b=CDU8B/ruzrBHMSJ4Rp0KOdHRcDDXvXd4bNgFoiHJ5MxpLMOKV9E6VLRm465HwK56yh/DurXic+4+yAq1e/P3maP3fFlnf6qxxSaoNyFaWPoz3vHBS8ihHWXFcESfbsZjY8bFhyS4mxKcop8gu/WKFiDIkCwGD+XRQlSmZ5n1x7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721162817; c=relaxed/simple;
	bh=70pNCh0gTngXESz19XhJgIZXkfMZO1ZAwvDtsiSnZZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=B5K3v05EwISvtuFx8JZcb+x2vLuD7B+9q1OQxuiuArPm6/5pmdnFH/ERKOH0FRWuXR0RRUGerkXJtthRIozYRfrnSopVxQP/e+FU4KlijbvTz928XKqsUioqyN73lCtUiLR4XIJyCGwxboMjZMKHAJ2TkXAfj73/TOT2UvP3pFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeOEnHpf; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeOEnHpf"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6b61bb5f6c0so19548116d6.2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 13:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721162814; x=1721767614; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hFOLRE1QEbGoioM6inAqebQ6pt+yClTlw418Sxdop1I=;
        b=BeOEnHpf2sez93CX6h7vAkwtD9sJNopEoZH5Tfw8XZe1B70RAv5ULbhnttTPusrJ4a
         AtZrrE4JJxXoD0eKQcHSHH1oJ23X9cmuE6D54KTYQ08M3kAa3fz9pgwJ3uQdQ+IJB8P8
         U8K5KpvRK+7uh9mUV3O8boqkyFUbCJfrXWA/SiAmRAZsyiJpzO5vQc45GNrmJDBIlmdA
         E4tTOj+PjEJEqGfgZyW0x9T2zp9B0OCgnJYCpb67jNEE1gz4KehMklh9aO4YB3atjud7
         +bag5R7k2x5RXfrTYMoVITsH05/z4PGEEraSQQINCaYXs6U/hLN1JQUlll0Q2NYoEE0P
         w1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721162814; x=1721767614;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFOLRE1QEbGoioM6inAqebQ6pt+yClTlw418Sxdop1I=;
        b=XFsqhIJiNs03cn890LhJPSQ6Pjt5LrdlofcQglCZUqjw+S/HXdcPvjz6zmpNlxgWg1
         Q3ekQYeE6ynRew6hDOwvGbX3jgfWRHSKesB73sY3rBXzAy4NzFWMZmrBhkb0mVQ1EoPE
         Kq0P8wKArTPfZa8QRg3A/BEtltia6Qc1UgmTUb+H8F5nvBcIv1l5rv1Na/vgh59hCpk0
         /IHokGzk48zv4EVddm0u2pxF50FXA0xbXZBtZEUeAK6eyLzhf9QsqbcTWqZpGag1WZNC
         iNqkyFYCLmlISgl0VvRZeOamxfnNYqBdeQqnhBCPNRZFF/0+Vd+Wi9/J0HnyfN145iEJ
         3jmw==
X-Gm-Message-State: AOJu0YyUulD37X5rFffiVTsUh+fAC1ANuMBAHCqBaX+V9+LY5iMXlQIW
	kEzuXgu6UYF8uVhFYPgT0jcCflzhnCIGpnVNyCa698Z7EGL2m5tA2UbUT8+29TyWHstj9syqPqz
	c0E9sqS8WUDmQCuzPKqAJHWCtVAK3zw==
X-Google-Smtp-Source: AGHT+IEDYSXjcOIfo3oZF8HvRhszmzbzReemPMrQ/Y8bQvS01uatTJAcGErCqU71jgKDaZIRg3Db0gG8vNug5HxaQfs=
X-Received: by 2002:ad4:5dc5:0:b0:6b5:4e5d:7cfd with SMTP id
 6a1803df08f44-6b77f511356mr30679876d6.23.1721162814531; Tue, 16 Jul 2024
 13:46:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEoHhZyh=Cri2gkJmSnqj-MBa3wp2xEGMV+F02iM9TOv4QeWGA@mail.gmail.com>
In-Reply-To: <CAEoHhZyh=Cri2gkJmSnqj-MBa3wp2xEGMV+F02iM9TOv4QeWGA@mail.gmail.com>
From: Matt Ayre <maayr3@gmail.com>
Date: Wed, 17 Jul 2024 06:46:43 +1000
Message-ID: <CAEoHhZyVLw74iA2a549kyok=PDXr=JJDPGN1TcqT3oNvoJy=WQ@mail.gmail.com>
Subject: Transparent SNAT bridge with physdev module
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi there,

I have a very basic SNAT + physdev setup and I'm finding it wont work
and it would seem to be a obvious bug to me if this scenario is
supported, which I believe it is

Some of my versions here;

$ sudo iptables --version
iptables v1.8.9 (nf_tables)
$ uname -a
Linux us-sjc-eqnx-sv1-gw-0-5530 6.1.0-15-amd64 #1 SMP PREEMPT_DYNAMIC
Debian 6.1.66-1 (2023-12-09) x86_64 GNU/Linux

The relevant iptables configuration is this;

iptables -m physdev --physdev-out ens87f6 -t nat -A POSTROUTING -s
10.0.0.0/8 -j SNAT --to-source x.x.x.62 --persistent

The result is that SNAT works in the outbound direction but on the
reply direction when the packet is unNATed, the dmac is changed to be
the bridge mac which causes the packet to punt to routing instead of
being forwarded correctly

I know this because of the following packet logging I subsequently
added on the mangle prerouting and forward chains and can see whats
happening at the intermediate stages inside the system;

kernel: IPTABLES M-PR:IN=br_nat_in_3 OUT= PHYSIN=ens87f6
MAC=52:54:00:2b:95:c9:82:71:1f:83:80:b6:08:00 SRC=52.94.29.126
DST=x.x.x.62 LEN=84 TOS=0x00 PREC=0x00 TTL=241 ID=46108 DF PROTO=ICMP
TYPE=0 CODE=0 ID=54612 SEQ=408
kernel: IPTABLES M-F :IN=br_nat_in_3 OUT=br0 PHYSIN=ens87f6
MAC=a2:20:71:68:06:df:82:71:1f:83:80:b6:08:00 SRC=52.94.29.126
DST=10.117.117.91 LEN=84 TOS=0x00 PREC=0x00 TTL=240 ID=46108 DF
PROTO=ICMP TYPE=0 CODE=0 ID=54612 SEQ=408

$ ip link show br_nat_in_3
226: br_nat_in_3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP mode DEFAULT group default qlen 1000
  link/ether a2:20:71:68:06:df brd ff:ff:ff:ff:ff:ff

Same problem is visible from ebtables logging

So I can imagine why in some of the use cases of different scenarios
rewriting the dmac is necessary to push the packet back up to routing
and get it forwarded to the correct place, but that behaviour becomes
a problem in the transparent nat scenario

Maybe its never worked or never been supported in the history of
nftables/iptables but some of the examples I found online led me to
believe otherwise. It does make sense to me that it never would work
because theres no toggle to turn off this behaviour and its required
for the other scenarios. It would need to be smart enough to turn off
that dmac mangle behaviour when the physdev module was in use for
bridged traffic, though possibly that would not always be the desired
behaviour

I did have a quick look into ntfables and whether it could do this but
1) i couldnt find any documentation for this scenario or examples of
people doing it and 2) I am understanding that both are just frontends
for the same underlying functionality anyway since I can get the
following output with the nft command for my iptables rule

$ sudo nft list table ip nat
# Warning: table ip nat is managed by iptables-nft, do not touch!
table ip nat {
    chain POSTROUTING {
        type nat hook postrouting priority srcnat; policy accept;
        ip saddr 10.0.0.0/8 xt match physdev counter packets 10959
bytes 1033744 snat to x.x.x.62 persistent
    }
    chain PREROUTING {
        type nat hook prerouting priority dstnat; policy accept;
    }
}
