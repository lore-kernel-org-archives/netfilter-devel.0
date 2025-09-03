Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383919F12A;
	Wed,  3 Sep 2025 23:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756940986; cv=none; b=Jx4kDDdeM2UB322iST8ZX7QTcxYp9etpuYiJY7oPC3QIheQP6ols7f/9dcF25IgL84EUyp6fo69pwFwwmK01OVK16pJpb/LNlFtt//o7fFdVI5wxfdIjOxp3sN3+z5oprGmln6stQA9ZVdw44QVhwJ33o1Ouj+y2Eg6ERzt4VNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756940986; c=relaxed/simple;
	bh=MnK5x+u2vsPXChCOwxVvcYRQZplc/jyPK8RAoWfnHi0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZBsWUl1qaf4hYqFpUgimDbYU8b2SQBRJc4ViYHJPJbGGRpeWa7XXqIWrU9ddzXGtjsEIs7VETL5s+2f0BAO/FLg2ZHGfL9I0oXPrIxht73PR7MT31A6gnbudFI5BIVeqX3UYkdyvlxTl/yBJ05M6y++3S3CG9meGHKMku3cqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tITAqU+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tITAqU+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF9AC4CEE7;
	Wed,  3 Sep 2025 23:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756940985;
	bh=MnK5x+u2vsPXChCOwxVvcYRQZplc/jyPK8RAoWfnHi0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tITAqU+S6D1DX72m9n4YtUvDUDRaHlrMFN9k3XZPR3JQ1lSOv2ql64hxXM4K6uLDz
	 9XDBZ6Ao4LNpfimuotUaBNu1Jqv2T+qj+vdVyc664H+3kkv+Fy8o1LaBDsR54JJeW5
	 WfAPlkgJCx27MRzTdEyULR9cRkrTvaNIuXIecWNlToiHlsucIJN8kldnitvUKR2BvG
	 goD33eW5RHWckONI0vcagIYYZTdijmiLAkA9OY3LKpwNVdWKIJbpggGmiwygereOxo
	 4Aow0nehnDx9kDq4+nmd1A5GNa9ZEjalGkrQ701zC0jNytrSkQJa+R9Xp8fMCoN53G
	 rFsb9ib80i01w==
Date: Wed, 3 Sep 2025 16:09:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net 1/2] selftests: netfilter: fix udpclash tool hang
Message-ID: <20250903160944.27826c84@kernel.org>
In-Reply-To: <aLjFWzreiLM8nWgL@strlen.de>
References: <20250902185855.25919-1-fw@strlen.de>
	<20250902185855.25919-2-fw@strlen.de>
	<20250903151554.5c72661e@kernel.org>
	<aLjFWzreiLM8nWgL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Sep 2025 00:52:20 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue,  2 Sep 2025 20:58:54 +0200 Florian Westphal wrote: =20
> > > Yi Chen reports that 'udpclash' loops forever depending on compiler
> > > (and optimization level used); while (x =3D=3D 1) gets optimized into
> > > for (;;).  Switch to stdatomic to prevent this. =20
> >=20
> > gcc version 15.1.1 (F42) w/ whatever flags kselftests use appear to be
> > unaware of this macro:
> >=20
> > udpclash.c:33:26: error: implicit declaration of function =E2=80=98ATOM=
IC_VAR_INIT=E2=80=99; did you mean =E2=80=98ATOMIC_FLAG_INIT=E2=80=99? [-Wi=
mplicit-function-declaration]
> >    33 | static atomic_int wait =3D ATOMIC_VAR_INIT(1);
> >       |                          ^~~~~~~~~~~~~~~
> >       |                          ATOMIC_FLAG_INIT
> > udpclash.c:33:26: error: initializer element is not constant
> > Could you perhaps use volatile instead? =20
>=20
> That works too.  I'll send a new PR tomorrow, its late here.

=F0=9F=91=8D=EF=B8=8F FWIW I'll be sending the PR tomorrow so plenty time..
