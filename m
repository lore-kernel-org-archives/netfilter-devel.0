Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6FA6EB7C
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 12:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741869749; cv=none; b=ZrBwPD4qVKwBnXeqYXaFSiygpO0H33UffEahEZcslWPawrUdqxnR74jTffRpUonrA5K8eABy1OCwO4Hw+YgBKYbIgi3svdeJbZadQr5ClAg7KmFzLlDLcXA1t9dQ8oFK7A0HAcQNPI2x8Mkyz94I56t0UBT7rrBByBNBei1EKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741869749; c=relaxed/simple;
	bh=YMWvI/xIan9SnmLosmBgTrZeS3nypaa1tOfl0cjBusw=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=c1+xQbuB3Fdv7d6CjqgACYqoQr77v8fJwIcPBiygmWW3uEQMr6eP03ZW+V2Qh/bX3e0qphW+KEI5CIsK9EfQyKWjNPa2BVPmOLLvxdempBbK1VpcbDNuep/UYe0HfwWdzGd4f4zWGEGZMF718kH89s2grNkh+F8m9dOa+Z1gG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIK+vQ7y; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIK+vQ7y"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5493b5bc6e8so999161e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 05:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741869745; x=1742474545; darn=vger.kernel.org;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=29W3BVoFIBcG7t9Kg8KvZGW+095sVPy8J0/ctBBA17E=;
        b=jIK+vQ7yjqWru5Inic/GVPcXIX/6+2WeclL8+XgWxWI5GHJmsIwzLNB8LFUhCZsEY4
         r8I4A9FDF5r2VPNy5h7ZL5aOuXHnUCfxWABmY+wQVw7LgZqGju+TRDBoNtd51iZ3AkcR
         rd95wziF0aYAeOUy5A7fT9bMPRussNdyzVho1UOGZ9xd/3mbdbRGWYKTiPYgCuoFaJHS
         R/LshyHCMETdJ3tC7GlUVWRHB4naNl2TQ7JzIefIfL2cnBXZqJRfWaR+HOMbdVGzPchV
         mOH6Xr+j3vFR0VbDhDOZO3bDi05K8/n3ixcN5WnmVr7f6r466yvz+4sUzFR3TbgFh5DD
         jcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741869745; x=1742474545;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29W3BVoFIBcG7t9Kg8KvZGW+095sVPy8J0/ctBBA17E=;
        b=DaGVi31mt+obbChud8Lpl8J8F70AffadcuPfDx53U0J7MwcIwKR19vbOqm6LCCYlcC
         WMmWWHX+VFgPz2D4P8t7OHawFdKP4PZqg9aywQbvySnUrGAmlUrG6RD8b/0sfnq44/oT
         G6n7F59Beq82ezIH6mpkiiuzSFT3wkyRgcI0kaix7wxMfniznL+k+c8PDwC7alcveeJy
         l/1KUJzJDzbrpFYEkSsFo88kBFZC+Y23NxTleUC16AmoMTJ2irHt/7jf4L9iv8XosaDz
         aoRldxAsDcclgH/MgUsfpMyNPRjtYGopTYEKUrXCr2bLo6f+qy43aoPDGlaZTjc49614
         he6g==
X-Gm-Message-State: AOJu0YwNiJV/RP9eglc95mDoaO4ioWwcqgXGE8DN8+cmeVNppHUGgxqI
	KBh4DwQdeoebsQD6B5Bco1DRZmLh6fwCDWuaqPCi5MNzJ3uQK1SJuz3VctnB
X-Gm-Gg: ASbGncsHuncmXJM1Xq+KXEGKhSAbgV148DVXxVdekZ5uQYFShS2BDxhj3fXQTNWixyd
	JiZ9PsiMGdhPvF9gsNMUIjOZKQoVQCmevtC8h1EnZ78UPIKx+ywmCD+s4ESOpRmjhA8HvExBFCq
	dxsbsEcJ1qcGAbd1bH9W0kITbOvNj6PE83BKPOnyE7OJqQaCRTGJAfkypvf+auoMfg7ihWuwKd3
	E9/SXh6tHRaXksD/fJd25pPATFmc6FXolHjWCwmt1wNaIV0P6nyrQkLLlJIMCRBM50VwIQYFwEL
	V7mzPpajjYwM8gTpE7becdACNhzhiKHNQF4HmASoysmIdu20qRKVbAm5sPnu
