Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBC1D63CA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733932153; cv=none; b=SpRhasa4Luad9lYKMPsBo75BGxO6uOLGzyAJiGAqwT+2Finc66fp+jb1bpHsWwDvHEh1LuEkjqPTcl2jaP1sQzn1oJBrlcJBUhzuKD3Yv5fCYOstwgnGiSctwx4OlJKzHM/coezCOUWP/q2t7qq0IK24pbVtBOTgyMTJM6o4vhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733932153; c=relaxed/simple;
	bh=J38ibBNH3Aw6lYafA9TGz9uhaMK3mS6IigwLX9amwzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzZTiVEzhLZp8sZLY62Qx90RCk6lzWb/e2UkM6t4GU4xXPHy4PTFdZ9dwX1/ydBnDCv1UZKZrWZBwoj1UMykCTKFHTGhq15mLa9u4HIlfMW5hpiOrDU10dXBKBWgaecUFfy+80QaWSMp8o+wWs2NIUrWXB4vPEWtyhiQPCaTAAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c3pTggp2; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c3pTggp2"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3862a921123so4101559f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 07:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733932150; x=1734536950; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DfBv9YP8uyTkbd048cu0wiwdrnwl82wTzZ/vbZn1Plg=;
        b=c3pTggp2Xs/U+kezgNAyKUczbfPw0tUbAoVPukVmqBmTiWgfn4bh1grEGyBQB9DxKt
         fSrI3Tu+OlIpjOCmiREEZBwuL6yLfXAmVJju4J+dBKThpv/RoTwd9gkHEVYnPF5aratv
         KRynGqGnbqD02jhqhMR7DtwmUJOEtQe3V0lwUK3kjY88T9/7R7o6v+4tvgIWa97X69Yx
         d1+/eXGpnhWs8xWjXKNCbgVeI0LNJymIUhmlPVjZ78Jw+q3BZ0X42OfQXZsvSosESbsl
         HrOKSDo+/vrGrm+b3/8K8n63GRB/19vvZze0kqPwTtaJKQLjETYrCHKJ3ShPgl1ZTFJV
         k+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733932150; x=1734536950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfBv9YP8uyTkbd048cu0wiwdrnwl82wTzZ/vbZn1Plg=;
        b=CxxnBbJEm/fovEXgVq2Vkk1ycs1r4Ab/+a1zmhl+4u3quM/TFzPzzAl9RIdViHLd9L
         a0PU7YfQETPoGgwk9ffof5lsy8fzHfRTW8NolEhH/kf0GlVzpvrF6IHg6XX3qvJvqS1u
         vLNFxH1UVYXGbyiRgNFHhE6tU2HnzUara49IceHfNeHMTePAN/tlWgVKqKXDo+CcXXyZ
         sU/eFNii/Fd7Y4ylpBcacBfB3B8uxzs3TMbqgtPOeOC6S7jnQiauhy9A/IpAXeaDMB7t
         Jw2ARdvaib9cdWt9RmWWR/rG3uM05lkQy825x0m8dpvKTdnv2zHoM/BxTZjL3Eg/fOyC
         xnnA==
X-Forwarded-Encrypted: i=1; AJvYcCVA8iqqQHGGKh50wFzECGZs4Lco2/rmTRPYw/e9DMihdmJz0t3DJC3u1roFdUE3gvONZHF8hdAQ5TysAG2snnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YydD3nXR12kTcI0C6/5MIqElMz6kq4RYqCOe3msA/qb6s38tkIW
	pPRBm5KVWpn9W2jCJUSRiFRVqUBrS4IZFkd4swLdsioWuRgcA/28JEqNfYSC2W0=
X-Gm-Gg: ASbGncvzstHXJPOUJPM25bfzd3FEAakX73MLhFvt0IYGaYd0q1QHJTEVtH9gB94MSaj
	aKPtWtP0STo+5kfWX2kREBESO60A3se70EhqGJni8Mb7bJQ4oLGif+/Kp/TAImOj9kT1FYqFl4P
	VhfJgDfugi4NXElznczO+zSNGXQt/NBlqI+1SpH+/vK9X8GDMARcDGAjnkdu2Ecmx49fvhtFp98
	JjkTgPG9y1YdIZVw1twbwWCKPiKmmtIEPguILjK51nG4HtW4ji3mLgc6L0=
X-Google-Smtp-Source: AGHT+IHgVguIQX7zRdkeSiogpetBA09LUoU9WaRTxjvY87GzH77emXIzHenGyofWFwiTSdXlRShTKQ==
X-Received: by 2002:a05:6000:401f:b0:385:e9ca:4e18 with SMTP id ffacd0b85a97d-38787688392mr90463f8f.1.1733932150243;
        Wed, 11 Dec 2024 07:49:10 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-387824a4ea3sm1550192f8f.28.2024.12.11.07.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 07:49:09 -0800 (PST)
Date: Wed, 11 Dec 2024 18:49:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: David Laight <David.Laight@aculab.com>
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH net] ipvs: Fix clamp() order in ip_vs_conn_init()
Message-ID: <6b363719-0250-48c1-9d89-0d4ae86accf8@stanley.mountain>
References: <1e0cf09d-406f-4b66-8ff5-25ddc2345e54@stanley.mountain>
 <7e01a62a5cb4435198f13be27c19de26@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e01a62a5cb4435198f13be27c19de26@AcuMS.aculab.com>

On Wed, Dec 11, 2024 at 02:27:06PM +0000, David Laight wrote:
> From: Dan Carpenter
> > Sent: 11 December 2024 13:17
> > 
> > We recently added some build time asserts to detect incorrect calls to
> > clamp and it detected this bug which breaks the build.  The variable
> > in this clamp is "max_avail" and it should be the first argument.  The
> > code currently is the equivalent to max = max(max_avail, max).
> 
> The fix is correct but the description above is wrong.

Aw yes, it's max = min(max_avail, max);  I'll resend.

regards,
dan carpenter

