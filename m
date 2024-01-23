Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BE2A47
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 03:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705980440; cv=none; b=s2vHLCZ9OJ4/qUPONZ2QRLboSxbkcDArZwdzL1YCiIUZ1+C+T23f/uGVOYmwbHYnfqWoQPxpy4LCb8vRBp8CYbJ8ie08YSkNdO8jqEhldpkXYNLx2HyoNIRtvFGfu0LTLxKVU3vvVHhcewXwNr80GFLzQfnhHUJPNQf4vdECSrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705980440; c=relaxed/simple;
	bh=wlHEdCNTk6+NcGmeF3jsbxeG7NdPWeitikNW8IlWtCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF1Wxmj0KGr0Vssy5lypBDhaKKUEfPtN2gdp52eo+IbKYOg8vIyFg4LcM6q2T11mLPmHtdQaQK8qp+5u2NBtxkqwwTUqwqNLLLkWaKW3jZ5JJyyIJlC/MMxtoKIkFKsAgEOGBCeH60JBsUiGlL1hGZtRH/h9LCl1YxkT+lnqBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=La0+w9LY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="La0+w9LY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705980437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0nQeAiUhDEkZZ9fTqjn2KHETQU/ymAd0zKfMrlWKgw=;
	b=La0+w9LY48w65rnObix1sqCInwLlcULLTfePfVcuDROFsZc6M4W5xbacSw5+EhZ+qzvokf
	TK+wfA4bEm1PS6a6+ZUgOoazb/oYLycGjBhIONCmCnxAuA/0b2iB87uh5whWy1kLyDqzJN
	whnoVS9rgWd9GLZwPyZHtWfAPwMHcXc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-Ae2800tBOfqK5ZTMK1uRMA-1; Mon, 22 Jan 2024 22:27:15 -0500
X-MC-Unique: Ae2800tBOfqK5ZTMK1uRMA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7816e45f957so629774785a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2024 19:27:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705980434; x=1706585234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F0nQeAiUhDEkZZ9fTqjn2KHETQU/ymAd0zKfMrlWKgw=;
        b=M+BZqI0L7KbpN8ja07G32X8XLHLhzYSFxpOv80t+8vOV3cJu2aXy9GkRwzZlW4ZZoA
         sjNEbp8OTGasTvN4eJuKO7NQMMjvjyAhyyPMoWIYj7nGJLmqu+ErhLCsQjNsU9pvumUb
         ttGGVehh48Lo8aearNganAC0Gwx+b/ykFl/PlHfcVXime8AN2F4zSQDMcXZw3Xi8NOdj
         DxE1HMElJQIvmISrG75n7ku1dBbs8/gdQsGjZz3kPgKQPMsXDV5rPkZTh0xBqudVvqwj
         4rgVQR9Ok3CG10yn33EHA2+YOPx7YbzUHr16lptqTVgNQ1AoQdt+r2Z28od47gQmvZzc
         l5BA==
X-Gm-Message-State: AOJu0YxLRkQ63CcbkOCrsdsZUdO0maLb4xd71X3Y5rj6vG3wgZRpyuYh
	TP4kHoxuMcPc8Wsa4eiDZBC4NPcBzb0xORWguSp3f7s7MNvFOH2kKaH/U0RJ9iu3Khp2zjE+dt/
	LH9vmKkY55JPdbSU3hpvHqI1PGtgD+/FYF2WeYnFUSH+okV+B3saqDffjVhOVNZ1QcUnZAhXb0A
	dspzKVKAAS4BSFiw7yhOBiTKG981d856j6XVdT66g7mzBkSEebaou4/w==
X-Received: by 2002:a05:620a:c07:b0:783:339b:2c37 with SMTP id l7-20020a05620a0c0700b00783339b2c37mr4859445qki.116.1705980434566;
        Mon, 22 Jan 2024 19:27:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvPK2o5MKZyAyIsYQ7eN+dA7fgAesFyfzULCBsRwDlOiXUqV55kjb4taWAApnk8xwywRnoSfM/xI3GvwDdwns=
X-Received: by 2002:a05:620a:c07:b0:783:339b:2c37 with SMTP id
 l7-20020a05620a0c0700b00783339b2c37mr4859433qki.116.1705980434197; Mon, 22
 Jan 2024 19:27:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122162640.6374-1-yiche@redhat.com> <Za6vFpJZCHVw1LrV@calendula>
 <20240122212623.GA29630@breakpoint.cc> <CAJsUoE34NyBPm=bBOhsvDh80g6L1BzHOm-m2nLNQDWDsMY8V4g@mail.gmail.com>
In-Reply-To: <CAJsUoE34NyBPm=bBOhsvDh80g6L1BzHOm-m2nLNQDWDsMY8V4g@mail.gmail.com>
From: Yi Chen <yiche@redhat.com>
Date: Tue, 23 Jan 2024 11:26:47 +0800
Message-ID: <CAJsUoE1bQz0cGXFgvhRU8xJGxTLdsX_fAeFKL9QC5FXT=iQs7g@mail.gmail.com>
Subject: Re: [PATCH] tests: shell: add test to cover ct offload by using nft
 flowtables To cover kernel patch ("netfilter: nf_tables: set transport offset
 from mac header for netdev/egress").
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, fw@netfilter.org
Content-Type: text/plain; charset="UTF-8"

> Hi,
>
> This test reports:
>
> I: [OK]         1/1 testcases/packetpath/flowtables
>
> or did you see any issue on your end?
Yes, on the latest rhel-9 kernel 5.14.0-408.el9 which hasn't involved
this patch:
a67db600fd38e08 netfilter: nf_tables: set transport offset from mac
header for netdev/egress

 it report:
W: [FAILED]     1/1 testcases/packetpath/flowtables

This test case existed before and caught this issue.

