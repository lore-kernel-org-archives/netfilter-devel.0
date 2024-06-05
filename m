Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA41213A268
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717608442; cv=none; b=donXeiZniwGc5qh65ix2zjXnkcOJN7qmlkP7rxVdwnKQsoWcAlnVlEF2oagIZvAgliymAnddUMZuPEKrhj+wLEA4hX6i07u/CGr+HJoucE5B6ZMO0lLC22TqCtsszHKoRLVyk4zw3J+YlDCo77UNvpzcYGo7AIQBbb79+XUSH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717608442; c=relaxed/simple;
	bh=M60D1163nh1GUy0bZ4UyWiq6zkSS1gd2L/8crmtJR40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r71xlmG0ceLkIos5Oh2pm7jFHlFiLPN0fUCJTL/z3nrvfF/nwBC1fgPzj5xvR+a2mFeBf9WOSHZkc0IreX+vyTswAEEN/y2q5Gw3t89Ip9aXHx+89wF/uw+JtjNy7aoKM2PtdEgn50RdrtrFQaZOYglcilCH4HdwxvBpZhgyE6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OghaySav; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OghaySav"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a6905050583so2892966b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 10:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717608439; x=1718213239; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a9djuyU8XHVzjv14Ti8jF3kGt+mqcvSEVysfl+kKShE=;
        b=OghaySavfPCMBOhHNSRDzpkGGMnMAl8gLwxHxEjp0FQU2TibwsbjknCrPEBrj9W4WM
         dEHszr+urrtL5+iJXcjS3ZLH9J86hY2Ab3Zx0znBslolCE9Mdp3CatPeNcgHWk1aNlu8
         JakulJ7mHBFxcbnbqIX8VEcNefPELVOLt7AAgQG6ybe0GTIIBvw1ogZD5S0d1Wmxve8L
         rG5um5vwI2EV0/djVlsqNe25uDqo2JHLu4ZGn+Y+Ccm2fflHq5fTj/9uL1HhcIq/VNwb
         OVJvH4z6NtjSYOu+Sh4B5F28qRtQW4DRew90U9VVmXeqOIRUdjibp+sDio3focRobkbs
         T6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717608439; x=1718213239;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a9djuyU8XHVzjv14Ti8jF3kGt+mqcvSEVysfl+kKShE=;
        b=SDjgGWH262SvrpDh1uDNm4pS1SdZ8tA83vEIJopTOtAV1uIfmfNcV01KFoFB7eMTSO
         9O7v66fWJlT+4vdVo3qBc6jl/XqYYUYJkmqbzjSyW1t7+Glyw04uX9CeLf6ZEMXkmQng
         mtXfyxOTmIh0XoPqMYoeXeOD/rZMfw+OXOJc7Tx8BLLgfpxe2YMDEShxUKAk/Ftdduo6
         J8o2dAoIgcHCcYdsfg7rSxdhtRnY31YcOC17OfyqZAWq8lzoZPL/1dPlLC6uI9EPUTLZ
         sxalBLZlfIL66xkyF8fwZLVLcWyLCGECNaT6I2zqYV/eubvp5Gb9zCmsuV4ldy7ib/sx
         dfbA==
X-Forwarded-Encrypted: i=1; AJvYcCWpQLJpGT0w0zeYhhhYLdYwuD8Gbm0E0UMSmpTEtpKaAQ6W6LHbXMuTfgWhNEYLonTGJcW5mzdwToQpQBDA5bCwPlumRRblkxVwL3qi/dtm
X-Gm-Message-State: AOJu0YzdypGdz9tA+e7E7XlY9FXyooLri7Q2mUCpKTi/+4GsBnomPERP
	Bl+t20/+HY1h/zyU+9yGp+Gmlrep5mlkk19pZX5JTg70WdZK4k5K7FgOXeDaq9WQ3BsqCiFNNJA
	LwA==
X-Google-Smtp-Source: AGHT+IF4n48l6BP6GkLuLDe8i8RvsCuSkqyur4Lg9eWseWiMAINhk55AV7DnJVNXUFyUZnx5x7+lzAgMzkI=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:3896:b0:572:32de:ac1d with SMTP id
 4fb4d7f45d1cf-57a8b673ffdmr3753a12.2.1717608438880; Wed, 05 Jun 2024 10:27:18
 -0700 (PDT)
