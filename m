Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C7434A796
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 11:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780313602; cv=pass; b=WA5LVKnV9ZbYysXbS2XxqhIwxTaC2SYgilivLuu0t1nGNoY3+bV3Sa1gXK/LpDepIZPm/IyHu0yoNhPBdSGZgKOX2iTfM2ionDL030UPsE31/VW26504KtOBWqz/ycfZlwBlinF9ww/Ei+A0HVNNFi5auPVTFdN5/7cxQep1uBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780313602; c=relaxed/simple;
	bh=uVMhWSI3M7PqFpwkfEATZt8vBsIE3hJ1C0QZF5LG9t0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dCmogWgQ3LvQ/pmR82lWTWHwWdc2FbikibjFVedUVYOMya6Uu28ZW4wxKjbgBAeXlucEjCHsqNbdFz5/wY3zaWxr3rrAkYxYCrSt0Nxx82hMvZEdo6n7aCmak2DnyDsHhx6U8a+x1/UuElNIMyzjKqmMGUcE+XGAyLCT87qPR0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=NxZq/K5P; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="NxZq/K5P"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf36a6905cso13348995ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jun 2026 04:33:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780313600; cv=none;
        d=google.com; s=arc-20240605;
        b=IH9b3i3Gt6NyyWaLsP3TaVXLx+T/GImzlhCFrvypX4iLRah52kX9te2u5j3J/zSFM9
         pGf8bqBGl6G9mko4xrzm4F9t6w5K5LVuyYSk8S4h/rD/5n34egOSubFqPto3FJKlu5Vc
         MTyhie+W2EQzmyn/bj4PP4+X947fy1yvtA9sRhbW6eHL42lTi3qu5BpEHZWwjK/Wb0FW
         2bBSM81dYSdFKQR400edDvVTNOGbA60jyi0E+kVnXQpoSKubfFyUhHvotvQw8jWA8M97
         XNnaD4klsaM+S6u/yzGxILp/SVfz5sdekYcx6Ba2FhWzuKcijVc/tBk7sBDH9nZsfRYV
         93IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uVMhWSI3M7PqFpwkfEATZt8vBsIE3hJ1C0QZF5LG9t0=;
        fh=uRj863t9x/xaEvA46vPf9XZ+d1kJdY0oDilRPeh6bE0=;
        b=VtKjtLVCUBQ193l0O9jw4mjk8GLxiG7Um+s09ban+kHMLsMxTPdjJYabfTwgImvQ3o
         pgCXyG1tZFWgFDvaPMcxUygeJXT7FzuFVgE4lS15JNEvN53bX07qhfiEdFiE6OZDkHlE
         v/kZkGmMSCM9KZlsoxi1ybpHzGL/PCAkxwSGKA5mCiR9E/dK4NqGr3gCcSUOd4I+vFA5
         2Us10essk4g/YJgrVJDwaGY/+ZBYR2KzpYM3sAnBt9eRG2OgcW7a+q5JzGnyEAKPHwdS
         9vWDDAVbEr5MwnULU6e0YkG0PALTCUQ6BQEqmuyX2rAFhQOGFfovS2XrQ5HQryRGPxvg
         idQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1780313600; x=1780918400; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uVMhWSI3M7PqFpwkfEATZt8vBsIE3hJ1C0QZF5LG9t0=;
        b=NxZq/K5PUE0h0E5mGzSrCcr06uEotsZJnn5qP20NrM5IJBFexugyZDJon0nmo7VDjK
         LAsOk5Kav4Jj2LBD7XkQV9KBDwQ0DJjBWBd2u5tdFg443tQC8c/v4YGU0fSgAeinMXtP
         UILenMZXPIcO414OeOhdT3GDiKYB3rE/cdROQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780313600; x=1780918400;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uVMhWSI3M7PqFpwkfEATZt8vBsIE3hJ1C0QZF5LG9t0=;
        b=f0E4rKvAdFDSiuiuoMmNz7aT1baphn9yO92Gz55GjfTcwP26N+S9JhMKrM53VsDmve
         rJrGEK/I+ojzX+8nnQ5rKpLgZaPF/ATTTQhkGEMlENmyjTgyiDDNVDzomGX9wsD4N2qV
         vnOBpZW8ZLNsuZn1Kd4Z9Vh1+q5rJI5b8dhzc6sXRN3OnVL8i5/2u51Bpx4Ohldu1XvO
         rvP7YyM7UzWKCK3IrUU04w49QW3mJNGqZdy9ggxRje8IvNcj0YogAmUki3iMLRPXnvX4
         yzStFdypzq43v8ak1qSA96Dl2CFjyuJqKrXwLvk+zIBZSeFCFnEcdoxff/neAcCoeEFX
         NkNQ==
