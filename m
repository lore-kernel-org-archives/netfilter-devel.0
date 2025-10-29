Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9213C914
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762177; cv=none; b=rFFkuii+jVQuJBM/hg5GjThXFLPedpsMFtj0/f41q3k8gvKIA2cjtKfIoJNwJmIMKk2WUXSlhJL24La2rBiwe42ZTgNOPgU9Snwa7AniI30QMiao3+9MqWjlbIsMcJoOKDvdxFPyUQPlL1OIhQ2h8uj8VizosI3N78o+RAcY4M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762177; c=relaxed/simple;
	bh=f05UiuSQMhtZ8gq+nbHCtuf9QQNBH4OFyRHEsEEkRYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHuxzccQrA65FUZZ3mfZZHi7EvOfr501Lg93AfJ1HVEcfXf77N8VA4CGHaQVckNE4EpW9qDu0OzZL8ZejrQ+s7ymBOsR4KGNykOfUafqZScDkS4mUzqzn4EYuagHyxj22XQGq4jH3V5aYG/QvnuGNCxa4PA4EupsLiWXKw30oCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XivZbhaN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XivZbhaN"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE19360265;
	Wed, 29 Oct 2025 19:22:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761762165;
	bh=0jOyt0z0D6C6zTGKa+Krw1n8B8ijm9QlyuWzJubJdmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XivZbhaNpjTfGMgwGZVIt33KtgSU53aFex7peQd1d+odRcsUeimH4roDTZiqdPBrU
	 i7YiZsqckGjT897YY1KGjbdgnQ0cJUlacK85qbWao/oQfaxp8f3hEZUlp/ivnAvP3Z
	 VN+UY0bjl5efC8m5NIS7dey1S4e4y2u+kpYZEt+55yvv8JRDd60hr5mZh0qEnZyptD
	 q3kzVXMeAUZzJPJPfvnjt5RRVPQb1iqPCPiG/06F0lShpwosfiwWPU1KszJuJNlQXy
	 Xb7diC35u/xzw8FT5i05uN2zQkpNDcMbmOIh/QnU1xtlyY4oJNVd4YKkcjB+SCc/ET
	 gQL8ai57mBGmw==
Date: Wed, 29 Oct 2025 19:22:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 13/28] Define string-based data types as Big Endian
Message-ID: <aQJbciPngSX4qNpq@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-14-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-14-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:14:02PM +0200, Phil Sutter wrote:
> Doesn't quite matter internally, but libnftnl should not attempt to
> convert strings from host byte order when printing.
> 
> Fib expression byte order changes with NFT_FIB_RESULT_OIFNAME to Big
> Endian.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/ct.c                  |  2 +-
>  src/datatype.c            | 10 +++++-----
>  src/evaluate.c            | 18 +++++++++---------
>  src/fib.c                 |  5 +++--
>  src/intervals.c           |  5 -----
>  src/json.c                |  2 +-
>  src/meta.c                | 16 ++++++++--------
>  src/mnl.c                 |  2 +-
>  src/netlink.c             | 12 +++++-------
>  src/netlink_delinearize.c | 14 +++++++-------
>  src/osf.c                 |  3 +--
>  src/parser_bison.y        | 10 +++++-----
>  src/parser_json.c         |  4 ++--
>  src/segtree.c             | 10 +++++-----
>  14 files changed, 53 insertions(+), 60 deletions(-)
> 
> diff --git a/src/ct.c b/src/ct.c
> index 4edbc0fc2997f..e9333c79dfd42 100644
> --- a/src/ct.c
> +++ b/src/ct.c
> @@ -273,7 +273,7 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
>  					      BYTEORDER_HOST_ENDIAN,
>  					      4 * BITS_PER_BYTE),
>  	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
> -					      BYTEORDER_HOST_ENDIAN,
> +					      BYTEORDER_BIG_ENDIAN,

No, this is not big endian, this is confusing.
