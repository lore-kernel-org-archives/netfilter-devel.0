Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A9255E23
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741792918; cv=none; b=EVgpcT7PYuLgKpxEt2vMdouBB5GXb7rJuSvTcJWst2EroppVrXoEeDbE+z96SlfldddKPuZWK2IDhhm9HYzoK5Eyw43DaKr/8inZY0PZwWojlqkO8RyGJMBZ+o9r7zEaBp9nLqfHO88/GDh9qs71gu2FuC94Epl5pxOxZ0eclho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741792918; c=relaxed/simple;
	bh=lP+uHbGbMws3xQ6lw3icAdgVfLMNR8R1mga3R+hadWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJlHHM2wp6I8TRJtNRAbwu0g6aiAO5lEhA1JHSV5P3xAVYocR/an+Ig4i1191ru/uLdX6m0aaHKKobiRGt5K8XFTfC6psMYyoTXzt0h5nwsHhWEkqbH0vztkP4u/bUswXSImuYtbqAKsQ/SFAlhDwHTICCUgKm34h1q+kz0g6Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsNu6-0007Yy-0u; Wed, 12 Mar 2025 16:21:54 +0100
Date: Wed, 12 Mar 2025 16:21:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2,v2 3/6] ulogd: raise error on unknown config key
Message-ID: <20250312152154.GA28069@breakpoint.cc>
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
 <e3965ebb-b9f9-46ce-87e5-4960405dbe35@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3965ebb-b9f9-46ce-87e5-4960405dbe35@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> Until a6fbeb96e889 ("new configuration file syntax (Magnus Boden)")
> this was already caught, and the enum member is still present.
> 
> Check if the for loop worked throught the whole array without hitting a
> matching config option, and return with the unknown key error code.
> Because there is no existing config_entry struct with that unknwon key
> to use with the established config_errce pointer, allocate a new struct.
> This potentially creates a memory leak if that config_entry is never
> freed again, but for me that is acceptable is this rare case.
> 
> Since the memory allocation for the struct can fail, also reuse the old
> out-of-memory error to indicate that.
> 
> Signed-off-by: Corubba Smith <corubba@gmx.de>
> ---
> Changes in v2:
>   - Reduce indentation of case statements (Florian Westphal)
> 
>  src/conffile.c | 11 +++++++++++
>  src/ulogd.c    |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/src/conffile.c b/src/conffile.c
> index cc5552c..7b9fb0f 100644
> --- a/src/conffile.c
> +++ b/src/conffile.c
> @@ -236,6 +236,17 @@ int config_parse_file(const char *section, struct config_keyset *kset)
>  			break;
>  		}
>  		pr_debug("parse_file: exiting main loop\n");
> +
> +		if (i == kset->num_ces) {
> +			config_errce = calloc(1, sizeof(struct config_entry));
> +			if (config_errce == NULL) {
> +				err = -ERROOM;
> +				goto cpf_error;
> +			}
> +			strncpy(&config_errce->key[0], wordbuf, CONFIG_KEY_LEN - 1);

This raises a bogus compiler warning for me:
conffile.c:246:25: warning: '__builtin_strncpy' output may be truncated copying 30 bytes from a string of length 254 [-Wstringop-truncation]
  246 |                         strncpy(config_errce->key, wordbuf, sizeof(config_errce->key));

What do you make of this?

-                       strncpy(&config_errce->key[0], wordbuf, CONFIG_KEY_LEN - 1);
+                       snprintf(config_errce->key, sizeof(config_errce->key), "%s", wordbuf);