X-Gm-Message-State: AOJu0Ywi2Cnj4/9qcS6UnN6m0l7uGkAjRhKIdKkMKTHzPzIhqYsS98tx
	+vM5r5k16j9MLiojt9fAd/01o2Nfs6k88jdB2IVOi3xOpbLBkzxQFC8sWHSXN+KlebeMWHjMQNv
	xGwn7VmaSta1/eu26uH+N/rtLSGBPxJNgvvhxXJuc
X-Gm-Gg: Acq92OHbmspca7VWz0LInUMPaHN+ibKxnYmJYHohhKs6oicJNFzNkodW4B0bzUc4HMO
	uOELKK/wXHJxoUVsnrrIZY5wko79mQ8NwY0dBSvFaIXfhVNG2gY2ZhOpWfGtCmXCyntG1sJXm15
	2QOXNz4WNzHEpj7Ic544bZa9ydkD6KK365ZJp3zf1hx+ZFS5SBVhBojpHaqrUh+CU7WeoPnEch7
	rS0vZ9RxmEVkO87Q6XPbgQeQieFue68i0ZU4PSEfF0GA2XYGVAKDGtnRfEVl05EsjQMLMYfdM/3
	/zupCz2z+R56lRtpSIzDZLMsTg==
X-Received: by 2002:a05:6a21:7a96:b0:398:b433:87ed with SMTP id
 adf61e73a8af0-3b427f5dee5mr11677802637.44.1780313600132; Mon, 01 Jun 2026
 04:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 1 Jun 2026 07:33:09 -0400
X-Gm-Features: AVHnY4I4Oq7kfzkvATZfqv_I4dIxsQYBxFxWE5rf6WImcq-_O15EbAx7JO-P5HE
Message-ID: <CAM0EoMkbu0Y-qhtdQ03Zn93JKOUHd6yZy-DJ2mtYDC6aehsR6g@mail.gmail.com>
Subject: Call for participation: New Age Tooling BoF
To: Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc: netfilter-devel@vger.kernel.org, 
	linux-wireless <linux-wireless@vger.kernel.org>, netfilter@vger.kernel.org, 
	lartc@vger.kernel.org, ovs-dev@openvswitch.org, bpf <bpf@vger.kernel.org>, 
	people <people@netdevconf.info>, PJ Waskiewicz <pjwaskiewicz@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Apologies for the shotgun - I wasnt sure how to best reach out given
the short notice.

The recent AI tool bug onslaught (on the victim side for me) has
highlighted the changing landscape on development tooling.
As an initial skeptic I have to say the quality and accuracy of the AI
analysis makes me feel like i have been in some deep slumber. I am
still very clueless.
And for these selfish reasons, I am helping organize a BoF at
netdevconf 0x1A (week of July 13 in Rome.it) to discuss this new age
of tooling.
This BoF is a catch all for folks engaging AI in security (you will be
in a friendly environment!), building tools, doing code reviews,
generating patches and general automation. The intended focus is
networking, but adjacent areas are also welcome.

Come and discuss your tricks of the trade. The contribution can be in
the form of a talk, tutorial or demo.

cheers,
jamal
