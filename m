Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C917B4FF;
	Fri, 30 Aug 2024 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021961; cv=none; b=ALEeXgZdrsSbYmmgLYdWIChvd4LM4HLt84+jf1JPG8OxxuMSRkPi8x68NElbJELvgl4iVl5by01t92v8+amTlcPi6oxtrtQ4WC7fn/JKcets6UDl7DcSVumslPQyONTqidP18abrFgaR/Uwp2ttpANbbpN9I1uFVc0RnY0rxBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021961; c=relaxed/simple;
	bh=SYqrsyCvhaWMTy1vjd+g6I5QKxClOIpLV9pc73Zk1Co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asFSeiVuf7HisMUKrNjlcgYwH5reoPOWrHKKY1608hF6yNk2T4Wt4aq4XcypixA9X0ZOQ1r8Ihu2MIMrkaC3zfKhDBvxLS5xZw6/KMMejpvUomv55ek3R7+2UtofMAzL0CfvveIm9P97DRkHW1OMpxyIn8QfFlQwZO+pg9Tua4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a83597ce5beso294775966b.1;
        Fri, 30 Aug 2024 05:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725021958; x=1725626758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLZHYItqUThIKGDq3BwSU4uVTYQcIvrN3xmEbSMUUeU=;
        b=KeWaQXlVj7zFm9jhctFPRnk7KNsLJcwCh3KtkhYefOcOtBpsKIAhK5q0jcBUVnnfgE
         IiqDEy88RbDN4OJd/dqL3RKpsyHXNTHQdXbUeuoV5O13t7xVuFwAqCQbMRI3lYWmDvlR
         rrG7EmNXM9Fd8DBtIm8+RkQGDsDraAooLoWjZQaTaKoIb/Xmc9uHKGmWPaJYs+H+rFVI
         dWFoYEWn/irAhG8LePdSuoz9SklEMS5cvKI77c8FHlb4suSGANNZqaxbw43TjAMdvKf4
         KgUdICLev6EQDt+Uh4SqtgpZzHYYBkIXIrPK1o4EG1cdC122lvbqAXkS7V6Cv8HWzO+e
         jqhw==
X-Forwarded-Encrypted: i=1; AJvYcCUyCB2Vus+wmh/2jMnE8NrJz/29H0Xq/pg9LILQn5Vsb929/IBuTk+GIwLe8/w7IaOoHTrgMrQG@vger.kernel.org, AJvYcCVFv+fmJspPtxdTeG9+tobodtz91Amx3T8sh5TqKtGyloI//j9DX1JVJLCX7icVaE2DmQwVHaPucanaflc=@vger.kernel.org, AJvYcCWNg1AYcPpLLrarV0h5jygNSDfd/aMsj6VFDVSEfXJZdQ9gcQPz/VgwEvOS49Il3kswyCNmgwVsKZbU8tzuHbRd@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx4WkdgZtowgl6Tv79MmyBdHVxjS2MUYi4avzPXHSFeh0h2Q6Z
	XhZNWykEThCuPQZaV1Wcdh8Mxn/DP85Vic29+oVWKUDZZ6EbNnPB
X-Google-Smtp-Source: AGHT+IEa3fQA5oFfpE1oRsQVGh+ZYzRAZIi1EM7VzLQcYf/c+EeJ9u7F+fJPcJGdKJsB8B4NB68/JQ==
X-Received: by 2002:a17:907:d589:b0:a7a:c7f3:580d with SMTP id a640c23a62f3a-a89a2924ab3mr238476366b.25.1725021957900;
        Fri, 30 Aug 2024 05:45:57 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89940980a1sm155694466b.47.2024.08.30.05.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 05:45:57 -0700 (PDT)
Date: Fri, 30 Aug 2024 05:45:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Florian Westphal <fw@strlen.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZtG/Ai88bIRFZZ6Y@gmail.com>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
 <20240829162512.GA14214@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829162512.GA14214@breakpoint.cc>

Hello Florian,

On Thu, Aug 29, 2024 at 06:25:12PM +0200, Florian Westphal wrote:
> Breno Leitao <leitao@debian.org> wrote:
> > This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> > users the option to configure iptables without enabling any other
> > config.
> 
> I don't get it.
> 
> IP(6)_NF_IPTABLES_LEGACY without iptable_filter, mangle etc.
> is useless,

Correct. We need to have iptable_filter, mangle, etc available.

I would like to have ip6_tables as built-in
(IP(6)_NF_IPTABLES_LEGACY=y), all the other tables built as modules.

So, I am used to a configure similar to the following (before
a9525c7f6219c ("netfilter: xtables: allow xtables-nft only builds"))

	CONFIG_IP6_NF_IPTABLES=y
	CONFIG_IP6_NF_MANGLE=m
	CONFIG_IP6_NF_RAW=m
	...

After a9525c7f6219c ("netfilter: xtables: allow xtables-nft only
builds"), the same configuration is not possible anymore, because 
CONFIG_IP6_NF_IPTABLES is not user selectable anymore, thus, in order to
set it as built-in (=y), I need to set the tables as =y.

Sorry for not being clear before, and thanks for reviewing it.
--breno
