Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795348926;
	b=1IweiVgiRlNhJ5xrX5VzMy3iIwHRCOKd4KwwN+M4P0rkTFrD2kKc+2dTipV4hEmNosXN
	 VN7U5jNUkq6ny52amEFZuxweyIgKRV6E2WGLMsEsHjE28qR/XtT4jBUDLW8wPLkaBSDEg
	 AXQylkEG69z6OA0dhVuf+uqX2PUdK8/gcywCjVNiL1aXh3+6WpMOPM4iRKTiacm9D6s8T
	 BiA8wxT5XGG+yg4lIcEJ6+a2O34e1PDa2jBz3M3rIgznQCkrelqJcO2P6fDEBJ0AVVcNz
	 zMIEmYZCrDFEBHHxOqmQOGKhfz4SS/WhA2x72IZkB0PHYVlKJXmR1CiCIs1sjvtW6JA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795348926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=VDAY2l0Py9SC2OiRZKfmkxrUpoDnsAjefW9a1e5gT+g=;
	b=POy73u42US9ZChhEuII0nc5K7oHz3ECwHPNbl/hBtJzgw92wPjxa9syy9kL3eSvUmEzo
	 KnjPSTQ14odvCHDDtom65Lsn2SmYCc8IiB9+zFRGySQ546vlbuOH9wZC6Hcg7tF+9EFza
	 9JSC1ipoKJAAjcfxSw79RYwrXMoXqoiwICmleSl6U3XWcbOQ1VhNRstHNfoVXwTFEHox0
	 hoxneGg7bE4kmIVxKJ2bnR9f/jZ8JseFksbH3sPpUJnylyIzcMKzgqWhQWqwQYqPdOxl8
	 /fcKdybpnAdfDiUD5IzFQSY2eXi/9u0p/snzTg0G172rch/3HT14zPv/fYlqQKPz2Xw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=GSa20sQr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1397606A320
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 12:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1397606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=GSa20sQr
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b4e18369c8so13141437b3.2
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 04:02:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795348925; cv=none;
        d=google.com; s=arc-20260327;
        b=IvTL322NJIHSknIiFaDCN8SC1kghesd9HJFDHpvM/RDhSWleHxCLzCo/wdxs9uZHeM
         5/UUiropQ81GGE2xazeSHHgNV1O4x4zDDT5DOgiVi0i9A3VXokik8fapE/3uzLM0Ba4R
         OK1UuWB+W4Wnw0pX+/Vcfsza4JA+Fu2nUB7wJf1DHWeyARQCk3FwHo5BMQF1piHm0SZa
         lO+2icvmJ9HbnjJaY1KhBgSjlqRWLEDgmEH/LiEk3qHh0cxE7CPhpjPzN9DJI5EQWE9I
         cbV3G6/K2EshtLpl8ZuH6DEu6oV8OrqLcULnoc/aBHcvRHT9XzdRVQTjWdjrWzNe/beH
         Z3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=VDAY2l0Py9SC2OiRZKfmkxrUpoDnsAjefW9a1e5gT+g=;
        fh=mVa/O56zbHAIr31Ynior3G8WAwMH1L2wmXiu/rGe0h4=;
        b=SPkCIjSsfs0FzRoiklNh5RM8L2UPhMbjVz5hdQG3qJm/eV/nGRNuTSbi472Al/nrxL
         vCK8OMkyJ+ytXb8wdoiHc1lH9LQEOD/qUmroZVhdtYmUzQfV9bndNLOs2AIXIPXHprpC
         OBR5Mx8LNmQZ6IVNY6dXtSzJgPYt+3y9lxcClo8dggDAm2qleC9gyszkYBNQoce/LA3K
         aBWE3fMw40oc+phYyRLgCm0BnwreQ4CERFgpvNjAUaVzt2Zf4yGbCqIdmYYRq1UGUeQu
         HXOTDh3M+5vApEWuKBBqM1SF7rQOVXakeA41yFbNBxOZyc9l09mHbGzSQu7HRE1jja8g
         3fnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795348925; x=1795953725; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VDAY2l0Py9SC2OiRZKfmkxrUpoDnsAjefW9a1e5gT+g=;
        b=GSa20sQrHDNKTwqo480osbvm+10D+MIqy4bM6L+DapIHb2+q32BNJpyla/6tGUYXG7
         +LJhhd0SpTrDDH2g/XM8D1aHXxHPaaAkoPTyPApDq9UflQdqV7zoj0XLGRdw6ncSem79
         tcdx1fdOemsgY7A/iop/NZJHRVtlp/ZupsaqrTTIvwsBH0e3enpDWIwatPwA/uFEneZh
         2OCB8R9fL0TFOLbZDOciy33FJaka1jNWVeowsQq4eJfVNS1vJbqdJ/lbjELoUczjcDX5
         dNcR/NUkb+CLyr3k1Dr3lwiPEk6LpTTu3xV5UgDiMV2Wftlu1+gIYmfwIcGcFd/U9D8O
         Ahng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795348925; x=1795953725;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VDAY2l0Py9SC2OiRZKfmkxrUpoDnsAjefW9a1e5gT+g=;
        b=QGxbAvn7LHWCL3FCLoOFZLgjFHKaoIvlvBy+WhqW/1FKTH8Jj5pHb2i33JZbkgjnRt
         VAqnSFCIGV35yn1GGci4AZ/BOpvoDCimUEzrVDpyGcSFzstc1TfCyIrZevnwCHJIdrWw
         lkdFx8s2srCSvwHeiHvznyInIPTytof7jdr/c3YhNUVZ5yeunT9WBTp8ac0OV7kjg7hf
         jUU2FMAHzkJmZe6hy0AiqfEwOjpGftPR7XjUz4eoUpa1hdBd+A9n4rCB22jU1mGJUrdY
         gv80KKNVHs0GW4SpWIq6U4C504uams/3EQA3oERTlTVoWu70av9Z9ToqXDsZNWEZwbR1
         rfDg==
