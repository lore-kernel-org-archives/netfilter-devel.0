Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B53C31E5D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 744DC206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K11KZ0sl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfFRSpd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:45:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40219 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbfFRSpd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:45:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so16671007qtn.7;
        Tue, 18 Jun 2019 11:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RQUmAvZKOB0n5aRHDDnkpnJkp/zZ0CD2VBmJlNueqlA=;
        b=K11KZ0sl2ortG7zfX/UDTOyQVahCgbla4GQOd3wX7M3bncotVkdJ38UDjuEPtNIP9x
         W4ZXRVSSnqhT4pPcbKj579ttHFK7eGKyNnjSI0o8bg2iQL10HK+pKIKiGJhQCsNaoN9f
         K8eSTf+prQ1ZWQ05ynDCFpc7bcYRFHGxBtVsxyjmrbNlZ2Zp4+GO8LEqSEkMoVUX3JDg
         Uan6IvuG9MkBfjLXodUDmGyZ5CfpiTL8/DopfHiIXWn7kAPTnb7tIdstJn7p/XysrYWe
         RG6BK5UmE0PUw9/p+ag4ipzQbAWov2yKvjDEyVVLqZ7qtJmeEbPDqmzHfLIlYf7Bzcbf
         ye2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RQUmAvZKOB0n5aRHDDnkpnJkp/zZ0CD2VBmJlNueqlA=;
        b=di3MPdB8JWhWl2ogta8Qkk2CAe6mni2zuGfUQqOyBbdYK76iTgkPjNvCdLcETpye8Q
         1jFxT6TR5musgDxHygzH5vzIBKLNE1R2p2GRmGrO8ZsvidwEqAdiAx4y9TQR/7zBRcpD
         pCSJtRaek6lVmwwPCAsrYMGKdGzBpjprYDWDl9OTDTstnSe8xr76UK/mFgO0RtSKWGD6
         8Q0kOz2FvUsb1zLqz2a363syQmfFpirVDJDxdYP1CztYiRSBz8oikS4KY3ruJjh7jlDL
         i/0C+ZSU+ZjmBDuoyBpi8X3eaEt5ja+zPotBx4HC3CS7DJIavvjZzEBNR1QJPyk00fK6
         jXzQ==
X-Gm-Message-State: APjAAAXQ9TbrzavO4nv40FTjbQCQ3ipTfvTdSBgGGIhUzLjY/XIbn64B
        JDU2lEOf/XXivHgs/pB6yQ==
X-Google-Smtp-Source: APXvYqwU2beKSiLDe3Z3LszvHjvWf5pMFzrl0342RAP4g96QEwvkhFuYXh9+dGykb3pt5R68KTrxUQ==
X-Received: by 2002:ac8:768b:: with SMTP id g11mr66633971qtr.182.1560883532134;
        Tue, 18 Jun 2019 11:45:32 -0700 (PDT)
Received: from ubuntu ([104.238.32.106])
        by smtp.gmail.com with ESMTPSA id h40sm11107455qth.4.2019.06.18.11.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 11:45:31 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:13:55 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190618141355.GA5642@ubuntu>
References: <20190611120912.3825-1-ssuryaextr@gmail.com>
 <20190618153112.jwomdzit6mdawssi@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618153112.jwomdzit6mdawssi@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 05:31:12PM +0200, Pablo Neira Ayuso wrote:
> > +{
> > +	unsigned char optbuf[sizeof(struct ip_options) + 41];
> 
> In other parts of the kernel this is + 40:
> 
> net/ipv4/cipso_ipv4.c:  unsigned char optbuf[sizeof(struct ip_options) + 40];
> 
> here it is + 41.
>
> ...
>
> > +	/* Copy the options since __ip_options_compile() modifies
> > +	 * the options. Get one byte beyond the option for target < 0
> 
> How does this "one byte beyond the option" trick works?

I used ipv6_find_hdr() as a reference. There if target is set to less
than 0, then the offset points to the byte beyond the extension header.
In this function, it points to the byte beyond the option. I wanted to
be as close as a working code as possible. Also, why +41 instead of +40.

> > +		if (opt->end) {
> > +			*offset = opt->end + start;
> > +			target = IPOPT_END;
> 
> May I ask, what's the purpose of IPOPT_END? :-)

My understanding is that in ipv6_find_hdr() if the nexthdr is
NEXTHDR_NONE, then that's the one being returned. The same here: target
is the return value.

> Apart from the above, this looks good to me.

AOK for other comments. I can spin another version.

Thank you,

Stephen.
