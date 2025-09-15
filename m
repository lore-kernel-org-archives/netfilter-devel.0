Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2F1D432D
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2025 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971098; cv=none; b=oSnR29i7Da4q2x/DbCr+zxocirW6JTzSlYmBNUZ+zC2JELYzVjJ3EYrqxEMb+7DYfvdKma+Kypp1bJvBVwlrDrZyeNyVsiJMYhtIXEp8Pirig0PmvGg31qRG8sJsUpccVcx5mpyRibyhx2xYMHh+kc32ZD6tCgeJrUZfabl4mI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971098; c=relaxed/simple;
	bh=ylzC/nd0YGM5zag350urSi7yGIl6tdCgno4D2nrQMEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NH9oKKBdIjZPGMNlgbzlFkdisB5MOudN5Pbwol5Nb1oukaHBOcFY0RDBdBDlQmjoyLN+7eb0R86P1vIlD2DiYLnlTzf1L+yxxBsqyUnRylZ56+JcDoUEHrJECRr+0kyVXXSplq9K7FC0hIRXNSSl3+OAz0ZAJJ7Am/88J5snvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d3mnfHVs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KOgf3mPS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d3mnfHVs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KOgf3mPS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2D60960255; Mon, 15 Sep 2025 23:18:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757971090;
	bh=xS1CctS1OYxTZ3GPbYjDh+TlgKu538BvIBrs3Pk+iRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3mnfHVsmo8XsxJ97FREbxWNgw1wG+ku+vFNem6nX2FEXaeHGvtBY9ApPpIPux37o
	 ofREs8urkM8/7Utj3Yk6tpRRNdx9ibW61tKdRq5ymoBa/f+iVR7wvgbmgYukL340DU
	 gTdc+dnZxPqf1x/HtsLQ3dQ8tLc/bfI6VqVZhQlA937G8s/6+es5JrAjhfFR2El9nQ
	 h98Zy6ofQ0tcNjGMtNF+2p6E4j6yDogbYWgd3EvgZzQIrXiPxYz/8252bmQwHDYDB0
	 80lkM+jEf76+H0eiNA14bEVkD8/LZw1fIHaxoVCdNRaa6132oViB7AFo+4cNMYlY/f
	 78G2X2VwaHS1g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 50AB8600B5;
	Mon, 15 Sep 2025 23:18:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757971089;
	bh=xS1CctS1OYxTZ3GPbYjDh+TlgKu538BvIBrs3Pk+iRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KOgf3mPS1W2RMcnqIrMuNyOVcHxbj+t32J0Pz4Qz/vP56i+VJXvWCYxNaiLVF8jJF
	 6wTjDHq7k1p0nXL+mxVeRYyn/pL+b0tsrOjHKGW09RTGdpQmMRB1HtGSbFZll2C5n5
	 9ABgQWAX9srqqyuV+Oy6zirM2ur+LtT62PITEyG1dLuLzYJVKgIgbUh55/9t8B43lW
	 bC6mJtLeswinVEcEu4affIZAHSWBqYVESrmYpzQ/JD9V8bAREAfm0ra1AV5tULbny2
	 7UTTYTXhViWUgUTEj8MpHjzB8ihKdSyvBb4WOof6eXVwc4w+Kp0uNpptieC9UBEZPg
	 tEZMIW55GwfQg==
Date: Mon, 15 Sep 2025 23:18:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Sudha.Ranganathan@bmwtechworks.in,
	Divyanshu Rathore <Divyanshu.Rathore@bmwtechworks.in>
Subject: Re: [PATCH libmnl] examples: genl: fix wrong attribute size
Message-ID: <aMiCjv-IDEQdCv_P@calendula>
References: <MA0P287MB33783620765E4FC9131E161DF915A@MA0P287MB3378.INDP287.PROD.OUTLOOK.COM>
 <20250915124049.331477-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250915124049.331477-1-fw@strlen.de>

On Mon, Sep 15, 2025 at 02:40:30PM +0200, Florian Westphal wrote:
> This example no longer works on more recent kernels:
> 
> genl-family-get
> error: Invalid argument
> 
> dmesg says:
> netlink: 'genl-family-get': attribute type 1 has an invalid length.
> 
> Fix this and also zero out the reserved field in the genl header,
> while not validated yet for dumps this could change.
> 
> Reported-by: Divyanshu Rathore <Divyanshu.Rathore@bmwtechworks.in>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  I will push this out later today.
> 
>  examples/genl/genl-family-get.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
> index ba8de122094c..0c2006755e30 100644
> --- a/examples/genl/genl-family-get.c
> +++ b/examples/genl/genl-family-get.c
> @@ -199,8 +199,9 @@ int main(int argc, char *argv[])
>  	genl = mnl_nlmsg_put_extra_header(nlh, sizeof(struct genlmsghdr));
>  	genl->cmd = CTRL_CMD_GETFAMILY;
>  	genl->version = 1;
> +	genl->reserved = 0;
>  
> -	mnl_attr_put_u32(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
> +	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
>  	if (argc >= 2)
>  		mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
>  	else
> -- 
> 2.51.0
> 
> 
