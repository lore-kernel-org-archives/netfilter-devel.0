Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E026382F12;
	Fri, 17 Apr 2026 07:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412312; cv=none; b=QiUe440Bn5vhrfi5VJjuYLYnsdo0dnnR6ZCUYMX5lNwJ8SAhcOy6rwoBY1ldwB0SWBCJEoOdTqAj/TdS4hBRUsPQl33mbxRq5lvCjFK5DmqaLR0W7YuR4z7JeQ4zud2vR4P/bhd8w1x1U4edhevuxrNll4ReNNgXVLmJaO7cFXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412312; c=relaxed/simple;
	bh=OYAGwy9MTm+ow03iecXkfmblodkn/G0PyBhnwKBU0Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPklDtNIesVNa2uxaHMmmKYzWOl8Qw395Tci2x/EvoSEiONyje0ZPefcjDfiXI/kdYCbKzt4+54BW/AURVpQO9eyfFNFAX6h/LToECNbHoylO0lbP3zJjBsXIkllLY3Nb1NfvlBu9FqoWoJjV8vu6h1RpFRlMDWKa+zQpdAW8do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dmy4OPGU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dmy4OPGU"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id F1BF560178;
	Fri, 17 Apr 2026 09:51:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776412301;
	bh=BpNM+GQZCW6hrf6VGd87Afd90Vl6W3KFzh5DaZW4unY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dmy4OPGUqLQI4HTeXvlrtV8evQKdS8uMbbWptjPhLJ3dbV6wqX0hgHs3FBhkq70bF
	 sn+pKTO2ptsfjAico8OVKG087ZT8OSGsk6r/idUSR3y+JCJIBlaoWQOIvaoAakn9KE
	 5H2BJnSj9M8r5G2/WPJdNPpCBp8xEEU0Rb1YGEUFO1trodYndyzTh82KVEd/g6X2x+
	 J2k2JK9o2+8KTDwidqtlSC5KhW3v5T0Qy0V4zghIsgRuqlaf3zvqbHI55pehsu4mMQ
	 0SUB1FCxrm7E0sQsN8Pj3CLE0a5Up+YHFjkj2fXKVtIjDnMIBGxZqMpznRo3F7fMzN
	 fGsMTjy9Vt43Q==
Date: Fri, 17 Apr 2026 09:51:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net,v2 00/11] Netfilter/IPVS fixes for net
Message-ID: <aeHminpmIiI4SVVw@chamomile>
References: <20260416131453.308611-1-pablo@netfilter.org>
 <aeFRt__YQqJ84ZaN@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeFRt__YQqJ84ZaN@strlen.de>

On Thu, Apr 16, 2026 at 11:16:39PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> If you don't want to take this v2 because of above issues, please
> consider at least applying
> 
>   ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 08/11] ipvs: fix MTU check for GSO packets in tunnel mode
>   ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 09/11] netfilter: nf_tables: use list_del_rcu for netlink hooks
>   ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 10/11] rculist: add list_splice_rcu() for private lists
>   ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 05/11] netfilter: conntrack: remove sprintf usage
>   ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 06/11] netfilter: xtables: restrict several matches to inet family
> 
> manually.  nf:main always tracks net:main, applying them manually
> doesn't cause issues.

Florian, I am going to prepare a v3.
