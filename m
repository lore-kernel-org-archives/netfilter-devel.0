Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F6190462
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160192; cv=none; b=WBQRaJjdxzaUTrtajifRDngALjGoOiJUIAoiVqUJzsEJSjbONKCnYUtaZ19c0VHXiWd45mE6YgaqSKdJ35uqMa2UNDl67054dfqgqNh39LvX78bmkHP2CeeNj0te7CatO66szY82cb4A5GL/W/7li7NGTnQrtgyRq5GB9yl6WG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160192; c=relaxed/simple;
	bh=5UXxwFQFUtSnuhyz4VpJ7abHHEgSnmu7fU6qaxNCCEg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r3cion3tKYTELlW9lRJAvxdCllrJt7ZYUtYTaqNSIqWFWdWYRTve37tT/2AVW7FQEGQ6jIRid9qoL62WpK5G0SIVF82V8wQWI2bCPV2Nt++A04r9Tx3UCKUGL3EsINIpX5AbKymRRb5lDj4p1byN4DkS35uqpUqkq8/8Sle2elE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IWrpw8Ox; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IWrpw8Ox"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6af4700a594so53340327b3.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 06:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724160190; x=1724764990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFkaMkvquxlxQ/SAD95exzmFVOY4XR5S83ydFyfM+yk=;
        b=IWrpw8Oxgs5zYnmGoEnlgG0UdS4yH3u7Dt5iyCVGMcqSFukVHrMRhRQdbJhPrV3rAj
         JiEOILCSQ2s/b7VqnsyEQ6gLJ/dSdyjUGTTOryHpudeiJshH9wmfadgwnHrSOOArrbfG
         CGxrP0SI0E21iAyKJMrUZ2KONCMqdcHDs70cLv83ZN2wEbsFc9XlrNgE3Ys2pJdNZxaH
         SuQDv+awDwt1UEBceGRUIaZkm4VtfrX4IHv3x6mUK5zQI+TkztW9uaid3gN6tvDHh/RR
         bztghsNqHaUks9boNFYyz6U4AIDppngUG/oNj9UB55cmb45v9MqajjKRgqjdvWzj/Cbu
         PF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724160190; x=1724764990;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xFkaMkvquxlxQ/SAD95exzmFVOY4XR5S83ydFyfM+yk=;
        b=nGX0jNGSKE5q54ggkKssQo2y0Czo+DRWObrSZY0zIfjdhG4sJq3tOr/uQDCn5XaaoP
         YyHNjjvhtLW44RfwMVu4lDCZX8W9CcOkiDI6JUuQzozTsP/GDvhXtcXXGsHoox3wNNmS
         Gqj+NRQnqvajipyb1GJe8kVFoGrSb5B0uT3hUmhXzg3iHqWVVQd6GG4vpnG7Zs6rRxet
         QBF6jMzZLFVXe7+utQiLGN4p0Qv6IB+vHek+aEGngysJ5WJZytpk8DNTvPIsNn3ulKma
         EnPvC5HPTKW+StupCh7FLIKfwJXQ5HKkXi4DKRD+IARfCu8E8nWzEut8yRbffSuVaVMN
         Dggw==
X-Forwarded-Encrypted: i=1; AJvYcCWhn4H3p78AdPw9biJEmzbf1nQK1fZk8+9pObABOy3DWXwV8s/MJEmY4+cZ8XzjDmBmfVqFQvmP9HgqmpRkNeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YznYw8jrPYIlynFFgr68fMil+QOSeIwSCXQ8IQ8GN3VXklOwCNy
	re4M9N+GBwHCUeZCIrEXUds3OQ4Lc2d55S9yrBG4FBF/s+jQhQB6aqkPMKZdpyPK5uOoYV/oVpl
	16A==
X-Google-Smtp-Source: AGHT+IHThblM1I6eLnWzs+7DU0vafJ3uxuRONBKy1loc1jSGtA+l5WZ1Jzc4algrF1reUjnlnyt2lh28slU=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:2f0d:b0:6b2:6cd4:7f96 with SMTP id
 00721157ae682-6b26cd48157mr4228417b3.9.1724160189787; Tue, 20 Aug 2024
 06:23:09 -0700 (PDT)
Date: Tue, 20 Aug 2024 15:23:07 +0200
In-Reply-To: <ZsSV6-o1guJdpPfu@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com> <ZsSV6-o1guJdpPfu@google.com>
Message-ID: <ZsSYu8kV9l-OTUnF@google.com>
Subject: Re: [RFC PATCH v2 0/9] Support TCP listen access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 03:11:07PM +0200, G=C3=BCnther Noack wrote:
> Hello!
>=20
> Thanks for sending v2 of this patchset!
>=20
> On Wed, Aug 14, 2024 at 11:01:42AM +0800, Mikhail Ivanov wrote:
> > Hello! This is v2 RFC patch dedicated to restriction of listening socke=
ts.
> >=20
> > It is based on the landlock's mic-next branch on top of 6.11-rc1 kernel
> > version.
> >=20
> > Description
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
> > ports to forbid a malicious sandboxed process to impersonate a legitima=
te
> > server process. However, bind(2) might be used by (TCP) clients to set =
the
> > source port to a (legitimate) value. Controlling the ports that can be
> > used for listening would allow (TCP) clients to explicitly bind to port=
s
> > that are forbidden for listening.
> >=20
> > Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> > access right that restricts listening on undesired ports with listen(2)=
.
> >=20
> > It's worth noticing that this access right doesn't affect changing=20
> > backlog value using listen(2) on already listening socket. For this cas=
e
> > test ipv4_tcp.double_listen is provided.
>=20
> This is a good catch, btw, that seems like the right thing to do. =F0=9F=
=91=8D
>=20
>=20
> I am overall happy with this patch set, but left a few remarks in the tes=
ts so
> far.  There are a few style nits here and there.
>=20
> A thing that makes me uneasy is that the tests have a lot of logic in
> test_restricted_net_fixture(), where instead of the test logic being
> straightforward, there are conditionals to tell apart different scenarios=
 and
> expect different results.  I wish that the style of these tests was more =
linear.
> This patch set is making it a little bit worse, because the logic in
> test_restricted_net_fixture() increases.
>=20
> I have also made some restructuring suggestions for the kernel code, in t=
he hope
> that they simplify things.  If they don't because I overlooked something,=
 we can
> skip that though.

I missed to mention it -- the documentation in
Documentation/userspace-api/landlock.rst needs updating as well.

=E2=80=94G=C3=BCnther
