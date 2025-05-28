Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62C284696;
	Wed, 28 May 2025 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438798; cv=none; b=R6mpWf2zWmnYDBzihJ3mjXbVvR6O5ztte8Wom9GPMB5HbOr2ttXDZOYIqvEfVb8IibuO9stZ8xLTP2NbnZ59qNuBnshj5wbJdrkYlfqWARc5FKZafARKTC7LP5OYPNyq7xOUlzmTeCzqeAPfolPhnBSyUJ95CsSk8MqtOMIUrrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438798; c=relaxed/simple;
	bh=VPsQqkwfPHGKSpcpB8sg7p0QtkZWF9LZET1JEEHDW4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RO69bCe/KtISj36pd0wSuQWgbr3xMRLidfFIbTSFXOax2hgQxNHvlyvmYGZhRX4Z9jirzTMFf+8QfaOHGYS5Iq37EVDXlQB2c6S/5KWD3PttssQR2Au2Hjoz9q/I95804HhL98Qph5MlF0sDm0zLKxaD8oTFzlv3JoNzJMfHrn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVmcOgcn; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVmcOgcn"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-604e745b6fbso4620821a12.2;
        Wed, 28 May 2025 06:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748438795; x=1749043595; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPsQqkwfPHGKSpcpB8sg7p0QtkZWF9LZET1JEEHDW4w=;
        b=hVmcOgcnciSLSb3chLtS/4fV9Aw/7dR6Aw/+gRJeuWddE4dXwGytcOQnT0y+egFsGN
         9JCAIlFrg4vWnM8TxLyKwMMjwtnndxFBy8XRBwTkpEmJvKlZSSQwi31Yxd++LBRdxWdj
         inbGUuUMcFl8c1a2yiG2s6Wu9PQJG3Mn1zk+Fr6eaRjJLHDIQ3RUwiW1b6RNPHAVadyv
         kQJTYUCkZt1YUbubu/42OH4U/EVGcatm48a0iqC6v5AGqCDWVT0egu/UyatkOaCy4rv5
         qbTAToMfQ2gorYnf11nQp33QQmVHroXC6pMwklWz+FWyzOKY1sD1Il3Hl58p4cepJCtd
         dKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748438795; x=1749043595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPsQqkwfPHGKSpcpB8sg7p0QtkZWF9LZET1JEEHDW4w=;
        b=dv9vRrVKGtFGtJRm8IWZtjBaXnblOa25Lr2qJTPHl65k6oxP4OwZUL78nTz7PdnyLq
         6qmPIhV3mf448xwx4K0GtAlLFQauNn1NLKrBTGf7MtQUgXTo/Jc3/zAV7STLgJzXSeR7
         JsJglrZ7Y9RV4/IjGF2O9GSgJBWWn92rItwayQgxtgUmMZKZ9nAftz0Z7+HX74drZZCv
         Gj5B0ZYAjuC0OeIGrmx5PkQHELyKiVe9zUgn6OL23ixS2Q7eFBEn8llHE97PFACcd85k
         joO2xmiS54Zfsfa+1s01HXHzo1Wq13EtL42mbKvddd2IcVdbMNHPnFTYF3ffRlqcE6U+
         o6KQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4CkxwTO/kx4+y7L+/Q9qfnDY6KS8i0dtrZkENxnT6mzxfrEmnHFnnJkDF+uYu2S41hxKGgtTep0mPWBbI214Q@vger.kernel.org, AJvYcCUFSfuOK4irxpCON7enEuUFIoXe2HCQ0l8udRL1891+sLUYejc1SY0zi+rLpBmTDG09ObzLc3uX@vger.kernel.org, AJvYcCVN9wuGEIgRT8TBnhuuRbfHGHgNOn8Dn7rVSDaQGuJO9VilNaP7OJaOEdV5iOZYM/ZHE/3UbmPGilAoJMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeRMFm4gbCZzBEhLGMYl1jSH5yeqrZRYTRF/9O9QavxDlnrknL
	TPRILA5Xpt9nxm0tPjyZCmBmaCRYkXh108zzEc3xL4SF2bhGBVH1n5Jcn+PLC59mp0n6EpchMRe
	SUZauUJ2a2Nf8o18GDu7YoTKWz5RmeGk=
X-Gm-Gg: ASbGncs5V4ZfoMNDb4cAcGDJl+rcLoJnYpnv8KO4ZYJmxupwzWeiLzjyJelYPuLAJbz
	/qIyymG2G/QZbAE06IvuB4RUXenAJmYu1cTrQp9Lj6x3VnCK4qfUpZdZuVZMcMUShLFAlmYxaXh
	o9IGKJutc2sXBPQd7a3r9kMQEZvu8yCgnJ0g==
X-Google-Smtp-Source: AGHT+IGY3WTGofHERJhXHFrVQNx0Lrd8u5WGFlxYXOOuC8HUrH3lQtd0jPe8jURqgKSoVM5HoKIfeodRWCOxl77FccQ=
X-Received: by 2002:a17:907:2da5:b0:ad5:34cf:d23f with SMTP id
 a640c23a62f3a-ad8a1f0f399mr213276466b.21.1748438794380; Wed, 28 May 2025
 06:26:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <aDcLIh2lPkAWOVCI@strlen.de>
In-Reply-To: <aDcLIh2lPkAWOVCI@strlen.de>
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 21:26:22 +0800
X-Gm-Features: AX0GCFuIrdW9VNZ1czfCrrMjSQPt9e8UqQ69svvcfmWJ9RkuT0Vx34are8Ftpmk
Message-ID: <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> ying chen <yc1082463@gmail.com> wrote:
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
>
> Yes, what do you expect to happen?
I understand that the conntrack entry should be deleted immediately
after receiving the RST reply.
