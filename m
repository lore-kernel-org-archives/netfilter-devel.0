Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861C2857CB
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748437191; cv=none; b=T3D8EwMLsoOUS8avE3aFjGs0mg5hbwNb0bq5gYwpwBvOvJ6AQet17wdwoWsv1JrlShXUOfNQJUonCCosoCOGex6oEYpjyqibeQRmRG+eT11uOpPFQMHP7a2I+i+7QTQN2IW0eS51U4fkuLIIlZECkuexRtKYizYDGwH9lvlnea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748437191; c=relaxed/simple;
	bh=C0NmBaW0ATR+BjEQEZWGSFa+sfjvBIIHXFfmCizBQV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUqLop4wD75a1pCaIIsBrKPwaSeWoXs07XSdI0p8H7Qf5XtP816DktMzQRy5ogdttSaCBh+jYycJaRlvrntclVSeI9HLrIBTi2AeJRvyxHwePKd9vC0dy8ombE7WUlcDvJNP8YL9QgaarTrUlzwqNtD1AOqswRu2qF6KPEa6tSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E2hOF5uy; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E2hOF5uy"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a3db0666f2so10763711cf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 05:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748437188; x=1749041988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mh3KYFguc08WUp3HQG/e3NOwLqhhclGw8CBRTTOw3xk=;
        b=E2hOF5uyCYaFXLK3QY9yHNIuPk9SUOYJMKyVoeum8fZWf28pRvz+yGCaCAh0uTmMP1
         XazinLmHV98caDDOhInckm9MLVURIyaxdQrGOtS71bmbeZ/TovcclOODD6hY0XeprTrl
         hn0jKnv9mLhw0fuYbKWlSyJ45qlThQJEYEX4yan3lbhf8VcGNZiCvstgvJH5HvjH9hSi
         LLVXqo1OC9vprxNx40wGa3rHrXEYfJH+U+WAoATWbD/g1PN6YmoglWNmPCnni5CIrIDY
         DyET9POZX0Kismg6eNLFhFWGtl5LWZlqOIp1fde3Hf2XHrmbpaChA9Ej9iP+xbLRLTJM
         Pxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748437188; x=1749041988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mh3KYFguc08WUp3HQG/e3NOwLqhhclGw8CBRTTOw3xk=;
        b=qEWu5I1oBva9HT12FC2XbgGD4ufwUfsVIf2DiMON9CLN5+QxlDUC7lpjbyQR3MmrJS
         8EYelaicDSdArHn6GsPn3hovYZ4TZuMsDb0CGR+WJKexme4f9dUekeQE9bzIGzL8sZi9
         eTXQJnDPu0ydYjAm2s/PG3kjnP+tykIp7lFGFbF+TrPMhb04no1J1PiqasAsx6l7Uofg
         Fqxjd2Eim7jvMPEH6dq/oToE118lGtbu84zV4m2AHIBcLWd7wYZ6HIEJAotRgesW7jI3
         6e2i2dnUzIDwi81D3UvpOkfKOJCOnauSyUkk6g454wIizf/CregRY5Sx10Oq7yv3Vvds
         RPmg==
X-Forwarded-Encrypted: i=1; AJvYcCWmsRHAvFxpDL6IUfXFdB5H2UGYL9yYEW31n9TqJs8jpUQusAYMJzC0sjLKIWgFWs9mKQJGHC62sbWrC71Vjsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL2th63Cwj5o9OCOZknc6Dmba5y0sKzGB2MSMqJC5RqFFZVDX1
	TCVGSDRcz1LKZEiTDbnF2kYtkaasWmhGNIJ0sj6SdkY27AyCmma8xlIH+fOgXwGYcQ0kbbeGtAh
	wwzdouX2jlnnGB9SNKLdMtNaeLNKgsBlX9mKwjQn1
X-Gm-Gg: ASbGncs8oSadcI16bdg859xthu/gGRuNvR1qn60RNRmvz33KTS8COwDiJS0xzizNtFP
	+0d4dgrAiFXKDlawzD63cJxhThfsQcSKnJl1vzBfzhw0DUPhxn1ka33yKQ17j0YFzdo0cp1kLZ3
	OJJ0+v0EYH0Aso4dvdfnqs+qNcIRNFcJEpbWRFczaFB6k=
X-Google-Smtp-Source: AGHT+IFAJntWLEM+jLIr7N9mWP3wVZkrJg6XEkO/SEN/9+02OAMFuE/XmC+xS/0WBbR3yG/snqITFeF03Is/SbZOa1Q=
X-Received: by 2002:a05:622a:540c:b0:477:1edc:baaa with SMTP id
 d75a77b69052e-49f46154670mr281543701cf.6.1748437188237; Wed, 28 May 2025
 05:59:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
In-Reply-To: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 28 May 2025 05:59:36 -0700
X-Gm-Features: AX0GCFv6GDabW9ltrrqADmuYBvRnrtFJ8jrQAKBbibiNhMSdO8QJCQSrZAN03og
Message-ID: <CANn89iLB39WjshWbDesxK_-oY1xaJ-bR4p+tRC1pPU=W+9L=sw@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: ying chen <yc1082463@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 5:52=E2=80=AFAM ying chen <yc1082463@gmail.com> wro=
te:
>
> Hello all,
>
> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4.
> Running cat /proc/net/nf_conntrack showed a large number of
> connections in the SYN_SENT state.
> As is well known, if we attempt to connect to a non-existent port, the
> system will respond with an RST and then delete the conntrack entry.
> However, when we frequently connect to non-existent ports, the
> conntrack entries are not deleted, eventually causing the nf_conntrack
> table to fill up.
>
> The problem can be reproduced using the following command:
> hping3 -S -V -p 9007 --flood xx.x.xxx.xxx
>
> ~$ cat /proc/net/nf_conntrack
> ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D2642 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D90=
07
> dport=3D2642 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D11510 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D9=
007
> dport=3D11510 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D28611 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D9=
007
> dport=3D28611 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D62849 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D9=
007
> dport=3D62849 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D3410 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D90=
07
> dport=3D3410 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D44185 dport=3D9007 [UNREPLIED] src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.x=
xx
> sport=3D9007 dport=3D44185 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D51099 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D9=
007
> dport=3D51099 mark=3D0 zone=3D0 use=3D2
> ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> sport=3D23609 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D9=
007
> dport=3D23609 mark=3D0 zone=3D0 use=3D2

The default timeout is 120 seconds.

/proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
