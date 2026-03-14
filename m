Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0CA33121F
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 22:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773526927; cv=pass; b=LBxIWXLG/HDLroVomY3tMGgVV5cRTe1zILWTYomiPCf+ipKIadlxHv1A43OODldC4x7g6CQLrFae1kDn83OV+hhoNdMM1eQYDtFnqgQ/lixF3/xEkE2L4w1qNn2yP35T6i0fWo9mXKrB6yszQHKUdaP16inIP8Kzu9khZMoCKmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773526927; c=relaxed/simple;
	bh=neSFrD7gF54uNepP15GnJHWFOH6FNCQ64zZaWnsTn30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2RvF0dRx5K0GveueDNbA7kyihz0cHdpoDA1zb8DGygIhrfaVH30XZhs6cA1pGNW4eOOla/CD5imtHWgiJ66qlprDPRejFLJY4jO0Dr2015R8InhVwcMZEz2JzkrBoR8rX8SNlikqcIcEI+Fkll4Ms/ZbdJtHkbS9l1nTZ8fdhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m7Chj2zW; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7Chj2zW"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899fac9caabso44683516d6.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 15:22:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773526925; cv=none;
        d=google.com; s=arc-20240605;
        b=XueMWJq3ZNTSQgWM3gzC75hDV0b6Gio7RmJU4PzwXwLiAOOwHf7eUWhOaoUMAfdGBy
         FxGmJVVhKsHWK2/6eUBAh2fwxocLqlOkZmq0oA9Ehq/XEHVpPdLlLQTzZvGmvsdapE7z
         datpfyeoQGenzOJzn+GIE1pMUdiJB0efmMNuo8zF8brcaIrg6aFBt5v4/VolfZ+JdXgS
         SvBXrLDptVm2swqF4W8iEp+J2P4P0Jj+zXh7/nwieSaizM5pEbl8xVz13xTQrMnCC98K
         v17LKOp6pppltOCM1tskbadbxvOjZjtbFHPeeULjLIb+3LUqGCnJrdETd+/LwvpIY3iJ
         dVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OYxPtHTatvyRC5Z188iBenV7bmVebaekboXILpllvno=;
        fh=SPGOv/tG52Tbrcgw3PwoBiYsYLLdM2rZMN9KuziyiwM=;
        b=a2VSpp1Is4pIMzoOLrRMe418zEKk4Yv929agwQOHnrjAGeVI67TEo+zIotVzDvRY5k
         9Yil6z+qV6B54Cv2h3XL84VZF3NfECI3CcPyJvWJOLQqQhuS37vpYaPi9e9pAJtIYhhT
         yxaMlYZ8GP2GPXRryRw3H4S4WhlwR7Tu3XuV6Q3Y1YQz01Ym62ZGE0dGDmltCWvpG2Hg
         /75HAz2OHiSycWOe2muOvb6PqDi8eKlNScviFiuIn1Hxo083Nl30+6RorahZJk52r1Nt
         v7E+Ned21+XV4qIT2lkUddGhQYh9yPHWF4csV0lhisSxw73D0Bq2XFmeGWnFHBJEz/M+
         zYLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773526925; x=1774131725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYxPtHTatvyRC5Z188iBenV7bmVebaekboXILpllvno=;
        b=m7Chj2zWZzVApHEnDlPAXM/V9IxHWLCvaCBpRpK55fybSdImhbCdkq9l5wKfb25aLv
         XnXeCnN6g78PYouIBdKTfIUGZBxwFiyZodUJJQncdqfAGVZZLNaVBR1OPfHgCqpg1avf
         0rq/ZHG/9S/5fy9gj/UVHSi3TilwP+DN7xMvXfJaoqEj0zlIDp1neNE8vAq09aGNu5SP
         MqKQHrVKBcug2oN3g44NeS8RPdzjQkwzAkthut1UcYcPTUQ0mAfObGmbjIGvsMULmAsh
         yteGwSHIy6tQSSWcwc/rcczc+cFk3+Q5d25m7LVzl+2vGnSTkv+YUY6kqGrObr5rgYd/
         Cwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773526925; x=1774131725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OYxPtHTatvyRC5Z188iBenV7bmVebaekboXILpllvno=;
        b=YA1ZQLpIOiMuCAgNVunOHOq7wefksrf/2t/TR1wyxHFLLsw7tBw9Ki++r4jgXF/FW2
         FL5Mbc1+gGrwuveNO83vSoai2EQffh3ErMk5P+wXhkvBDitF/lrHHbKntv6+EGIrlhnd
         lY+lJdyo/vc9nYAcyBSoVu6IKGHakDxRW4Y172sV+7LDM/5Q8yVbY01AFxja+r580ldS
         b8axaWdemrBlKWS9bteFkz6sFW48dbflihr48K5bGi8nn1WEKQ4LMq6qupKXrRMnKwp1
         ckv43f/HbeB80J6ReBLdz56Lum4Z7n/Hpg2Dmb+YUq2LMCdYjab4WfdUv5rxw7sJtyBN
         RsrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUU2pybeVLM+X4OmfwNEuh9JUD6HhPEU9B4dNqj0iQMM4mfrNWdG58QPO9JZq+mvlHAxpCd0LADAdCvmZQi1es=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfaydPIRKFLf/xjfMR/S1uzQ28chS+33AwcqL1wC5mze1EJwlM
	xqc3yHDrYU9OhrjUV9Czx2O10Ycluc3ubJM7r2jEZ8WTIqMqxLtahKmcYcGIbaRpBVEEPFbrslv
	az30MVRRdW7Bh9zYInBNXO/sD+oLathI=
