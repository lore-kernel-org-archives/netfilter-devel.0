Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793938742;
	b=ZhPshCY0zjHfQqgM8l0EhxRpkx3XYDk9n7ldbB9Jg/VJ+M1Gbbx1lvL5n1Eg/fRlYDX7
	 ngELQUveYAaNAf83VqFzUTtwLGQcum2mPh5ze2i0R1tgiWOSQfi7SggVsnIwy9olesBRF
	 ePI/T0tnmUj3cWfy9+jfi7Pa/9zf7klZ0H/RhZc2mnVjxPX5i3p+olQZo52u58yfGa6R2
	 OnYnLinRnKGnv3oj7Uh5uE8drV/t6So4zyB4/2T9phEAIPkPN7ivqUzp1/x9R5ssmqhhl
	 o2j2mHYtZdVZZyBG3MyuSVpZXXwBkVC474GUruOYe7y/QDr0RGGcju0Mf4+d1Nlu8uA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938742;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=+QHalZACJ3QrM7+p2YDwvBbF+vGSs6C8jZh48BjQxEk=;
	b=sWhaJM+jrEOjWf8EPiuY8BsAC7WuBIAPtStQpfYwwpSQhF6afT8Q96VlrEH8oPFjoqQs
	 vnz0CQ4f2V090QXORCpK34g0iPhDIhILZ0QT9fEfTqZqCd7P0LL49bjNPgKnpdnJUGgBR
	 6fB2Ls89wQIKv+FH4YopBE7pUOK60kRCWZ8elD9UmzlmdmV8nfDJrbJq3y3sc07myyVSi
	 MhHAoRpBkybgou8W0SpmMPkMx6PtNoF7i/eLJ6zXchWj+1MBjzX0D4dOKWyLKKGDLcYD/
	 PHz3HeaWSYuIU8zd5Q+OAkJzJlaX5BEo+/uB8X1UgzawnLTi0XFVYXv1pXmILSTbnfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SQOMVIgD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3BA606A328
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 04:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA3BA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SQOMVIgD
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b57182c4c6so226430a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 20:19:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793938740; cv=none;
        d=google.com; s=arc-20260327;
        b=TTss8wzgHxkxkYj60fa6E67EjjUqFyrOFxtoa14KJi1Q+kX8LIPtgelyW7uWowVrKp
         fHe1I9e0ulnKRaEZPMv5V+ps62+VL3TUWpGy8ftzMDlJvnyUix/u8csBDZZVcyt4rp9h
         EJ/DqVW22tNWwRVp2zL/8Vj8QNaaRcYBtFR+xQd40ousygM5laOw1RcU2MC6ZEfqsLJj
         vQDMNgWKhO7nMXr5k91HSmLv+p1Rook9j8ajY9sZjRJNAwJolkQZZcqltL3ESrqjnP/6
         Fb5MMv400ShS1Dx5Qg+IKNLQuEnAhydvtDuh/Qx8d5Dmm7hFdv390yI/G/FfWcI/wGfV
         0gMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+QHalZACJ3QrM7+p2YDwvBbF+vGSs6C8jZh48BjQxEk=;
        fh=nhV1oo+Lq5YhtQSFPuBMkhZLoQ8SIBhlPudimJ4dqPI=;
        b=sgOcbRFgjKrORZyyIYyFDblOG3TSa0DXzQuz25MC5HbCNZ0sRPtkQEZNc1UV/uN9ke
         KVkMPoCeFlyAThvZIyi5M5VWBVzTSPnUabFmJPms8X6LUlsJnQdEBmD6NzDHl1QDNDIe
         5RjZO5BsfoG75zG1KtgcmHF2nQmOCH6wdSuGxBWrlvgZM7rli2osESY61ro5O/J5kNxx
         e88Z/l8rshyr8qNFy8gM5qDej/UNj9ZSiU7iWuhrXe1/CvGZyjTNazPcAxIKuIiwW14T
         iTTg0S2sgc+nmFyqx+1zwCGI17YZojmps2KN/f0kOCmB588o8H9dq3VoHludHB5yb6km
         mnNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938740; x=1794543540; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+QHalZACJ3QrM7+p2YDwvBbF+vGSs6C8jZh48BjQxEk=;
        b=SQOMVIgDG07Rs1CVYdq8e/3W4Jclytnfj0371yqD/4HbKar+1TpM/XjYuwZeIB2N6e
         yOrLPPyTfSmQ6ffdSnQJ61qSbjTZGO26AHMhsoy+obNqIe5Gkb9+0jX8NX2VGLFL0ryl
         MpJ2OXQoysU1Hj9T3R6ZdTrNWv2VmEJSzRDVd5nLS5vgSPQshnelZEvXb7FPbPM0YQ6K
         dKCTggP55elkJCpzHDkXOq6kEvIuYSEBi0oefqzVtheYjaq6HeHUvA9OFLEdBTUfj7hH
         vcEJRsr6N+lt7oPPpxCuoUhVHsR6S8DJri7Rr1oo4HKdthigi0EB9QQnMkfDUJyCr1Lo
         0haQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938740; x=1794543540;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+QHalZACJ3QrM7+p2YDwvBbF+vGSs6C8jZh48BjQxEk=;
        b=wAg3Yb0Xbd+FdP6M6YajDuRc3AgDvAZI7XSQxZD1JQKd3mFmDIwBWyKZGk5CVQuJwG
         07CzHusnu1UDCoKxm0wXicACQwQgoVXSwmGTiHE/njjm4qIY+vrwHZLpxjIrKCCuCqjO
         jznBiHk8LWUJm0uuMpAScVVBGZOIwQLvSKUBBM3k6nY8tnAnfdzckU9WTYuz28UhmMkP
         GIJsy7d4QmVwW+z+rwHTkP5YT2cn8ryEMmrqXs+xaHA5o/Ba9IZGIlCiAL12R1TrU2oX
         E6dKjwQusH/ivaBJBKHPjcmDXnni1An7qXWOGTkhdaZZnEYIiVCL0jwVWNlgsgFakqMs
         dA5g==
