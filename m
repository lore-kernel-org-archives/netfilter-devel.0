Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0FC81E
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 00:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742429086; cv=none; b=I2RPCfjNRyIyC5ZdQVsUz20PP02C3QyffElj6/LH7URQ2LKH2CEZiafZPIWuHc/W2IQ69Ug5GytqBWvT69M/572mUuCqkOSCdX7nj4b2OczZz3bvNYyyqUJ/Yov7QjpBWk3OGVoc1XtRC09c9T93p2nno38UmHYesENBdNbThxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742429086; c=relaxed/simple;
	bh=g3egrRSYYSRhZZySVaGNp71Xdvfwu2CQOaWCBzum86o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaUGaQUqSs+IMoEacDDF8rFej80RIG7cZKiaCSmhSfvlcwI7pJBx4CtWu3yECYe7o+KqDr/0tNsU4CSn8HLF7TnsSmFkPh7A6OxBs3rO2AwGjpY9wY/o5E9Qehfmjlc3Owk+fa++wp6HZzUW7+xMZRWA/ejlhyDM+TbG58KJBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W3yBhXwQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fLjcR2vl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W3yBhXwQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fLjcR2vl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9D8B860549; Thu, 20 Mar 2025 01:04:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742429082;
	bh=HgCdc8seaUZeRMc9+wYQ7s2O8C9jcTHwuxGTUwKBYsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W3yBhXwQ6LkijIT26tDrTvGq+OuQmEiAog8QTl3Qz2qV9P+46Qxwj1p4B6ZiEoAp4
	 EHbOuUSK1sIaudANvAguQE0zsURL/rxFeQX5sGCAdYQG+s4UBikEuCHZgjaIJHpL6Q
	 mhpNEo7AvxvJsndjtne/xR2U5R+XY2t2XerFYinHmzkgyz+ytKjhS6KDL6LVT+V/H7
	 vLVOCYAa7XLUH1xv81VJooexAyo8mhFuM6gAieuVmILpcMld+UCY/Ro5Y0guMXxA6N
	 YSijMVx1IViLh8A1Xrs3ssooH0SxDjueeIdycbkk06fZz1betvO3wkiLuA/gW9HGq6
	 dWhOJZftdFYlQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B5CAB603A8;
	Thu, 20 Mar 2025 01:04:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742429080;
	bh=HgCdc8seaUZeRMc9+wYQ7s2O8C9jcTHwuxGTUwKBYsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fLjcR2vlS+r0lBPsddJkbCE8ry9hhBuL/oggFlRNi7zzozi6X4rALyQB+ZH0h6QuB
	 yvLuJ/J4RsR/ibGyDfdygKR0yg5AxKNfUlDoXx5jBjh+sYWPecBX3ImefvGJ7mKzUz
	 2/vrKmNk1SBWtOWgX5zlaypQ+PJUd+5TNl09t7QZDDXfalNO1eZZNYPSzK2qid1QQ5
	 WzByD8bFiaJ8hcKa3P41e8XGsA1pL03+0wX1S/rS11XnNuJF2mTg+SoxWF+osoJTcs
	 JtOL8arrtIimJX4id4K991fG04ITq1lSSV25Rg3GmYlZPo2Wx8qe0xOShYZIvcBbLj
	 7ZfDqgLPdN7rw==
Date: Thu, 20 Mar 2025 01:04:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, matthias.gerstner@suse.com,
	kevin@scrye.com, fcolista@alpinelinux.org, seblu@archlinux.org
Subject: Re: [nftables PATCH v2] tools: add a systemd unit for static rulesets
Message-ID: <Z9tbloqNMyxd4I0F@calendula>
References: <20250308182250.98098-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250308182250.98098-1-jengelh@inai.de>

Hi Jan,

One more request, see below.

On Sat, Mar 08, 2025 at 07:22:22PM +0100, Jan Engelhardt wrote:
> diff --git a/configure.ac b/configure.ac
> index 80a64813..64a164e5 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -114,6 +114,16 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
>  #include <netdb.h>
>  ]])
>  
> +AC_ARG_WITH([unitdir],
> +	[AS_HELP_STRING([--with-unitdir=PATH], [Path to systemd service unit directory])],
> +	[unitdir="$withval"],
> +	[
> +		unitdir=$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>/dev/null)
> +		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
> +	])
> +AC_SUBST([unitdir])
> +
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\

Update the configuration summary to display this service unit, I mean
this report:

echo "
nft configuration:
  cli support:                  ${with_cli}
  enable debugging symbols:     ${enable_debug}
  use mini-gmp:                 ${with_mini_gmp}
  enable man page:              ${enable_man_doc}
  libxtables support:           ${with_xtables}
  json output support:          ${with_json}"

Thanks.
