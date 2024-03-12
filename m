Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048C478286
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253585; cv=none; b=XpdR1PHnmyUdWKR1nUNMi8K1qqjV8+6jxKjf8MSpGUjm83CbW9YfgK8isY0MOZSvIQnDKBMBas9DCcU5q0WTxxTyeXgVu4NjxsmJTrzj0IGOc+wEBKjkzYk30MMlFC1emWyEHGK3aEEDt7lKffokO+P1G135rnKBdCQjgzMwgQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253585; c=relaxed/simple;
	bh=tNMouqGF52QBhfqgBi+nzFmA4/kRUYnC6v6s8m0P4ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XO6RDWWjXk01gdstaUSF5zZfwayDNVcQwSVA4IdCamibKCPA2WDCRvm86H9jncGa47ueKk6zWHtVDRd8c3NVeZQpRYqXvmoY+1ffx+aYxrcvW0jqkE+tmd61QdF3GhU6z9P8Jq9oKTaOFL5waL+O2I+Xi8/8+1dETVjWuGCIlPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ia8R4dhE; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ia8R4dhE"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso2891891a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710253583; x=1710858383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=peTTWWnPk8i4zrY5hy8AFjv6RKN10tqmZKCxgLJ6n8o=;
        b=ia8R4dhE9ZTAHq/jpI8TiBL+ElHAZ8A+7mOCZ3x+IYKTrWxJa8tSokc8177ZTvfHh9
         5WDGWkTBPsE/XTbVhEXn6MQo5HvPsGCvDAFgmnL2L+cb03w97SCtEjTUs/ubqWlBjp19
         pBI/YkT0mPVpv/KzfZTRGir5HkE1C3tAi6y6sJhwAxFPxNLYAleLJ2NrW7axX1NSa6eO
         bA+/RJfMQR/S5iiMsHCQpGQ8KyNYQMQf+5Rfk/h+tHQ8F6FxeQpJM9xm6f5ob2YZqF/1
         xXMPI9i4j4HFwdoHOCkRymlV8Ee4JVoGzHk6VTmsoEmGdpLtRLPJiSJzqU71ih2UJAOM
         M1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710253583; x=1710858383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=peTTWWnPk8i4zrY5hy8AFjv6RKN10tqmZKCxgLJ6n8o=;
        b=gjOtBqjCRZUIN63OuTfwFOne2HzsMSAs1hw3ebx8rRwjAf161F122xdU7ZG8FS0GhJ
         uVTShWI/jnS8z5i5Fjylzq/cayEm4ops0L+E4FMpjc2xafFAlFi5wjxkTIzuDIsckIpG
         EvTZ2hwswKDRVjoTCuSxr5CYigbzgxDBflMk/HTwx4bCudS5hhl6RvfDYnMfS/RT46IS
         /PXvS0GkUxXTW23eY9oAnhrS2ZEY9jUudRTUuSu6Gl7RGURjX6oa6enmxMMZ8XIGzDYc
         6Pu7Ml12GSOxJY58YCD48gIg59HhNop/zeTO5AUQHTlAL5u/rQnexpXLm2FeO+gxawJd
         6m9g==
X-Gm-Message-State: AOJu0YwEyGI+9AcrEv3dZB8nwUWz0Vg5qq/1UX4viJui7Du6CF5Joy6E
	p11kH+MHrHcOTT1rIRGtA9/Rks0tFR6cdH0yeVyMdDR5vFHVdIe/
X-Google-Smtp-Source: AGHT+IGag56m/4SahqmS2FW480MBQA2PSoYuSCZJxM+DTTf9g4gvmXOaksd751qmDMAHNQc4e6wMUg==
X-Received: by 2002:a05:6a20:431c:b0:1a3:13bb:f9b4 with SMTP id h28-20020a056a20431c00b001a313bbf9b4mr6216489pzk.23.1710253583193;
        Tue, 12 Mar 2024 07:26:23 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id z17-20020aa79911000000b006e6150a5392sm6204499pff.155.2024.03.12.07.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 07:26:22 -0700 (PDT)
Date: Tue, 12 Mar 2024 22:26:17 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	tianquan23@gmail.com
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfBmCbGamurxXE5U@ubuntu-1-2>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312130134.GC2899@breakpoint.cc>

On Tue, Mar 12, 2024 at 02:01:34PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > AFAICS this means that if the table as udata attached, and userspace
> > > makes an update request without a UDATA netlink attribute, we will
> > > delete the existing udata.
> > > 
> > > Is that right?
> > > 
> > > My question is, should we instead leave the existing udata as-is and not
> > > support removal, only replace?
> > 
> > I would leave it in place too if no _USERDATA is specified.
> > 

Sure, I will change it in the proposed way.

> > One more question is if the memcmp() with old and new udata makes
> > sense considering two consecutive requests for _USERDATA update in one
> > batch.
> 
> Great point, any second udata change request in the same batch must fail.
> 
> We learned this the hard way with flag updates :(

Is it the same as two consectutive requests for chain name update and
chain stats update? 

In nf_tables_commit():
The 1st trans swaps old udata with 1st new udata;
The 2nd trans swaps 1st new udata with 2nd new udata.

In nft_commit_release():
The 1st trans frees old udata;
The 2nd trans frees 1st new udata.

So multiple udata requests in a batch could work?

Thanks,
Quan
