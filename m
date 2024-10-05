Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9241581E1;
	Sat,  5 Oct 2024 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728147448; cv=none; b=QL5x+Zx+FLNrpQh/XFRYRQOpFHvwVfa1gNA8m2/SW9P7Tu90WbUSb2wYl2nGCwheNT5h/yED6GoK93ZXxSpLoqnfRHeoyhKpZ+J9EQJkUkdyEGAChiinkbu1pD69h2teEE+AH04thGeKjyHBARoTSNtz3xKH4Ah98K4W3svEGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728147448; c=relaxed/simple;
	bh=wlcdioYOW2Kr4D89kdl4eY+lEskCFiz3bWWyUXcxslg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbMMZy40SKtcyBsAfDhkRNIapgkNPKxv7tJMZRWJGgjA3mLRNuLI6jsybEcyj2WYanT0iF1UF8YPq8816NtvKl9Eu7mtSHGghcBjodgmR+2ccMmuZcha4lP+Gqn2gZ6yIRbjVbwSDNETepN3YGm0MnqVGWlgu5XLWqqzQsk01Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDjC2eJM; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDjC2eJM"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a98f6f777f1so411451966b.2;
        Sat, 05 Oct 2024 09:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728147445; x=1728752245; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MSeTJd9jkaOjgipXSkW43JYFmtYMXXveHmjg3KNv1DY=;
        b=jDjC2eJMupfuQbTBydTJ5++iuXvSsejNYw52rsAXNdjCZU8hWkxDqNJtkZHDIgThio
         zoxoYvdPr4n43bFM7h+8WX/Wju6x+8qjr2sS6Qldla+tVt9G1rQyjyiO4m5XvhaR7fKy
         KMxUBQ8ZOhhWWRZFeewu9gFJY5iI3An1bZTaQgkeRktf2HyzmWKX1WpIXwXqcwFg9j2J
         o+3TCgMuA5dZA+MUB5+4XaVtplZOBAmpL5AbS6GSzavP762VykxP/mtWXc4AddsZWlg4
         GAse68YL8pHUPTvEI/m9Jn57xKE10cGQCYIOt9qbrEWL6g2FVvbO4t6Ec37W4FlbIpTw
         7g8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728147445; x=1728752245;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSeTJd9jkaOjgipXSkW43JYFmtYMXXveHmjg3KNv1DY=;
        b=fmOvBalxh67sDT9QXC+iGb1NidtURBZEIR68eEJJG8492CmAJuoRQoPeY01ZeMvIxc
         IurABy7eDPiOPlmNtuhbSdBvxdmk3Dx8FiHFLOccxym+QyrKdqR3i8IZ/WcIvgX/P0r9
         pzHOXbJw0YIZnMAWLd1MMvme3zo5Ya84CXdVhcGBebORMHHwWBwPoGEk4OmB0+wkSWdD
         qkqC0ErENZ62R+IdsJKqW6x03Owk/JCezV10WvfldncP4wYq1p/cdC0OaS/4FDYPfsWJ
         I4EYm0VpDlScIICKZdJP+D+KVWdJsBDN+gkJVTJOVvAj102yZWzcNTNI9FwcTkc3WLFQ
         HIAg==
X-Forwarded-Encrypted: i=1; AJvYcCUWXSF0CM7kM5l3tPiGYC085Kr1yAbsyCSuYJShIpupO4vvFkbnINNokefip2H9EPjXjPOAm/fs6S18hCGuGqtB@vger.kernel.org, AJvYcCVQsndj46xcYMwR3aQEg8fksnyWmm7be7r18hK1KLEutyb4gxjH7nmYS76VKrw2HLcub/DFe5lW@vger.kernel.org, AJvYcCWjvFJWrVAhwtYkclwjgGvjs1z2U7POsJpI1HUkbGdDDzbS6j++DXau03YKDQWBrBvjzhCtXqsADp3cMoo2noGwEglQi70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk3VBQRe5QynqOmR39MSiGnlKKa0CLwo8eEH5WeveUtSbChk+J
	HPSdJXe8z1EBmA5Q4y33XgLVWRcwagwTiJwQQTzhxExkKaHt59Mt
X-Google-Smtp-Source: AGHT+IHSRdtSkX09+NIKnLFVTlBJ8EfB5bPMeacHe3SGg6lgAWnNOTlZunGTLAhyTEa/r5ZHE6wbDg==
X-Received: by 2002:a17:907:608a:b0:a7d:a00a:aa02 with SMTP id a640c23a62f3a-a991bd05705mr655075966b.1.1728147445371;
        Sat, 05 Oct 2024 09:57:25 -0700 (PDT)
