Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3DA352F9D
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775772731; cv=none; b=UVqK9X7XbcTIIvsM0BDKAr+V9HyahiogGOzpPJzY3evInKvIPld9YGN4WYJK0K103aOLmGEjAxO/nrTYkfgQNhy5bQxebSWQ19PjYD7H1hBoLDhFbBKxTr4mYwuukq7bVcLAHXFrxAiVjMQtXox6LE/5s0S162B3Am+ZDUZB1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775772731; c=relaxed/simple;
	bh=wo6Ox7iCVjKYu5cSTs6fnMoWweBLD66PN67ebOZ9Rlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HF6C5OOP+C3Nt02km6cyqntAOfWyCO0zdQkMNjNotoaD7fLU9C7qOoh2RvVd/cCBGlSytCpSYiKOt+e0slA8M06pNOzztyxO/awCoei67qo3ifLU02jhe/rA8ZwzbUD0hxMlXYFLfqmEoANrhhW9VHCgZ9KUXSNRlvrydFXATxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=OD2OYFr0; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="OD2OYFr0"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id AvXnwdhRqjw8YAxa6wSu14; Thu, 09 Apr 2026 22:10:34 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Axa5wHHKBxUZ2Axa6wDqOD; Thu, 09 Apr 2026 22:10:34 +0000
X-Authority-Analysis: v=2.4 cv=HJHDFptv c=1 sm=1 tr=0 ts=69d823da
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=chC0KcwHAXg1M6QkddG+Hg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=QSUYj3f-MeYbdhfgnocA:9 a=QEXdDO2ut3YA:10 a=2aFnImwKRvkU0tJ3nQRT:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wpf1yAGrWWdCI706JaYjI24hP31WYUmdkcxek4LzYwI=; b=OD2OYFr0F2IVAr8xatAm2K4sjj
	WFHM4NVQEne4vc54doaNgD1aSgnW0LbwTnaQp4BBXuxotMVvGIASDxK4y6APSOcNLrEpfyIw+VJKa
	jC0U7+4q52sGkjLIbL1rwR70ByeRCik1Q9o68lcp/dqfQ+5y4/yzlHyGrTFjN11gJlfZYTJSam2cY
	LVC7FSh1jd+9E2R+8M5F+use96KrCp2pRi8xxSCpicwBdZPVZjFggpLzQjMljyKu+qMM1rNL8puPX
	xVJF9yPyx8RbS8WezciZP8QzFz4gQ60ziuEbmVm8yzph9aPWfIlniluha1p/cI+DbCGHzTouDCFue
	MwANqgbQ==;
Received: from [177.238.18.219] (port=33830 helo=[192.168.0.104])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.99.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1wAxa4-00000003KKH-30tW;
	Thu, 09 Apr 2026 17:10:32 -0500
Message-ID: <96b116e4-d91d-456a-9a08-fb3de4822a62@embeddedor.com>
Date: Thu, 9 Apr 2026 16:09:21 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kees Cook <kees@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <adgL5wPm9VpaV3MO@kspp>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <adgL5wPm9VpaV3MO@kspp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.18.219
X-Source-L: No
X-Exim-ID: 1wAxa4-00000003KKH-30tW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.104]) [177.238.18.219]:33830
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGL09omnuMwgKdoDrGlciPwhYaL1H5LHDdPF3mze3l7QSMCqg+whOSFl9x56a72NagP13RfE/B8VWghrpI95OW7bXnK+ahpc3OIqQOHkQzsGvFNcOxnt
 n4o7U4ch5UHqEgtGu9ul0Ww9Gn2Q2/d758V8VHE0oeguQIvKz+zetjS2by4Or16d4YscOVL8PNahaHujID7AyBdKzjCtLQoDrJjMj9s+4McO6Gow/mt1nWK0

BTW folks,

We can use the TRAILING_OVERLAP() helper and address these warnings with
the following patch instead:

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b39017c80548..9dd5957d9ed4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -819,13 +819,15 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);

  /* non-compat version may have padding after verdict */
  struct compat_xt_standard_target {
-       struct compat_xt_entry_target t;
-       compat_uint_t verdict;
+       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
+               compat_uint_t verdict;
+       );
  };

  struct compat_xt_error_target {
-       struct compat_xt_entry_target t;
-       char errorname[XT_FUNCTION_MAXNAMELEN];
+       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
+               char errorname[XT_FUNCTION_MAXNAMELEN];
+       );
  };


This helper creates a union between a flexible-array member (FAM)
and a set of members that would otherwise follow it. This overlays
the trailing members onto the FAM while preserving the original
memory layout. It was created to address exactly these sorts of
issues where flexible-array members end up embedded in the middle
of structs.

You tell me what you prefer.

Thanks
-Gustavo

On 4/9/26 14:28, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> struct compat_xt_standard_target and struct compat_xt_error_target are
> only used in xt_compat_check_entry_offsets(). Remove these structs and
> instead define the same memory layout on the stack via flexible struct
> compat_xt_entry_target and DEFINE_RAW_FLEX(). Adjust the rest of the
> code accordingly.
> 
> With these changes, fix the following warnings:
> 
> 1 net/netfilter/x_tables.c:816:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 1 net/netfilter/x_tables.c:811:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>   - Update verdict after (compat_uint_t *)st->data;
> 
> v1:
>   - Link: https://lore.kernel.org/linux-hardening/adbIKC0cZcK7VcCF@kspp/
> 
>   net/netfilter/x_tables.c | 31 ++++++++++++++-----------------
>   1 file changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index b39017c80548..746012196d83 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -817,17 +817,6 @@ int xt_compat_match_to_user(const struct xt_entry_match *m,
>   }
>   EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
>   
> -/* non-compat version may have padding after verdict */
> -struct compat_xt_standard_target {
> -	struct compat_xt_entry_target t;
> -	compat_uint_t verdict;
> -};
> -
> -struct compat_xt_error_target {
> -	struct compat_xt_entry_target t;
> -	char errorname[XT_FUNCTION_MAXNAMELEN];
> -};
> -
>   int xt_compat_check_entry_offsets(const void *base, const char *elems,
>   				  unsigned int target_offset,
>   				  unsigned int next_offset)
> @@ -850,18 +839,26 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
>   		return -EINVAL;
>   
>   	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0) {
> -		const struct compat_xt_standard_target *st = (const void *)t;
> +		DEFINE_RAW_FLEX(const struct compat_xt_entry_target, st, data,
> +				sizeof(compat_uint_t));
> +		compat_uint_t *verdict;
>   
> -		if (COMPAT_XT_ALIGN(target_offset + sizeof(*st)) != next_offset)
> +		st = (const void *)t;
> +		verdict = (compat_uint_t *)st->data;
> +
> +		if (COMPAT_XT_ALIGN(target_offset + __struct_size(st)) !=
> +				next_offset)
>   			return -EINVAL;
>   
> -		if (!verdict_ok(st->verdict))
> +		if (!verdict_ok(*verdict))
>   			return -EINVAL;
>   	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0) {
> -		const struct compat_xt_error_target *et = (const void *)t;
> +		DEFINE_RAW_FLEX(const struct compat_xt_entry_target, et, data,
> +				XT_FUNCTION_MAXNAMELEN);
> +		et = (const void *)t;
>   
> -		if (!error_tg_ok(t->u.target_size, sizeof(*et),
> -				 et->errorname, sizeof(et->errorname)))
> +		if (!error_tg_ok(t->u.target_size, __struct_size(et),
> +				 et->data, __member_size(et->data)))
>   			return -EINVAL;
>   	}
>   

