Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB403E558E
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777920444; cv=none; b=eK8XN7r0U65oHYHoTXoEuaERVkc0LjrPa++AfPxZLPmGYiadFFbaEFWxcRp4C5MMVI3T+FOHSQUN0H38p/y8GDkPUtwCN4UciA56/cf4djTZcj2+DWJJQJboOi/DbKXrZEqeCiZt8L62rEBGj00GfWBLC5PXiRJF8RUtgF7yqo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777920444; c=relaxed/simple;
	bh=jx3SSsyncpOgFT3ZUj4BUS2vdlPaT0opqKezABr0XlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KDTY5L0170Y4g5m+MPRFWugfqlAt9vakD5L/sMuZ/RrvfxjV2rVvV1C/VgNiqtfGMvoPRC2ZsavLkf++pPG6KnitCi2WnYUR2vdHeDXiKEMC477vgtvMObbddysX8q2kALkFHIF2sUlvgU12ZOXpUN7fGX/5eQ66nhNik11xILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pytxNiVC; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pytxNiVC"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48896199cbaso39497565e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 04 May 2026 11:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777920441; x=1778525241; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jx3SSsyncpOgFT3ZUj4BUS2vdlPaT0opqKezABr0XlY=;
        b=pytxNiVCoeQEw7xeT/osGsu6S2YgSoHwImbhmYFohF81IfP6iwKi4kiOm6pyPT2YU0
         PgojadXkh+V8mBEvBQpSxF3WCEHUY+VK41EE9Ph96vVt5BSTLGRhxRsSiri9F4DK4yeG
         kb8XdcgghZvkmoj4CvUhF/5VR7OhGjWjPdDTja7t+5gKhuNcH3dJbnX1Mu/DyXWpRqlm
         MfM7p3XiDel1cTAcuQDM30xDNdtEM6RKDgNMuCKo/YyPxlQVLz1kCa4TS7ZJexGEpbrI
         NBwYY1+fpN9Ruf/YfPQ81CqbzJAN3fx2ELDu9NQZlBGp6WvU3e3MSB8084Wibc+GDciP
         ix4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777920441; x=1778525241;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jx3SSsyncpOgFT3ZUj4BUS2vdlPaT0opqKezABr0XlY=;
        b=cCynu71UyiccNOgKdMOhtNd7YRWujYP8NkjvVM8KmjpIjAE3am2eq49JFpeM699sUk
         nnofn1yBsDwoo0kfGe1erQEg88i5wzjE615m/Bh+h8LQ+PDbHYWcx3q6ov/7H+fOZ6A0
         j5cDoZ2gn5Rmcjmf2GiPmJ3eqmgBqakHjA8n5/S8TVxG6QYbAgmVij+dXT6Dy6jB12i+
         fnVWZ2P/5zbH5Xl0h5yk5fxe0KkKZhf88v4ZzG/CsgMCaqjZPMl1X9b0gby+Xq2BQnLL
         /a51tU1JghyqGctLz35p1Dp9DUw+cJQzgImE42ZNV2TIxdLxXpmJOf9EtpY7JfC5dv+G
         0s2w==
X-Gm-Message-State: AOJu0YyihuY8Tj5aQUtvjW2iitKLnBx0yHCx7whtg2X7yrHsjK8PDxPW
	d0a9Buq1bRcWaU/vW6zW2mi9P6Xa71+uev2QM5xP9dPVwXaZ9gzPZxOmMPsp
X-Gm-Gg: AeBDiet6ynLYygGj7nn90RSbBMkzzmTKTxTY77B38O14jyRBwH3jXCGwe4q2vd9bLdX
	ReMP03uZ+JuOSeCGoG+4rQUCa9sFon9SyPMWWmHeyAjvYKA7TQcN4ZOAe0hPby6EMbiPxatWK8G
	8m7YORomI2G51fBQBieOHKoFFzgG3PeQGEIabPhc3SOVhwT8tWSiXd3BDHjvtb8kolTZVvaEW47
	3mAeFMB5oxMi9t82l25xz3RibWux3Z5tcfkrLz1R9c6Q3EuwZls0OQhCDG8hTLBsEZHwWb7Gmf+
	vpLFrCiPUZ/ZjubxZbH6Hm7XxVXb2L5cgDLR4SDyUk/Tf1gWDCD4Lf6V9vezwOIGzSeBp+YEmuq
	0OKJbzUW7YtpTZ7PdG1KJG+4DA6uvGs3dfE8ELm/V4j+psUaxkrxiK5goRSVAGN4aoAgSdCLJCH
	Fc
X-Received: by 2002:a05:600c:3496:b0:48a:53ea:13df with SMTP id 5b1f17b1804b1-48a9852c565mr185503605e9.2.1777920441393;
        Mon, 04 May 2026 11:47:21 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a986aaad6sm24789727f8f.28.2026.05.04.11.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:47:20 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, tristan@talencesecurity.com
Subject:
 Re: [PATCH nf 3/5] netfilter: x_tables: unregister the templates first
Date: Mon, 04 May 2026 18:47:20 -0000
Message-ID: <177792044028.2307140.8003648539483235646@gmail.com>
In-Reply-To: <20260502075639.7440-4-fw@strlen.de>
References:
 <20260502075639.7440-1-fw@strlen.de> <20260502075639.7440-4-fw@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thanks for the series, Florian. The approach is much cleaner than
my original patches.

Small nit: could you update the Reported-by here and in patch 4/5
to use my development address?

Reported-by: Tristan Madani <tristan@talencesecurity.com>

(Consistent with the Signed-off-by on patch 1/5.)

For the series:
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>

Thanks,
Tristan
