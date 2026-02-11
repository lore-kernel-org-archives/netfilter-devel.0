Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3753019DC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824203; cv=pass; b=cfOIDgJDoQ+AP4JNPbpEVj7evwnXz2/3s0MeXa1CNfy6A16MxfaDC2/C4w6puCRHSnqo9p2NiH0zodo5rB0BwXALpjOuMQQFV9YlhbpyNhZLb8WP85DnC7HyKXsR4aCWoE4Kg0wGNrm9It4vbXAtPAgss6g+VEaDIIp9uLCwX0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824203; c=relaxed/simple;
	bh=jqd7Pci6pO9FGBoMvZVYHreBQHzYczgY7hgUC5HHs0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q121pphc5KtBbTP/Olfl8o/cK5u45NmqnTMgzkPJGgm+U2Oci79dM1iCq2EJYSpV3B8kLPBTT5jNxYlA2G5BjV7nhwE/i5W0keodN1EjCfrWDfNv+/AXu6MnDc0ixGTrYXYDGaOhwjLywVVhN97SD7ipTocnROQTfXh3fCAZ8l8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ii+AsDIw; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ii+AsDIw"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5033a2c4b81so60644091cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 07:36:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770824201; cv=none;
        d=google.com; s=arc-20240605;
        b=ShdIHBnAzdTjsAkcXjarfhwEt5GduhsKPE89lypnCO2jy6IIuSEsCEm97fUPg2fqhb
         RyjTByvZgkWfKNvsE9WGp7LG/yAaOySk2X4JfGemaezv80GaC0wPMZqFFS/lmSmld8Oo
         vlE4s6sOvVHMQ+RXGq0PgqtQez/klz3kKAIS+BmgY9IHtiGHOo3pRb5GQ2c+XRMjqmhR
         afHkOaWpf0MrFZv2Zqtlowpnv3bqyzzCKmkzfhzYwl6Gata7UgK7aunhlxng2Lhbp/mI
         PrQb/1tDmKUO6FHDxCGU+rZhVjC6mAl160PEWlnR8zsRrn92JXSADxNra+t9y5/q3pnU
         ASJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JSkphXcA5Qjfyf1LyEdX5F27uHMSV1cYDt3Oc6QFKQc=;
        fh=vJ+9BfVEh8pu4UsA7gEp+lV3hecELAL2lSMjRcsq17c=;
        b=G7LTZJyzSO+WF7naDbTEo+c+J19QJ7Fjt5UAbJXw+HbgHzlXU7ZLhMxQuty50Yf12N
         E51RHgvVMqtc2Aivf0eUbSDWN+dL+6nwpk2JN808vskGLdNKbpU1gv0AMVig882WnIbq
         KHUQwnXDj8LLMyREzvRXeNBFj6wELhNIY/836E21JggUsxAe9k/k/nzthkUsyATtEb/n
         vWNco3Ok8TuhPdVfZQz5god95aFcN5lYCcHJ26t6sw9fdkPWsxeLLaIZ4v5chYLN1fl3
         vD4PhUtJhdIaVrhsFBOTGos5lnl5pn3XWFvGqGZhKTo6KlOXYjBCE0hrn/V+srl6Ngl1
         XJZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770824201; x=1771429001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSkphXcA5Qjfyf1LyEdX5F27uHMSV1cYDt3Oc6QFKQc=;
        b=Ii+AsDIwiS+MbB7Day6D/X5LGuXanZ3cnuspUDHPYWqUpkd4qvsmgs4xk77kNoVAZP
         VvF3nCcGy0b5ePgKsh8RYNAk6fGea1qaVRvTpmwd3mrEwG9s3a0obTl2he8qvEOVFoxx
         S5APmq1TCNWZgUykV9RaBGYIIlAs956U68NOsuzArsDojqkxjzlNVvj/P0QStEZ5nIiP
         LwbQNyRKs63Wkno/Z5XCJYDXUkVWMHZy5CbNF4NJ5c/sufhXmIIGJnPu45pg0kOQgO6W
         2KmKi501Lxts9RowmYEK8Ab/cOBs59NV3C9L2nwf8uZnMPEk3OUHfIT0YpOX/okNjfH6
         OnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824201; x=1771429001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JSkphXcA5Qjfyf1LyEdX5F27uHMSV1cYDt3Oc6QFKQc=;
        b=s1uyoBs3WK1HLnl6Co3JOSXVU0hOujGuy8Aj+MB0jh4K75Jln8iCR+8S3mCrSagDHC
         WJKozmMzuLaG9JChk2ZSeGySQutzSZ4amgq5/EURy2xXDavYbzKEp/9gyMuPFEQ14cSj
         JHqnna25dB6IBag6+54EjDMLu7M/0M+2RWSrlX+I45dSLnth4w8P8lDzOPWWmnijA6wW
         UsNkdAaTpUQUBabiZG8dsDAqS/8UygiToBh194FkMH/Jaai3rkSWFwWIdSonTkU27Pe+
         8q39+XrI9dseV2k61NLBiuVIUqrKVVl1DXg/AL+/TTVOJifVshbKUSKGvp42IdeA7jY4
         xq4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVC6tmaF8nAvmWJn8uXz2W0dSFYr8h0Oh93UKDrG2NuyK7BwL08B/NNzy0iJixZ5o02BSzDghzx47qL3rNTdbY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfRey/4KYLqKQHqb2UqwBzujLD0iXnBD7XR1w8AT1f96gG1MQp
	PErUbNp5zTlFJmj37FHtdDaH/AV7ZtWndzNGQ5jVf+upROWksoY6Vd/LxlHxIaL1QWeb8J89if9
	IJrJrGv/+B+FeRwO2JooYcOx4p6v76CNFBucen4mo
