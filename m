Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2913D264609;
	Mon, 10 Feb 2025 20:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739220880; cv=none; b=Xc28zJLeV+PHhbA6pOWFHlV4wSLjQuErPRXohWs/6LLoOODbZWGcrLbnS97k+caRQUijuvbyuMF/QGIxVYQZwHK5pP3lMygzVRPn0FbjPF9Ax9/BzduHfNJn238HvikH7PHiUW68moEnrRGnjuOGQXyCRfHVVA43NuNUpyLa+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739220880; c=relaxed/simple;
	bh=6l+7RC1vw0ZzHR9nnCstKHP4Gh+PCbZGc5teky9kJtg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L8vZQqeo4Y0644MPucewhdAh5kpm6WtI/cPIPZE6bw9Hvy4SxupjkfeBTII9fl2J+jhnuUlAEAQL8OAfEpdTp1wutUJuTm9GzFzQyjiv/7rSv4Zo3fbw+6c+ZHek4Y0CKzsV+Iw6hnFFpOdzasmzQ7MD5USsc8bYaANiDzD+BPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pywgIed9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pywgIed9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB58C4CED1;
	Mon, 10 Feb 2025 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739220879;
	bh=6l+7RC1vw0ZzHR9nnCstKHP4Gh+PCbZGc5teky9kJtg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pywgIed9ZhvGhm6okkFOyKkExt7BkePZTnexqYC7VOr7SflK6bPE6K2NR8/dB2zYW
	 IOkWUaOgZqZqOktcgRC3oAUpD89wTn+BkeFBaWvZe5ItkYm5HIhLIpmfaOhKX2CMnG
	 mB1tj3n1Jn47AmHs3um5uIElNb0ILJvDsYwOpVWMwM5KfOZwDodl9N5hKOcFdoxkJE
	 uXtt5I4T0V7YimLV4UpLNbPGTLEOedEKjuzhsGhrPjUyq6llLqFBeoSQMwCo7lJu+p
	 kFUAjJCNX2wAC+9BUcX3HqFoxxjvfBDWRbUUgM94VyNfkVJRgOVDFG/II/rXjfQNY0
	 1fVx473v4gIbA==
Date: Mon, 10 Feb 2025 12:54:38 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 donald.hunter@gmail.com
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and
 stats dump support
Message-ID: <20250210125438.48560003@kernel.org>
In-Reply-To: <20250210202703.GA12476@breakpoint.cc>
References: <20250210152159.41077-1-fw@strlen.de>
	<20250210103926.3ec4e377@kernel.org>
	<20250210202703.GA12476@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Feb 2025 21:27:03 +0100 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 10 Feb 2025 16:21:52 +0100 Florian Westphal wrote: =20
> > > This adds support to dump the connection tracking table
> > > ("conntrack -L") and the conntrack statistics, ("conntrack -S"). =20
> >=20
> > Hi Florian!
> >=20
> > Some unhappiness in the HTML doc generation coming from this spec:
> >=20
> > /home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink=
.rst:68: WARNING: duplicate label conntrack-definition-nfgenmsg, other inst=
ance in /home/doc-build/testing/Documentation/networking/netlink_spec/connt=
rack.rst =20
>=20
> Looks like the tree has both v1 and v2 appliedto it.
>=20
> v1 added 'ctnetlink.yaml', I renamed it to 'conntrack.yaml' in v2 as
> thats what Donald requested.

I see. We need to clean the HTML output more thoroughly in the CI =F0=9F=A4=
=94=EF=B8=8F
I brought the patch back, let's see what happens on next run.
