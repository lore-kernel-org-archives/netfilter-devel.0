Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2151A2567;
	Thu, 12 Sep 2024 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143284; cv=none; b=GwHuRHhIt3emF0mTBHSL7ZRjQjSUmD/El8dpSMleKprTsDDMUZuqwe2T4oPFOOQRFLiFm264yy5bp4JU+VVhhQQgSYLogWCSYzJX7/UqWzpgd8afyPdlP2zrDM8mLbj1hqHp39SE8bKw72QuiGRyyZs6SvvszIpZSV4HG0MyYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143284; c=relaxed/simple;
	bh=8p7KZcuKFWKBaLfxA+I5E9oDfDgXAwCN4bB5/v75Pv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7WZ59SVKJqqy3rztsDFNwqJ/GqSksSDoZIX8t7QuSdGp3oA/5p2deplqWVhsQjR4EXMyk4JUvlFAFToXzYajMJQYohdEnBe20xwvGYwNtzVWHI7qeibzF658DYlXV+JSYaL/9OmDGHOLnWHdtNhqMYlTJHWtT/JeFxecXI0FwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5365c060f47so1025660e87.2;
        Thu, 12 Sep 2024 05:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726143281; x=1726748081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdHw9GQ6e2+S6Xb4WuYu0I8q6MO4LyuwN/DojR0meKY=;
        b=pHvLIYTwxNExsNUcjzW/zoGyb6T/DLECrHAD6kaVw2xFTTZwD9+zzQlRvkSKL8oPJR
         MQZOGHaNm5aSoOlmdcFGLIeGeUvvEB2bCI210225V4ZJ8IP/308br9fkKDmg48zl2/Fs
         y5ab3b/vU7C3Ev0+uARh4ei0jK6wi3x3Tcd23voDrgb6gMZ9b/wqySwk/4HLomgnzULO
         Upj2CRaujU1lzka4orH3lmcPKDxE0YLZSQhNobnGzhi79vAhcIVA5yIMYjOF2XeaIo40
         MaWrqX3COlCQngeRcU0VXtXI4TL0jonFhVZ1RahisA+xwCnDRDXCkAOs52FVWWccHVsv
         HjBg==
X-Forwarded-Encrypted: i=1; AJvYcCUjvVHPjPrDfQTN90wxsw67RjQ6AYaznRvBmjZYdbMIWwttEIocnMOzALR4g0ZgJUkHA2Hwde/tESdeOkEoWZkz@vger.kernel.org, AJvYcCUrqH3durpuBezudTDurA/SOeBeC+LMFTRivs2EaNspgBNpX77fD/FHX50p8m5tkdeWPMh0L4i9QzZ0DqY=@vger.kernel.org, AJvYcCWFOYfee9sajHqbiapv4kui3tZHVT7PCrwydZbYm9X0XvrzofAZHvlKrnZ0EX5DeyTBXammnL+8@vger.kernel.org
X-Gm-Message-State: AOJu0YzkndHpBVroBODphK3JoHUJrkiFcjyqEHhaL+bd+rZi1Z9NRXJj
	oRuwI7QQ5rZvnzOepKA5Lj2nTxfbRSRx/3VfCYF9/lIH4rKGzRau
X-Google-Smtp-Source: AGHT+IFQ4lgyOsageJFniboUeANrCl9n/IpwYDcONOJ66kiM2nDOjZZy+n7d1cFD0DaT7Kc3gf9gSg==
X-Received: by 2002:a05:6512:3ca7:b0:52f:eb:aaca with SMTP id 2adb3069b0e04-53678fcebd4mr1617097e87.32.1726143280498;
        Thu, 12 Sep 2024 05:14:40 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25a2539bsm740400466b.85.2024.09.12.05.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 05:14:40 -0700 (PDT)
Date: Thu, 12 Sep 2024 05:14:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v5 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240912-colossal-uncovered-nuthatch-e1c3a8@leitao>
References: <20240909084620.3155679-1-leitao@debian.org>
 <20240909084620.3155679-2-leitao@debian.org>
 <ZuIVsZ813wxD6Y3Q@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuIVsZ813wxD6Y3Q@calendula>

On Thu, Sep 12, 2024 at 12:12:01AM +0200, Pablo Neira Ayuso wrote:
> One more question below.
> 
> On Mon, Sep 09, 2024 at 01:46:18AM -0700, Breno Leitao wrote:
> > This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> > users the option to configure iptables without enabling any other
> > config.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  net/ipv6/netfilter/Kconfig | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> > index f3c8e2d918e1..425cb7a3571b 100644
> > --- a/net/ipv6/netfilter/Kconfig
> > +++ b/net/ipv6/netfilter/Kconfig
> > @@ -8,7 +8,14 @@ menu "IPv6: Netfilter Configuration"
> >  
> >  # old sockopt interface and eval loop
> >  config IP6_NF_IPTABLES_LEGACY
> > -	tristate
> > +	tristate "Legacy IP6 tables support"
> > +	depends on INET && IPV6
> > +	select NETFILTER_XTABLES
> > +	default n
> > +	help
> > +	  ip6tables is a legacy packet classification.
> 
>                                 Is "packet classifier" the right term?
> 
> I can mangle this patch before applying, no need to send one more.

Thanks
--breno
