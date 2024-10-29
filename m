Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91F8204F70
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203494; cv=none; b=GRh3zZXuSqi6I1ZRKp9am/4FRdS0AfiGG8JE255xeRvlAVv0H25gDgDaHPAaZOP6EB83ARuG4+WED3z4DCZNN4KZWsfGtyHvbCdHRSf7FzSgPzRqyhnEmxf1FX0Y9s6X9ujP6dSsHs9wcaG3Ls9a57rgSioXGNlHho8aK3+yq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203494; c=relaxed/simple;
	bh=+NV0ts4h9S8JlwaIilGa0Mdu/mClNSTnD6qUv9gnlso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeYgPIcCvkRayhk+WcB6FcTKDpiJH2ll2v1cFSUsHq7+lwdbXri/Hbhw+8bZOgiuQcvjinSR+Jz2drpplYJKjapBOhOgQw5wEathDwcFO+4X2FV7AUB5T3RhOpRrsDL5fPElaraChoQi8AApoMBFy8ftCD74cRkQyloAMX5XF64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LTzu91ie; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LTzu91ie"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aAdGttqUFBEQ3Nv/wmxaE5PjBo3uqj6T79IeXCtet2I=; b=LTzu91ieXjPXWSPB9/WtuEOf89
	/abiszdpxpeVJZ7wXdsSdiQavz075ZPKZHgSoGbwMToUaL+TI0dkjzmyojTN+aEvIaxvjsZ3M8TrC
	k0td64oqeW+D7v9Wlg1otlIselV7cS0Igz2ZMuM+kMQIOkyG3LDf7RGZjyOJRdLu5F0sn6EWMxKma
	rod2m02SzeQBkOChTlxtOJ30FqOA8RnVIJL7CUgBt4h6UtWUrN5zAGcuFHoXNNanJhy1xMIy2SWJN
	koHD3C8gFemMhqHED2Ax48XvuEEjLN0kv6z/Jq0Wj71fSGLUkdAkiTqDJ5daR0W17F5A/WF4n1Pu2
	ulV+glLg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5kxt-000000007Bu-2A3w;
	Tue, 29 Oct 2024 13:04:49 +0100
Date: Tue, 29 Oct 2024 13:04:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH] Use SPDX License Identifiers in headers
Message-ID: <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
References: <20241023200658.24205-1-phil@nwl.cc>
 <ZyAVA6uzi-OUBtcO@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyAVA6uzi-OUBtcO@calendula>

On Mon, Oct 28, 2024 at 11:49:39PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 23, 2024 at 10:06:57PM +0200, Phil Sutter wrote:
> > diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
> > index 13be982324180..fc2e939dae8b4 100644
> > --- a/examples/nft-chain-add.c
> > +++ b/examples/nft-chain-add.c
> > @@ -1,10 +1,7 @@
> 
> Maybe more intuitive to place
> 
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> in the first line of this file? This is what was done in iproute2.

Fine with me! I just semi-automatically replaced the license text block
by this specifier and didn't care about its position. A quick check of
how things are done in linux.git shows it's not entirely consistent
there: When Thomas Gleixner did an equivalent to my patch in commit
0fdebc5ec2ca ("treewide: Replace GPLv2 boilerplate/reference with SPDX -
gpl-2.0_56.RULE (part 1)"), he used double-slash comments, while Greg
Kroah-Hartman chose to use multi-line comments in commit b24413180f56
("License cleanup: add SPDX GPL-2.0 license identifier to files with no
license"). Is this random or am I missing a detail?

BTW: Jan suggested to also (introd)use SPDX-FileCopyrightText label, but
spdx.dev explicitly states: "Therefore, you should not remove or modify
existing copyright notices in files when adding an SPDX ID."[1] What's
your opinion about it?

Thanks, Phil

[1] https://spdx.dev/learn/handling-license-info/
