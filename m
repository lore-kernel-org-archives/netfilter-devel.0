Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CE4F20C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796828; cv=none; b=ebbEeFajVbtRYcAOIQFHjwlodBieFaQ6QpsGF+IU2prrydNWSdzXfIyDzFWXoxPfNf/bINJDhAcP4J9UPd50J98PYr1YsWNw8OAgR7FvzIPZB08VmKVut+RMBFBvJtDnsfnHHwypkAQv8Ao1ukscB7zu4C/hKqJsZ6ovsazqZLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796828; c=relaxed/simple;
	bh=iDedjNuT1t03cX+qFif4FzImN63+HoTSLPNc+6/zLRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YG+IBDIrAJUVp+eTw4flKEX7wxTP0C0b3gg7BZ1CzE5Dzzk4Bwa8Et72GrA3C2W1aLYUueisU4qwFwepgZJNGKhCpEqZQXl+DEikDrrDnWMl5hJHREtlNvuhjQS8gMKnOB80KBA9S8lPdFz9w2rUoiSn460BfuK/yfy69HIkiN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=33264 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tGdbp-00FtY7-BT; Thu, 28 Nov 2024 13:27:03 +0100
Date: Thu, 28 Nov 2024 13:27:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl v2] whitespace: remove spacing irregularities
Message-ID: <Z0hhlEbfJvqcRgJE@calendula>
References: <20241112004540.9589-1-duncan_roe@optusnet.com.au>
 <Z0fWnsfypKyFMtzF@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z0fWnsfypKyFMtzF@slk15.local.net>
X-Spam-Score: -1.8 (-)

On Thu, Nov 28, 2024 at 01:34:06PM +1100, Duncan Roe wrote:
> Hi,
> 
> On Tue, Nov 12, 2024 at 11:45:40AM +1100, Duncan Roe wrote:
> > Two distinct actions:
> >  1. Remove trailing spaces and tabs.
> >  2. Remove spaces that are followed by a tab, inserting extra tabs
> >     as required.
> > Action 2 is only performed in the indent region of a line.
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: Only fix spacing in .c files
> >  src/callback.c          | 4 ++--
> >  src/socket.c            | 6 +++---
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/src/callback.c b/src/callback.c
> > index f5349c3..703ae80 100644
> > --- a/src/callback.c
> > +++ b/src/callback.c
> > @@ -21,7 +21,7 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
> >  	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
> >
> >  	if (nlh->nlmsg_len < mnl_nlmsg_size(sizeof(struct nlmsgerr))) {
> > -		errno = EBADMSG;
> > +		errno = EBADMSG;
> >  		return MNL_CB_ERROR;
> >  	}
> >  	/* Netlink subsystems returns the errno value with different signess */
> > @@ -73,7 +73,7 @@ static inline int __mnl_cb_run(const void *buf, size_t numbytes,
> >  		}
> >
> >  		/* netlink data message handling */
> > -		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
> > +		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
> >  			if (cb_data){
> >  				ret = cb_data(nlh, data);
> >  				if (ret <= MNL_CB_STOP)
> > diff --git a/src/socket.c b/src/socket.c
> > index 85b6bcc..60ba2cd 100644
> > --- a/src/socket.c
> > +++ b/src/socket.c
> > @@ -206,7 +206,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
> >
> >  	addr_len = sizeof(nl->addr);
> >  	ret = getsockname(nl->fd, (struct sockaddr *) &nl->addr, &addr_len);
> > -	if (ret < 0)
> > +	if (ret < 0)
> >  		return ret;
> >
> >  	if (addr_len != sizeof(nl->addr)) {
> > @@ -226,7 +226,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
> >   * \param buf buffer containing the netlink message to be sent
> >   * \param len number of bytes in the buffer that you want to send
> >   *
> > - * On error, it returns -1 and errno is appropriately set. Otherwise, it
> > + * On error, it returns -1 and errno is appropriately set. Otherwise, it
> >   * returns the number of bytes sent.
> >   */
> >  EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
> > @@ -235,7 +235,7 @@ EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
> >  	static const struct sockaddr_nl snl = {
> >  		.nl_family = AF_NETLINK
> >  	};
> > -	return sendto(nl->fd, buf, len, 0,
> > +	return sendto(nl->fd, buf, len, 0,
> >  		      (struct sockaddr *) &snl, sizeof(snl));
> >  }
> >
> > --
> > 2.46.2
> >
> >
> Can somebody please apply this? I removed the UAPI header patch as Pablo
> requested.
> 
> Cheers ... Duncan.
