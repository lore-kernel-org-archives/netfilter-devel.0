Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE4F4E2
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIjI7bmd"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-28c0536806fso6786817a91.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jan 2024 03:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704195262; x=1704800062; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoe95m25lG5GyL+nMwNC6SAg/ypGavgT/1S1Yjvbw3o=;
        b=YIjI7bmdvmSjKVVsz7DNyVGuIBJebTAkXIczfEnzKaTvqWHRgL0IfcbYocO89bL+/4
         q3qVefffSp+5uUcdB5JyH6jQf3Uyz1qrK1gZvXrh+fdcOztQaG90vOb/0nB9XxgfPMBG
         eYdDp5hTEGUq92yrVe1zJv+JTJHGumGExYTQFomvbaWQYgVjs17Ho2IlC/l6DKZq5aFg
         ZNimLuNeJU1jhY58Q0eyl+ckRqRrXEWhUYK9lphr2wJecOcYAjQyvx8ye046Wo10dYJw
         Bi36D+U9Bxga8iG2IVEjwWx4HF2UlVxeG3OXeWeAvGbXJlXlLNAruvp+QaOBdaPxFt4P
         bHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704195262; x=1704800062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aoe95m25lG5GyL+nMwNC6SAg/ypGavgT/1S1Yjvbw3o=;
        b=owGF0gU0UOCDQdpsIRcQYP9rX+3/lwrYYJLPwhP89Aa63lnu1k+e93OPHtZEutB+DM
         dn6BaXHkpPUtrfSXqP/ndgOUafqMsMwgvEAWmQ+qz792AxKMQrcMspgyC5Rls1U9kfXw
         sqg44iQBGISiHp1Nk7zJBnTIaGJJxVQ4yf2xJtx+tLhyzNi4tKLJKsBrXr8rQF2QvKe6
         L6gVGu3cUBAZxdx6u0fexrjDOfvMA6O1dahd22gfLDP5CE68UsHW16l5Fod6NskWsyBP
         tOA99ML1o4ZLrWB0/GVrO5hIEXKxjssWXjqrsxFgf0WNvIGBR2K9KOmX1WTD4XiyLNI5
         3PTQ==
X-Gm-Message-State: AOJu0YwWz0dgJLpuG+tvDBIkJdzM4+aa0ZG+g16pHlE/NDdZ2alaESTs
	3dnX6cWnIg7yjs/lPEsOoaFk/6tjKLYg2qSitOdIIoiTKAc=
X-Google-Smtp-Source: AGHT+IFJv7D2tFfsu+Yn2eBPIRiQ0hyOPf4j54vrPqAM26I1LP+A2FyLGpRJ6f5LXhB9Nd8HScTkToljaAgMu0i5oPg=
X-Received: by 2002:a17:90a:aa0f:b0:28b:dd93:a2ee with SMTP id
 k15-20020a17090aaa0f00b0028bdd93a2eemr9069368pjq.95.1704195262341; Tue, 02
 Jan 2024 03:34:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
 <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc>
In-Reply-To: <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc>
From: Han Boetes <hboetes@gmail.com>
Date: Tue, 2 Jan 2024 12:34:11 +0100
Message-ID: <CAOzo9e4o3ac0xTY4U3Yq0cgrwcaK+gYoyA3UH7xZEqQ6Ju7UYg@mail.gmail.com>
Subject: Re: feature request: list elements of table for scripting
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Phil,

Thanks for your reply.

How does your reply help me produce a list of IP-addresses? How does
it expand the CIDR IP ranges (xxx.xxx.103.118/31)? How does it expand
the dash ranges (xxx.xxx.103.115-xxx.xxx.103.116)?

I don't see how your reply helps. Please enlighten me.


With kind regards,
Han
