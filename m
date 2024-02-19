Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5782EDD
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Feb 2024 02:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708309667; cv=none; b=HhCL36iexygiL1JmbacJFXF2CrusXykdv9HjC9UgkRqLl22Rc9KpIC26n+aC1ChTj0mnN90boJlsLGN1nh51Zsr2ItrlGQLz14CFDP30I+b8nVVsx/WCUNUcAlhbJ3tEOzGn8xT0XokPUgq0nTF+TomPxle09y3n9PhRsZyMvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708309667; c=relaxed/simple;
	bh=sszWCIhssK/qwQ5jt+q0Yk+wyMTyptn14Py38l7c5q8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfE/SziSVMH7p+rO19EQVccrsy2ZdGdIfd8mWof3bXn+EmTX3dvAKmJS0ZqFkWS9JSn0CzO3M5Sr/g7AlimuntKbEtnUwWsQMqxLtUwoiKiDaOQuD9S3ehg8jUK+F64p0yOBoS9hl3Fn7YACrh8IHmb3kJqiixCshJPyUGVUB0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKEKJkby; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKEKJkby"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-21edca2a89dso209210fac.3
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Feb 2024 18:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708309665; x=1708914465; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZT6xxyuaPH59gmaEdmIIR7WT9N2YtYEhsSlGpMDbC0=;
        b=OKEKJkbyHha3EhgXrs7NQio67g2dp7+IpdjXa8Dw7NRsRGcUAV4dPVts/9dH+MHTuc
         ep7Wjzhln7/2jApvRkBu9wf0OFNoNQDA8CDVuEXb6RJ483DnbFMF13x5tdUavxdz+/tU
         AX4C8TSkbRegnOYDcVhUkzUmXRjKmmc9qLs2woLjiuvtjGA4VTI1FLHkeLXf2grsiUDE
         zHJChqGLi4uka9nQvZltSQuB2EwOn5z7ZtMdcfyZIeC6U0nxkQaCewkiEalZpiJCmXOo
         mtkZol9cWmYlfO0o77yaKhoNx7XLfS+TVYzHDX5Q59RUT5GEurTc+KTi8IbWcW9CKbXU
         LCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708309665; x=1708914465;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZT6xxyuaPH59gmaEdmIIR7WT9N2YtYEhsSlGpMDbC0=;
        b=q/JR6Z5iKkPgZRJ5DtWrW5a9NaQi48TtT8B9VLxHtihkWkL1KDkH7PKoSKwbikdvC/
         BJMrZbpAFu+hZoKppJe9ovM/Om1NSbtXVdtxiVE2evB0yY+Xm6njTRdjgPF7sq+S/qPg
         cCFryxaby8Da57LlOt0uJGJb2Q3Wzk7k7UMDfVFAbGIjFucINgsjcItkEqtWqY8y20Ae
         zFZCRaYR8T405VXL/mv5TRpmz9m9OAUymniTj170RTzB98ka+4ry0scgEdfJw4exru3f
         Q+D65cLEpuRd3PZSChznMccTX/wZTn8nxeJl1wI8S2dF3MXszS2MhL23UiyAY6ahPjmR
         w8tA==
X-Gm-Message-State: AOJu0YxWZ3pzaNsTxxwxyjjaEAJMFXrP41VMjn11q29j1O+aZzsx/N/q
	SWUl/Oij4UsVOLXbeURM0eqGqFQyoyStuGMC0UalqZRcb2ciFf7ByHwOqHwU
X-Google-Smtp-Source: AGHT+IETFSWoN/d5XvYryjc0lSbRJFACuyoPvwsiSceegmseycah9Ttx1PGo7gPjsOtw+xTZnMRKYw==
X-Received: by 2002:a05:6871:a913:b0:219:28af:f8a6 with SMTP id wn19-20020a056871a91300b0021928aff8a6mr10749710oab.56.1708309664917;
        Sun, 18 Feb 2024 18:27:44 -0800 (PST)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id s12-20020a63f04c000000b005d67862799asm3529701pgj.44.2024.02.18.18.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Feb 2024 18:27:44 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 19 Feb 2024 13:27:41 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] Convert libnetfilter_queue to use
 entirely libmnl functions
Message-ID: <ZdK8nU6p28JmzcAr@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
 <20240213210706.4867-2-duncan_roe@optusnet.com.au>
 <ZcyaQvJ1SvnYgakf@calendula>
 <Zc69T21ekMhEbjZ1@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc69T21ekMhEbjZ1@slk15.local.net>

Hi Pablo,

On Fri, Feb 16, 2024 at 12:41:35PM +1100, Duncan Roe wrote:
[...]
> Userspace applications *will* break if they either
>
> 1. Call libnfnetlink nfnl_* functions directly (other than nfnl_rcvbufsiz())
>
>   OR
>
> 2. Call nfq_open_nfnl()
>
> Is that acceptable?
>
If it's not acceptable then there's no point in my spending any more time on it.

So I won't post again until you reply.

Cheers ... Duncan.
