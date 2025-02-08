Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1F244E81
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 21:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739049648; cv=none; b=Ledxg8PQAa16EZP7YF06v1Dvr8bKT+w7vSqu6ZeljOadHobj7citePmGbMTeJB/GX7X+ujt5CGtbtDqm9JAApr4xSTgRkQiLQv7pCMj81fdPvNq2EwZGtbWFyEb2rIXsDmynpi1b6pEKYoDxdlUIjNxSaaYCD1C/6qLB/QRtUMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739049648; c=relaxed/simple;
	bh=ZBrVfy612EKZIAQGiqsa39y1fpBmA5N+ElU/W93iddg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvjL4+xMp72aqja2CqeWMghRS/3JhZcOw9EU70QXWQPxNsiWXsByhqxBiKr7j6TXzfHfBG+2CoOQcKBB0hR8zu1VahhEwO7CTQh4pa2bZblLVGwa9kyztaYN5qax7+r+FtFoL135/gqEpegi6feWEpaBIzkDeuUB8h98kMqpts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FCteF7kW; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FCteF7kW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FCteF7kW";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FCteF7kW"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 968B960305; Sat,  8 Feb 2025 22:20:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739049635;
	bh=fjRGmCXuJGw0igg0kvrOdriDZoIl9qgzjOIOjkItdMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCteF7kW67ghdyPuXpnk55lYUUgy6gTvEzKpbpgSyoNPTcjhBm/SoVa9ouEe02BhS
	 Sui2Y2aAk454VfCd9gza/POa4CLRNK5rM4AW8LSzWjsQrT9q0P1KM32BgfX2g9eUUr
	 EuqzBFKIr1lQMXapjG7CayLzd4EkX3q3Sfg4VcWGcZtz0Z4eVAN3ZICwlFN/Dy5kG/
	 mMAS5ap1kCF8wu59M1qRaXZDkZmZXuYw8M1sY44n2xrq6mOaMPRzTHxqCyQJyHIIYY
	 xRif8pcu+W32VG8GcxfqEi/CHNSlrvdzYaNrDlnBkbOEnOEaGdgcQjgmVaEF9kF5dp
	 H9yqD6Gh77ShA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8A39602F7;
	Sat,  8 Feb 2025 22:20:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739049635;
	bh=fjRGmCXuJGw0igg0kvrOdriDZoIl9qgzjOIOjkItdMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCteF7kW67ghdyPuXpnk55lYUUgy6gTvEzKpbpgSyoNPTcjhBm/SoVa9ouEe02BhS
	 Sui2Y2aAk454VfCd9gza/POa4CLRNK5rM4AW8LSzWjsQrT9q0P1KM32BgfX2g9eUUr
	 EuqzBFKIr1lQMXapjG7CayLzd4EkX3q3Sfg4VcWGcZtz0Z4eVAN3ZICwlFN/Dy5kG/
	 mMAS5ap1kCF8wu59M1qRaXZDkZmZXuYw8M1sY44n2xrq6mOaMPRzTHxqCyQJyHIIYY
	 xRif8pcu+W32VG8GcxfqEi/CHNSlrvdzYaNrDlnBkbOEnOEaGdgcQjgmVaEF9kF5dp
	 H9yqD6Gh77ShA==
Date: Sat, 8 Feb 2025 22:20:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: corubba <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
Message-ID: <Z6fKoE-JOtvbKHvY@calendula>
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
 <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>

On Sat, Feb 08, 2025 at 02:49:49PM +0100, corubba wrote:
> Gone missing in f04bf679.

ulogd2$ git show f04bf679
fatal: ambiguous argument 'f04bf679': unknown revision or path not in the working tree.

???

> Signed-off-by: Corubba Smith <corubba@gmx.de>
> ---
>  output/ulogd_output_GPRINT.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
> index 37829fa..d95ca9d 100644
> --- a/output/ulogd_output_GPRINT.c
> +++ b/output/ulogd_output_GPRINT.c
> @@ -179,9 +179,15 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
>  			if (!inet_ntop(family, addr, buf + size, rem))
>  				break;
>  			ret = strlen(buf + size);
> +			rem -= ret;
> +			size += ret;
> 
> +			ret = snprintf(buf+size, rem, ",");
> +			if (ret < 0)
> +				break;
>  			rem -= ret;
>  			size += ret;
> +
>  			break;
>  		}
>  		default:
> --
> 2.48.1
> 
> 
