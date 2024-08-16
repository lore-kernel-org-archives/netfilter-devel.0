Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C73EA9A
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2024 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723772559; cv=none; b=ErbSwwEnoGkgzY4eDW9suE6Xwc7lACKel64VZFKss4Sy7m1aS0tlV3KMCxeztC5ko0hIFa0NMgeIo3Z7fZY5UTVSU60FD6t0rSWhkR7LZvGreu0JStFrA/+O4rNJFfdurnD1xGBfSFfLRCNgTPpD8HC6myeCLwH5PYV3HlK3N9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723772559; c=relaxed/simple;
	bh=wufldpYXNSX/UfEDCsd++exXIFt7pbztxovQy0nwGYk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Se7RY3IHJ2nXKf5iv9o6nrFCmJ1/xwDIHUYe766hUrFo4yTHgSUEspXvgJr8Hp539N3QdAwq1JWG+4wcrVPdakN+xJXVJR2WoHpFnLjF+lEorTQw2GO96A+DoPxQ4C73hvUfFTsySN6uJZo6G8rMxxNNMwxvTp3/9oYCwXehwqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diVu2a1D; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diVu2a1D"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc65329979so15186005ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 18:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723772557; x=1724377357; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sHP1p3Jy0+HDktHxgMtBxROo9d+5dSjXP/HHcUHD7eU=;
        b=diVu2a1DiAWiCjiGHD7ReoHP7xfM2PdI0ExZ7Dz4szxPBp3wz8Nms4iUEbHP5FbQUr
         B80/Lv13suO9yuomjwvADQH80Q6o15lRXK3gDyWIeLu5EeqzBipAjHBU0y1efHzkvEaE
         nWu3lH0uQ6Zlq4to+llaP6SCL0MVg3KcmJXill/dvqs8xhaT0/ElXqYfc19UI6S4U36K
         7liqRYH+JuWIRkPFZmRsHPCW7FK4D+y9TU+Tf5Seuan4mcQyOmZtl+Kzs9b5pGuEMReQ
         9ahdxwkKYXEiKZv5UkbKT9pa3jaFVuQVfY14RwJ3IuqWkmMOwp+aniIJLxCstTjyImI8
         5W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723772557; x=1724377357;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHP1p3Jy0+HDktHxgMtBxROo9d+5dSjXP/HHcUHD7eU=;
        b=fbScSSfvgG4fibutuM4yDbAW2aDuTCWKKCw3M1L3RpxiN2Cda5HxWtdPW4+4wKTv52
         /aq+krs81EoI5JHlrsQ09nqKUZR+8u1zLe216OOUmUBIZzV4EnQVFCT1eSXfoScEYGqW
         kFYPBira9E9ebxGMdkHe78XYaNjioD82BccKs/PZRObTnb9sNZv7jttkWG1HpWtKiP2S
         oWT+POkBqZj+wXtevvA/sA2cKMDKe9V+RfAVpBD7kCrzCELSVxqzqR14HD3I8R/qoyKF
         HbiqUylnjMNQPkGlEFVjmSYSMfg6JZLmD7byvG1Nvk4FfCUOhKeLJpQe8ciPJH2Ayv30
         TCCQ==
X-Gm-Message-State: AOJu0Yx6h5dc7wAffIjFQBVHXyzMMw9vlemUo0n5STnmq4BwKF3eZosS
	GD5pQs4ySfKS28JWryMqe0KrJ6tc1BBYQts+zucMp6AYl+rBAyMVlsHROQ==
X-Google-Smtp-Source: AGHT+IErp7C7Qisi/6+q6vbVTeWNb6fqVu1/gNiOn2key9g9BZDJoOj4/zeybFkLDUMGtd6hIMvUew==
X-Received: by 2002:a17:902:e752:b0:1fd:684f:ca72 with SMTP id d9443c01a7336-20203ea74a7mr14862405ad.25.1723772557294;
        Thu, 15 Aug 2024 18:42:37 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fab02sm16135325ad.48.2024.08.15.18.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 18:42:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 16 Aug 2024 11:42:33 +1000
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Please comment on my libnetfilter_queue build speedup patch
Message-ID: <Zr6uifNX3ox+V2sT@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <Zr1JN/xKIuzi9Ii+@slk15.local.net>
 <20240815073425.GA19654@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815073425.GA19654@breakpoint.cc>

Hi Florian,

On Thu, Aug 15, 2024 at 09:34:25AM +0200, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > Hi Pablo,
> >
> > I submitted
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240628040439.8501-1-duncan_roe@optusnet.com.au/
> > some weeks ago. You neither applied it nor requested any changes.
>
> make -j 32  1.19s user 0.70s system 124% cpu 1.525 total
>
> ... and thats before this patch, so I don't really see a point.
>
> That said, I see no difference in generated output so I applied it.
>
Thanks for doing that. It certainly makes a difference here:

before: 6.77user 6.22system 9.52elapsed 136%CPU
 after: 3.95user 3.43system 1.29elapsed 572%CPU

Cheers ... Duncan.
