Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C122C9A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631675; cv=none; b=ht2zx24+OHc7kcKQU9FxkcBbY5uJtzh5HcuDlMH48dzaTLxBJuhqdkfwL25eL5FuW4aZ+qCigHkGdbCNYdyV1FhrGqXUVXh0BiSsRoRoT6TS/voLWHvsUQRqQPy2gIthu+5eNzNtYJ+6jZ5Z4B+LTVvJ7yRrlQNDpPMHYpcdojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631675; c=relaxed/simple;
	bh=FA0BLEPODPFNO3J3h/QfKOMTuV7EyoLj3ubhBcvgdtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkmE8QPck7XOWINIYJV3QeYTOBXmE7qyL4kzsfbqs8ed2itYq8QXaHZ0ZKRyQPydEERQSSHJuugSgHGTfIiFpGyYkKhhftlmQaYoPA1oghbVc4wowYpIB6ls4RHeYAmWTJx50k44RyjTY0iqrP1zdDkhOUZygoS6ksBJafZNyzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 31A9E60491; Fri,  4 Jul 2025 14:21:11 +0200 (CEST)
Date: Fri, 4 Jul 2025 14:21:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft 3/3] src: only print the mss and wscale of synproxy
 if they are present
Message-ID: <aGfHNiL5k6qDxvsz@strlen.de>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
 <20250704113947.676-4-dzq.aishenghu0@gmail.com>
 <aGfA5_aH6QT5z_rf@strlen.de>
 <CAFmV8NfTqTQcfqrvxpZf2nv=mSf=CpDVCbWv=E+La1oii1jzJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFmV8NfTqTQcfqrvxpZf2nv=mSf=CpDVCbWv=E+La1oii1jzJA@mail.gmail.com>

Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
> > > -     if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
> > > +     if ((flags & NF_SYNPROXY_OPT_MSS) && (flags & NF_SYNPROXY_OPT_WSCALE))
> > >               nft_print(octx, "synproxy mss %u wscale %u%s%s",
> > >                         stmt->synproxy.mss, stmt->synproxy.wscale,
> > >                         ts_str, sack_str);
> >
> > This looks wrong, this will now only print it if both are set.
> 
> The following else branch will handle the other conditions.

Urgh, indeed, orginal conditional makes no sense.
