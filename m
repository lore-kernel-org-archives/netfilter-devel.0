Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1716A8CF
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724306638; cv=none; b=CbEnewkRUBNm+bvp/xvdBl1Zy/w64wvfWZrc9dWypXODyXSQ/8yY0kWLl4vX85mk07Iyy5/7cdIooT63A6BE4MLSFQccOHUoxvA8FllyqqoBmrntkkTgwoPZCxABRjoAmbkTMFyBC3pI06Ql/GTpst0Q0XfDVTPdZUUj5V92FG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724306638; c=relaxed/simple;
	bh=A6A4Fe632TYShLqfk32WrMMELcP3NWtAJYeFYitcR44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mIEgYNlhnIv/ZXBH1h+hgV7hh7O65Tf47TrTk+m/ebXhfNJglqQIrKcP2AQNg+j9GUnTA3sjbQedBmfGxMjTuwNpDZYspUxtZUS7X7Wixr7ZNlFR22oxk7FE+i37ff6IN7p789PMVtx4p8LATgI4lOH25Xoebm5+hoQntLIS4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSME000o; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSME000o"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a83597ce5beso64862766b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 23:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724306635; x=1724911435; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6A4Fe632TYShLqfk32WrMMELcP3NWtAJYeFYitcR44=;
        b=bSME000oWPMnQydZRZXV2mKwr+14BbHvtEPSKT/MUAj+SsCdZU5prvCgYxQlPste2n
         EuaC9IX4cNALFcZ69hlYF+C8SWvqsVjVoxMILHCwOeoTPNn7qkrfSXpiOVq6Ysy1nD4S
         g2jLz51eXptzSTRVlZu0qqZVVOk+VSI53neyKQtE7qm4eX2TZPBE+viMjykSY3TGkpd6
         PFbMu3/gutoIpmeLfPP6uKEcTFjnCIiWSpE3shGZKs3xb7nainZ26NixUAfULzRTE0Z7
         rQeV5iI+rCtcFDHkTIUtxTL9+zorLY2mNHya9LFNRDEvAINB8FI6AKufzdRaGdxei16u
         2fVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724306635; x=1724911435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6A4Fe632TYShLqfk32WrMMELcP3NWtAJYeFYitcR44=;
        b=uWSz+q6ixJL3BUt5A/LvAphMvuTWAp9Q2/0derTkp/mR57QP2FW1pnsCgRUfJy5XJd
         erFonJ3QTUT7pHLn96kRWCSmxZ8ft3DtLPbgY/ROZ0KqVrVf+8R1DA+omoZ93Sxm6k8X
         KQidwU8t/3lAS371+ZT6zTbi9uxeXQorVMSXSS9yPHiMVG8S/LKv0Q8TbFOyVehEgIcI
         q+BgnLyPs+TCsmu/M0P3/kkqNwPDoHfisQ6NJ19aTflJlou+jm/gMT9jPTCiOvG4pJMR
         1PbDRj+YJHFM5MoCQL9gvsw9aaNY4utX4WC5vGH8N3UEZTJOf6lY2z69Dxks0tABCyMz
         7X6A==
X-Forwarded-Encrypted: i=1; AJvYcCWO9V9JC77hGMMD1b3kbcMhbHulpCdI4hp583w9sGENpz3MoEJziklEUoV/nk1VeIkcEVzSfVdWoYnjQwwrSxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZJ4vUFwORhIK2dKwIKCPK7MTGV1yIhWqg+Dan9WCVu/rgpzMo
	NhSKc5LStxAMFLazf6TW9sd5ST5Vuy/vbDVma0wioCZWyTOMAgOoCK4srr/ilux8jyVAnxNc9FH
	jNELfOyJyVSK4xtEBJpkJ3v2wyRN1NCIIlW89
X-Google-Smtp-Source: AGHT+IGNfFwTAmIsIllx9KcRV2vWMF9IIN4oRU2yH5xHn4rDW0RJpAFvaGgqE4eyO/Fg6KLLFZkJ9cN2Jikv3AYMafQ=
X-Received: by 2002:a17:907:7f1f:b0:a7d:89ac:9539 with SMTP id
 a640c23a62f3a-a868a5af23cmr176699566b.7.1724306634586; Wed, 21 Aug 2024
 23:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822043609.141992-1-takakura@valinux.co.jp>
In-Reply-To: <20240822043609.141992-1-takakura@valinux.co.jp>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 22 Aug 2024 08:03:41 +0200
Message-ID: <CANn89iJGUCp-4fRJWzwNzakyNZM=_mSNjX=_OUT8WJW-+isAfA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: Don't track counter updates of do_add_counters()
To: takakura@valinux.co.jp
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
	dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 6:36=E2=80=AFAM <takakura@valinux.co.jp> wrote:
>
> From: Ryo Takakura <takakura@valinux.co.jp>
>
> While adding counters in do_add_counters(), we call
> xt_write_recseq_begin/end to indicate that counters are being updated.
> Updates are being tracked so that the counters retrieved by get_counters(=
)
> will reflect concurrent updates.
>
> However, there is no need to track the updates done by do_add_counters() =
as
> both do_add_counters() and get_counters() acquire per ipv4,ipv6,arp mutex
> beforehand which prevents concurrent update and retrieval between the two=
.
>
> Moreover, as the xt_write_recseq_begin/end is shared among ipv4,ipv6,arp,
> do_add_counters() called by one of ipv4,ipv6,arp can falsely delay the
> synchronization of concurrent get_counters() or xt_replace_table() called
> by any other than the one calling do_add_counters().
>
> So remove xt_write_recseq_begin/end from do_add_counters() for ipv4,ipv6,=
arp.

Completely wrong patch.

There is no way we can update pairs of 64bit counters without any
synchronization.

This is per cpu sequence, the 'shared among ipv4,ipv6,arp' part is moot.

We could use cmpxchg128 on 64bit arches, but I suspect there will be
no improvement.
