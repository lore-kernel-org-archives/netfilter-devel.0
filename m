Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326164963DD
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2026 11:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778845736; cv=none; b=WnInqwlY/XpC0kOrVKRXmraIPJX5+7Vl8kdPOLm1iFn3AW4y+uJIIpe7W+ckZE4odcBEsINOyZasWLnQSJxoT0fyRIgUuPdQG4Z6N55OmaUUq4izyCsGxt2u5SRxTaVeQN2aLFWcNDSE/+7vprXziIgnLuS780BzeUl+wo+lzwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778845736; c=relaxed/simple;
	bh=wwiNcYnDC1z10P0PrRs9APY772ZKV/kzqcnC5P5allo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAKecuLWuiMqNN+k5fQAgzvxQcFbyyz99EB78AOMR2aer54BQeqzRYsSCTGVKKDxh6BfNUXclkKUGRDLsH/+4b7qlQxLvUb/B20f8aLvrkmQVnSlDOiPXc3gQgirOIXlbri69IfVAVRy6bx7cOawimQ0qITMP8VhIWgcfV/oz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXiZjQV5; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXiZjQV5"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2f68f3b075fso13552704eec.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2026 04:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778845734; x=1779450534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REkPrp5VneTuK6ehtYR1UAlutKollViGkaFp6MZ6pyY=;
        b=TXiZjQV5RqNHr/6bEk9wDCgK72Gm24+OtLYHe2Ib1W80uZXRq8bCE55bqcPQZkd5h/
         iW7VfXqcRQB71xdPwi2oJ6IX/R3QNioJQ9xmdeY+rUA0A1Y2c6PbnDzyOkM7qIBxvITd
         De8tnaN+u9jyrQH9wCAm2ybaoyvr0da6yNqN1nIfWyIafMXbj8xMs+g4yDMmCv0YVfa4
         SwXynq6blXJjBMztam4eXs4/HLtiTjj7+Sd32M/JHIMs5g0R/mlR7S9xfSwQ4santlI8
         HJ6vyNcZPfzMf1WNRxR25pyXa+3xcG5vbiVS0g68rI0wI5mGd2QAg6pKm09JqxuEcYUB
         wtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778845734; x=1779450534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=REkPrp5VneTuK6ehtYR1UAlutKollViGkaFp6MZ6pyY=;
        b=C8h+dz/FGDeP/yPdS6boiCaQcBuMwJzVnJ5ZqlsTueFR+znFbg8j0tVklLq8PAj3rM
         Nz6MInZvGJiooCg/IFmKFlcgkKVKFQUZ5zYaljX+6fLv+uvNObSqEI8DvduznYB+jmSo
         tlZM1ojhexHK7euiJerSdwqxis7GZSa3JHFZQ9J3+uU46o3BKV3QCWJ9xJENWWdu7QMC
         3DJK0Rw0mW5qcE75Rm5YrwX7ViqrInAqPdOmMI4VLdvlOq3vJvACvnpbaBYLaMW1Kt2S
         uAbkvWm+JwKLJ7jbkr8q+DGkhuEepAm4Eam2MVbagOl4NrspgP8/6QGf2X1WH71nZYqa
         hNSA==
X-Gm-Message-State: AOJu0YxB1pbt5E483UXXrCoS3idQyqt9kPSy5dEZBTuGzsGZXMjW5QrC
	1QiYygtYKOKCZXVeU2vaJdBi2J+rSyXOvxTOL3Ahd9FfvOKNrv4hLwXQ
X-Gm-Gg: Acq92OHFYK40z9Iw3qOA8o7kLmZiBTdcjAUyWjT4x7IMExsf3w/UjJAn1mTasBPtYwm
	/FTRSMSIuWvemfEUMTe4DK18D1PBsEtMleYwPhISPbFaixC6NAkEVtDOQQfgHUOL9eOe5acDKv/
	tpOUWLjyNXjKbenU0Ypouw92kzXrMUozx3skyizrKtcTAej3jA38i5B4L6DLFKCnimPQAd8nSaQ
	B0dBhbEpT+H4VaLwfBl+ersC+V8uNhaO+in1t4zOeG3++l9W93vyXIU3jv7Ivf36CGgw+z9Pgnl
	8jOcrlsOiQoAUcgTdDHyELMbs6k89AWrkjC3H439wdSlBJyunLedxtCq9uWt3iFka0+STpkxRBz
	kEpCQY8qeNBMII4FgTAxnmJ+OkLyeOC7hK3VWsUuzpNZVppMoyyiBzWNrYqfVcJ4y9YscfjQxS6
	2E1UKtEZlgJbJRhOC4UD+Cf3V29nhGZEC55A==
X-Received: by 2002:a05:7300:ec17:b0:2e7:c701:aa85 with SMTP id 5a478bee46e88-30398626570mr1942874eec.17.1778845734267;
        Fri, 15 May 2026 04:48:54 -0700 (PDT)
Received: from localhost.localdomain ([148.135.103.3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978b3cb2sm8288053eec.30.2026.05.15.04.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 04:48:53 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	pablo@netfilter.org,
	herbert@gondor.apana.org.au,
	michael.bommarito@gmail.com,
	lyutoon@gmail.com,
	Qi Tang <tpluszz77@gmail.com>
Subject: Re: [RFC] netfilter: disable payload mangling in userns
Date: Fri, 15 May 2026 19:48:48 +0800
Message-ID: <20260515114848.1105927-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515100411.3141-1-fw@strlen.de>
References: <20260515100411.3141-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I agree with the userns block.  I'll keep pushing the five
consumer-side bounds-check patches: root in init userns can
still install the same payload-set rule and trigger the same
OOB at the re-read sites, so the underlying bug fix is still
worth landing.

None of the five sites overlap with the relax wishlist (saddr/
daddr, transport, linklayer).  Same class showed up in an
earlier patch:
  https://lore.kernel.org/netdev/20260514035802.1540395-1-tpluszz77@gmail.com/

These five are unlikely to be all of them; we think the
consumer side warrants a broader audit.  Thoughts?

Qi
