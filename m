Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F19172BCE;
	Mon,  9 Sep 2024 08:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725870591; cv=none; b=tujkwzs6IMpew1Dde7TjmqgnpH5orMcqL3UTaMZuASGu4J74LahzyKgty1+QzPBTjpANdMfpMVHWB6FE9rwp2nB+mk4+Rsuet0UU2gRE7Zxb048aGLM+Q8OKdvwCC9klLhMAy3oqNS1HHAHI2B6l33QQ7lCwtYzXZ2VfGaTvkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725870591; c=relaxed/simple;
	bh=9iigcWNH9gaJKI9MZsjycWsvetp15GSPT7FV5IM/MZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hz0l5dQdx4Q4jT4+Y7wNpyKzscvd6zD8DzR86My432KxS6Hn3NMy0e4RZTYbEa8E9fuB6xEkf+xx5lkPMCsJlqWmHd5q2LEn2oqMTDRLghej5rdIOjdGuukyHVGSud1ZJgqdZjiWDnKrF/q78HFWojByxm2ZXpoyomiLKreZf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f75428b9f8so22621521fa.3;
        Mon, 09 Sep 2024 01:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725870587; x=1726475387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=stcyakZ4StpZ9LKESQVGGE1UUqCBnyk68kBRqrRncz0=;
        b=E76vGke4w3NnX72zW8zGDBOAMXMcA6hz6U6wuKQx+Rt8xdPZ/U+QLVAFGvVMTdohfC
         nUgdFoTczdz5pAIXU6kuFrDHzyUULMb6J7AFW+helB5gq5J8+tHofOCThzAKqDYNiPPl
         Iq9XvD4sUuFdVGPu7IqxazJh8xXipWrefP3rW8xZEUFrh07Bd4w0meSqEBaGSOf8bB02
         CfYaWdkXBFjYkOxk5eRgeH5GX8f489hH2PoZ6naw6I/HJu9CEnBMHCV/7ux0xDW/SBQA
         sHrlYB2ClvLx5/8rb8UGp2XyygyRbN2XPbXT3C3BsTCSJtOTo+vKcpor0PAgvt6e7zuX
         vpYw==
X-Forwarded-Encrypted: i=1; AJvYcCU7l+bCToBOSLMqN9uEeCMNRy+DdUrs4o2s1A8Ona2ZbvdUNumhWBylMh6A4+L4r8/Nui0qWj9T@vger.kernel.org, AJvYcCVmJYuJh3RO7CmfgtpPYS6eLhwh+XBZZyglNYt7r3hUKgzvSApbFRMn2wLLurtIer7PC+wb7D+QEy0QyKzfmggt@vger.kernel.org, AJvYcCVyn036F6Fw5EARw2leCrOyC4ZXV5dZkByt4hEZgXUGJE+F4DxUAhjc/PH4tQQAM2c9n3TFLU04GFLVBdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA6mIkrIT+ZKXGiRnl90HCPGdgFCEzYCZcj5OltncDuqpRfBxH
	4EuRXZRaR0QjNnlOgl0zx20WtN/gbQ4e3KoT59f3AYM+gBSOwoBB
X-Google-Smtp-Source: AGHT+IErn9w1GAPNrCT3D/10AYzxY/ljH5DGqmwTeoTRx5ggId14vjDT68YpOY6LfNTH7pX7Uv+GVQ==
X-Received: by 2002:a05:651c:2126:b0:2f3:e2fd:aae0 with SMTP id 38308e7fff4ca-2f75a96ea93mr65251031fa.6.1725870586452;
        Mon, 09 Sep 2024 01:29:46 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-113.fbsv.net. [2a03:2880:30ff:71::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25ce96d9sm304750066b.157.2024.09.09.01.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 01:29:45 -0700 (PDT)
Date: Mon, 9 Sep 2024 01:29:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240909-aloof-magnetic-bear-ecd5af@devvm32600>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
 <Zto4WmXldf6KzeQO@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zto4WmXldf6KzeQO@calendula>

Hello Pablom

On Fri, Sep 06, 2024 at 01:01:46AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 29, 2024 at 09:16:54AM -0700, Breno Leitao wrote:
> > This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> > users the option to configure iptables without enabling any other
> > config.
> 
> IUC this is to allow to compile iptables core built-in while allowing
> extensions to be compiled as module? What is exactly the combination
> you are trying to achieve which is not possible with the current
> toggle?

Correct. iptable core is built-in, and any extension is a module.

> Florian's motivation to add this knob is to allow to compile kernels
> without iptables-legacy support.

Correct, and this continue to be an option. This change only introduces
you the option to set the core as built-in or module, independent of the
extensions.

> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  net/ipv6/netfilter/Kconfig | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
> > index f3c8e2d918e1..cbe88cc5b897 100644
> > --- a/net/ipv6/netfilter/Kconfig
> > +++ b/net/ipv6/netfilter/Kconfig
> > @@ -8,7 +8,13 @@ menu "IPv6: Netfilter Configuration"
> >  
> >  # old sockopt interface and eval loop
> >  config IP6_NF_IPTABLES_LEGACY
> > -	tristate
> > +	tristate "Legacy IP6 tables support"
> > +	depends on INET && IPV6
> > +	select NETFILTER_XTABLES
> > +	default n
> > +	help
> > +	  ip6tables is a general, extensible packet identification legacy framework.
> 
> "packet classification" is generally the more appropriate and widely
> used term for firewalls.
> 
> Maybe simply reword this description to ...
> 
> 	  ip6tables is a legacy packet classification.

Sure, I will send an updated version with this change.

Thanks!
