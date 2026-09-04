Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166EB3BCD0A;
	Fri,  4 Sep 2026 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501367; cv=none; b=JDGCpct3tmEf8g/bXO9Dovc27ShaUBam7hKjlxYZnUcIuPVuIXidGx4tiU5kwusj2HPvTHJ8XQYNM1Xx2iDFB76FIavlFwDKKQ+Wq1rEKD40AibsFtpCwvvTkzUJu+S/e54HElRjCYaWnZKH6b+A6IA34rjn+zxWtu5zynyVZ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501367; c=relaxed/simple;
	bh=Ffgw3X76VV/azRkewEZgJ4M7+5msq/ov+6aaQb1hxqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1ltCydjWyuaYgHIf2Lv1bIAj1iqqGzuggz9Co80tRWku8VAXzwhUcY+1AofNsaPKSOqcvs17Tn6gOuvSnh+vC4Wez1rVKKYHrEsbfedyKjIN/RV1xySqXWejQCkMjD94s4zWp3Bzj+9Q83cE0lI5uJDZEOs5mG6QYhZ+7efjPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D73BC6032B; Fri, 04 Sep 2026 07:56:01 +0200 (CEST)
Date: Fri, 4 Sep 2026 07:56:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 07/12] netfilter: nft_payload: restrict checksum
 offsets to known values
Message-ID: <appdPTMTwCeFBce3@strlen.de>
References: <20260903004149.1037028-8-pablo@netfilter.org>
 <20260904020148.3549914-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260904020148.3549914-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> [Severity: High]
> Should nft_payload_csum_th_write_ok() also handle IPPROTO_ICMP?  There is
> no arm for it, and neither IPPROTO_ICMP nor struct icmphdr appear anywhere
> in nft_payload.c (linux/icmp.h is not included), so pkt->tprot =3D=3D
> IPPROTO_ICMP falls out of the switch and returns false.

Sigh.

> Two things that may be worth considering: adding
>=20
> 	case IPPROTO_ICMP:
> 		return priv->csum_offset =3D=3D offsetof(struct icmphdr, checksum);
>=20
> to nft_payload_csum_th_write_ok(), and making the run time refusal set
> NFT_BREAK rather than silently skipping the checksum update, so load time
> and run time agree.

Sigh.
