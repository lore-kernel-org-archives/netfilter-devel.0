Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B059717BA5
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 02:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732761253; cv=none; b=ErKdFDYaThUxysKT62xCWhOEXc9KiyLHM3KhbbuDPmHWj5sU1oiVTcwCYlhEQZIS4WVq4mYLw9jfzsKXj//4XQ88zhKVZQWuMDka9GfMlxQGubQVhY/7iVZiIqs7BhbAb0Nb1lSAADCGFLymki1XOrxjyTOmSTQDXsG1Lb3NzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732761253; c=relaxed/simple;
	bh=cTNnxe2a3aGLxcCjl+wOyfEr74P3Oqja4+p0TTs3AfY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPS/4/318zjQKNF1eOK9lRf9106dqlAJxBintSL8oO4VYc0UcR5WB/drhdAABXG0MNy2sQ6M9UStWWhejKA6E+wG116kbX4tfGnjGTMlI3v158m/MFFbGEUkljXx0BOGMOk4rN2T209+z5F2ewGBViZmthDxpkvUqcv7+l/DpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTuOlHjw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTuOlHjw"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21278f3d547so2409565ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2024 18:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732761251; x=1733366051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YrBRYQ/hgtHQtqH0fxZBIQof3jZHhrBSLd70/Na+GGE=;
        b=OTuOlHjwhvuSQAhc+BAmVP+yERei/Ug1HHfZBdYiofMsZ99mXIEobMziRsX7H2QkMC
         bE1KNgm8gth5UqbreGhPAJJT9FI251rlZq2luxwRyt/C9aTJwYSOvHrQ0ZdwlooKYpQq
         csH3DnM8fer828/OhSkOHwwLMCjmH7TcVlwDm6KRy0Hn+j8AL9MhPWdXuIEIVbiGXbl/
         ibwfBxtSStEXONjk96WIKJfERdlh7mEmUXnTgP4mzuAN3PNTsjqTaSa9vfAVuyAR16/n
         S36XHUZg/cRqIGyMS/5qS6phGMoXQ8kz89C2P1fjuGDTGJ79HQ6Hg1R3S65N6OtPge/8
         K1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732761251; x=1733366051;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YrBRYQ/hgtHQtqH0fxZBIQof3jZHhrBSLd70/Na+GGE=;
        b=N6SxZd5ni7L3uGL2Vpo9uuWAm3biMlg8gv2QXuj5JUoLW+aswftGTRba1e8UJkNOQa
         hFohBlg6CSHDyw1hgLe4bDulLv3z4a/TCQd+1vJ+ZmVBDivHweVGCSCXCwiCbMGhUu7+
         XW9ZDGd9C8ikguEenkOdmw1KlCA+dqxToRtvP+bWOeXQD20IF3YQP1Buq/2Fm4TK8e0Q
         veC8cHJuf/whPq4rtFC32/qo+EowRqAs75oUau5J8Q4CTeIu6Ie25sF8y8E5xV1uOtFG
         xzVyT8iPw5Iv4nQOWzQT3kI7rEBgXI/ByaKEu6Pg9w8wO+DT1e8jraCXs+kB1K7R4rae
         smBA==
X-Gm-Message-State: AOJu0YylJI5y+8SbyqxT1+iW7X/sh6l5Z/8JMkK0hsK4BKOH+J1B1Efe
	aiuykY/+smnX/TVi8eEAZo5BQe2ON+CcVrrMW4Jfu9MK6xO8X679/Yjk1A==
X-Gm-Gg: ASbGncv0OQmDfP9Ak0/1IbPKRuYy7B9am8tqIwwfqyG097GS/kHhUuU5/Ry0PzTs4Kb
	lhZmNjxPuX2EbT60UlJFYcj5mFRCxMexgBeX2UvF59oChBlEFBnPjxlJnMC3cgdR/vf1yxjCXgH
	44pwcEhjEEWPZ06BMCE7eG0uJbQ8ynDNQDiad/IDsDBnUgz95oNS0Soe5yg6k0ynkgYh5vegDH0
	9rMrGY2GrQemYbGUv1H5TH2gLZTyMVEkSpqUedFk0UkWBRlcDthjp6A+5Pb53jwmFBQYnQ0vNsR
	ofcjQ+0KbF/tJnYN5G3HotdTNO8=
X-Google-Smtp-Source: AGHT+IFc0yVvnZx0C3vPPz9uDIjumg3dIN2JAS4iDb3AgLQHCM3xB8y5TSc/dxxnuWvud4Ndvtv20w==
X-Received: by 2002:a17:902:c951:b0:212:48c8:f456 with SMTP id d9443c01a7336-21501b63da4mr68259365ad.36.1732761250834;
        Wed, 27 Nov 2024 18:34:10 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21521906225sm2692165ad.77.2024.11.27.18.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 18:34:09 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 28 Nov 2024 13:34:06 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl v2] whitespace: remove spacing irregularities
Message-ID: <Z0fWnsfypKyFMtzF@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241112004540.9589-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112004540.9589-1-duncan_roe@optusnet.com.au>

Hi,

On Tue, Nov 12, 2024 at 11:45:40AM +1100, Duncan Roe wrote:
> Two distinct actions:
>  1. Remove trailing spaces and tabs.
>  2. Remove spaces that are followed by a tab, inserting extra tabs
>     as required.
> Action 2 is only performed in the indent region of a line.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Only fix spacing in .c files
>  src/callback.c          | 4 ++--
>  src/socket.c            | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/src/callback.c b/src/callback.c
> index f5349c3..703ae80 100644
> --- a/src/callback.c
> +++ b/src/callback.c
> @@ -21,7 +21,7 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
>  	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
>
>  	if (nlh->nlmsg_len < mnl_nlmsg_size(sizeof(struct nlmsgerr))) {
> -		errno = EBADMSG;
> +		errno = EBADMSG;
>  		return MNL_CB_ERROR;
>  	}
>  	/* Netlink subsystems returns the errno value with different signess */
> @@ -73,7 +73,7 @@ static inline int __mnl_cb_run(const void *buf, size_t numbytes,
>  		}
>
>  		/* netlink data message handling */
> -		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
> +		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
>  			if (cb_data){
>  				ret = cb_data(nlh, data);
>  				if (ret <= MNL_CB_STOP)
> diff --git a/src/socket.c b/src/socket.c
> index 85b6bcc..60ba2cd 100644
> --- a/src/socket.c
> +++ b/src/socket.c
> @@ -206,7 +206,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
>
>  	addr_len = sizeof(nl->addr);
>  	ret = getsockname(nl->fd, (struct sockaddr *) &nl->addr, &addr_len);
> -	if (ret < 0)
> +	if (ret < 0)
>  		return ret;
>
>  	if (addr_len != sizeof(nl->addr)) {
> @@ -226,7 +226,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
>   * \param buf buffer containing the netlink message to be sent
>   * \param len number of bytes in the buffer that you want to send
>   *
> - * On error, it returns -1 and errno is appropriately set. Otherwise, it
> + * On error, it returns -1 and errno is appropriately set. Otherwise, it
>   * returns the number of bytes sent.
>   */
>  EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
> @@ -235,7 +235,7 @@ EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
>  	static const struct sockaddr_nl snl = {
>  		.nl_family = AF_NETLINK
>  	};
> -	return sendto(nl->fd, buf, len, 0,
> +	return sendto(nl->fd, buf, len, 0,
>  		      (struct sockaddr *) &snl, sizeof(snl));
>  }
>
> --
> 2.46.2
>
>
Can somebody please apply this? I removed the UAPI header patch as Pablo
requested.

Cheers ... Duncan.