X-Forwarded-Encrypted: i=1; AKwUvBzeny4v2awOUiCapGXgovnZBRv+g2f0VzY0maMwBGLqucLi2/VP6fXyIBTANh9KqAUmcoq7Irp23qRvvxE0wyg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+pqTXD4fFMEvDk7J6TOsyJKcZgTtAzJU+rtYPgjhRl6/0NlAas
	pgn1FNleQcsVhFNQB/zCLeLDhmpSwZXrnXes8HKeFX0qb9uEIpZbMdRwzuGmPeyAq2d8Dlb1tAI
	M+S38/cAXEcYIH6X1Q1WFdkKIlNNvjNo=
X-Gm-Gg: AYBFou091WAH/WUZKCvvYpbiDsr7DRvA/APXA5cOCNvGefPr601V0PNa9Aq7O1lPMNA
	5S7hdp9upv2ewWml/x9X1bP010bUS3pUY1e5xzFLvlSWH3y7zlK17mFSgxEP1pqFflMtJTniPc4
	mX1ldEj9J5+1FbVTLEo8deGKZBTXqhkRD1PpWLyv+A2ozcirMuLkEP3k1udcWYTRPPP15Fen7V1
	5yRQLUCY6qM3D9IPkJELmYWMxYENILTjAw2sYhQSJL7SlMJytJjWOglIYEa65hVuRRnQjkpe0H7
	zj//EkT5/X5Ew7POmDkd/ZbRG5cTmhBsfieZpgUE03scVwABKgsTxM7Qzjr1+JB288oT6gNflQX
	ATEn52LeeYfdzin/dLPCUq4jsSz8CeRoVjioo
X-Received: by 2002:a05:6402:428f:b0:6b4:8d16:af57 with SMTP id
 4fb4d7f45d1cf-6b5977dd07emr739331a12.23.1793938739937; Thu, 05 Nov 2026
 20:18:59 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
In-Reply-To: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
From: Subham Pal <subhampal789@gmail.com>
Date: Fri, 6 Nov 2026 09:48:47 +0530
X-Gm-Features: AclHuK_XRxaa4K9UC2UuqiWc4DvioVlO-BGrZn2eJzo2Ajh9WhPEJCLIzENhwTY
Message-ID: <CAHeizqFNiJ=06rh_0yg5+xWiB4uq_M4mxsJrmXNrKKhadmP2dA@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 0/2] netfilter: nf_conntrack_h323: fixes for
 NAT bypass and ASN.1 decode
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Just a gentle follow-up on this v2 series for nf-next to see if you have
had a chance to look over it, or if any changes are needed.

Thanks,
Subham Pal
