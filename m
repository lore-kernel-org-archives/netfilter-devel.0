Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D0627713
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776122364; cv=none; b=RyfFo1qOnS6E7NPAOQMJzYv8d1njGQ8GCZvRWpjxPS2iDMrbtFZKNwC68XNu77/yn8DLYgZyoqhF3vVWJVKWoq2LNSDR4iGRn4FmRR2Rlt60Cwv9DPuUGOTIqEYs1yVLzwLrGnTR0YHgKIjdBJo+iz1ut601UHmdRD/USHY4yuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776122364; c=relaxed/simple;
	bh=rIggTXd3xPvh0+qtxk4q9eAS4L6p9O3C/rvir+/t7Mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taZyG0EaaHqrWkGCMKU2lCPmgcj20R69FyGiKN0PKk7NaUm07hF+JfljeDtxUyNSFgU3n0k6bb6GPorfaM/QMM2dD4GMrBsHPK6BRbEhPPse4rRIiAm8ncOxRgfIaMSztQ3st9jwH6jolObKNXx/bDdj30bGiTtGcH9faFiNBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TJRkmfVW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TJRkmfVW"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A61E160177;
	Tue, 14 Apr 2026 01:19:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776122359;
	bh=i0x70cD3FGHUMmY+CwHEnSJm4Pgpv1dz163BxeFmcU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJRkmfVWW8HLeXQ0LhfZj5Kn2jXt2EVP+vl7c2zCjuwbdznGKqxp5sQNnY9txVH6r
	 Y8UWM0Sx/wmiRGNsiUa2ie7xD7jldTplvRgrHPz0KmjlfZHIYsqXYljUg1gixMJ8IR
	 s94n2TZbLOQzToTZhnaNJ1jW8nuuWIA2+QwleHnWg31owh+EznSGLpMxzM4kbclHBs
	 IrrxvdEtg8Pg/+x307ShPf0dSG+V3ERvYFxApxX5qHXCCNFc2IiKpRhkGUceG9h+S4
	 sTdD9dfLuZCZ1zjpQ4Ly/HM0hYDDxBMTiimy/1zXGCs6qLvNHfQ/5Kq47L5HQ8Q//e
	 YpF51cxxCV3AQ==
Date: Tue, 14 Apr 2026 01:19:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Cyber-JA <giuseppecaruso0990@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] netfilter fix u16 overflow in get_port()
Message-ID: <ad159SsCudLkYKLW@chamomile>
References: <20260410135733.46391-1-giuseppecaruso0990@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260410135733.46391-1-giuseppecaruso0990@gmail.com>

Patch subject should be:

  [PATCH nf-next] netfilter: nf_conntrack_ftp: fix u16 overflow in get_port()

On Fri, Apr 10, 2026 at 09:57:33AM -0400, Cyber-JA wrote:
> From: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
> 
> try_number() parses comma-separated decimal values from FTP PORT and
> EPRT commands into a u_int32_t array, but does not validate that each
> value fits in a single octet. RFC 959 specifies that PORT parameters
> are decimal integers in the range 0-255, representing the four octets
> of an IP address followed by two octets encoding the port number.
>
> Values exceeding 255 are silently accepted. In try_rfc959(), the raw
> u32 values are combined via shift-and-OR to form the IP and port:
> 
>   cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
>                      (array[2] << 8) | array[3]);
>   cmd->u.tcp.port = htons((array[4] << 8) | array[5]);
> 
> When array elements exceed 255, bits from one field bleed into adjacent
> fields after shifting, producing IP addresses and port numbers that
> differ from what the text representation suggests. For example,
> "PORT 10,0,1,2,256,22" yields port (256<<8)|22 = 65558, truncated to
> u16 = 22. This mismatch between the textual and computed values can
> confuse network monitoring tools that parse FTP commands independently.

Fair enough. But stricter parser is better, of course.

> Reject the command by returning 0 (no match) when any accumulated
> value exceeds 255.

This can probably be expanded to say that "returning 0 (no match)
results in no expectation is being created".

Nothing is really "rejected" (that happens by returning -1), no
packets are dropped, just to clarify.

> Signed-off-by: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
> ---
>  net/netfilter/nf_conntrack_ftp.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> index 5e00f9123c38..680dd7560ebc 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -195,7 +195,7 @@ static int try_rfc1123(const char *data, size_t dlen,
>  static int get_port(const char *data, int start, size_t dlen, char delim,
>  		    __be16 *port)
>  {
> -	u_int16_t tmp_port = 0;
> +	u_int32_t tmp_port = 0;
>  	int i;
>  
>  	for (i = start; i < dlen; i++) {
> @@ -207,8 +207,14 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
>  			pr_debug("get_port: return %d\n", tmp_port);
>  			return i + 1;
>  		}
> -		else if (data[i] >= '0' && data[i] <= '9')
> +		else if (data[i] >= '0' && data[i] <= '9'){
>  			tmp_port = tmp_port*10 + data[i] - '0';
> +			if (tmp_port > 65535) {
> +				pr_debug("get_port: port %u out of range.\n",
> +					 tmp_port);
> +				break;
> +			}
> +		}
>  		else { /* Some other crap */
>  			pr_debug("get_port: invalid char.\n");
>  			break;
> -- 
> 2.53.0
> 
> 
