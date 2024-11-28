Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CB31BD9E3
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 22:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732834226; cv=none; b=AJNdorWDl11Ag0FTKOxoTdtEze+bQt4SThA5rqjeOsjQXHv2XjXowISqguTibAo3rGwUAoH68xyyWI3YEAzEl+5oVGJ+1IL2MvHfkvquLaP+iAs7u7Q1e9tFXzhY7Pxn1gGCxSyAmzeXYRe6jH00ZtCNqwdPhjh+rTgDaDHWPK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732834226; c=relaxed/simple;
	bh=Xm+uDaAT/a/7MpYBx4/1pEo58+JHZtIMvzwMMf0bZco=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0WMVH3P++jmF5MQdryFDh2WPZIUMqfnPxklhSIeKyvqwPNI1fnkQ0i6sk+ye6O3PO0Ku21Xkd1mqSFZGaigUeeYdVDmTC3f6WXQiAZwFcRVvXs7txasdrYjNs6WvU7a9x8XqXuC7nMtr65TBrnkl5SId9mjA8JvHUmcjKI/7x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P1Gk0++w; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1Gk0++w"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7251331e756so1188907b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 14:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732834224; x=1733439024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFaiyAAeoON2VMdF+sVmZfzBBGTm1s2xOkwvgbWVcTY=;
        b=P1Gk0++wqofXTGmDBDXYTukNCH6PNcNT+y0UuanT7GRNhGDRIvo6CnzQGooC0tJe95
         hbuB5RfjqLZpYypD5COxtcIwfwF5RfoNFPTANVyIGhpqzGoN7N/yCAMRIz8eqwMAFQS1
         E0/kc3e7sl9KbRQ3jUdicvdsueuPOG9bWtH++XjXSVXPl8RemHqXi25Lp6OFBDBDsv1z
         4Qta8OsBCQFOYHVJBJlEDkWmo1ZVITajh9MxiarUWOfpe3hfgfDuigCXMl3jw/fuo1Vn
         L06zHnz09xQEIRV4AVwlyGE0zJFPh9boa+TyxN5EowYbVJbnBtY5WzgrXqea8JX1okQ/
         Ux5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732834224; x=1733439024;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFaiyAAeoON2VMdF+sVmZfzBBGTm1s2xOkwvgbWVcTY=;
        b=QhKC2GX70zat6Dk+st5TZIrjxmJHWb4/ekzdV5Iw9oDCtDKHK6GtZIiI1aG70gl4nK
         J9fx8jhElzbAK91mqOOANQPGVoJdWyXSQQSFZQFS7B/iVgMvE0nARVT/IHBZsd/HM0ky
         68VMtRd+SxIbYva8V3RqWo97uNsco2NdS3PcsWPQxRfWJ/2D2dEn1mK54hXUUggMoeCJ
         1RVUcismJpvsr8+M93/Bn3v+7R0kheTGwLlFI/QxwwEE82GiwgIsj67jpWbpo/shcVc7
         /pJf/qDkZsZ1ER95ECJAIdQx31LpDw94txi3rYShdBUnVhw90EowlHsJ+JdyNsF6ld0r
         iYyA==
X-Gm-Message-State: AOJu0YylvZkJThiI9fnMjdnYkifIFwHoyX63z63/E0fv7RFj9KRBbAKn
	7uDQpxKGtOPoLYF6ofHv3UuJKrJCRGwk+eWXGoVQkwJk2foOWXq0MgrNww==
X-Gm-Gg: ASbGnctX5mR6FCiyam5ol0Yr+9kFHeq8q6Y1PL1PyksuGveMMgrUVUgGZkxG6nDDoZr
	QtVY4IvWWct2uiYCpnoK32bRWdwh9oBlEQXZLYYt4SnGIdV4j8YvAYBoaqY3BL8jXIYSH4IQaXi
	a0VcC9Qs0p21lTY186lDp0n+ylvPHasVgq+VNydFgt7rUGun9778lYPw7r9hg1Ir8aU2oF4/pAZ
	gMTwVg4uBggINcV2QzAYRaErVUBjUl8YXKKSKoVC3GKw+CtQPmrFsRBF9sljoakWLWtpCA8CUaL
	GbL98XFCUE2H/wqSlqI2JNmREqM=
