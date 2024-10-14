Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C1156F3A
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904340; cv=none; b=WzyvP9SG1FTzVB+o/FXxjG1tmJXO7QGAdhHqh08JdNzpuwAND436yY1poiSYiYi+es6jcG+7yfjXe36N/Ev/SJl0aWvZhG0BdnJ96GpF0UF8ce/XqQ+XtQ++tvi9ghg996JCXY3qWyVOi7K3KI84SQ2SrcZxjFEJy81InztkqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904340; c=relaxed/simple;
	bh=JCDMh6s+9Dw0oAy/bcn+Scib5aGRF1yGPLg55qjrXdI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jBPbbKvBT8NPz3rPWcIF8Jbw+Pjowu1VjUVCQiJoleYxdPgJL9WtjrAa4C06wh4AGyjdzEljkj29zYu1HVbIVYVrTWu8kiB71vsuItRJPuqHyLxRByUpFy4/dAZekjPQddTbEpxN+cMkxuBIQnqXea30pyw34aAuCuwk2LS3J/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 0B0E010041713A; Mon, 14 Oct 2024 13:12:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 0AC4A1100B1489;
	Mon, 14 Oct 2024 13:12:02 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:12:02 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
In-Reply-To: <ZwzRn6EQpRJWxYA-@calendula>
Message-ID: <n4r27125-61q3-r7p2-ns82-77334r0oo3s3@vanv.qr>
References: <20241012171521.33453-1-pablo@netfilter.org> <ZwzOgRoMzOiNfgn0@slk15.local.net> <ZwzRn6EQpRJWxYA-@calendula>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


>Duncan Roe wrote:
>> 
>> Distributors typically use the default config to make a package. That would mean
>> libmnl would go out without any documentation, hardly an encouragement to use
>> it.

It is true that distros commonly go with upstream default. When the 
upstream default is on "auto" however, it becomes a distro default,
which, due to a blank recipe, quickly becomes "no-documentation".
(Because of this, openSUSE was embarassingly not building libmnl-doc.)

As to whether that is an impediment to creating libmnl-exercising 
software, I cannot say.

Having worked extensively with wxWidgets (also doxygenated) in the past 
however, I found that when the API is large, needs frequent lookup, 
documentation has many pages, and online retrieval latency becomes a 
factor, I prefer a local copy as a quality-of-live improvement.


On Monday 2024-10-14 10:09, Pablo Neira Ayuso wrote:
>
>We do not have control over the specific items that distributors
>choose to include in their packages.
>[...] the final decisions regarding package contents
>rest solely with the distributors.

Well, not quite.

Removals are a powerful action that is seldomly undone at the distro
levels, so it can be regarded as the final say (well, in "95% of
cases"). Think of:

* deprecated C APIs (distros would rather patch consumer programs to
  work with the new ones)

* GNOME desktop, which is infamous for removing stuff due to
  confusion ([1])
[1] https://medium.com/@fulalas/gnome-linux-a-complete-disaster-feb27b13a5c2

Hiding stuff behind a configure knob is not a removal though,
so it is not too big a deal.


>Moreover, documentation is specifically designed for developers who
>are engaged in the technical aspects. Most users of this software are
>building it because it is a dependency for their software.
                                            ^^^^^^^^^^^^^^

The way it's phrased makes those users users of the libmnl API (i.e.
developers), and documentation is warranted.

(The following statement would be more accurate:

>Most users of this software are
>building it because it is a dependency for someone else's software
>they want to utilize.


Anyway, looking at what distros _are_ doing is an indicator what
"users" (intermediate consumers, or users at the end of the build
chain) desire and what is worth doing upstream somehow.

* ICU manages documentation separately; in a sense you could see
  this as --enable-doc=no. The ICU APIs are however apparently
  complicated enough that documentation is desirable to have
  available, and so you do find libicu-doc/icu-doc in distros.

* the closer a software is to the bootstrap core, and the more
  outrageous the build requirements for some (sub)component(s) are,
  there more likely it is for those (sub)component(s) to be built in
  a two-phase build or be completely omitted due to complexity.

	* texlive
	* pandoc
	* ant/maven
	* rust/ghc/go

docbook/asciidoc seems right on the edge (because of its potential
to depend on a latex backend), but doxygen seems easy.
