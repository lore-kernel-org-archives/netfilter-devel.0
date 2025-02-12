Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBE25EFA6;
	Wed, 12 Feb 2025 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386723; cv=none; b=nGl+xnD7ed7zhA9p/H0b3TEHfmibmZN+gjbcRyWlLNm0xnr3x7Y1inWlHAW51jMPj00Up6JGE/xH8MOOiKmm1dGQ9PfP4nekr8xqSwdcL6DkUAP9VCwXPE5+ihQRTZ6mZ5RF+f8Qfyc4n9dyuMLj0Lbv1OtRyE0fc9Kf99zhjDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386723; c=relaxed/simple;
	bh=34pcncqpehd+xfAkfY0n5sggGhkjxjqooXKhpQiKVts=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gb8La3w3OTptNtcttVoPCcT+q6PtOmFCYLAIBXkCuHKmPJxhGxlKZSrvPy4xY6MkKs03tHFsk7xtFlwv1KlQhufPbzHKhf0IipzkpRHsJSA2d420jD9ORXEidUhYIckzzHjmFTMh/KXYNuOAKSAmtIay2VWi+/ggyGS6rXuO8ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkPx6c5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkPx6c5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F4AC4CEDF;
	Wed, 12 Feb 2025 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739386722;
	bh=34pcncqpehd+xfAkfY0n5sggGhkjxjqooXKhpQiKVts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UkPx6c5upoOQH2yoiHapIlQqbBa4bDssSNu99hHmiw/JrS/nyFya8tBHFWlVgJn3J
	 S1jWmmtyGf19x00u5nlsKA37OXKgcRvCiujbDUGNTt4KDtFX1rz3SELh/NpVndB3Vz
	 vkSuI+sz24fzW0yiIIdBWZ6lYjUy6Xh7wupQY3NhtXNmB/u2yi/ylWXj+TRUiXrKPg
	 z8+CcVBt2h36Ml3BRbt9u1M1kD/u/hJVHemAZFz9H6HO8dG4XGmIcmg9StzTKlpxzS
	 sIuTOPX3wcJ84wehuX7d+4Zs2V17Whj/ZZ7p5kWaPBUOZ8fITyH29CgvKKkGJ4/sFc
	 F+fiM9P993Snw==
Date: Wed, 12 Feb 2025 10:58:41 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, donald.hunter@gmail.com
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and
 stats dump support
Message-ID: <20250212105841.03ccd91c@kernel.org>
In-Reply-To: <20250212182007.GG1615191@kernel.org>
References: <20250210152159.41077-1-fw@strlen.de>
	<20250210103926.3ec4e377@kernel.org>
	<20250210202703.GA12476@breakpoint.cc>
	<20250210125438.48560003@kernel.org>
	<20250212182007.GG1615191@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Feb 2025 18:20:07 +0000 Simon Horman wrote:
> > > Looks like the tree has both v1 and v2 appliedto it.
> > >=20
> > > v1 added 'ctnetlink.yaml', I renamed it to 'conntrack.yaml' in v2 as
> > > thats what Donald requested. =20
> >=20
> > I see. We need to clean the HTML output more thoroughly in the CI =F0=
=9F=A4=94=EF=B8=8F
> > I brought the patch back, let's see what happens on next run. =20
>=20
> It seems happy now.
>=20
> Should I work on a fix for NIPA?

I'm not gonna say no :)

The problem is a bit broader than just this exact instance.
In general we don't clean up build artifacts to take advantage=20
of incremental builds. So when files move or get renamed the old
artifacts are left in place occasionally causing issues.

I wonder what the best fix is. Feels like wiping the tree clean
periodically (once a day or two?) could be best? Something like=20
creating a local file, once that file is more than 2 days old
wipe the tree pristine clean by all means possible, and then
create the file again?