Date: Wed, 5 Jun 2024 19:27:16 +0200
In-Reply-To: <3cd4fad8-d72e-87cd-3cf9-2648a770f13c@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-3-ivanov.mikhail1@huawei-partners.com>
 <ZlRI-gqDNkYOV_Th@google.com> <3cd4fad8-d72e-87cd-3cf9-2648a770f13c@huawei-partners.com>
Message-ID: <ZmCf9JVIXmRZrCWk@google.com>
Subject: Re: [RFC PATCH v2 02/12] landlock: Add hook on socket creation
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, May 30, 2024 at 03:20:21PM +0300, Mikhail Ivanov wrote:
> 5/27/2024 11:48 AM, G=C3=BCnther Noack wrote:
> > On Fri, May 24, 2024 at 05:30:05PM +0800, Mikhail Ivanov wrote:
> > > Add hook to security_socket_post_create(), which checks whether the s=
ocket
> > > type and family are allowed by domain. Hook is called after initializ=
ing
> > > the socket in the network stack to not wrongfully return EACCES for a
> > > family-type pair, which is considered invalid by the protocol.
> > >=20
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> >=20
> > ## Some observations that *do not* need to be addressed in this commit,=
 IMHO:
> >=20
> > get_raw_handled_socket_accesses, get_current_socket_domain and
> > current_check_access_socket are based on the similarly-named functions =
from
> > net.c (and fs.c), and it makes sense to stay consistent with these.
> >=20
> > There are some possible refactorings that could maybe be applied to tha=
t code,
> > but given that the same ones would apply to net.c as well, it's probabl=
y best to
> > address these separately.
> >=20
> >    * Should get_raw_handled_socket_accesses be inlined
> It's a fairly simple and compact function, so compiler should inline it
> without any problems. Micka=C3=ABl was against optional inlines [1].
>=20
> [1] https://lore.kernel.org/linux-security-module/5c6c99f7-4218-1f79-477e=
-5d943c9809fd@digikod.net/

Sorry for the confusion -- what I meant was not "should we add the inline
keyword", but I meant "should we remove that function and place its
implementation in the place where we are currently calling it"?


> >    * Does the WARN_ON_ONCE(dom->num_layers < 1) check have the right re=
turn code?
>=20
> Looks like a rudimental check. `dom` is always NULL when `num_layers`< 1
> (see get_*_domain functions).

What I found irritating about it is that with 0 layers (=3D no Landlock pol=
icy was
ever enabled), you would logically assume that we return a success?  But th=
en I
realized that this code was copied verbatim from other places in fs.c and n=
et.c,
and it is actually checking for an internal inconsistency that is never sup=
posed
to happen.  If we were to actually hit that case at some point, we have pro=
bably
stumbled over our own feet and it might be better to not permit anything.


> >    * Can we refactor out commonalities (probably not worth it right now=
 though)?
>=20
> I had a few ideas about refactoring commonalities, as currently landlock
> has several repetitive patterns in the code. But solution requires a
> good design and a separate patch. Probably it's worth opening an issue
> on github. WDYT?

Absolutely, please do open one.  In my mind, patches in C which might not g=
et
accepted are an expensive way to iterate on such ideas, and it might make s=
ense
to collect some refactoring approaches on a bug or the mailing list before
jumping into the implementation.

(You might want to keep an eye on https://github.com/landlock-lsm/linux/iss=
ues/1
as well, which is about some ideas to refactor Landlock's internal data
structures.)


> > ## The only actionable feedback that I have that is specific to this co=
mmit is:
> >=20
> > In the past, we have introduced new (non-test) Landlock functionality i=
n a
> > single commit -- that way, we have no "loose ends" in the code between =
these two
> > commits, and that simplifies it for people who want to patch your featu=
re onto
> > other kernel trees.  (e.g. I think we should maybe merge commit 01/12 a=
nd 02/12
> > into a single commit.)  WDYT?
>=20
> Yeah, this two should be merged and tests commits as well. I just wanted
> to do this in one of the latest patch versions to simplify code review.

That sounds good, thanks!

=E2=80=94G=C3=BCnther
