Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71E2369997
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388352; cv=pass; b=tNyA7OSILX37HxcYxHEsnsTNFpqs4dHGwuEhe2jH58O3435i7sCk4gopaQommDz6X20r4NFA/a/nYCOrpYOqWu9LUNnGdj4m2R2+pEJXxIQ/PuFvQ3IqszOzwXN3QlOECpH9czEUJ1bMWaGKV7udL2Dpbl3dvB8c2xKSG1vJw4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388352; c=relaxed/simple;
	bh=G5QAWNgkx7DW/w2sNZv58uxdaR8uMZDdjmra9Zc4X1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Akja2SneZjPCUi5SwuUeu0UHjDK2asSI+9/lhHD4AB8vbxaqXaMUy146vS8MZM8bMNcAcRSbYLa8H+anqpC0mEqPqj+FwjZYmMeO2PBrr2VZwu4V/eTUPEyzKp6RnEPHdkNxZFUw5iK9z+IMvD30qZa3K0cbUciHdOKfphoHHMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tDqdCqKa; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tDqdCqKa"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33fb4680717so11294834eec.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2026 08:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791388351; cv=none;
        d=google.com; s=arc-20260327;
        b=erHofsVmo+WbkhcEoFV9Xzn0r7g+AkZWbNS+7sNlIacRZS0RZiqEf4hSDOXm0tzzWn
         EqLCwedUNzgrysh7U7aoKAh3Kqzh+C8w3g6FdkDQPRuiMp/zOqdhmoKc8L6diBJLkCbn
         wYuD1wOK/InCNtODZafKM50I6VUXD7DUvFgGH9jssKAGQGa1ZdqD1YDk2+LtqRA4CfZ2
         inxO8YlgFufz+btwN6Upm8MXouUMGRr334N+vSr1D6Kq2YbR498jp0jI3iKec1XGR+IL
         o/cwm1XSEsRuOMBaB1LznfIu/auLCk7fiCWDNNnkiQOIvt6Ui8Ice0giDjikzxilJJ6n
         A5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ddlJN96nno5/ia6Ry/GbBS7HZ/b+A+h0CpSQK5QF0U8=;
        fh=9r59rkDjWia3UgVerOL7yevDXwbFbEwpEmgzyOpFjYk=;
        b=BYaSnusMIEPOJp6Od+cgnwXDPg9pOtLthvh3np431Ua9GB3XEJf/lyPt/UkPJPqWxi
         NASajJ7ohwVc3rdZR6Ix0Dc0/Hlp68OHp27jp6PdY7hqmOQz7wuwxM3/rImly97iFPxw
         4pczvAG1umMMOxHQz/+4hZsaUfEzzw8HbPDlrvKtJSWthbTF2oELHOEdCqDwPb5j1rkx
         gZKFXzJTpZ5lYw16sNACt37fAPrdvMyBA77ifKmEF1CbKOv9UFo2UaYZGHbEACyqKv/j
         NsQG7PcnyYmKeHB13ixR5lWFdUhwudgbao8yOhR/wEswzxIo9f5PuXbhJ5PIjlTG0HaA
         twKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791388351; x=1791993151; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ddlJN96nno5/ia6Ry/GbBS7HZ/b+A+h0CpSQK5QF0U8=;
        b=tDqdCqKa3S69UtjqZ6M7NC+G4a7oz+glTXwNSOR4lN5r6NmgAlIp/+1534kwTYl+rV
         uAQ7FPt4z4iao2lGsFAf1t/YTzg9KGlxfj0do0BtjXQpr8pNhpdmWSdnZ/WaMTwrlH+G
         U6JvAa1qGLiFlcIjR8283sgXrqUFBvH1wPkBhLKyKsYi9Zwpf08Nxgs0wC0BtL7Pfcqx
         V/flqkTEw71X4koJSnePdwKlH2F9NTX6oXNZpkfmn8FhNVg3GDWjcax9QdlVJmFAj3+4
         eJUaoaqPqwWC8srJWV/Iea4Ag/pGzyKOwJydLs+z6XOd3h+1f2uX//PoMZMeyNH4JD1i
         Gytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791388351; x=1791993151;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddlJN96nno5/ia6Ry/GbBS7HZ/b+A+h0CpSQK5QF0U8=;
        b=ZDKhUuDCDxkICBOXvKWtluJN55GaJVelHRc46Ir6o0fcdHjh8OueKOArSo73Pn90Cp
         cf3psjvLZeYiNApiLvhzzvcitGO07oRNInYSpjCmHTcxsCIioQRQRHzC96zbaxmYHKON
         QbBYlQHntnQIVq0D6FJjvdT1qnY4I7wH3HFpTUdtd8UmMiO9sjBhk2m65MSGXzJ1Gniy
         Dq+grUSU9IZbd44BW0/ywl9emr9USVkVGJzPHL9ICn1zoW1MTTpZnaHaJn/Cxqb/MsJO
         CnhD6guBoe0L1Fd23oWUi+hDWQeSqAWDewGBhK7pCtkkc21EgVHY2gWVm7vKyOE8xtso
         ZzWw==