X-Google-Smtp-Source: AGHT+IFARoaMJfqbZWRiJV6Br8qJIkbb2h84SbVrmR38BV3BwC20Gdx8E9v/HQOP6NRxAzNfJpwZ8w==
X-Received: by 2002:a05:6a00:179f:b0:724:f1c9:236c with SMTP id d2e1a72fcca58-72530172167mr12016097b3a.23.1732834223772;
        Thu, 28 Nov 2024 14:50:23 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72541848b36sm2188401b3a.187.2024.11.28.14.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 14:50:23 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 29 Nov 2024 09:50:19 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl v2] whitespace: remove spacing irregularities
Message-ID: <Z0jzq9lDuJx35047@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241112004540.9589-1-duncan_roe@optusnet.com.au>
 <Z0fWnsfypKyFMtzF@slk15.local.net>
 <Z0hhlEbfJvqcRgJE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0hhlEbfJvqcRgJE@calendula>

Hi Pablo,

On Thu, Nov 28, 2024 at 01:27:00PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 28, 2024 at 01:34:06PM +1100, Duncan Roe wrote:
> > Hi,
> >
> > On Tue, Nov 12, 2024 at 11:45:40AM +1100, Duncan Roe wrote:
> > > Two distinct actions:
> > >  1. Remove trailing spaces and tabs.
> > >  2. Remove spaces that are followed by a tab, inserting extra tabs
> > >     as required.
> > > Action 2 is only performed in the indent region of a line.
> > >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > > v2: Only fix spacing in .c files
> > >  src/callback.c          | 4 ++--
> > >  src/socket.c            | 6 +++---
> > >  2 files changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/src/callback.c b/src/callback.c
> > > index f5349c3..703ae80 100644
> > > --- a/src/callback.c
> > > +++ b/src/callback.c
> > > @@ -21,7 +21,7 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
> > >  	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
> > >
> > >  	if (nlh->nlmsg_len < mnl_nlmsg_size(sizeof(struct nlmsgerr))) {
> > > -		errno = EBADMSG;
> > > +		errno = EBADMSG;
> > >  		return MNL_CB_ERROR;
> > >  	}
> > >  	/* Netlink subsystems returns the errno value with different signess */
> > > @@ -73,7 +73,7 @@ static inline int __mnl_cb_run(const void *buf, size_t numbytes,
> > >  		}
> > >
> > >  		/* netlink data message handling */
> > > -		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
> > > +		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
> > >  			if (cb_data){
> > >  				ret = cb_data(nlh, data);
> > >  				if (ret <= MNL_CB_STOP)
> > > diff --git a/src/socket.c b/src/socket.c
> > > index 85b6bcc..60ba2cd 100644
> > > --- a/src/socket.c
> > > +++ b/src/socket.c
> > > @@ -206,7 +206,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
> > >
> > >  	addr_len = sizeof(nl->addr);
> > >  	ret = getsockname(nl->fd, (struct sockaddr *) &nl->addr, &addr_len);
> > > -	if (ret < 0)
> > > +	if (ret < 0)
> > >  		return ret;
> > >
> > >  	if (addr_len != sizeof(nl->addr)) {
> > > @@ -226,7 +226,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
> > >   * \param buf buffer containing the netlink message to be sent
> > >   * \param len number of bytes in the buffer that you want to send
> > >   *
> > > - * On error, it returns -1 and errno is appropriately set. Otherwise, it
> > > + * On error, it returns -1 and errno is appropriately set. Otherwise, it
> > >   * returns the number of bytes sent.
> > >   */
> > >  EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
> > > @@ -235,7 +235,7 @@ EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
> > >  	static const struct sockaddr_nl snl = {
> > >  		.nl_family = AF_NETLINK
> > >  	};
> > > -	return sendto(nl->fd, buf, len, 0,
> > > +	return sendto(nl->fd, buf, len, 0,
> > >  		      (struct sockaddr *) &snl, sizeof(snl));
> > >  }
> > >
> > > --
> > > 2.46.2
> > >
> > >
> > Can somebody please apply this? I removed the UAPI header patch as Pablo
> > requested.
> >
> > Cheers ... Duncan.

Did you mean to add something? I see it's still not applied.

Cheers ... Duncan.