X-Gm-Gg: ATEYQzzIjJgVtggM44Iz8TwX4abVePg7LxYHOBAUWzcBzfoNKIUZcRjMBmS4WOA9G6e
	NKYATcM/5xLQ2pL6m/A7mfnScVOT3DnDZ6LX3Qb3IwMiCqJVzp00NQiCqqH3XmDPVE8c96ayyTX
	WAbIZxe6Koo28sZ5/eq4Sl1/hukuIsO95IPDw+hUt/jCfH++uK/YXeMsv6WK1FWeUmMGyVOkSU/
	9dDUhkvFZIt+V7PPI/tEOX0jHXM56j1SY4GfQ1tKgpwRn+AMuNn3Ex+IDU89/0xG4G4SCB7ujgw
	5u+1uG8=
X-Received: by 2002:a05:6214:76c:b0:899:b64f:5f9f with SMTP id
 6a1803df08f44-89a81e17c74mr113035846d6.29.1773526925492; Sat, 14 Mar 2026
 15:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260313201346.562476-1-qguanni@gmail.com> <abSelah2hPOUbEng@strlen.de>
 <abVLg641YYZ6TlvM@chamomile>
In-Reply-To: <abVLg641YYZ6TlvM@chamomile>
From: Guanni Qu <qguanni@gmail.com>
Date: Sat, 14 Mar 2026 15:21:54 -0700
X-Gm-Features: AaiRm50ZHdRk6jR7lHoWsoEoCxct34EAlyoS8Siy5uvU4vQEy9sa5rv-DHUy_zw
Message-ID: <CAFzOa17xzzjC6U7rC647kA-mT9FTMvX+V1Tc7isxeaP4+P5oww@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_nat_sip: validate exp->dir in nf_nat_sip_expected()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, kadlec@netfilter.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian, Pablo,

You're right, the root cause is the missing ctnetlink validation
that Florian's patch fixes. I hit this crash while testing SIP NAT
with crafted expectations via ctnetlink, which is how exp->dir
ended up out of range.

Happy to drop this in favor of Florian's ctnetlink fix.

Jenny

On Sat, Mar 14, 2026 at 4:50=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Sat, Mar 14, 2026 at 12:32:37AM +0100, Florian Westphal wrote:
> > Jenny Guanni Qu <qguanni@gmail.com> wrote:
> > > nf_nat_sip_expected() uses exp->dir to index into the 2-element
> > > tuplehash[] array without bounds checking. If exp->dir has an
> > > out-of-range value, this causes a slab-out-of-bounds read.
> > >
> > > KASAN reports:
> > >
> > >   BUG: KASAN: slab-out-of-bounds in nf_nat_sip_expected+0x804/0x938
> > >   Read of size 8 at addr ffff0000d113e3b8
> > >   The buggy address is located 72 bytes to the right of
> > >    allocated 240-byte region
> > >
> > > Add a bounds check to ensure exp->dir is less than IP_CT_DIR_MAX.
> >
> > Ok, but exp->dir isn't expected to contain crap.
> >
> > How does exp->dir become >=3D IP_CT_DIR_MAX?
> > Are you sure this isn't papering over another bug?
> >
> > In particular, there is missing validation in the ctnetlink code
> > for the dir argument.
> >
> > https://lore.kernel.org/netdev/20260313150614.21177-3-fw@strlen.de/
>
> Yes, this sounds like a duplicated bug.