X-Google-Smtp-Source: AGHT+IGWOslehcIzCwLebv09rLbrZ98vtL9RQQY15dcabQc78ZQbjsLd9bvpJ4bY7f1MukZe3d5s7w==
X-Received: by 2002:a05:6512:12c3:b0:549:887b:253f with SMTP id 2adb3069b0e04-549910d6bc0mr10042758e87.51.1741869745066;
        Thu, 13 Mar 2025 05:42:25 -0700 (PDT)
Received: from smtpclient.apple ([195.16.41.104])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-549ba88598dsm199928e87.188.2025.03.13.05.42.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Mar 2025 05:42:08 -0700 (PDT)
From: Alexey Kashavkin <akashavkin@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Thu, 13 Mar 2025 15:41:54 +0300
References: <20250301211436.2207-1-akashavkin@gmail.com>
 <B89DC7E1-9DA1-4B38-96EF-F2AB021F62C9@gmail.com>
To: netfilter-devel@vger.kernel.org
In-Reply-To: <B89DC7E1-9DA1-4B38-96EF-F2AB021F62C9@gmail.com>
Message-Id: <20A1916E-9740-49AC-9881-5F770D481116@gmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

> Rules such as the following will always result in the NFT_BREAK =
verdict code:
>=20
> # filter input ip option rr ptr 4 counter
>=20
> Because the function nft_skb_copy_to_reg() returns -EFAULT. This =
happens because in the skb_copy_bits() function the 'offset > =
(int)skb->len - len' condition causes a jump to the fault part of the =
code.
>=20

As confirmation, here is a listing from kgdb. Target is Fedora 41 with =
kernel - 6.11.4-301.fc41.x86_64.

Thread 2 hit Breakpoint 1, nft_exthdr_ipv4_eval =
(expr=3D0xffff888004dc1210, regs=3D0xffffc900001009a0, =
pkt=3D0xffffc90000100ab0) at net/netfilter/nft_exthdr.c:163
163		if (nft_skb_copy_to_reg(pkt->skb, offset, dest, =
priv->len) < 0)
(gdb) p offset
$4 =3D 42
(gdb) n
167		regs->verdict.code =3D NFT_BREAK;
(gdb) p $eax
$5 =3D -14
(gdb) c
Continuing.
[Switching to Thread 27]

Thread 25 hit Breakpoint 1, nft_exthdr_ipv4_eval =
(expr=3D0xffff888004dc1210, regs=3D0xffffc900000eb890, =
pkt=3D0xffffc900000eb9a0) at net/netfilter/nft_exthdr.c:163
163		if (nft_skb_copy_to_reg(pkt->skb, offset, dest, =
priv->len) < 0)
(gdb) s
nft_skb_copy_to_reg (skb=3D0xffff888009407f00, offset=3D42, =
dest=3D0xffffc900000eb8a0, len=3D1) at net/netfilter/nft_exthdr.c:40
40		if (len % NFT_REG32_SIZE)
(gdb) set offset -=3D sizeof(struct iphdr)
(gdb) p offset
$3 =3D 22
(gdb) n
41			dest[len / NFT_REG32_SIZE] =3D 0;
(gdb)
43		return skb_copy_bits(skb, offset, dest, len);
(gdb)
nft_do_chain (pkt=3D0xffffc900000eb9a0, priv=3D0x0 <fixed_percpu_data>) =
at net/netfilter/nf_tables_core.c:290
290				if (regs.verdict.code !=3D NFT_CONTINUE)


With the second packet I manually changed the offset value in =
nft_skb_copy_to_reg() and, as you can see, the jump to err for the =
resulting NFT_BREAK did not happen.=