Received: from localhost ([2a02:168:59f0:1:b0ab:dd5e:5c82:86b0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9937e58499sm114014266b.38.2024.10.05.09.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 09:57:25 -0700 (PDT)
Date: Sat, 5 Oct 2024 18:57:24 +0200
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 9/9] samples/landlock: Support
 LANDLOCK_ACCESS_NET_LISTEN
Message-ID: <20241005.92cff495291f@gnoack.org>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-10-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240814030151.2380280-10-ivanov.mikhail1@huawei-partners.com>

On Wed, Aug 14, 2024 at 11:01:51AM +0800, Mikhail Ivanov wrote:
> Extend sample with TCP listen control logic.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  samples/landlock/sandboxer.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index e8223c3e781a..3f50cb3f8039 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c
> @@ -55,6 +55,7 @@ static inline int landlock_restrict_self(const int ruleset_fd,
>  #define ENV_FS_RW_NAME "LL_FS_RW"
>  #define ENV_TCP_BIND_NAME "LL_TCP_BIND"
>  #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
> +#define ENV_TCP_LISTEN_NAME "LL_TCP_LISTEN"
>  #define ENV_DELIMITER ":"
>  
>  static int parse_path(char *env_path, const char ***const path_list)
> @@ -208,7 +209,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>  
>  /* clang-format on */
>  
> -#define LANDLOCK_ABI_LAST 5
> +#define LANDLOCK_ABI_LAST 6
>  
>  int main(const int argc, char *const argv[], char *const *const envp)
>  {
> @@ -222,15 +223,16 @@ int main(const int argc, char *const argv[], char *const *const envp)
>  	struct landlock_ruleset_attr ruleset_attr = {
>  		.handled_access_fs = access_fs_rw,
>  		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP |
> +				      LANDLOCK_ACCESS_NET_LISTEN_TCP,
>  	};
>  
>  	if (argc < 2) {
>  		fprintf(stderr,
> -			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
> +			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
>  			"<cmd> [args]...\n\n",
>  			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
> -			ENV_TCP_CONNECT_NAME, argv[0]);
> +			ENV_TCP_CONNECT_NAME, ENV_TCP_LISTEN_NAME, argv[0]);
>  		fprintf(stderr,
>  			"Execute a command in a restricted environment.\n\n");
>  		fprintf(stderr,
> @@ -251,15 +253,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
>  		fprintf(stderr,
>  			"* %s: list of ports allowed to connect (client).\n",
>  			ENV_TCP_CONNECT_NAME);
> +		fprintf(stderr,
> +			"* %s: list of ports allowed to listen (server).\n",
> +			ENV_TCP_LISTEN_NAME);
>  		fprintf(stderr,
>  			"\nexample:\n"
>  			"%s=\"${PATH}:/lib:/usr:/proc:/etc:/dev/urandom\" "
>  			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>  			"%s=\"9418\" "
>  			"%s=\"80:443\" "
> +			"%s=\"9418\" "
>  			"%s bash -i\n\n",
>  			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
> -			ENV_TCP_CONNECT_NAME, argv[0]);
> +			ENV_TCP_CONNECT_NAME, ENV_TCP_LISTEN_NAME, argv[0]);
>  		fprintf(stderr,
>  			"This sandboxer can use Landlock features "
>  			"up to ABI version %d.\n",
> @@ -326,6 +332,11 @@ int main(const int argc, char *const argv[], char *const *const envp)
>  	case 4:
>  		/* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
>  		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_IOCTL_DEV;
> +		__attribute__((fallthrough));
> +	case 5:
> +		/* Removes LANDLOCK_ACCESS_NET_LISTEN support for ABI < 6 */
> +		ruleset_attr.handled_access_net &=
> +			~(LANDLOCK_ACCESS_NET_LISTEN_TCP);

(same remark as on other patch set)

ABI version has shifted by one in the meantime.

>  
>  		fprintf(stderr,
>  			"Hint: You should update the running kernel "
> @@ -357,6 +368,12 @@ int main(const int argc, char *const argv[], char *const *const envp)
>  		ruleset_attr.handled_access_net &=
>  			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>  	}
> +	/* Removes listen access attribute if not supported by a user. */

(also same remark as on other patch set)

Please s/supported/requested/, for consistency.

> +	env_port_name = getenv(ENV_TCP_LISTEN_NAME);
> +	if (!env_port_name) {
> +		ruleset_attr.handled_access_net &=
> +			~LANDLOCK_ACCESS_NET_LISTEN_TCP;
> +	}
>  
>  	ruleset_fd =
>  		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> @@ -380,6 +397,10 @@ int main(const int argc, char *const argv[], char *const *const envp)
>  				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>  		goto err_close_ruleset;
>  	}
> +	if (populate_ruleset_net(ENV_TCP_LISTEN_NAME, ruleset_fd,
> +				 LANDLOCK_ACCESS_NET_LISTEN_TCP)) {
> +		goto err_close_ruleset;
> +	}
>  
>  	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>  		perror("Failed to restrict privileges");
> -- 
> 2.34.1
> 

Reviewed-by: Günther Noack <gnoack3000@gmail.com>
