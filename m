Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2852613E8B5;
	Tue,  4 Jun 2024 20:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717532573; cv=none; b=Ouua3ibFzJUkHBw1bioOZWkaY2fHBU5qG+OcVkeNH4cbMWu3uUhUvisbFu0XsX9mlLrnKlRPFL7TLfd0dDIitUlOi3qH4jljyxB92Qs/VgqBVaIkPJNP1L+GKAgvwccUzc142ANjJU2XWvmakCB6hkvoW6ZD9vwOENLqObPAkQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717532573; c=relaxed/simple;
	bh=rprCz2kfM6uU6vFs55xzq8qeh7i7r4w/Ir9xd0LalVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4lOwjC0QGieY8C4BOceGTttPWXrcvWUyZoygZkTNpfzVD8FfDEQDDolSk714YgMjrtw9jXuI/r0SIuSblg7PTp1vnvLR9QGUo+DXfgksh9fc3XffLIxqJaAf15XXebRZgar507ZtzyQaGCvEj1XciadWTtNU1RrD5nE/UvctmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLSSoOR1; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLSSoOR1"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2e724bc466fso70650731fa.3;
        Tue, 04 Jun 2024 13:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717532570; x=1718137370; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D+5VN7JC7w36LO4y/6SnJC0QWdaCns+KEWJ/kmwDx20=;
        b=nLSSoOR1z7uv/L91BZIdUwouPyi5jCaCXuL1c6yXSo0XCqHSZB0chR7SLNKGid2Fir
         rED8TVF1IbToaZetltzK7Mx4CepVbnsowqyg+v9JiAjyXogpIeXwdygIhUKynE6uKODd
         mo0qBEfrOv9jjqxbBakFuERSMKEDdjCYTJGdPev+730JB1YM2MkD/zBZIerQSOzFGoeq
         9/MFpWXzSbUHxTc2OwSHhrIq3R3YMN9LqAursAgh/tcJiqDVdu4ZdLyL+gZpwlALRFWT
         9nul1fo7Zz/9RLMUY+2TAbV3C/DnWFbEK+VquEpBkwXHB1Jb2CpLtU5Q+mmJSsMAm4yg
         Ql0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717532570; x=1718137370;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+5VN7JC7w36LO4y/6SnJC0QWdaCns+KEWJ/kmwDx20=;
        b=Zy4b/iBTuYMc1tZpe2siBWwGN5IUD0W8gCXXQOl3vt10FEmi0nMnDCbLU3wAN03cc3
         pc1Pxo+b2FGy1J+7a5B3iWr0uqbjVoJztY7TuW+HA+NwXwOzd/BktqS3od9JhPr2K+uz
         epiPw3UJqEO+ZEMoZ1Wv35n85Kdx9aNEVhw5ZoGTXtzoX6QLYvcgfRlKelP7/W+QO/LO
         Ck52cHUYEEJVtn7vC9u/ERoNBIglvTU9okgI3RWzkkZhC70sD9Tc68YP209x0uwaZ/ip
         fujsH6H3l4dpZ7hedoTYlhX4SZln5ukKm6HIsZCqzQlmL/9eL1QxBWEtfWmLrkQirN16
         Jxbg==
X-Forwarded-Encrypted: i=1; AJvYcCWMGId3J4eqD6Ov89tPByT4jyZpHjTAjDmu4/+2PSUIIf/5uwq6pzABr2IRLfASdrX/W2fFmuiBfC45jujoMEDwRvQNbBI5bmPzNUHpSlknyoNKOZe+IJcdDxGaiv2hsSF6C+8QdnLR7RkNtIfunVXV37+ol+WznOxY5KwLL/t9zjKOzup646dMAb43BdzX
X-Gm-Message-State: AOJu0YyyI6g8qqkuYTC/8jHwWYRymSGJ8qRQy+kLTZrjvPpuY+u899UJ
	SYcxRJ98A+yT1pgxrWGPplDt0+gBfSYBhI2t2dLwy2p+TnDFuXfv
X-Google-Smtp-Source: AGHT+IHbA6nBXzhEGt0w8RUq2Jf6dO0ymzZGh1nbN9gbq0tkCsrC3dyep/a04os+KbH31SMx/r34gg==
X-Received: by 2002:a05:651c:b2a:b0:2e4:a21a:bf7d with SMTP id 38308e7fff4ca-2eac79ed730mr2397901fa.21.1717532570057;
        Tue, 04 Jun 2024 13:22:50 -0700 (PDT)
Received: from localhost ([2a02:168:59f0:1:b0ab:dd5e:5c82:86b0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31be7c04sm8041588a12.58.2024.06.04.13.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 13:22:49 -0700 (PDT)
Date: Tue, 4 Jun 2024 22:22:44 +0200
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 00/12] Socket type control for Landlock
Message-ID: <20240604.c18387da7a0e@gnoack.org>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>

On Fri, May 24, 2024 at 05:30:03PM +0800, Mikhail Ivanov wrote:
> Hello! This is v2 RFC patch dedicated to socket protocols restriction.
> 
> It is based on the landlock's mic-next branch on top of v6.9 kernel
> version.

Hello Mikhail!

I patched in your patchset and tried to use the feature with a small
demo tool, but I ran into what I think is a bug -- do you happen to
know what this might be?

I used 6.10-rc1 as a base and patched your patches on top.

The code is a small tool called "nonet", which does the following:

  - Disable socket creation with a Landlock ruleset with the following
    attributes:
  
    struct landlock_ruleset_attr attr = {
      .handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
    };

  - open("/dev/null", O_WRONLY)

Expected result:

  - open() should work

Observed result:

  - open() fails with EACCES.

I traced this with perf, and found that the open() gets rejected from
Landlock's hook_file_open, whereas hook_socket_create does not get
invoked.  This is surprising to me -- Enabling a policy for socket
creation should not influence the outcome of opening files!

Tracing commands:

  sudo perf probe hook_socket_create '$params'
  sudo perf probe 'hook_file_open%return $retval'
  sudo perf record -e 'probe:*' -g -- ./nonet
  sudo perf report
 
You can find the tool in my landlock-examples repo in the nonet_bug branch:
https://github.com/gnoack/landlock-examples/blob/nonet_bug/nonet.c

Landlock is enabled like this:
https://github.com/gnoack/landlock-examples/blob/nonet_bug/sandbox_socket.c

Do you have a hunch what might be going on?

Thanks,
–Günther

