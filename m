Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F2F17C98F;
	Thu, 15 Aug 2024 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723715727; cv=none; b=ngDzeTGOBNI5cJpvFtlXIbrRgPh6M7OKXcAz8Y4zLKoxigN1rD+pP9vVr/F3bKCK1Vr3ksyomS1ZDhqTwVQYjX3kse5UJ8KsTHlRHMPiEdLIWtCbneV4KBnqVEhLo258Z2SxwDSoEcvMG6OvAyYkKDbcgW0KhQ6Fwm0Va+YkyG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723715727; c=relaxed/simple;
	bh=Lgo/VgloMjv6fLJSUrtmBCgVTWsKGabMKO/aaEKlSuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hb0768jjVMwN3D9ieLvQHmDjXgGrN/9sVLEnolJNx4O4HOnkf4iqAcZxBmhNtoEBHXBXxlRDkevkOzPY7m2tdOahkdfvkWBjSWBqQihgB5U1sVMs3hGnwNcZ6pdxsiUUdRsX/djFRviovY8v8C7aPHcOAVWNBWjDttXxmfSQk10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ef248ab2aeso12049971fa.0;
        Thu, 15 Aug 2024 02:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723715724; x=1724320524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhxpIfrOZR8Ies+hYSFH0zNgK/4n9SX+6YegLe1LHNk=;
        b=wJT1w954sBEtENMobFB9XJUKYHRbLQKzdh2FoQewJP6g7lyvrNS0H9xNzHzNPbiEcd
         vRb+bhWRVDiOEsx1P+g0iIiX29xi3B4A1yxyH+jblj8j7mDLkMX5OaNcJ2hZJKjjAjUs
         H70neboy2yK55/maOMY6tcyivso0aePbSrLPUdVNC5mI6fcCh3OoQlMJhwEfTpn5C2Qm
         O717DlLtv0GSCP+x1mkUXTEz1/VuFh0ylhQTDVOlqqnIZ5Ehxj+3QitLkQA3tkHKn4uN
         KyOCPCUyZXNTb+qhLVaXHpvhs/Qk3jMRE1ntnqwByCb6kvnI9qx11kFEhRxNX0UCUgCe
         LuBw==
X-Forwarded-Encrypted: i=1; AJvYcCWq6+cWVUvQYnoQgcx18LU0C4710u8oY2uwsKOfVrRTefvSKaf5UVyMqhKsHVSGJKrVDqMQP9rNu3zX5n/PaqeOrxsyT1JIbJVSqEZfR09tbW6PGOu1TovzHr3ecQ/ibxtsv89Sxo7HzBqPaVayWpv4cXhe8wfwUYaVQUkxxpctWM7M21kw
X-Gm-Message-State: AOJu0Yw+Rd29gInrt7wLwL62YpXcZ3fxA4SARZVhQw01/h4cAoKoJxfb
	V04e5w2WhYR9SNS6cYN1T3DgwrvtbztCq0gjAJCcGhzS9OLbpbcq
X-Google-Smtp-Source: AGHT+IH1vdwmSr6sVrVAeVDr3p7TkdzdG1CjLf8R/tVXngJ35xiUlDssG8qqC9A8+p8gYBgTtuX3VA==
X-Received: by 2002:a2e:9c0a:0:b0:2f2:b7c4:45e2 with SMTP id 38308e7fff4ca-2f3aa1f0072mr38628371fa.20.1723715722891;
        Thu, 15 Aug 2024 02:55:22 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-000.fbsv.net. [2a03:2880:30ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383935807sm75451666b.134.2024.08.15.02.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 02:55:22 -0700 (PDT)
Date: Thu, 15 Aug 2024 02:55:19 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: icejl <icejl0001@gmail.com>, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Message-ID: <Zr3Qh5FW7PsynJ4O@gmail.com>
References: <20240815082733.272087-1-icejl0001@gmail.com>
 <Zr3EhKBKllxigfcD@gmail.com>
 <Zr3LQ4hGx-sN5T8Q@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr3LQ4hGx-sN5T8Q@calendula>

Hello Pablo,

On Thu, Aug 15, 2024 at 11:32:51AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 15, 2024 at 02:04:04AM -0700, Breno Leitao wrote:
> > On Thu, Aug 15, 2024 at 04:27:33PM +0800, icejl wrote:
> > > In the nfnetlink_rcv_batch function, an uninitialized local variable
> > > extack is used, which results in using random stack data as a pointer.
> > > This pointer is then used to access the data it points to and return
> > > it as the request status, leading to an information leak. If the stack
> > > data happens to be an invalid pointer, it can cause a pointer access
> > > exception, triggering a kernel crash.
> > > 
> > > Signed-off-by: icejl <icejl0001@gmail.com>
> > > ---
> > >  net/netfilter/nfnetlink.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > > index 4abf660c7baf..b29b281f4b2c 100644
> > > --- a/net/netfilter/nfnetlink.c
> > > +++ b/net/netfilter/nfnetlink.c
> > > @@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
> > >  
> > >  	nfnl_unlock(subsys_id);
> > >  
> > > +	memset(&extack, 0, sizeof(extack));
> > >  	if (nlh->nlmsg_flags & NLM_F_ACK)
> > >  		nfnl_err_add(&err_list, nlh, 0, &extack);
> > 
> > There is a memset later in that function , inside the 
> > `while (skb->len >= nlmsg_total_size(0))` loop. Should that one be
> > removed?
> 
> no, the batch contains a series of netlink message, each of them needs
> a fresh extack area which is zeroed.

Sorry, this is a bit unclear to me. This is the code I see in
netnext/main:


	memset(&extack, 0, sizeof(extack));   // YOUR CHANGE

        if (nlh->nlmsg_flags & NLM_F_ACK)
                nfnl_err_add(&err_list, nlh, 0, &extack);

        while (skb->len >= nlmsg_total_size(0)) {
                int msglen, type;

                if (fatal_signal_pending(current)) {
                        nfnl_err_reset(&err_list);
                        err = -EINTR;
                        status = NFNL_BATCH_FAILURE;
                        goto done;
                }

->              memset(&extack, 0, sizeof(extack));


nfnl_err_add() does not change extack. Tht said, the second memset (last
line in the snippet above), seems useless, doesn't it?

Thanks for the quick reply,
--breno

