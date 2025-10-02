Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DC430CB34
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759402028; cv=none; b=S0OLFOtOFQ11UGQYx4Q3BAFKzSV2bkI4dtZqKGWKdaOCxvDQnyKTMe6uKuUX8F4eFTdk2hC/kZI0Z7psh/dpM0CdFuEhH9IMdcnP+NY+ZWglM0+ENRbrXJU7AcwYJrxPDRnTBEd7j5H1iJeWH74ZQTPdj3pbZ3iALVBUtkffC8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759402028; c=relaxed/simple;
	bh=P9MEzJ9waSoEzavfWu+hFbtTQx7qvaHJN9zFQ8zvAKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6XojnqX3wZteRf5BZAgFJyNnOJEF8YSFYpMV5ZSG4MpyFN0+H9NB+0rI3iZI4HJGqNCAb9zTa/6D4fBAfYAsh2etHdcnBx7wO5bjENrG1WCQe/ZwVnRAixlJMMsGpgDFCaWG6JGYiHaFmm35Y6Ns4Wl3CrQ8B0hHjtgKkBEup0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZcbS2O1; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZcbS2O1"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42861442ec5so8358945ab.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Oct 2025 03:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759402025; x=1760006825; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P9MEzJ9waSoEzavfWu+hFbtTQx7qvaHJN9zFQ8zvAKc=;
        b=AZcbS2O1ux4l62DGKbrqo0tRo65PIbs9MIOh97F5xCJZpoqhlxQt21y9glfBKOpgE1
         TAPGk2I9RJz+inG5wp1lI9UlLHj/pq070evYTXfAWY7QFHd03KAWb2XIFAvt+gn89P0w
         l9z521hdS3xkk2IrXVxDVvl36vEHyktqjH2UdSZaX3uh7v02Jq3WBo3fprAcnvL41RwX
         9nhMri58MeSO/QBI+O9M15fKP97l9UECnOq7mwYrjgbB3nDTPER3KvZN+EcW7SIXwWeS
         PdkNVDWUS5L+VpGVxHVKt8j4Nm9F8P/j1b17VrSW/kqw6amk446QEOA2MwBfcyg/O6GU
         FZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759402025; x=1760006825;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9MEzJ9waSoEzavfWu+hFbtTQx7qvaHJN9zFQ8zvAKc=;
        b=r/vhoE7LEsCQDFBsLiDUiVaUlqvvckxYITwLZPe3Rhgs3QBu42wM8C7/mgNM7VnRzt
         hIzMez0ZARIJ+l17Dip3iWRVaz59DJJ7Y9eh/fVhDkFNvKRY+B5/MTIZuVYVw2K8Fe/O
         O3ebt2A5Ed9u9Bgzn5oZNwUsU4QFng0Yq8KOVS6HvSk7p1A/aYj/wQxGswqk9mu2mFta
         dmfsnZlhP4H+uk2hC7sP9ZyCWHkfK8rNMGrlPb7s4n5OVSQqDcVYbm8yvzAuFavnDXdn
         T8Ljfp+blTtHA5BOeNhYVsCaPnz3gvwTeFQgOhgZmdxpZHyOWHXi4Zeg2QfEEUUC9qLW
         N5Fw==
X-Gm-Message-State: AOJu0YzpIXOD6rOF5HDLU8pt9zLfnv5brUNPuHdbo5H9Y9bZM2SPuQml
	a1ghoYqXiMpM6nDwUAk7nAZoorcmBQmyXFJRYKASWh9GzJpyPJRns9/JZclKGb2RCRT1Czl4R4X
	t/iO9F5qrH0yX8kzfFerzNeXiRJf5g04=
X-Gm-Gg: ASbGncsQp5aMGRua4ydck4rwZkYYvOGw+GGBAfH86Q94eS4RXltXIxEe1vU/qFoRso3
	V02pYCoghqshldvddJo6L2EVqgQi6+3UdlACGHRhJ+u96RQGQDC2ACSqeiY9ysR39cKtRTXEhNR
	bd7o4l7OnxTvFLq2ChhhgCaza9h9ZHM7acLcbpiiCAeN9/MjjFK9NweW8t+RzY++71zRldcArDo
	8J53xb/a8nv1Aw11ZgZvdiw/7/rsPhn6Jgxrxly2cCqhQFpygGwHxMr7/75Nz8KN2SvbQ/SvSvJ
	5yKDINGm7I1Nqs2BIFVCNshbGGm81PdziWTVYKEbSqxZwFo=
X-Google-Smtp-Source: AGHT+IHPpYK6zdPXHdcIobaaKtdvb4km1tXR7Cz98uQZNvdKWcURqXMHIVWFa143tEc+Oj00/ssRHz+yEP56Zv3S0b0=
X-Received: by 2002:a05:6e02:4408:20b0:42d:84ec:b5cb with SMTP id
 e9e14a558f8ab-42d84ecb8c8mr44941735ab.7.1759402025512; Thu, 02 Oct 2025
 03:47:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001211503.2120993-1-nickgarlis@gmail.com> <aN5PeGA1yLdlxuea@strlen.de>
In-Reply-To: <aN5PeGA1yLdlxuea@strlen.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Thu, 2 Oct 2025 12:46:54 +0200
X-Gm-Features: AS18NWBgNkgOTmJUtYqjDY8EjW2p72kVjLsXc_NyiCMFy2Uf5AXhxvP3QWw8gHU
Message-ID: <CA+jwDRmxqJJJD-V_mMOt-p_WcOT9uApZ6oCeeCMTmEeL-rFGsg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	Fernando Fernandez Mancera <fmancera@suse.de>
Content-Type: text/plain; charset="UTF-8"

Florian Westphal <fw@strlen.de> wrote:
> You could add a nfnetlink selftest to:
> tools/testing/selftests/net/netfilter

Thanks! I will add the test and include it in the patch. I should
have some time to look at it this evening. Since there seem to be
many corner cases, I suggest we wait for the test before merging,
unless there is a particular rush to get this out.