X-Forwarded-Encrypted: i=1; AKwUvBx/UZW+0auT+CBE1dUsNZjn+cDFji8/2QyRudq+8p7h+Aw4vQX0rU++yoRGfSP8s+7bgJVuB386JicT7zEIuag=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJABOAziILvg7r303gzIObAhRI+WfjeA5KJL6vc1v/nZG1AYjT
	i0ASU9DKoO6ifLsW9MyyrtbaAF8vDkueHypSZSkq3nof+JCqb2h0etm6jB1qPnodb7HMdq4JLRB
	eYjmqlFwHl0p8jrSAR14Cb+n6RaxbSuY=
X-Gm-Gg: AYBFou1eiE6yAD/XMd739fUqpyk03D8A9oAvqAmP2ubuBZGECaMi7ZK2Trt7AaesdrZ
	1+KN7OESsULBeWcu45UK8sb/fixXfLoSLV26c13xccU9bxsX0LjAFnnbKN8Yd59scPIDd3K25gz
	EMwN/ebYMj/PUKcfOwqH0as/gyX6P7ql9z9EfRx2erIKYLqdfRrzYGEHEJIcT4nVa3fvzOwv6Gg
	pXF1BntJErMiCcUJ6qodSDYv+bGqvcqiVzrtbppqzYspoAyMgMrBNjJsnrLSv1bRxHWkUmfKy01
	ecyKAptckwEkr7sLHJwtONfKPmWVgM4foQou3sxmmjFsjcO0x7eCs5JidKbpupV2kP/km4BzR5S
	CGRAobgNQ3869tE9KkjzfxIo=
X-Received: by 2002:a05:7301:4208:b0:351:1b39:9e49 with SMTP id
 5a478bee46e88-3515dd83c6fmr2861584eec.8.1791388350571; Wed, 07 Oct 2026
 08:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <179138670045.80227.4002052840715926590@gmail.com> <179138703794.2527009.12321622169213831789@kernel.org>
In-Reply-To: <179138703794.2527009.12321622169213831789@kernel.org>
From: Joas Antonio <joasantonio108@gmail.com>
Date: Wed, 7 Oct 2026 12:52:19 -0300
X-Gm-Features: AclHuK-Khx-Zw915T81qHlg6B6H0bmWM95M5HnMxwh0PMIbv95UhhJY0UUwPEWk
Message-ID: <CAOCBhwE_JmVTmbuzJc8SEU1ROVyrat=7K-wqTQE=Er0gUy4fLA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: only honour Via: port in
 original direction
To: netdev-bot+sinfo@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

How the issue was discovered: manual code inspection of
nf_conntrack_sip.c / nf_nat_sip.c, assisted by an LLM (hence the
Assisted-by: tag), while auditing the conntrack helpers for
direction-handling issues.

I then confirmed it at runtime on 602042bf29f6 (QEMU, arm64) with
client -> router -> server network namespaces, the router running
nft masquerade and a "sip" ct helper on udp/5060. When the server
sends a request with "Via: SIP/2.0/UDP <server-ip>:4444", the client
behind the NAT receives that request and a following plain UDP payload
on port 4444; with the patch applied both arrive on 5060.

Thanks,
Joas


Em qua., 7 de out. de 2026 =C3=A0s 12:30, <netdev-bot+sinfo@kernel.org> esc=
reveu:
>
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.



--=20
Joas Antonio dos Santos
Cyber Security Specialist and Ethical Hacker
joasantonio108@gmail.com
LinkedIn
