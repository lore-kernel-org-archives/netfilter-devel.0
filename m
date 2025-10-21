Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F73491CA
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761063890; cv=none; b=YoR/jX3hZcR5HPM00QiuftgPy/R7a7bB7yPcr6fcmyeRitRBor7iKqY9WLcHeY7q6t0ZF54Ue+ZslokZ4GjoPJKOHk5yPzacfTy3plVG4dFtXS/dvn9hwNEyH90cKvxcA5mSWrrtWycj1RboDBv8hMbrha1Nw+bgvm1QRimjYyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761063890; c=relaxed/simple;
	bh=LPxcUV/uZgRLwv77CFqbAK5ZXM2mug3gCnaHpQGcE94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kvd+viRGmnza7ifF5CDffPLLXpQqvefJe6Y34qJhcIm4zKLCtfMu77hQjY1Fi6ApdddP/T0KbT1EMR++VRi9Djgj4CKcUWVvNkuziKk5s13cNeIbAzomiME/wqCkphcsqLxqE/iWLn3Uvywx5aoM8vwGSQb7zeypyF1N3m87jMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=dOZS0BM0; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="dOZS0BM0"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-783fa3af3bdso46604997b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 09:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761063887; x=1761668687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUhkDUpdWJD0ROxc0J5na9HrpWd09vQOwYetoz8/ls0=;
        b=dOZS0BM001wApP4MQUQVYMoA0ZL8aGm3ELyHJ5tDbiNjfFuJDJgxStpnOfqDMbnwdO
         4oA0DhnHXme8S071kCbgGYTuOFUhXbbXthj9CkZQN4f1SFHW5ydI6HW4A7FBjwze8/9O
         kxFL/ALAltq5PjUM1eodmtTnn2UhNOIMYCN1WpvXBcwE6p0b9Ss8+WICd5jnsiTaEpZR
         jujBkyYrCKirvzB/v/SlNdJAJ3bLkavYaGhvuOSPXhhy+qjjtdW4hm7AtOMacx8pF1dM
         QQlL7ADjXWv8vE/e/WvlML3KQe7NQRr08k/vXAf9P11P4b0U2g57S8Nhc5BpVDFuWZGF
         o0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761063887; x=1761668687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUhkDUpdWJD0ROxc0J5na9HrpWd09vQOwYetoz8/ls0=;
        b=vsqGeUOfKah/M0jYaYAIx38nO7AnflJsTth9KFkp4NgyNYPsUu7C4ysAQtkAdT+S/Z
         pBzNJHwQCZO7q7oWbz96GGyXTGVfT2FN78tLHgUXeoXICT8C3NVQiHl1Ytn7lg0WOYcl
         Z5iIHfpJZOY52mKiJxo6d8WYxSlOkon5gLDv3My62qT0z7T0+r4JLzp7OQuFYdmfpgUI
         phSbFliqCj5i3Dnqxh7oCx1C8jcFsHCmicLGR6WkmR771jhuxUnPw0sxM/2/MvPMRpgR
         i/t5gkdSNXhTaoXg+xZPe4HdZCjBNBo0HEGVtGdE+d2gGkovn/xaAwF2tV7wHRz9J67I
         T5YQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnURttkEItm6knjPeCgLgMyrRBUcGdh04yI6EDW38HX1lwv8UYschAx/zCFsnAtf632ZpwePRvFDwRqfS0fxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH7e07E+fuxcj+5KkYJ4UTY+ykpzcIBCg5ftr1fmp+E2m+ZheU
	nJmwa4l0LIKw/5jK0pUTm0Zncj4tawa4vOfGm122K8UFszwnVG+oC9c5jAspSoe8H04CuGIGpB5
	2n+5y7Q2qVlhshacIHqmVMF3cTeaSr5m1kj7HBo51Mxx9WpLbc7ATBXp6Ng==
X-Gm-Gg: ASbGncsGHM1u/fLwNDC922bEYP2H82IxPvji4Jh39bfeGQi90Sh8cpk2VMHXkPc63y2
	3UaeMPVovSP+sF9CxmPpwJZLsxKr8cO4CCO13cCwlNMhNPdc8bgWViWm+fE51/QDACjj4Phe6gV
	PRp8SGXIhL/oaX9b2t1fkBRU8HKBMp0/wfdpYADwc7Wr/EVQ3Rn+YtoBIVjrqaPF7jy+FcXeIth
	qjC5yNVNs1/wiNfLIPgNQFo6OvjrPGJiQFv92uBy3mXioPwmaE9cXatKGCWXGm0xXtwKA==
X-Google-Smtp-Source: AGHT+IFIzbGahgpm0Eliv/ifkch8/rPof8WlRMgywPs12B4KoNybuHeK0ASzfvhF2LV6uGZNnc6bklwBlg55lommUi0=
X-Received: by 2002:a53:d047:0:10b0:63c:e3dc:c2c with SMTP id
 956f58d0204a3-63e1610ebedmr10995594d50.18.1761063887030; Tue, 21 Oct 2025
 09:24:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io> <aPeZ_4bano8JJigk@strlen.de>
In-Reply-To: <aPeZ_4bano8JJigk@strlen.de>
From: Andrii Melnychenko <a.melnychenko@vyos.io>
Date: Tue, 21 Oct 2025 18:24:35 +0200
X-Gm-Features: AS18NWBuMcw-0lPVxcWWOGxdZHPzhJEVza7-n0ngZzaB1sMq4eLnUMOo6bQ7bfY
Message-ID: <CANhDHd8uEkfyHnDSWGrMZyKg8u2LsaMf-YXQtvTGgni7jetdZg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed conntrack.
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

> I think this needs something like this:
>
>       if (!nfct_seqadj_ext_add(ct))
>            regs->verdict.code =3D NF_DROP;

Okay - I'll update it. I'm planning a proper test.

Apparently, I need to provide a simple test FTP server/client, not
fully functional,
but sufficient to "trigger" nf_conntrack_ftp.


On Tue, Oct 21, 2025 at 4:34=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> >
> >  struct nft_ct_helper_obj  {
> >       struct nf_conntrack_helper *helper4;
> > @@ -1173,6 +1174,9 @@ static void nft_ct_helper_obj_eval(struct nft_obj=
ect *obj,
> >       if (help) {
> >               rcu_assign_pointer(help->helper, to_assign);
> >               set_bit(IPS_HELPER_BIT, &ct->status);
> > +
> > +             if ((ct->status & IPS_NAT_MASK) && !nfct_seqadj(ct))
> > +                     nfct_seqadj_ext_add(ct);
>
> Any reason why you removed the drop logic of earlier versions?
>
> I think this needs something like this:
>
>         if (!nfct_seqadj_ext_add(ct))
>            regs->verdict.code =3D NF_DROP;
>
> so client will eventually retransmit the connection request.
>
> I can also mangle this locally, let me know.



--=20

Andrii Melnychenko

Phone +1 844 980 2188

Email a.melnychenko@vyos.io

Website vyos.io

linkedin.com/company/vyos

vyosofficial

x.com/vyos_dev

reddit.com/r/vyos/

youtube.com/@VyOSPlatform

Subscribe to Our Blog Keep up with VyOS
