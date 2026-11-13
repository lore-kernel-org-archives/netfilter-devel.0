Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794566787;
	b=NYcqADXHLOsADpqqcLZvkEi7gDaWD3llkZ5/S2ZsolNSkkoZ6pruujrgVwUHazPvfB2V
	 cjsEF2b6kIapaA/33dRm3vDZ01/q3t9Ig8CTCYPejuAlm3qOa9JBAEQKnMy8U3iyI1tK7
	 RxL7ynWtfJi+aLtNuLqDw1PkZ57SgWtDzAW1N02fa5r4+XUIRtBI383li0vQNgV6gCnim
	 B9VyYxQ8HVbkUuggEjqS1+Tl6/enDAYMo1Vcctqz7BvcZYU2ol8xR1utT2jyUHsV5TiTY
	 DS+i6/so6ENCDCfxHKlOFOTBd+vWprhxiuLBUyXKIP16Vtz1JJd3EDG1C4279JzlDWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794566787;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=y1T1+ISjKKMb0PbggoVjZcxhEV3VwCrwpDsHahz9mo8=;
	b=KjSgKqxJXNiVJG4Zk2T73gYWiJ/4v6UiaVQ1jl/S5ZCOcfwlnaIfWs8GqUKHzSTug1vi
	 m+ViDoxwM/ehQQffV5DmWqY06/CqSS8P8huA20zNACXg0k9iOlJRuDL5D0wVb9JUokMI8
	 5MlAAHksXw3CgHFpWOdQTcSBXeC3ECgnQVXw3ESnLp8nlMNmHPa23IlUmiinuH0K1i/ot
	 R+x4THxHZLlpOqh3wQ/nOKa8H5mkUM/oblmHBu77oDZRCSsNUe77D32yV+hf6C2jC2ruw
	 D0M2kR82+MCpnhGym+r+HKdZnYWT0pnv7aD6CRRuiOdKtLUPm8F4w3l12Bhnowef3MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VKQxK0yj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 65B26606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:46:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65B26606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VKQxK0yj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794566785;
	bh=y1T1+ISjKKMb0PbggoVjZcxhEV3VwCrwpDsHahz9mo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VKQxK0yjhLIUhOwxfCZdeLSsthBC6MffL4RIMeiBvoOdqXWRae5J0jSdiSVK9Kznm
	 xbtTrHQGRWTj/HVo4cuY0Vnwf3N/Lv12QobhfDqGbX7btAMTatt5hO6z4hTjdjuOEr
	 1C5+iRcjvBv0N9rDMMBtNgv9atKz52rBRIZ7WA7FBGT826bOjaAXYSRGyi472u6egZ
	 WwCOqyNUdbFvq3qVi0IAKmihL5QOZ9jQ94UBq5Rz+7PUeDPQeq/Ll5aeriAeE1XJZ0
	 c6XUBxnwTVAeEWwR+d6k8M+KUl3Lrj1dMQbGqDbzKR3rSziYwa0KLhwv2qtT3yaGPX
	 dRqw18SyIFs/g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0F1206005D;
	Fri, 13 Nov 2026 11:46:25 +0100 (CET)
Date: Fri, 13 Nov 2026 11:46:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Stosse <florian.stosse@harvester.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl 4/5] nlmsg: do not read past nlmsg_len in
 mnl_nlmsg_fprintf()
Message-ID: <avbqfgxdWkiPX0z2@chamomile>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
 <20261106191841.1645-5-florian.stosse@harvester.fr>
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
In-Reply-To: <20261106191841.1645-5-florian.stosse@harvester.fr>

On Fri, Nov 06, 2026 at 08:18:39PM +0100, Florian Stosse wrote:
> mnl_nlmsg_fprintf_payload() prints the message in 4-byte words while
> i < nlmsg_len. mnl_nlmsg_ok() does not require nlmsg_len to be a
> multiple of 4, so for an unaligned length the last word reads up to 3
> bytes past the end of the message, and past the buffer when it ends
> there.

This function is used for debugging, I think it can be confusing if it
skips them.

It should at least print that it is leaving bytes behind while
printing.

> Only print complete words within nlmsg_len.
> 
> Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
> Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
> ---
>  src/nlmsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/nlmsg.c b/src/nlmsg.c
> index f8eed79..e38f806 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -302,7 +302,7 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
>  	if (fdnum != -1)
>  		colorize = isatty(fdnum);
>  
> -	for (i=sizeof(struct nlmsghdr); i<nlh->nlmsg_len; i+=4) {
> +	for (i=sizeof(struct nlmsghdr); i + 4 <= nlh->nlmsg_len; i+=4) {
>  		char *b = (char *) nlh;
>  		struct nlattr *attr = (struct nlattr *) (b+i);
>  
> -- 
> 2.56.0.windows.4
> 
