Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259625570
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707311352; cv=none; b=h4oeNzsWoEgFJRPafh3SSUgXbfKH1MLaFELJBWdUGC2w8JpLg8ohoh1h/k9a3DBxn3mKJYGICdVMKNviedwE2Twtre/wVdmkNtgemtHtrJaE1T9oQ/FbHSF4TTnJB4YbCp7/6uNLht2U9zZg4BRz9OKiQQvQ+z+hBg1pUSd75NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707311352; c=relaxed/simple;
	bh=UoAsE2ea9qPvP/mpSHGCyOFMrgo082SU+jXAtwASVVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oS0LUGhDBxA/ONG2lZ6GM2VW6RVUkCfXjQuCDtPDrQ4zVYCcLoRKTtE2I1Smz/lig7WPnefAmUVthUTyI45NEYl+O6NByNFgOjyn2fViypdmBzaRfejGfjmJQ99y427wcW4NH39+VioL6NHgjP8Xgv/M07eVtpBCHWPG1ErZlyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Txv23V4N; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Txv23V4N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R6Qfgoc6qlc+eTvkHbFpQPWxFsegvCSqVMHfNpFQDg4=; b=Txv23V4NnzxGIbGqfn41KbremD
	JvrKJTrpAxDNVLiPa3+8zT+D6WkAb9kmz96xgUzM70F3dLpCxHKQnbcbs7wjrV5//G9wYP0UTHyKI
	W/BCwc881zXAWlXoOh1TvJmE//nGBUm52zOpHDFJ/LRlc+SvBqTQcnpTpvZrewczZCIHIxpeUc8e+
	wnPla7xdtUj5hz7ajYunZuXNCCDqrDZiOsPEbDhnNePVH1VLo2oWTT8qQ7ShRILahEK/1KgcKKepH
	ChSFHa4XyMjSJ1P+GzElE0U5wUGBGzQ2OwihzbB812awekTTWuydWfN7AHexCp/feaMxNlOEnTUVX
	tV9M8UBQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXhfm-000000004Cg-1GFM;
	Wed, 07 Feb 2024 14:09:06 +0100
Date: Wed, 7 Feb 2024 14:09:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: =?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] evaluate: fix check for unknown in cmd_op_to_name
Message-ID: <ZcOA8ndZCDf2DoWz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	=?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>,
	netfilter-devel@vger.kernel.org
References: <tencent_4CE98729F09EB6B547CF9AE06FF119AF7D05@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_4CE98729F09EB6B547CF9AE06FF119AF7D05@qq.com>

On Wed, Feb 07, 2024 at 12:27:57PM +0000, 谢致邦 (XIE Zhibang) wrote:
> Example:
> nft --debug=all destroy table ip missingtable
> 
> Before:
> Evaluate unknown
> 
> After:
> Evaluate destroy
> 
> Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
> Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
> ---
> V1 -> V2: Update subject and message
> 
>  src/evaluate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 68cfd7765381..57da4044e8c0 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -6048,7 +6048,7 @@ static const char * const cmd_op_name[] = {
>  
>  static const char *cmd_op_to_name(enum cmd_ops op)
>  {
> -	if (op > CMD_DESCRIBE)
> +	if (op > CMD_DESTROY)
>  		return "unknown";
>  
>  	return cmd_op_name[op];

Maybe eliminate this source of error once and for all by making it:

| if (op >= array_size(cmd_op_name)

We may still return a NULL pointer if there are uninitialized array
elements, but it's used for format strings only so should not harm.

Cheers, Phil
