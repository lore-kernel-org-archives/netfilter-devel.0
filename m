Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB2D2E339B
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 01:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742608182; cv=none; b=PR+1JMVHRSd7Tgmt8zHeeRU7PKvnqo5E3m9Pb9MLtVR9AEKV6/uFIXIEWfQ/vGifBlUN+rNhiamNQ/JbePDxtt/UOhXmhBhRkS80J6iUgAT6yNSasCsZLN3d0XcLjE8vSAn7+83A62qGlhlr4Jn47xE++Wj/kCvgBAUJuKfeT5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742608182; c=relaxed/simple;
	bh=GK+DbIyMnTyEYbgRQascC/DNOUkwf5akCPxuW8Q6rBk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrMT3e8+w0jF1XoaiabKHSG+7jZJLU5AQBpIZZRk108vUJuQuZSQFBRCtct3pe2T+JqwUzuK+nJju9PbA/Tv2p2WHngM9I58MfiWgsUrYErEk9AMZVZ4fVy6+ET5U8UXQgjNo+UN8cBLskg65QZ0KojLS0ogKOpqynab87Jba/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icDIKapK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icDIKapK"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22622ddcc35so30504675ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 18:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742608179; x=1743212979; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GK+DbIyMnTyEYbgRQascC/DNOUkwf5akCPxuW8Q6rBk=;
        b=icDIKapKu08wx8OdpfpOMe4mTxjXakmEmZYoHMbIl4WABf1iypQeojbL1sXYjpYri8
         pjSigZLKO9mypT1U2A80hKDi76huGVGFvpQvQmeD3MGI72hriiRlSBMyF2UbW2S59iHr
         o9PRnjQT6kOTb5smEBjerj/g6rPguTyRoXYUmlNftWV7uDUX4/o5PddVZVwNaRnmIQv7
         sWOpfMkoB+N0Ie3F3vcWr8vT3DoAUFJZJHdd/Ds53rkPKUKkklIzONHVItK7/+gJk8J0
         83fnHgmj4Pu3mnJejTUlX5OyOSqZ3Uj0vdrgRXRT31wqCWn1KwEgYlPKmQLBgET2RMpX
         j/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742608179; x=1743212979;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GK+DbIyMnTyEYbgRQascC/DNOUkwf5akCPxuW8Q6rBk=;
        b=ra4IiXlQLAhF2NbI44azBlJKYdC+N9zHalN79hWs0K7KHFNGUaXANumbeDI5oz1TiM
         1LvjdClWqmXjC7+XL8X42x00ABEbfiTjegKgQtTLdVaCDnzVtg+dKTNRCh6WFgyyhMv/
         Ak/mUNNxxDXbqYTY5DQn3LUqRUANt1sht1I4pgZye55pAADXU3K1iY5N+hwj3lCGRxP4
         3pf7lGiEVTh/PvnzHI9ZrgO0Rngbe1QxLN2jha2i0MDCywNIXqHnBI/sGr11kJr33Bcs
         /TuPHdwEzh1OernUim+av7keqVohX/kb1V5puJhEchmdb1lyiXwSHQqbrFRcrfwPchhi
         2v4g==
X-Gm-Message-State: AOJu0YwAlXr1FtstvoSvUDemEHXqKVvCjtvyj4iJf7jBGNptj7rzaWJs
	zFdpgmXs4LRSJWsYKIKdihbUitWJLSWPQFqUbuBrLn/6hJtl66E3sGDGO1PY
X-Gm-Gg: ASbGncvzVX6AMIn9Y4WRwFwbgcjmg5PeYa77OlWsblkTTlPQUP2iQUnrUAZGyr0H3Mm
	0kiZnj5Akx9PLvX7LcyarEe6/XmRS1gAEtWIjf9cAdqUTEL0sJpo1atp0QZI7MrCSY1ZuhYdbbw
	+LauVmXgak+JJhXyjacNNZAqdySLd+hVlE6jfBnw7X7EMdYIjBvHWijvGlzN65hkpnqf/3Pe1fv
	6nwroRUIP/brEo1g25O63+p81m7wIX3admB6ytnRAgrouW+iW8qS2Y0ZUa2tvnrjRQwvCb4seJR
	bT1El7tKEd8MHgiw43UtfT0jcNKrRJcuTJzScVMdNVH+DMYCE84fNjbwoFtjhNJRcVmibTECY3N
	UBQwb/RlW6E0jAHg92r/jxg==
X-Google-Smtp-Source: AGHT+IG/1Y1UmoZl+Jqm/eWysWs1wpcpX/AtyhanOe3AzF1QSU+msV42fN7GohC3fpmcgKHy9d32fg==
X-Received: by 2002:a05:6a00:3d0b:b0:730:8a5b:6e61 with SMTP id d2e1a72fcca58-7390597f133mr6675056b3a.2.1742608179361;
        Fri, 21 Mar 2025 18:49:39 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611cacbsm2905069b3a.102.2025.03.21.18.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 18:49:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 22 Mar 2025 12:49:34 +1100
To: Arturo Borrero Gonzalez <arturo@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	matthias.gerstner@suse.com, phil@nwl.cc, eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z94XLnSQRfMh9THs@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Arturo Borrero Gonzalez <arturo@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, matthias.gerstner@suse.com, phil@nwl.cc,
	eric@garver.life
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8jDjlJcehMB_Z9F@calendula>
 <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>

On Fri, Mar 21, 2025 at 02:29:46PM +0100, Arturo Borrero Gonzalez wrote:
>
> On 3/5/25 22:35, Pablo Neira Ayuso wrote:
> > Hi Jan,
> >
> > I added a few more people to Cc.
> >
> > On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
> > > There is a customer request (bugreport) for wanting to trivially load a ruleset
> > > from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> > > service unit is hereby added to provide that functionality. This is based on
> > > various distributions attempting to do same, cf.
> > >
> > > https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> > > https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/
> > > nftables.initd
> > > https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> > Any chance to Cc these maintainers too? Given this is closer to
> > downstream than upstream, I would like to understand if this could
> > cause any hypothetical interference with distro packagers.
> >
> > Only subtle nitpick I see with this patch is that INSTALL file is not
> > updated to provide information on how to use --with-unitdir=.
> >
>
> I have mixed feelings about having this systemd service file in this repository.
> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
> outdated and neglected after a few years?
>
> For most folks, I assume they will run nftables via firewalld or any other
> ruleset manager, unless they know what they are doing. And if they know what
> they are doing (i.e, they have crafted their own firewalling system), then
> most likely the systemd config in this repo is ignored.
>
>
http://www.slackware.com/ doesn't use systemd
