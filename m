Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973988;
	b=l8a7252Kkr1JHDObNZDU7DGy8pfHNh0G1rVa9laGBJvz4FGSC9NJSYC7U2/KZMpkVk1G
	 NPPbmuu0DDWDTp+KkEefTSHwv38bMSJSmdkFEGllwzglXzUKkOiulKqbQS+oXyFWnok48
	 paWB7DfarB8KeHqIDWkGhM+nQJ4+JYbZkmR64fzz7Hi3hV5OsNxO2In/o6q5T7DY3Xpg0
	 lctpc0bTncnShtC/UnLOJUpN/4vFxj+eZ6TOT2WJpZbrfCglV9VlabU36dS6gkiX2l8xQ
	 3QDIP/8uuPpREJWKbCa8s/IYQ98sLiaZce9OirhJOs/OEzmmm2YuQ5Rt8DVbWkTQSXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973988;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=lXbpjV3E7kFZ0P8jizWwbfXc1K40U9stF3hn0cWf5uE=;
	b=z15QhL/rliYAHzFiBrCKKtGU2J+JiGLnMZ2kpTQt1b/kSm+VlfITilJopW7cr1F/OXQz
	 qcdJSKpP5LtOzNoKwlAp803aA0lQCq36PT5RPI2ZlYMFXfQU29M7o7MlZpglqLZR2WSLW
	 AamkXdEXuqsU2lD9V+gireaal0TS3B0qAb8Bv9EQ7rtI4drBnWWuXF/gkMhc0QD46T7rj
	 p492Y/94bqVuItlhm6vSdhU+qKdS+AibJFlnbBzjfwMDLlxJXg+lY3AfDwWGrGpR+KV98
	 DqYeHNQft5LLc1JFfzMTH4dqWwmMR0qK9FehDyYVvDDbKnnRAd4Ew0VLnzrmAra2+Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZXLnk8Kt;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D81CE606A326;
	Fri,  6 Nov 2026 14:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D81CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZXLnk8Kt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793973985;
	bh=lXbpjV3E7kFZ0P8jizWwbfXc1K40U9stF3hn0cWf5uE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZXLnk8KtVW/woZyGZ/n14wzOwHty57s/9PCeuslLu6aT8tI3Onv6ShmBqgp6V6UPs
	 4lbONKJWMw998wqR1nir6K2EvYrgEqZNfMIp4HShvEnAMburgJueMCf3JsaGQYk2Se
	 Ybn/EcMHXGe/sz0Dty6jIYFbvp0jPpdzUnyyrJGoXvwW6kASExjUOKdKTb2afmaOVM
	 8AA6g/9rsu8BSIVhxmFhWmhEjNXMZRbnmMswsjT1w5nmEFZoRUfcjKZm5vd6HzGyGJ
	 Bnt0+cHcDNgd4gCWEvcJrelhxAA5SoY8H8hwJVdvrZaqfdZPk8WkLeypbEo8cDPBA7
	 4YL8/i+UcuIkg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B10F56005C;
	Fri,  6 Nov 2026 15:06:25 +0100 (CET)
Date: Fri, 6 Nov 2026 15:06:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Vikash SS <thisisforspotifyvikash@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] netfilter: conntrack: document sparse hash table eviction
Message-ID: <au3e3qI5oXk8YI0K@chamomile>
References: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>

On Fri, Nov 06, 2026 at 01:58:16PM +0000, Vikash SS wrote:
> When nf_conntrack_max is significantly smaller than
> nf_conntrack_buckets, the hash table can become sparsely populated.
> 
> The early_drop() path examines at most 8 consecutive hash buckets
> when searching for eviction candidates. Under table exhaustion,
> this bounded search may fail to find an eligible entry even when
> evictable connections exist elsewhere in the table.
> 
> Document this limitation to clarify the implications of configuring
> nf_conntrack_max significantly below nf_conntrack_buckets.
> 
> Signed-off-by: Vikash SS <thisisforspotifyvikash@gmail.com>
> ---
>  Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 4426cce2a..fc07a950b 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -99,6 +99,10 @@ nf_conntrack_max - INTEGER
>          the reversed address). This means that with default settings a maxed-out
>          table will have a average hash chain length of 2, not 1.
>  
> +        Setting nf_conntrack_max much lower than nf_conntrack_buckets
> +        may cause early eviction to fail under table exhaustion, as
> +        the eviction search may not find entries in sparse hash tables.

Maybe provide a positive hint:

+        Make sure nf_conntrack_max is equal to or larger than
+        nf_conntrack_buckets, otherwise early drop may fail to evict
+        entries when it gets full.

>  nf_conntrack_tcp_be_liberal - BOOLEAN
>  	- 0 - disabled (default)
>  	- not 0 - enabled
> -- 
> 2.34.1
> 
