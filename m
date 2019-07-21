Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED09C76196
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 11:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C4F2147A
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 11:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ru1zRw1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfGULPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 07:15:49 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48840 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbfGULPt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 07:15:49 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 76E9D1A2E5F;
        Sun, 21 Jul 2019 04:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563707748; bh=jo9u5m+Q29xRNixyDJrtUyqC1cAAPP8b75cWX1JEfSw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ru1zRw1b8DK/gS3BqtnodvGZSdUDGSrigRlOEBTmJ1YhlSl24YdjTb/XT7v4kob9O
         y2KB8RP5K1Om1EnDXec/32FC8pEIxC9i9UCgnFwFdiJBOyJndRTAZKB14SXdAzvbPZ
         04NQJ8iYWHe8xA8uogoDqOmSDnJQRzOO5kZnX4HM=
X-Riseup-User-ID: 056B406499C5B3A70A31BD2FCCE03BC0C50C7DA0DD1E916B168B586C60928C78
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id BDA2E2226EE;
        Sun, 21 Jul 2019 04:15:46 -0700 (PDT)
Subject: Re: [nft PATCH 2/2] nfnl_osf: Silence string truncation gcc warnings
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190720185226.8876-1-phil@nwl.cc>
 <20190720185226.8876-2-phil@nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <bb559c36-00f3-b295-ed61-6d1ae7d52b58@riseup.net>
Date:   Sun, 21 Jul 2019 13:15:58 +0200
MIME-Version: 1.0
In-Reply-To: <20190720185226.8876-2-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

I am porting your changes to my patch and I have few comments, please
see below.

On 7/20/19 8:52 PM, Phil Sutter wrote:
> Albeit a bit too enthusiastic, gcc is right in that these strings may be
> truncated since the destination buffer is smaller than the source one.
> Get rid of the warnings (and the potential problem) by specifying a
> string "precision" of one character less than the destination. This
> ensures a terminating nul-character may be written as well.
> 
> Fixes: af00174af3ef4 ("src: osf: import nfnl_osf.c to load osf fingerprints")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/nfnl_osf.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
> index be3fd8100b665..bed9ba64b65c6 100644
> --- a/src/nfnl_osf.c
> +++ b/src/nfnl_osf.c
> @@ -289,32 +289,34 @@ static int osf_load_line(char *buffer, int len, int del,
>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>  	if (pend) {
>  		*pend = '\0';
> -		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
> +		i = sizeof(obuf);
> +		cnt = snprintf(obuf, i, "%.*s,", i - 2, pbeg);
>  		pbeg = pend + 1;
>  	}
>  
>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>  	if (pend) {
>  		*pend = '\0';
> +		i = sizeof(f.genre);
>  		if (pbeg[0] == '@' || pbeg[0] == '*')
> -			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg + 1);
> -		else
> -			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
> +			pbeg++;
> +		cnt = snprintf(f.genre, i, "%.*s", i - 1, pbeg + 1);
>  		pbeg = pend + 1;
>  	}

I am not including this because the pbeg pointer is being modified if
the condition is true which is not what we want. Note that pbeg is being
used below. Also, we cannot do pbeg++ and at the same time shift the
pointer passed to snprintf with pbeg + 1.

I propose to let the if statement as it is and modify only the snprintf().

What do you think? Am I missing something here? Thanks Phil!

>  
>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>  	if (pend) {
>  		*pend = '\0';
> -		cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
> +		i = sizeof(f.version);
> +		cnt = snprintf(f.version, i, "%.*s", i - 1, pbeg);
>  		pbeg = pend + 1;
>  	}
>  
>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>  	if (pend) {
>  		*pend = '\0';
> -		cnt =
> -		    snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
> +		i = sizeof(f.subtype);
> +		cnt = snprintf(f.subtype, i, "%.*s", i - 1, pbeg);
>  		pbeg = pend + 1;
>  	}
>  
> 
