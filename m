Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6042C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD33F20781
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388778AbgFXKpW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:45:22 -0400
Received: from correo.us.es ([193.147.175.20]:38424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388421AbgFXKpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 06:45:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8A5DE4B82
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:45:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 989F8DA78B
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:45:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E240DA78A; Wed, 24 Jun 2020 12:45:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62D46DA73F;
        Wed, 24 Jun 2020 12:45:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 12:45:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 453BB42EF42A;
        Wed, 24 Jun 2020 12:45:18 +0200 (CEST)
Date:   Wed, 24 Jun 2020 12:45:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel =?iso-8859-1?Q?Gr=F6ber?= <dxld@darkboxed.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnf_ct resend PATCH 1/8] Handle negative snprintf return
 values properly
Message-ID: <20200624104517.GA2981@salvia>
References: <20200623123403.31676-1-dxld@darkboxed.org>
 <20200623123403.31676-2-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623123403.31676-2-dxld@darkboxed.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 23, 2020 at 02:33:56PM +0200, Daniel Gröber wrote:
> Currently the BUFFER_SIZE macro doesn't take negative 'ret' values into
> account. A negative return should just be passed through to the caller,
> snprintf will already have set 'errno' properly.
> 
> Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
> ---
>  include/internal/internal.h | 2 ++
>  src/conntrack/api.c         | 6 +++---
>  src/conntrack/snprintf.c    | 3 +++
>  src/expect/snprintf.c       | 3 +++
>  4 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/internal/internal.h b/include/internal/internal.h
> index bb44e12..859724b 100644
> --- a/include/internal/internal.h
> +++ b/include/internal/internal.h
> @@ -41,6 +41,8 @@
>  #endif
>  
>  #define BUFFER_SIZE(ret, size, len, offset)		\
> +	if(ret < 0)					\

        if (ret < 0)
          ^
missing space

> +		return -1;				\
>  	size += ret;					\
>  	if (ret > len)					\
>  		ret = len;				\
> diff --git a/src/conntrack/api.c b/src/conntrack/api.c
> index ffa5216..78d7d61 100644
> --- a/src/conntrack/api.c
> +++ b/src/conntrack/api.c
> @@ -1099,9 +1099,9 @@ int nfct_catch(struct nfct_handle *h)
>   * print the message just after you receive the destroy event. If you want
>   * more accurate timestamping, use NFCT_OF_TIMESTAMP.
>   *
> - * This function returns the size of the information that _would_ have been 
> - * written to the buffer, even if there was no room for it. Thus, the
> - * behaviour is similar to snprintf.
> + * On error, -1 is returned and errno is set appropiately. Otherwise the
> + * size of what _would_ be written is returned, even if the size of the
> + * buffer is insufficient. This behaviour is similar to snprintf.
>   */
>  int nfct_snprintf(char *buf,
>  		  unsigned int size,
> diff --git a/src/conntrack/snprintf.c b/src/conntrack/snprintf.c
> index 17ad885..a87c0c9 100644
> --- a/src/conntrack/snprintf.c
> +++ b/src/conntrack/snprintf.c
> @@ -85,6 +85,9 @@ int __snprintf_conntrack(char *buf,
>  		return -1;
>  	}
>  
> +        if(size < 0)
   ^^^^^^^^
I can see spaces here as indentations.

> +                return size;
> +
>  	/* NULL terminated string */
>  	buf[size+1 > len ? len-1 : size] = '\0';
>  
> diff --git a/src/expect/snprintf.c b/src/expect/snprintf.c
> index 3a104b5..b28ac62 100644
> --- a/src/expect/snprintf.c
> +++ b/src/expect/snprintf.c
> @@ -30,6 +30,9 @@ int __snprintf_expect(char *buf,
>  		return -1;
>  	}
>  
> +	if(size < 0)
> +		return size;
> +
>  	/* NULL terminated string */
>  	buf[size+1 > len ? len-1 : size] = '\0';
>  
> -- 
> 2.20.1
> 
