Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4A9C8F0
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999257; cv=none; b=FL4o9o064LLuEb78K4e2Eltf/Zkq4y2dSk/oZxA2bYi1QXZqCU6qf0iWdm8T2yoU9QDidauEZzxuxFzwufgODhIfQpqNWo9+wmFgZt9ykUmP/zsBx91Ymv1yvC0MDb1JIKEv9YD70wJde7ze730Sc0YuVhvYO9rGWEwgnT9p3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999257; c=relaxed/simple;
	bh=o0x73UvHGz8MEhyEbKd0m/JWTODClsc97zK2z8XEsIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/bF6j+oEi5iDJloBESiIZKCiahs6205NfbMqfYU7/PSZExBJHWZaGo744gj1gF7chZgoOEzcACdOAUJXXr7O/NWDZb7i9Hw47rKN3oFwGravu46h22aemB0ULaRRjRL91bj46Emwjfk9LAix9wTBQwxFFlmSrA93mjdG/NP2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VBLL8MrR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ONkD/OFd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VBLL8MrR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ONkD/OFd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5129C608D2; Thu,  4 Sep 2025 17:20:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999253;
	bh=fuUVLdJhGvaQSAWGgyhqHCMu9hMWmmhfo+QCLSWoTlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VBLL8MrRRerOflF+/Lvcp64CJuvEEIqnq1Gn3HyqIi130bu2NFTw/tKMKGQ1jn6z8
	 jzTu4+t3ZcX3ZBA3HG8tX7ufF4svsFCyKBgpjq0fH1jD72sN0tuIHuBOja9z7Af/AX
	 pDhqanhrWnEjiBbJMoMkEQJfgyaMyMF2pusvm7+CnVgi7KV0znUGTMGUXM+5pqq0Iz
	 nETknJtiu+e+4BMKzuXJdEJGjxghMpxMzjuZBX/mnuZ8vvz4Pd/64PF7VVHbY09+yH
	 ivqJXJ7vuLa19jSuQwynZpv4IiesH2oH+gp4GUxXj0IfycBqf7io9dBjICe3ETCwT+
	 mKIOmh1RnaxxA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88C96608D0;
	Thu,  4 Sep 2025 17:20:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999252;
	bh=fuUVLdJhGvaQSAWGgyhqHCMu9hMWmmhfo+QCLSWoTlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ONkD/OFd+S3PmhY1P6ikwTxUBr/Gwu24gJ3tgc7vXWDePB7WFPK7c/TjnKejxmt9g
	 KfwGFL23QCrpFXlV/JLyx/T/LV59wuzoHqdOlDYpeLI9VZZ1j9W3OjzX9dEK+ByTt/
	 p/AdO9Ws4a9dcexnSfT9bMW2z/MLdPWn4fToOViFv44kUtzxSr2udxhf6OucrA5uzQ
	 W+gjA3/yyXkGmzjBBqepIBLcnHMKjgmAbAqXDDoSxdU8wJlaSA7xiQOBWgcD3ns7dJ
	 PwUZ74ufdIx5uM+dEv9KyIDEVHjsBvCZdICE7WaB4zrW0erFauUXIUxvEQEgoipEGJ
	 gKmyIwf2vLmVg==
Date: Thu, 4 Sep 2025 17:20:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v5 2/3] parser_bison: Accept ASTERISK_STRING in
 flowtable_expr_member
Message-ID: <aLmuUveL_X-grotG@calendula>
References: <20250731222945.27611-1-phil@nwl.cc>
 <20250731222945.27611-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250731222945.27611-3-phil@nwl.cc>

Hi Phil,

On Fri, Aug 01, 2025 at 12:29:44AM +0200, Phil Sutter wrote:
> All clauses are identical, so instead of adding a third one for
> ASTERISK_STRING, use a single one for 'string' (which combines all three
> variants).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v3:
> - Cover interface wildcards in nft.8
> ---
>  doc/nft.txt        | 30 ++++++++++++++++++++++++++----
>  src/parser_bison.y | 11 +----------
>  2 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 8712981943d78..42cdd38a27b67 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -387,13 +387,19 @@ add table inet mytable
>  CHAINS
>  ------
>  [verse]
> -{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
> +____
> +{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' ['DEVICE'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*] *}*]
>  {*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
>  *list chains* ['family']
>  *delete chain* ['family'] 'table' *handle* 'handle'
>  *destroy chain* ['family'] 'table' *handle* 'handle'
>  *rename chain* ['family'] 'table' 'chain' 'newname'
>  
> +'DEVICE' := {*device* 'DEVICE_NAME' | *devices = {* 'DEVICE_LIST' *}*}
> +'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
> +'DEVICE_NAME' := 'string' | 'string'***
> +____
> +
>  Chains are containers for rules. They exist in two kinds, base chains and
>  regular chains. A base chain is an entry point for packets from the networking
>  stack, a regular chain may be used as jump target and is used for better rule
> @@ -436,7 +442,7 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
>  
>  * The netdev family supports merely two combinations, namely *filter* type with
>    *ingress* hook and *filter* type with *egress* hook. Base chains in this
> -  family also require the *device* parameter to be present since they exist per
> +  family also require the 'DEVICE' parameter to be present since they exist per
>    interface only.
>  * The arp family supports only the *input* and *output* hooks, both in chains of type
>    *filter*.
> @@ -449,7 +455,13 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
>  The *device* parameter accepts a network interface name as a string, and is
>  required when adding a base chain that filters traffic on the ingress or
>  egress hooks. Any ingress or egress chains will only filter traffic from the
> -interface specified in the *device* parameter.
> +interface specified in the *device* parameter. The same base chain may be used
> +for multiple devices by using the *devices* parameter instead.
> +
> +With newer kernels there is also basic support for wildcards in 'DEVICE_NAME'
> +by specifying an asterisk suffix. The chain will apply to all interfaces
> +matching the given prefix. Use the *list hooks* command to see the current
> +status.

Maybe explain here too that newer kernels also allow to pre-register a
match on unexisting devices (specify version), while old kernel fail
with ENOENT?

>  The *priority* parameter accepts a signed integer value or a standard priority
>  name which specifies the order in which chains with the same *hook* value are
> @@ -763,11 +775,16 @@ per element comment field
>  FLOWTABLES
>  -----------
>  [verse]
> -{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
> +____
> +{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'DEVICE_LIST' *} ; }*
>  *list flowtables* ['family'] ['table']
>  {*delete* | *destroy* | *list*} *flowtable* ['family'] 'table' 'flowtable'
>  *delete* *flowtable* ['family'] 'table' *handle* 'handle'
>  
> +'DEVICE_LIST' := 'DEVICE_NAME' [*,* 'DEVICE_LIST']
> +'DEVICE_NAME' := 'string' | 'string'***
> +____
> +
>  Flowtables allow you to accelerate packet forwarding in software. Flowtables
>  entries are represented through a tuple that is composed of the input interface,
>  source and destination address, source and destination port; and layer 3/4
> @@ -786,6 +803,11 @@ The *priority* can be a signed integer or *filter* which stands for 0. Addition
>  and subtraction can be used to set relative priority, e.g. filter + 5 equals to
>  5.
>  
> +With newer kernels there is basic support for wildcards in 'DEVICE_LIST' by
> +specifying an asterisk suffix. The flowtable will apply to all interfaces
> +matching the given prefix. Use the *list hooks* command to see the current
> +status.

                                                        ... to see the
hooks that are that registered per device that match on the wildcard
device.
