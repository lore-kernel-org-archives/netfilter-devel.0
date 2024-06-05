Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21ABA3F
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 06:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717568891; cv=none; b=EjZL7fhMhY2Mvozcu9OTuZ/U06ePqfEP4oRS0XKDcQLiY/+s33zO/HXwsEkjY4e8ElVCEUlgxO1xVDSyGrAjOI67m6ySp3sg7701NFVOGbXU5ib6j0xjOoT6Ql8m5QoY49n1OYpaPtpV4PE8KGgiw/PLKnaDGFjeemaYw2FzfDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717568891; c=relaxed/simple;
	bh=6KEM/rUUcAdHrBVTPazpB9ZgImkZQYBsRd699fjYX90=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lssM01eAYrSl+OfBz7kof9r0khyfUSJJLiTPfTF53doMqduhxK7K+J0NwrvBGj8d84ymCOog1xYBwKyT2QOkzKueBTRVvjfmOk+vuLVpd3rNOg5G9PzjPtPzXKpQ02NnD4ee69rI8bMaF/J2Oh43jT21muHCcUfnj5BajiUTivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 008F5CC010B;
	Wed,  5 Jun 2024 08:28:03 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed,  5 Jun 2024 08:28:00 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id BC956CC0108;
	Wed,  5 Jun 2024 08:28:00 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id B5E6D34316B; Wed,  5 Jun 2024 08:28:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id B434334316A;
	Wed,  5 Jun 2024 08:28:00 +0200 (CEST)
Date: Wed, 5 Jun 2024 08:28:00 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Zhixu Liu <zhixu.liu@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] fix json output format for IPSET_OPT_IP
In-Reply-To: <CALMA0xZ9y-oU1tNXK8BNHtN_FyqKuerkAGFvuRB1pfraMG=cdA@mail.gmail.com>
Message-ID: <7606e43c-4fff-ef50-4c16-7502fdfff5cd@netfilter.org>
References: <CALMA0xYY-QzN+gbPTxNw3TJt3Rvm-vkN1yb4MgHs1Ey4TuEURw@mail.gmail.com> <02acedac-3ec3-8b2c-0f27-30cf135be5de@netfilter.org> <CALMA0xZ9y-oU1tNXK8BNHtN_FyqKuerkAGFvuRB1pfraMG=cdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1514791719-1717568880=:7851"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1514791719-1717568880=:7851
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 May 2024, Zhixu Liu wrote:

> Thanks, please see attachment for the updated patch.

Thank you, patch is applied in the ipset git repository.

Best regards,
Jozsef=20
> Jozsef Kadlecsik <kadlec@netfilter.org> =E4=BA=8E2024=E5=B9=B45=E6=9C=88=
23=E6=97=A5=E5=91=A8=E5=9B=9B 15:09=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hello,
> >
> > On Mon, 20 May 2024, Zhixu Liu wrote:
> >
> > > It should be quoted to be a well formed json file, otherwise see fo=
llowing
> > > bad example (range is not quoted):
> > >
> > >   # ipset create foo bitmap:ip range 192.168.0.0/16
> > >   # ipset list -o json foo
> > >   [
> > >     {
> > >       "name" : "foo",
> > >       "type" : "bitmap:ip",
> > >       "revision" : 3,
> > >       "header" : {
> > >         "range" : 192.168.0.0-192.168.255.255,
> > >         "memsize" : 8280,
> > >         "references" : 0,
> > >         "numentries" : 0
> > >       },
> > >       "members" : [
> > >       ]
> > >     }
> > >   ]
> >
> > Thank you your patch. Please rework it and use a quoted buffer simila=
rly
> > to ipset_print_hexnumber() in order to avoid the many "if (env &
> > IPSET_ENV_QUOTED)" constructs.
> >
> > Best regards,
> > Jozsef
> > --
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
>=20
>=20
>=20
> --=20
> Z. Liu
>=20

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1514791719-1717568880=:7851--
