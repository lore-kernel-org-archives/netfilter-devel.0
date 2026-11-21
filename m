Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304786;
	b=VHUUZ/9GqatINJheq6uOneMBCf8x7OpXg20yKVm3o3k8qtqBFSRdzImWK8o9Zl0NYk1O
	 j4+Ku1QK9sy7wdfxbrlPVenpN3k3CIMn8ttexgq1HjxVjUlSpy5UpPKwlfjoqbksWzVgm
	 YBpQQuAFGX/SBs1qNOLsJFyIyJqSTpURFRFm/ADTqps8xlssYNVchOjSc4XXmcuDyMUdS
	 MhBCXb/eg1L+Pmebio03J9BE3zZXW3AwnkexwQyNwRA+BLfwG5wbyeklfjnOOAJWZNLKU
	 eodEokfJtzdFirE7lUYHGPUMQASQww9cYSTLT5ytPhi6CEi1h2/VGdIjX+jFou+Gv3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304786;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=JUdWpaHz7Q9uSwTwNBSZSN/IpJfQ6G74Ud1rEchCp2M=;
	b=k1NNajeIIaUY6t+9dSrnH/8Hu/a4ChO1IQCL8pJrAQ0LiX/f15mJQfjRN2cWQW0HwSrb
	 RoSrNsSXwZDyd/pQW7NT3gm+DVxIIKwA+FtfTobn24ZPALTRBT2ek/Y6A8p0WT+jSLRWb
	 Wl3lK1BoIbcQSTStuLk1ehzAtN/jAJKWyXxznNLpSkxODlnUwpRmKQEBB3LoZwmeBDJLX
	 7ZFoqioHMscOn9nuAk+zgSwuZ1eTjDWHrX1gIJhvISwKaoAwCyxsbhMBMhtwayjP56Fhv
	 hn/oZ2aaO4nAlZPDjzIM7RlljILQqZjvopxNimf4ABY9MzIUgnrb8dWR+DXMWnf5j4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=etr6yXZi;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4C558606A320
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 23:46:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C558606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=etr6yXZi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795304784;
	bh=JUdWpaHz7Q9uSwTwNBSZSN/IpJfQ6G74Ud1rEchCp2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=etr6yXZiTGBpELKCvlr/VSggK/hk2mzRiwT3EtUC9pqzdWv3bI71VwqWT5O+R4tG1
	 ZDz3eCvDRiyHSrnNv1JQiPRxCS4+BV5Sd4bGErD9my3P8sKsqiMpJQW0kfS2E5lveV
	 WLJQ4V1HkiWvFV/GWfpqAnO9FL2/1bWTe4bAVOnG11NbC67R8hZ6iXKurZ6AGBclHO
	 B38/7laLtcLE+d3IFPf55OtNmQB3ij0ys02QPYiaL5GPnr7wdHy1z6dHwwobDruicV
	 0QLNLT1X8MNqXbOrC6ooarTmIqOHxOLFnEucgF9frNPgIv7JoB3+exiHwoyDbWpXGe
	 /IgJ1fQFvHkMA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 33DF96005B;
	Sun, 22 Nov 2026 00:46:24 +0100 (CET)
Date: Sun, 22 Nov 2026 00:46:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Stosse <florian.stosse@harvester.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl v2 1/2] nlmsg: do not read past nlmsg_len in
 mnl_nlmsg_fprintf()
Message-ID: <awItTN9gNPqGsf_4@chamomile>
References: <20261121143407.19426-1-florian.stosse@harvester.fr>
 <20261121143407.19426-2-florian.stosse@harvester.fr>
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
In-Reply-To: <20261121143407.19426-2-florian.stosse@harvester.fr>

On Sat, Nov 21, 2026 at 03:34:06PM +0100, Florian Stosse wrote:
> mnl_nlmsg_fprintf_payload() prints the message in 4-byte words while
> i < nlmsg_len. mnl_nlmsg_ok() does not require nlmsg_len to be a multiple
> of 4, so for an unaligned length the last word reads up to 3 bytes past
> the end of the message, and past the buffer when it ends there.
> 
> Only print complete words in the loop, then print the 1 to 3 bytes left
> over on a last row labelled "trailing bytes", so that the dump shows
> them:
> 
> | 42 42 42     |	| trailing bytes |
> 
> Assisted-by: LLM
> Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
> ---
> 
> Notes:
>     v2: print the 1 to 3 bytes left over on a last row labelled
>     "trailing bytes" instead of skipping them, as suggested. Aligned messages
>     print exactly as before.
> 
>  src/nlmsg.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/src/nlmsg.c b/src/nlmsg.c
> index f8eed79..0db0fa7 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -302,7 +302,7 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
>  	if (fdnum != -1)
>  		colorize = isatty(fdnum);
>  
> -	for (i=sizeof(struct nlmsghdr); i<nlh->nlmsg_len; i+=4) {
> +	for (i=sizeof(struct nlmsghdr); i + 4 <= nlh->nlmsg_len; i+=4) {

Probably a good chance to add spaces here too:

+	for (i = sizeof(struct nlmsghdr); i + 4 <= nlh->nlmsg_len; i += 4) {
              ^ ^                                                   ^  

>  		char *b = (char *) nlh;
>  		struct nlattr *attr = (struct nlattr *) (b+i);
>  
> @@ -346,6 +346,20 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
>  				isprint(b[i+3]) ? b[i+3] : ' ');
>  		}
>  	}
> +	/* nlmsg_len is not a multiple of 4: print the bytes left over. */
> +	if (i < nlh->nlmsg_len) {

Could you use unlikely here that I introduced in patch:

        [PATCH libmnl] include: add unlikely() notation and use it

ie.

+	if (unlikely(i < nlh->nlmsg_len)) {

So there is no need to add a comment and git annotate will help
whoever looks at this line.

Thanks.

> +		const char *b = (const char *) nlh;
> +		unsigned int j;
> +
> +		fprintf(fd, "|");
> +		for (j = i; j < i + 4; j++) {
> +			if (j < nlh->nlmsg_len)
> +				fprintf(fd, " %.2x", 0xff & b[j]);
> +			else
> +				fprintf(fd, "   ");
> +		}
> +		fprintf(fd, "  |\t| trailing bytes |\n");
> +	}
>  	fprintf(fd, "----------------\t------------------\n");
>  }
>  
> -- 
> 2.56.0.windows.4
> 
