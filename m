Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC828314A;
	Wed, 28 May 2025 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438884; cv=none; b=FN6xt44r/mg4hllEKaONDbzbit/s33zhgf4HDWcXsdbBXGK4I5DV7VD/otMwSmcIoyF1pe9A2P4YaNbxRwtUQJvHiVsAabOHFF7+5tOiVJEjjtw4v2bRAm6iss9Jm9YV8RnajsKSfr8J9wrQmS13vGH8TCWJJzzu4Dzb1SxkSYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438884; c=relaxed/simple;
	bh=WmaV+BsdxzfYtuA+yPtSU5SX378QrBQeFZ9Ye5eP3f4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttzJH7lhXvVez1OnXgXsr+WxOS/CvQRMJx3eIQiD7M9h7Qih/DQhyVXvr4Io3vQZLgUTA2GndUOt7SKUxkdf2PBTjoPvDgpuzW0ym4UVKPzqrw8GWDidICHkNaexLMVAmrrPqAKDz7hmb//UPKUp/9dWX4Atv+NyJnm5T7J3eG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awmgPPsu; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awmgPPsu"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-acb5ec407b1so764599866b.1;
        Wed, 28 May 2025 06:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748438881; x=1749043681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hJmDMyrzKSMNIijzlmQpeW/FMMtaWb1uFYuAqgq3KE=;
        b=awmgPPsutGVOmqFc9hn6uFhjyAOfVAke3fTu3hkwZbbcPnTW/08CFpETNuglgCBBMh
         yFFsO5xFEAj5jsEaMZh12jgZuu0e3rTQVKa6rY4/Pm07pktIJUmPzJjc+Xrl2NVis7kB
         I/m2712vZI4L7C+gVIwvMa/1jmQEWSNb9/G/9aJ3Phkue30FYxGGx37ACsFDCDUtUs3X
         apLjPJIHiM819z0+IK2xDHedpHah4nFHYDeTynjKMJGSl7DM9n28FhMYQ77MnNzqb8ge
         WGlnT7YdyFzdvVLZBB4CekN3ltlNWBsdcwFnEsJmNM94UvqgaJhNrHDMoL3PDGr6XKsj
         qCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748438881; x=1749043681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9hJmDMyrzKSMNIijzlmQpeW/FMMtaWb1uFYuAqgq3KE=;
        b=qBb8fOtd/lMokehAK26Bjbt86pJvLd2xSvoRUjvVWIhWcMjrs/nrRJrV6hkvr69rBP
         oy8tk7MreaP35q3IqR+aKKSqpTRWxP3lWEroAUxLqPIgx1UMCuAb3AUgx6nLxuba+rni
         Opy4QYX/8iEOyZvxFgSRBtqlFo9hanjGaIkiuEolUQapB4qYzHE24pN8agRVv2+NiaFZ
         DDzEhTf6/Ag7cqMSix/BWqoOzREK4UsgoLmzrheCJv8b6NSz48oszrT1PhShI4vCc8Yn
         C6E5EGC9/2Ab+7RvPRixW3S2c38VXKaiNhaLM3vrf7+Kzr5p4QkFN+EObAScIizwqEKW
         q6UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhbjLiOIhn8yY6PUAuLwNLuc8MDgol1UJF8o8cGtioADFblzS0z8642P0oMm8GWrfK64kVaBLXNLoEClg=@vger.kernel.org, AJvYcCV/aCPBPh/9uwMDY8f/x1/Blyv2n5R0mntQzqkwLQjBX6hnlvJvHsGXRxm6zlZ0sMyIfjgofLRtpEjwG1DE8jUv@vger.kernel.org, AJvYcCX3jL2a7HGHYMuLktjejehRGPJRymZB07t7+7TFsL92QZnul+v02x203u951/wTmNQffABTckap@vger.kernel.org
X-Gm-Message-State: AOJu0YzvmQxFvVFACKabK209kBYbYRfKWJU8a/iX6dn2JZW/yXn45rHV
	UIWZTbIqGCsNO94afELYBKuTeUxdZDKkwEEACKokFreo+aeDixmdWVOQlSaBxOYK1ccHxB5Nnly
	m35yTyT0qKe1EaE5lrm4BEwwEVGvLG/9T6kN3c7E=
X-Gm-Gg: ASbGncvOR1SEbVDPokm9uATHAwdIYD3ckTz9t4ZiWBZD/z09BoTNT6GNVV3os4jjgbq
	QSN0Y+XrCEotWs24uA2IWMLXqfEf0C7qoegokUrNsWbM720GChjHhVJOgrnwaoM+mUt1+a8MhiR
	a/xJZeEj6kVd66RvtzX9I7TUCMQ7vwyyUQGg==
X-Google-Smtp-Source: AGHT+IEpjbfpKulVFIt4AC10v2ut2jASUrjSGDRXvKIp9xRXWPZYssr353ljZQWyevyvBk9stFJp94Pv9QSSh6wuo1Q=
X-Received: by 2002:a17:907:7e8c:b0:ad2:3577:38fb with SMTP id
 a640c23a62f3a-ad85b1ce89emr1504443066b.30.1748438880648; Wed, 28 May 2025
 06:28:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <CANn89iLB39WjshWbDesxK_-oY1xaJ-bR4p+tRC1pPU=W+9L=sw@mail.gmail.com>
In-Reply-To: <CANn89iLB39WjshWbDesxK_-oY1xaJ-bR4p+tRC1pPU=W+9L=sw@mail.gmail.com>
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 21:27:48 +0800
X-Gm-Features: AX0GCFtroHeHBCi1nDR6fGoECh-sg4FRt1kFUHtgLBXg1EIkgvg6NV-35vK1Smc
Message-ID: <CAN2Y7hxi+CoMhPO7QzaqzHOcg2ksP9ixCzxHazAV73P5bbeFFQ@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: Eric Dumazet <edumazet@google.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 8:59=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Wed, May 28, 2025 at 5:52=E2=80=AFAM ying chen <yc1082463@gmail.com> w=
rote:
> >
> > Hello all,
> >
> > I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4.
> > Running cat /proc/net/nf_conntrack showed a large number of
> > connections in the SYN_SENT state.
> > As is well known, if we attempt to connect to a non-existent port, the
> > system will respond with an RST and then delete the conntrack entry.
> > However, when we frequently connect to non-existent ports, the
> > conntrack entries are not deleted, eventually causing the nf_conntrack
> > table to fill up.
> >
> > The problem can be reproduced using the following command:
> > hping3 -S -V -p 9007 --flood xx.x.xxx.xxx
> >
> > ~$ cat /proc/net/nf_conntrack
> > ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D2642 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D=
9007
> > dport=3D2642 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D11510 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=
=3D9007
> > dport=3D11510 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D28611 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=
=3D9007
> > dport=3D28611 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D62849 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=
=3D9007
> > dport=3D62849 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D3410 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=3D=
9007
> > dport=3D3410 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D44185 dport=3D9007 [UNREPLIED] src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx=
.xxx
> > sport=3D9007 dport=3D44185 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 111 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D51099 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=
=3D9007
> > dport=3D51099 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 tcp      6 112 SYN_SENT src=3Dxx.x.xxx.xxx dst=3Dxx.xx.xx.xx
> > sport=3D23609 dport=3D9007 src=3Dxx.xx.xx.xx dst=3Dxx.x.xxx.xxx sport=
=3D9007
> > dport=3D23609 mark=3D0 zone=3D0 use=3D2
>
> The default timeout is 120 seconds.
>
> /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
Yes=EF=BC=8CThe  timeout is 120 seconds.
