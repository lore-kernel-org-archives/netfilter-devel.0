Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A089E49B456
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399832; cv=none; b=Bk3x4uSkkxMS3bkq4JHQY/qZGIf6RGRwq5zB5a1a9ZPDu+Bw/uDVkcoaI8w5f++OeNQEVcRh8uIidJ1xbZr/CXrlFZQqDF5hQegcS0hGXgf66UpoYpy9mckjfWxzW/SqsD2XgaMtqQTtE/kWTz0RpbbY6KoMki17JRxvR3sba5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399832; c=relaxed/simple;
	bh=70e6xG+YBySu5wpjxZoPWmyMmzBwNir9ni4AofvN2w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9nIlN2A/tJC3MdzMHGvXLvuBwxYVxKz7PwfNG2g/Y+0xtwmCCd6N4UMS1U7kgdNfdKzyZOlD5nnn0lwLEgnZkltrp/P4mZ3KuqhBUh7vD2xOsw54bQeOfpsU7TyS5KI2kNWUsVTWZeSSltg3Q52mRBov3q8Ucn/Xz4EmqHrz2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7363460515; Mon, 19 Oct 2026 10:50:28 +0200 (CEST)
Date: Mon, 19 Oct 2026 10:50:28 +0200
From: Florian Westphal <fw@strlen.de>
To: YuPeng <yupeng@kylinos.cn>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc, debianyu@163.com
Subject: Re: [PATCH] extensions: ebt_string: Remove spurious inverse check
 for --string-icase
Message-ID: <atXZ1Fc4HOy--Wam@strlen.de>
References: <20261016032501.2AA453AAF44@smtp.subspace.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016032501.2AA453AAF44@smtp.subspace.kernel.org>

YuPeng <yupeng@kylinos.cn> wrote:
> --string-icase is registered as a no_argument option, so getopt_long
> always sets optarg to NULL when it is parsed.  The ebt_check_inverse2()
> macro contains a mandatory-argument guard:
> 
> 	if (!optarg) {
> 		__ebt_print_error("Option without (mandatory) argument");
> 		return -1;
> 	}
> 
> so every use of --string-icase aborts parsing with the misleading error
> "Option without (mandatory) argument." and XT_STRING_FLAG_IGNORECASE
> can never be set.  The option has been broken since it was added in
> commit b1cdae8 ("extensions: Add string filter to ebtables").
> 
> Reproducer (no privileges required):
> 
>   $ ebtables-legacy --string-icase
>   Option without (mandatory) argument.
> 
> The inverse check makes no sense for a flag option that takes no
> argument, so simply remove it.
> 
> This fix was originally carried in the Kylin Linux SRPM since 2022;
> the commit message has been rewritten to describe the actual failure
> mode observed on current master.

> diff --git a/extensions/ebt_string.c b/extensions/ebt_string.c
> index 97fbe19..74a1bfa 100644
> --- a/extensions/ebt_string.c
> +++ b/extensions/ebt_string.c
> @@ -174,8 +174,6 @@ static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
>  		break;
>  	case STRING_ICASE:
>  		ebt_check_option2(flags, OPT_STRING_ICASE);
> -		if (ebt_check_inverse2(optarg))
> -			ebt_print_error2("Unexpected `!' after --string-icase");

Are you sure?  Probably:
-		if (ebt_check_inverse2(optarg))
+		if (ebt_check_inverse(optarg))

?
