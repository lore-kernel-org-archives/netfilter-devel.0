Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C5378831;
	Thu, 26 Feb 2026 03:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077284; cv=none; b=bzgLatZa5CCRGZhkUL2/n6D2fIscuTIReVksFdUKOHGPbHfDsSL3UyzPDG6c8x/dir/pxTo5yp6h723P8RGhi4yCX/ICdOu/wBV5f32WXE+PjtEcmp6Uf0LQvoVEcZ1XOr8NwW1ZuL78FT4j2YK+YfDAu/9VZoP871tFjP8FkfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077284; c=relaxed/simple;
	bh=li3Qjq+vB/+jOVcbQHbXwW4j7Zbqv1M7+Dnm7SrhjdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIxF4RYtndmyb7qj6B30HOLRLTH8VFPE79wsxULSX/zkdriifz/w6giaw6OWSuNuQbEWPE2mrBvwPd1TT3uE6ickbNoe6Px6xR766XDU5prddFb8/G6mX+lIOwTQKh/UXLxznWdusecM5/1uqAggnbJePb8Pmh/favvNqVWnIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNnt1yIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNnt1yIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3962BC19425;
	Thu, 26 Feb 2026 03:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772077284;
	bh=li3Qjq+vB/+jOVcbQHbXwW4j7Zbqv1M7+Dnm7SrhjdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNnt1yILxBGM5PFsqrp/pIPrcxTSN1XIuYdkRuBHTfCoo0y6IoD01uYWeKdT6qv39
	 WqYpVAo2aSvTl1+FJiqYNZioDcg5ZNeixk7DbOycdikTK2c5PuzuLOWWUxbjVlHsty
	 Nd0zptVg2t+PZ/YWgCvNfYlsRLYe5xI97nxLNO0fa7J83TtGNPxN20pzPYJwFSCS8r
	 mXd8ydnp6TBGZLvBDxiqUiUARKw4dXu3R7ZnqJzP88uUCLFcHAlgNhqni+uYT90HN0
	 H/0Ibk6TrGOJy3b/N1qQhaZAJvgMs562DjggFzQdBrOhKtus354lQvrYF5yY+qODzN
	 m3AadU/LO60Sw==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [net-next,3/9] ipvs: use single svc table
Date: Wed, 25 Feb 2026 19:41:22 -0800
Message-ID: <20260226034123.1806942-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224205048.4718-4-fw@strlen.de>
References: <20260224205048.4718-4-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "FYI"

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
ipvs: use single svc table

This patch merges fwmark based services and non-fwmark based services
into a single service table, eliminating the separate svc_fwm_table and
reducing the complexity of managing two hash tables.

> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 074a204ec6db..b5a5a5efe3cc 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h

[ ... ]

> @@ -1050,10 +1049,7 @@ struct netns_ipvs {
>
>  	/* the service mutex that protect svc_table and svc_fwm_table */
                                                              ^^^^^^^^^^^^^^
>  	struct mutex service_mutex;
> -	/* the service table hashed by <protocol, addr, port> */
> -	struct hlist_head svc_table[IP_VS_SVC_TAB_SIZE];
> -	/* the service table hashed by fwmark */
> -	struct hlist_head svc_fwm_table[IP_VS_SVC_TAB_SIZE];
> +	struct hlist_head svc_table[IP_VS_SVC_TAB_SIZE];	/* Services */

Should this comment be updated to reflect the removal of svc_fwm_table?
The comment still references both svc_table and svc_fwm_table, but this
patch removes svc_fwm_table entirely. Perhaps it should read "protect
svc_table" instead.

[ ... ]
