Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507D26A0E0
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748439721; cv=none; b=dFZugakSs5ebJNdMpflw48Ux9cK7pnbJkzjO4V3VieLB+XuEVxrY0T/EqspU0BqDJE8nQIbjP2fG+/wX7tV3MIr97o+LATJI0jVH+KXzZ+gBCNTc2Xa/pcYbAwmxSFGZSfB3DVQ0FHUR5mCldSLrJ8D3I53rJi/qjdRdgjAKx68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748439721; c=relaxed/simple;
	bh=q6+NUbSkDfbULFIkQSRxG3LqAFTgY8fsGbQ0EjJoDmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TkvRW26mpC1PB1FFQXFhhyDi/WUv2q+Z8itqAcpsRgG7Qfvab1apM5Sn4r6xr+q547gLQMr3akX086bu/W6Bs9SSS0a115msXFNrxZQ64j9yFaDjJVf0WKbuVU2QcjJzOIkK+/71ndQz8yE2YGMkOnIOHj+mX6nD2amaM3XuZf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvDTI76j; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvDTI76j"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47677b77725so41399921cf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 06:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748439719; x=1749044519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6+NUbSkDfbULFIkQSRxG3LqAFTgY8fsGbQ0EjJoDmg=;
        b=dvDTI76jZZGKZmTUy8Wff5m8yyne23JCwucBRkoFbQLgPKmcWzyLZ2j6RrrAgnWDlA
         Db5GSXJPcEIp1gJIjJmCCAnswBjT7gBApuO25JjYe/9SkA5BSUfPS02mZUwesFAVHmL+
         mrvM509kQpcIPbIWZPVIWspkkPPA3rxuHJKyloF4yoyc0wrHf8oA325hyPgtI6+n0Uo0
         qUPjyuJAKbzSwr10pvyQU8OKlKxenOXH7rvszJf1DqxBrBU2ZdhzifhdezlkvRgijtFs
         CLqEaXxVmkLzvJya9w2F3JcjClKiCSTiyXAgdCTx/qnSD394/bmpLZdVjJPwcdOpAOJK
         EANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748439719; x=1749044519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6+NUbSkDfbULFIkQSRxG3LqAFTgY8fsGbQ0EjJoDmg=;
        b=POhp+RO33dRmiponm1aizl4gYo2RQ+tNt4mqGZVh7FHALgKQBA4lhjtpv115UTU0xC
         tFsnOO0vkuJ4pcquXGL2+bS+O/dTxTtZ3svv10D1DoNHBuE3XL/QS97WDeUC0Kd4XWZB
         buQAjqOMkSF8ASXchzYk17cjrlcrdJy5CekPYPBZoJHnCftV/0qSkPo5TGgLzcjAuGvP
         OQEQ9Ja6G6rytfFJJBbYzwEdSwBK7EDTAekODWT2/cj/bMjl5kiXd6oWNKNuA4B0F0Gp
         Nh/lcj+Z6FV38Mb2ltpGRENZkoXnExR7kUR4xL6J6W4eBpZ3lG5vokJ1lWYN94Dm46EA
         Fkwg==
X-Forwarded-Encrypted: i=1; AJvYcCUHGNu+4ZL0LZc88RjF0VDG5lzG8L2E6VMjU/X1Kzvl/zFp2s7r1y1HGvWZ0Q5/0c7rQH0w1wmYsVDnstzZx+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwABFnsZTbl5QCbeBEHNP4FJrcTv09WuOLxsh6H3xnKvBnRhPbt
	UNd9ZBRq6Qq37la2cksHgaQzSrBSMBGInHT+whw1f45TvkEH1hdhc9dhk+AN20P39wAsNZwptb+
	TfuoAaTnrztFu1WRU6irEC4Mmtp1un5nHFWhVX1AC
X-Gm-Gg: ASbGncuUqosdZ5wSH1DX0V9fgpxKJWiEQyzHyWqVsYLapcK7HYLDm0++P67Ed+iAWUC
	DpQ7oHEYiGYQmpPAsxdNdIpeoDTzvWA3g/VjGc8zbyJ805+WFRTOCQCagM8jSyVyk6HsGsGMbVb
	Hz3vMsqUzPTlFNQ6tZZNX5fPYjdQ7FxdufXGWQn7FhHQ8hj63K48sT6w==
X-Google-Smtp-Source: AGHT+IFXUSUWOaRqlGgnQsk3Ddxf9ikBISkt0/KlPz6xvIxI0l0YyOvrvNO9ok6mnWdgT9562252wxJ87xj+prWb40Q=
X-Received: by 2002:a05:622a:5c15:b0:476:add4:d2a9 with SMTP id
 d75a77b69052e-49f46c33b2dmr291076841cf.30.1748439717984; Wed, 28 May 2025
 06:41:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
In-Reply-To: <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 28 May 2025 06:41:45 -0700
X-Gm-Features: AX0GCFtlj7sv-EQdf2aW5VpoDTLIYK53zi24E4KIItVmjWV2JQld-StOJ3wEEoo
Message-ID: <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: ying chen <yc1082463@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org, kadlec@netfilter.org, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 6:26=E2=80=AFAM ying chen <yc1082463@gmail.com> wro=
te:
>
> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > ying chen <yc1082463@gmail.com> wrote:
> > > Hello all,
> > >
> > > I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4=
.
> > > Running cat /proc/net/nf_conntrack showed a large number of
> > > connections in the SYN_SENT state.
> > > As is well known, if we attempt to connect to a non-existent port, th=
e
> > > system will respond with an RST and then delete the conntrack entry.
> > > However, when we frequently connect to non-existent ports, the
> > > conntrack entries are not deleted, eventually causing the nf_conntrac=
k
> > > table to fill up.
> >
> > Yes, what do you expect to happen?
> I understand that the conntrack entry should be deleted immediately
> after receiving the RST reply.

Then it probably hints that you do not receive RST for all your SYN packets=
.
