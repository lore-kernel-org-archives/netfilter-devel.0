Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1394C4CB4B
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711536336; cv=none; b=rRuxEavsVspVenonKX/0qiHhmp0BhpBgFX6jitXNeGA/5S2LGgDLAsmPBHbsDFPxwKfXPnNMLjhEked7dp06w7QucKgYeQKNRMqhihGRqs1+gEhIcRtZJvuyx0ACKGmZ/I38BNxb18d6acumjV+h/qroDGW5XaQ78xTCYFJWP1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711536336; c=relaxed/simple;
	bh=kuBo0H9J1FjHw4PFXPqSPhmKf3pZMS6EUaNHJSI6FL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhqorS52KR0Ijye6HfReLPi+eU6hljtDreJlqqyJLyBO/DYS6XwI0zCn7VgQVWznxQ7n0ub+AXR7ZBt6bmC86TEIs3PEdfEj0RZqUF4dpkV1NcXCkufvvawpZWj4jBs6zC5guSX0SFKtk7v2tYAp7bW+3Ei79qJVMLUS29M7crs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=0Ddi4oL7; arc=none smtp.client-ip=45.157.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="0Ddi4oL7"
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4V4Nc21n7dz47F;
	Wed, 27 Mar 2024 11:45:22 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4V4Nc15n0jz1Zj;
	Wed, 27 Mar 2024 11:45:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1711536322;
	bh=kuBo0H9J1FjHw4PFXPqSPhmKf3pZMS6EUaNHJSI6FL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0Ddi4oL7T/YfHlyGBg5FlsaH7n6qfIgkvoIhqiCT3hDhhsbVaGn4hpx/hPPLpdRxJ
	 hNgnaR/qgf9rD6tkmNgdZ+R9vTRhGjpDA/RwrUPNY9/SEl37uhbtlzgEBcXsTGjoGk
	 blquta0kc6HceETUP8btVeHlfxdJouVYpQvPgjfA=
Date: Wed, 27 Mar 2024 11:45:21 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [PATCH] samples/landlock: Fix incorrect free in
 populate_ruleset_net
Message-ID: <20240327.Zoo8Huo0eemo@digikod.net>
References: <20240326095625.3576164-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240326095625.3576164-1-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Tue, Mar 26, 2024 at 05:56:25PM +0800, Ivanov Mikhail wrote:
> Pointer env_port_name changes after strsep(). Memory allocated via
> strdup() will not be freed if landlock_add_rule() returns non-zero value.
> 
> Fixes: 5e990dcef12e ("samples/landlock: Support TCP restrictions")
> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

Thanks! Applied to my next branch.

> ---
>  samples/landlock/sandboxer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index 32e930c853bb..8b8ecd65c28c 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c
> @@ -153,7 +153,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>  				const __u64 allowed_access)
>  {
>  	int ret = 1;
> -	char *env_port_name, *strport;
> +	char *env_port_name, *env_port_name_next, *strport;
>  	struct landlock_net_port_attr net_port = {
>  		.allowed_access = allowed_access,
>  		.port = 0,
> @@ -165,7 +165,8 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>  	env_port_name = strdup(env_port_name);
>  	unsetenv(env_var);
>  
> -	while ((strport = strsep(&env_port_name, ENV_DELIMITER))) {
> +	env_port_name_next = env_port_name;
> +	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
>  		net_port.port = atoi(strport);
>  		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>  				      &net_port, 0)) {
> -- 
> 2.34.1
> 
> 