X-Gm-Gg: AZuq6aIMmVad1dk+LqiqrZcdDfWkhQycyM1uPcjQ4cogam+hl2ayA+ata5G59vTo0n6
	1Gd3euNHwPcUmWtKxbyc2vZaj1/xXvnAvw0IhfXsNC9MvqOs9O5krN1WMDVab9VS6tgJyndxwkE
	CnJyeps8NMM6dA8+vxXtNJOA35xN+xXLJ/lBGEjSKUOC65Kpg7ggXDgfCJWeUlVUamm7JjVTwJC
	h3VRMDy9uBjZY7SE5wcqWWFXzomr1pEKfaaGV8rAkLQHSx131VfzLCfZJSMXMNBOKkJpFu0ooeL
	99tDF+rYAiPgWQadRjM=
X-Received: by 2002:ac8:5755:0:b0:4ee:4a3a:bd1c with SMTP id
 d75a77b69052e-5068124f1eemr38903341cf.63.1770824200237; Wed, 11 Feb 2026
 07:36:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p2>
 <20260211103243epcms1p2dd304fd11b28df04f4e680e8c90a7fc5@epcms1p2> <207b2879-e022-4b50-837b-d536f8fcabcd@suse.de>
In-Reply-To: <207b2879-e022-4b50-837b-d536f8fcabcd@suse.de>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 11 Feb 2026 16:36:28 +0100
X-Gm-Features: AZwV_QjAGvi7BqseLa91JoZGgGvgvOjatXS8KhyY5j9-amfhurW9duRWp81Dkl0
Message-ID: <CANn89i+mNojd9mUL_dt_=D+7nZ9xcV96CYJG_LYFmBZDOYUMFQ@mail.gmail.com>
Subject: Re: [net-next,v3] ipv6: shorten reassembly timeout under fragment
 memory pressure
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: soukjin.bae@samsung.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"dsahern@kernel.org" <dsahern@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, 
	"horms@kernel.org" <horms@kernel.org>, "phil@nwl.cc" <phil@nwl.cc>, 
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "fw@strlen.de" <fw@strlen.de>, 
	"pablo@netfilter.org" <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 4:11=E2=80=AFPM Fernando Fernandez Mancera
<fmancera@suse.de> wrote:
>
> On 2/11/26 11:32 AM, =EB=B0=B0=EC=84=9D=EC=A7=84 wrote:
> >   Changes in v3:
> > - Fix build bot error and warnings
> > - baseline update
> >
> >
> >
> >  From c7940e3dd728fdc58c8199bc031bf3f8f1e8a20f Mon Sep 17 00:00:00 2001
> > From: Soukjin Bae <soukjin.bae@samsung.com>
> > Date: Wed, 11 Feb 2026 11:20:23 +0900
> > Subject: [PATCH] ipv6: shorten reassembly timeout under fragment memory
> >   pressure
> >
> > Under heavy IPv6 fragmentation, incomplete fragment queues may persist
> > for the full reassembly timeout even when fragment memory is under
> > pressure.
> >
> > This can lead to prolonged retention of fragment queues that are unlike=
ly
> > to complete, causing newly arriving fragmented packets to be dropped du=
e
> > to memory exhaustion.
> >
> > Introduce an optional mechanism to shorten the IPv6 reassembly timeout
> > when fragment memory usage exceeds the low threshold. Different timeout
> > values are applied depending on the upper-layer protocol to balance
> > eviction speed and completion probability.
> >
> > Signed-off-by: Soukjin Bae <soukjin.bae@samsung.com>
>
> Hello,
>
> isn't this what net.ipv6.ip6frag_time does? In addition, the situation
> you described could be overcome by increasing the memory thresholds at
> net.ipv6.ip6frag_low_thresh and net.ipv6.ip6frag_high_thresh.
>
> Please, let me know if I am missing something.

Also :

1) net-next is closed.
Please read Documentation/process/maintainer-netdev.rst

2) We do not send 3 versions of a patch in the same day.
Please read Documentation/process/maintainer-netdev.rst

3) What about IPv4 ?

4) Only the first fragment contains the 'protocol of the whole
datagram', and fragments can be received in any order.

5) We do not add a MAINTAINER entry for such a patch, sorry.
