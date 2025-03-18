Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2923F1598F4
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304627; cv=none; b=cGg50J3Guxb94yoWiKILmVat8dEn8MXbPAFz1xOYn6gowDf9nldZrHGQPxJ5AvvjzZmI8hbFV0FmbwXOD9Vv3oqI+WMNKGeP3peI3Ce5F8pD+scs2hF7oNAErLpSODXE96VzXk9f1e+PLdaChMbAWX+SkIIybDam4x5iUFbEteU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304627; c=relaxed/simple;
	bh=TOyXsE67II6uWVuS419ydhQ11S69OxC6BgesSnbcH5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=feJK4HklUEz3IaPXopGbAjE4YDmr5JmU7Fx76mdShoFBQl0z54i20ArwKXl9TZVm4O2Nw+7qHvjPJoe5acPFUhJ3puK+jXLox4zZGabI6gc/cf7KScEcGWzTVyMZMKiAFt3JQ6gUrTG6OYV8LpghKWTIm3fNKE3KhUKqC6/AOSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuX1T-0005XC-H2; Tue, 18 Mar 2025 14:30:23 +0100
Date: Tue, 18 Mar 2025 14:29:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: replace struct stmt_ops by type field in struct
 stmt
Message-ID: <Z9l1T85xloDQEidF@strlen.de>
References: <20250317224333.2037199-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250317224333.2037199-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Shrink struct stmt in 8 bytes.
>=20
> __stmt_ops_by_type() provides an operation for STMT_INVALID since this
> is required by -o/--optimize.

We could have lots of statements in a ruleset, so I think this makes
sense to compact things.
>=20
> Similar to:
>=20
>  68e76238749f ("src: expr: add and use expr_name helper").
>  72931553828a ("src: expr: add expression etype")
>  2cc91e6198e7 ("src: expr: add and use internal expr_ops helper")

=2E.. and it makes statements more like expressions wrt. ops, so this is
good too.

Acked-by: Florian Westphal <fw@strlen.de>