X-Gm-Message-State: APuU4Z9RZZdRi5C6DWYdklDrNcuO5P7zO4eBWuJXDXpAjHZZ0cZvEIHa
	WzgdZoL402mKTiTY3ecK6XH3OA1cfWi5V3R73frCFBTUApbE7ex9paNzlRIn+VW1qtdTb2+JQF/
	fn++GLMrtF2JNYHpB4GIiMJmNVO2gvA4cWEPClOkr
X-Gm-Gg: AZFdTZethSp4ca0ySCXDs1oL5/hOAxAeDIkcpqD7lZsWzdV/5Xg6uk9kj9yM+Yu90Ob
	YxDC2FtcfZJ3FQbrC40ploKSqzeFMBgVBvPzddBlErjcEKk8Kgk0h2+KmfMvorDoRl4js4tRaOi
	SsTnhU7rWuNTuFRIDftC3ZSglzKdZc4mdiJ9x92DWmzFlPzQzhsWqOYDHQ27KWxAscEMRhJnK0B
	iJDHSj86me7Zs20DQDm9/QlKNz+hStdOj0ce5rog0GS7C2M1zvXS+/bhwsNuhABjXMg54isz5nB
	tbwPb3Ybgnp1sN0NviG/S4S1Y/87xKUIPSCN7U8tiXQqDdssOLT8okAveiYauvvjNMUhJpD0w/X
	PuhUsnTcIStGuyUcSpW1HLvkNsJfOJQqI2sCEiJ0KOj0zk+eiyN8G59JUfucJLSuhh+dZlqgAKA
	lrI9yWrLUzSSgjtkJe708s4hRYkWkj92WYDM4/YurKeTucoTZeIRDgAbBPzca4Q7bk4j5LODnJS
	c0Sq1/YUkAElJkfsSkHstDKMjGeT6IsCjMuhHCa1MEYxXb7rZbN/zx/zUH4Lb5r4j0RUUrA1PAM
	RxfMu3DPE4/SS4qjb9Ty9nfTV9ECu1zg+U0lw2dAkNqSScyCQXQy9+YKwdE0Xf3Oeux19wMk8uu
	3xK9F9VrQAksJ2n9Rxxkgl1xJYisTfYRv9b8y/IIRNpra/Q7b2wg=
X-Received: by 2002:a05:690c:88d:b0:8b0:d646:95ae with SMTP id
 00721157ae682-8b520436e42mr29583277b3.18.1795348924716; Sun, 22 Nov 2026
 04:02:04 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sun, 22 Nov 2026 12:01:29 +0000
X-Gm-Features: Aa3M54pGP5Y5GelDYyIRXPac7qaJVRqnpPRHmYC1fODXTa_3sxZD5zd8Qe6ua_w
Message-ID: <CAC1t37+WBG97C5ZeimO9SXAKChk0BU1kRC5E6yKAaOHXvWDpMg@mail.gmail.com>
Subject: Re: [PATCH nf-next v11 2/3] netfilter: flowtable: tear down direct
 xmit flows when the fdb entry moves
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Eric Woudstra <ericwouds@gmail.com>, netdev@vger.kernel.org, 
	bridge@lists.linux.dev, coreteam@netfilter.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Nov 21, 2026 at 10:10:15PM +0100, Pablo Neira Ayuso wrote:
> > +struct flow_offload_br_outer {
> > + u16 vid;
> > + u8 present:1,
> > + link_vlans:2,
> > + link_untag:1,
> > + link_8021ad:1,
> > + inner_tag:1;
> > +};
>
> What scenario are you trying to support with this?

A vlan device of one bridge as port of another: br1.100 is a port of
br0, which has the router address, and the host moves from rr0, a port
of br1, to rr2, a port of br0. nf-next offloads the flow to rr0. After
the move only br0's entry changes; br1's still points to rr0 until it
ages out, so the gc must also look the host up in br0, through br1.100.
That is the "stackout" case of 3/3, which stalls on nf-next.

And thanks for the review! Can I send out the other patches to get
some sashiko reviews, or do you want to keep the rule of 1 patch at a
time?

Julius
