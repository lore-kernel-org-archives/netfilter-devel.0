Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F274C14
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 21:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760995417; cv=none; b=n2k0/SXq0tw+RcNxUSpiuuej0+w5JNfClYa8VGQIyVSzho7pAoa3enHpWQp6P5EUUBO/B+vTVWmilCawFQkYw/47ZjUjNzwiCVGHHWx1kBi7/GgsgLa+IPpJPM3nDl+2z2fgXXgi7DrzA6EyletOzOo/kiLUy1OlbOsh6QORQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760995417; c=relaxed/simple;
	bh=uOPlRmuFHq/IB3ocKYIa4uL5H3Qyj/Gwc/9cADr7v+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QX8VcriQguICOV9yxElsiL1c/dXwXxiUPT+qMTxSBV4yy//zqUODsni3Zn4hwgHXUTIV+WLBYetO6Sk1Y9hUpWI9FFHYmknQdZDO5bklFAXU9eSupMPb4mAFMb3wS3dlfYuMk8xVTEXQk4KI+2ipC0byZ10xSueDnhnVZQSoLso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pmYkZ55P; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pmYkZ55P"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-471075c0a18so50705995e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760995414; x=1761600214; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uOPlRmuFHq/IB3ocKYIa4uL5H3Qyj/Gwc/9cADr7v+I=;
        b=pmYkZ55PVZWwlqCLPKpgq2vfYDDkpVRxKGcx9B4wv7yOLQS2TiaU5KBPRikoZlEB8U
         cfakL6/NoS2A7ayD3FHKKasZRBpdRFCMNMAR69yRf41WoC/ZerW9B4oTaYdOL5FaVPpM
         p2yJyjg1mNpHlJhOg3ROqu64HW6ns0wQSv4su4qP1pIw51f5rfsLnL3qF2SLsMG6x9Wc
         5xqqxyQCU4FGT71FeYz2pXPwJQxiRChTXRYeqf5T3szbUGu4duYGd4/Vj79y83TlrY8m
         dXe/L1kst/6LfV1kfhcndLOJdBAyf5CJp07XcFVRLosiCibex7rVsU2QakueeLaXr8ix
         OGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760995414; x=1761600214;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOPlRmuFHq/IB3ocKYIa4uL5H3Qyj/Gwc/9cADr7v+I=;
        b=OGp0jiXePopiFyzVgApSWKRkH2UsKlwxWVKL/XzzERQ7kYP+Tj0NpkEPwcwhp8IsfF
         DypZS+ZorWkHsIgOv8PdF+dnFIGmt2oojNyec7cOkv2/Q1Fbct+FKCKYaGml/sxCxRaB
         J33AHcn3CgUbL+38DwsW3K3nR89CZ/rCUAGWF2SaDU7gVlumfOQqhJKL4iop+8WPd+/C
         yVm4zHGyxky7wp1vZRIbhlZkS+SEL1pPN93P26N/s7gqFnqFdma5xe+1GkLuT6nHcgiG
         4kI1+AwB5bt9a+cXpQiOKMMFHnqrk3trFB6gwu2NXQFttVr0bTknRUlIBpCQ3oN4YTao
         w+cw==
X-Forwarded-Encrypted: i=1; AJvYcCWnTxLVU3Qxbau2qtxJpRuMdc6niRpEGHzMclpuICKzgP5oZR4bWfU5S2RkAMSQov3SPn8pQ3wV+L/zKG9InNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTnSWIZtPsSUDEKwdh9iivKj7sOBfnhHYkyQmep9kKCPjeecBB
	xd6d+Jw7KmF2UIAPiwbg5RnU/cvKRLGEsZZ0NuJSoUr63KsWxIbmKhtlT1/KAylmkX4ipUFhkuD
	QPEiKO1jUKLuPTG5H7A6ZDG3NK6C6VEODdR12+Y2NkwfsgQ8Pqsl8mLRoUuI=
X-Gm-Gg: ASbGncshlLA1Pr34agpAjz2njia4XZ3ywObkuxajneOYAYqLzqrub8FlrFWocN+voAr
	wXPcmD8gRIk9aqw+SS9thIpjlPHGb2DaeZyyCqNLv4whYBrX6/PiaUaQThAxHfXqFS5xhiEmiv2
	mthUfL7X/xaK3AdPLaTXJS+ny+Oy/+nCoWrf0nvJ0xHLpSdFIYjlYJ2dSpK9stw/m726b257HeT
	vxBxnJ00QUfkrmFgneoDYhM6jVwWNzcze3aQmycwK8sq5K73Y7MiVtmHkENHpln6EJHUw==
X-Google-Smtp-Source: AGHT+IEB7Y6hXjC1ofKbdRBzCMn3xumEIrT0CQVZsC2Xxr5nSxRoJN8C6/nkNZm1xTyp6nhIKC86ffS9+/g4OUksMjg=
X-Received: by 2002:a05:600c:8b78:b0:471:989:9d7b with SMTP id
 5b1f17b1804b1-471179068e9mr101211685e9.21.1760995413904; Mon, 20 Oct 2025
 14:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020200805.298670-1-aojea@google.com> <aPah2y2pdhIjwHBU@strlen.de>
In-Reply-To: <aPah2y2pdhIjwHBU@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Mon, 20 Oct 2025 23:23:22 +0200
X-Gm-Features: AS18NWC-bSItK93RRYxpW8Q7QBFMfvTt72Lu62Vrb903VB8cg-EHay2hR4A45FE
Message-ID: <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Dumazet <edumazet@google.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> >
> > Simply flushing the conntrack entries does not work for TCP if tcp_loose
> > is enabled, since the conntrack stack will recover the connection
>
> you mean disabled?
> loose tracking (midstream pickup) is on by default.

yeah, sorry, as you say, I meant disabled

> > state. Setting the conntrack entry timeout to 0 allows to remove the state
> > and the packet is sent to the queue.
>
> But its the same as --delete, entry gets tossed (its timed out) and is
> re-created from scratch.
>

The behavior is not the same as deleting the entry, I tried both and
only works by setting the timeout, I tried to follow the codepath but
I'm very unfamiliar with the codebase to understand why delete is
different from updating with timeout 0.

> > This tests validates this scenario, it establish a TCP connection,
> > confirms that established packets bypass the queue, and that after
> > setting the conntrack entry timeout to 0 subsequent packets are
> > requeued.
>
> That zaps the entry and re-creates it, all state is lost.
> Wouldn't it make more sense to bypass based on connmark or ctlabels?

This simplifies the datapath considerably and avoids the risk of
having to coordinate marks with other components, but there is also
some ignorance on my side on how to use all netfilter features
efficiently.

The use case I have is to only process the first packet of each
connection in user space BUT also be able to scan the conntrack table
to match some connections that despite being established I want to
reevaluate only once, so I have something like:

ct state established,related accept
queue flags bypass to 98

And then I scan the conntrack table, and for each flow I need to
reevaluate once , I just reset the timeout and it ignores the rule "ct
state established,related accept" , then if the verdict is accepted it
keeps skipping the queue.

However, if there is a more elegant way that does not depend on this
"hack" please let me know
Can I apply a connmark or ctlabel via netlink in an existing flow?
If so, how to make it so it only is enqueued once, do I need to mark
and unmark the flow?

> I'm not sure what the test is supposed to assert.
>
> That setting timeout via ctnetlink to 0 kicks the entry out of the ct hash?

The behavior I'd like to assert is if this behavior is just some side
effect I found or something it will be "stable" , since I'm trying to
build the firewall on this behavior and if changes it will be very
disruptive
