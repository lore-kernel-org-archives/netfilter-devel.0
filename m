Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504BC383
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718380766; cv=none; b=E5bwE7kpLLCOKagrC7xWUigZbIEsup37GXk1Ys66HOrreorRbZXXRXa/6/jJIkrGdDItL/sUaJdv+XdNKNpdk8gLDRCchv8cGRhAYqmzeAHponydrQqvp9WeVJqIu2r05dnz8Rk9DgndNxYoIn28+/oaytN1sRam0AO6whF5Pfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718380766; c=relaxed/simple;
	bh=cwE7veRiV3/BY4G11qgBgVM1KhhEbQorIehhtRH3shc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mll7fX7hxGELKPxo4hefPHALvZqdUbpTvlxLx+7Kmw7lEQTZ0O78HSW4+C6x1zbJpg8vdDH6Ia+JAS6e02kInV5Shrk1n0cwPIylo1GP96dZclVCQVMM9JWwHAKmCnkhb9O138YfavRd5M4KCvD72SLKz1bS+PdhSHqh1ztpQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/7iewtl; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/7iewtl"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-632597a42b8so8899207b3.3
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 08:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718380764; x=1718985564; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cwE7veRiV3/BY4G11qgBgVM1KhhEbQorIehhtRH3shc=;
        b=M/7iewtliFmTu7DEBsWd3TuXpsh8Ix5USvfrIXGPyyrOQImZgP0AYzgdTqk/NRcXv7
         olrm9S/qO6gZ5eRmqe5tEnINU8hSg1wKf+0g4QmChGvyIvUhjls8Vb/F4Ed2s5e3bm/Z
         AOQiTcW67IHjYW81lv+lIWoOZ8YOiHI2fLeRN/X0M7BHYm5Ilx6JbZdZIMqKSljpw1Zy
         WINHGhAeS3jOCN2gjKtUYDkZb1ok5NvwgiSu2t2A/ICYF4ROmrW8symCcJ/NRVLItbly
         nWfA0v5X9pivNU8B2yeU/eu2VYGMXWDPmvLepZXnZ1eyrqM+OGaYNX9gqIFzVRE7DfNj
         EHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718380764; x=1718985564;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cwE7veRiV3/BY4G11qgBgVM1KhhEbQorIehhtRH3shc=;
        b=hUhWfFWpllnmKud/5pdk1+A135SPhjAjHXe2xQbE6oGm9nRXVAoMs2B15cDDraOH1s
         6IplbFUn+NUlkpFUuL5VpQEV5T1cBpjbN4iNOccorEzC157E0B+4a/9X20wcS7Ub5KpM
         u2x+3fA9bNGxbNIFZukPLBIny2F3fSji1bWZgj8+KZ0uqJJv/Pq7ZAwKMWzt1VldyaeE
         tW52IVH52eIHD6fFHqbjhc6tkjTrQ8wIUiHb5edixLZzrLPZVJLEWv+ustvmAsxxrm2N
         ZKjV18yroFc8iGtDafocruByq1AlBElTa6HxagWC+QqtSlCRnBFSQFLn6Nqb1Cjz5vAU
         GaeA==
X-Forwarded-Encrypted: i=1; AJvYcCVLWjhmwAVrrZml24mr//c67EPzuZFzRdFfyuT8yv0Tgzj7rA2Qos4XBVoyKl0odUB5XO+vBYaqW3b+kW+3JhIzObEr7I09RYEW72pZoOH5
X-Gm-Message-State: AOJu0YyTZDHJUnOSGxUetKVsfRbi27YGUra/El5RkS+qbtQvXHyjg80Z
	UxDiLJs+zogLkSfq6w5yl7XxNIoQBLBgJUhYWdHdgaHiNgY4vr6Bkl0tX9nMsOn/l1Zca9t5tSi
	8LnghlZHbZQn6Me6Im7XnAXnqHUNploDD
X-Google-Smtp-Source: AGHT+IFEzAfufmKhjTBF0aIVVqwhButSEemu3yZ355cVufQ5koM5hYWXYAFwGh+uipUuL9OVn+NDSkU7mJT6+lm7bCI=
X-Received: by 2002:a0d:de83:0:b0:627:d92a:bdc0 with SMTP id
 00721157ae682-632247105d4mr30258617b3.36.1718380764094; Fri, 14 Jun 2024
 08:59:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240614151641.28885-1-phil@nwl.cc> <20240614151641.28885-3-phil@nwl.cc>
 <ZmxgsGWJ3IUizwVb@calendula>
In-Reply-To: <ZmxgsGWJ3IUizwVb@calendula>
From: Fabio Pedretti <pedretti.fabio@gmail.com>
Date: Fri, 14 Jun 2024 17:58:48 +0200
Message-ID: <CA+fnjVCQZOe5Qo2q4LZu-Q_3o6ZTtjqawHfXqSj2j=qmXe8UEQ@mail.gmail.com>
Subject: Re: [nf-next PATCH v2 2/2] netfilter: xt_recent: Lift restrictions on
 max hitcount value
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Il giorno ven 14 giu 2024 alle ore 17:24 Pablo Neira Ayuso
<pablo@netfilter.org> ha scritto:
>
> On Fri, Jun 14, 2024 at 05:16:41PM +0200, Phil Sutter wrote:
> > Support tracking of up to 65535 packets per table entry instead of just
> > 255 to better facilitate longer term tracking or higher throughput
> > scenarios.
>
> Could you develop a bit more the use case to expand this? Do you have
> an example rule for me?
>
> > Requested-by: Fabio <pedretti.fabio@gmail.com>
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
>
> Hm, original bug report only refer to documentation update?

I indeed opened the bug report mostly for the documentation, but also
wrote there:
"or, even better, make it possible to use a bigger value, since it is
useful to detect longer duration abuses"

I was trying to use the recent module to log IPs which generates lots
of new connections from the internal network, to detect misbehaving
clients (examples: misconfigured clients, torrent clients).
Given the recent limit of 255 I tried hashlimit, however I found the
recent module seems simpler and better to set up, perfect for the job,
also it has --set , --rcheck, --update and --reap options, to set
different trigger values to detect and keep IPs in the table.

Thanks.
