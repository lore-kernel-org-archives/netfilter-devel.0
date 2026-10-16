Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E124D09F8
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792157591; cv=none; b=QmiwynTHtcm8dDm5wlF1RI1s08XnH2TIEhbPj0VXbXguYxTHj5aR+9Kv8psY1pbEaqM2X+7I9FDNjm7us9czIDXQqfWmj6cqqs9I+kWkk8AVNmrZq2UCvcFLEao9e/Lau6Fm3f8NvaBX7yj4ErHntiUTXt9U4aZjdqp6a8HF/1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792157591; c=relaxed/simple;
	bh=bK4PZUmX+zASONoSq5WJ3xb+fFaZlwfK9eWVJsHysGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cySglFM/frI68IVRZ+r2P/5+5wAOSSp3wsY9gceMwYlG86w6rD+lDsxTDk9EmFiknSsKmfjJgoqDGcpxHqEIgVX/I57szu0FGZxSGeNCgF9KX8Mkkx3KvvmdGKr613WGNIoWS68iwx0nrlVb/RHa1O2mMsu4RkOWksz8RpOgh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AhTgG1jl; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AhTgG1jl"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e6affec80so685078166b.2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 06:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792157588; x=1792762388; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bK4PZUmX+zASONoSq5WJ3xb+fFaZlwfK9eWVJsHysGM=;
        b=AhTgG1jlNmm+aG+EzrptDUlozc2eg0NlOfIL6JWPtifENW+XjQd7B+DUWF2D6+n+0x
         5FUulfW1JrrOSOs17pHLdnyEvZRY0Ven+u1bZmW0byWU5HK26apSGxBv6GclYI/oED1E
         8kjIccVX3xGx1tQ2+FRgKb02i0YTn631bOhkx0rTp70tjV++BrFPPy0UWr4cNAqfj3pi
         HVis1G5W4t1l4zVmcaHgDVI2pBlOdM3qmQUZWL4om6TqT9KutgDIFUScE82vSTN96Qjw
         ra56qVTRN1gWdDSmJOwagBE1CLOzZkFfDwtdE0AtchmJH/scfKjzXDJZzx34lRtC3Izd
         TYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157588; x=1792762388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bK4PZUmX+zASONoSq5WJ3xb+fFaZlwfK9eWVJsHysGM=;
        b=j+MYpH+98rWQr9Xlg4Xrjz1RvNRmXgqhPFt5jVbUS6DrL4KgJBQXyW7lp3h21sLlXc
         /uVhY4j2rUaXUwpigYle/gZMcpdsp40EGzxY+SiId3QVO+gQhGUhBRnTYBRh/778OPUZ
         wdd5YqQm1nzxf6h+xg9dTRS+KwCMzY1TpyDJYE+igJIIR0fHUNtg0GmEOTe4bZpowazH
         jNWndc3FvexW4byOadRyoHhqaOHmPTg8Ivk5i/mPRhI5PuJXTsCawLnITlmq+QuHahsm
         fCT4EhLlwPbkv0RU4bFj2qzrfvxMTscQTsJlrFf15d4cP8CcsfpQmesY2kAdVoMSpoHp
         DA+Q==
X-Gm-Message-State: AFq9FYJlyLRw03NpwqTCnKnVK3A6y55XRzHSgD4fayYClm/rlAXTKbN3
	B9JZRDjGC+jcgZX8xWTGZOq6EFSXW4vZdY+ja6FKDI6G0PDH5v5ti4J6GSUCMie7VooudFjUrTZ
	aQQ==
X-Received: from ejdf11.prod.google.com ([2002:a17:906:84b:b0:c39:66e6:4d4d])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:971a:b0:c2e:378c:8cee
 with SMTP id a640c23a62f3a-c31aa05bf43mr2042801866b.34.1792157587668; Fri, 16
 Oct 2026 06:33:07 -0700 (PDT)
Date: Fri, 16 Oct 2026 13:33:04 +0000
In-Reply-To: <20260928185803.335307-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260928185803.335307-1-aojea@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016133304.1755951-1-aojea@google.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

Gentle ping. v2 addresses Florian's feedback on v1: rebased on nf-next
and the nf_queue_nf_hook_drop() call in nft_ct.c converted as well.

I rebased and retested the series today on nf-next main (a5e7d8e446af):
it applies cleanly, builds, and nft_queue.sh passes, including the new
test_hook_drop_scope.

Is there a chance to pick it up for nf-next before the 7.4 merge window,
or do you prefer that I resend once 7.4-rc1 is out?

Thanks,
Antonio
