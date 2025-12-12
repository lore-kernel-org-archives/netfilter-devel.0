Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD08126ED3E
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2025 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765570440; cv=none; b=uN8A4KG5iRrIDNWW967/Fmb3MRibBwwqRFS8Fawd+0rMPUWuoyf5nTsCgCf9obd67mUM3YDOzxY1LWiCz7RJ72UagjbcD/DgBKwCQ69yV9H/lNIDf3e/YxXWeSsRvzKAVdBoPvi27/lLAv2T8WL8zTFw8DjN6gRsG6D07TB8rHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765570440; c=relaxed/simple;
	bh=4dL6byPfat9On/EjO33y2mJNQieTHSlSNTCcsPe+q4w=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=MLT7q6nXO8swJOO4RgnUSWQgpogTZNp7HNLuHu0PnlUG1LEK9UqtlfjLv3neehPjQIuKxeqTYOfAav19DYHOYj33hOpSZW7eO2X17IZlQM3VeBs1oM/q2frKdLxORPfdff/JXOqfC5QKD7sPKH9pHpEVsjAzb8ZVX7KoNcNhNss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6VD/yZb; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6VD/yZb"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c75dd36b1bso1218196a34.2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2025 12:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765570438; x=1766175238; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCtqwVvfmh9nSUZFfslmYUUcJYJfAJFfzxmpm1i7FFY=;
        b=f6VD/yZbs1oYIfRTH2JJ3yOPV7BMRZta6ZeiLrZ3koBQX03CVuW5xCarhclIH9cR0n
         3TG2U2Qj0Ee8mL3hv7JLauuytMC8cAI9/F8wt+paS3LjNDr8HcvAdftsMbo2vRc9r1/p
         lX1DLerb22gufNtLY78Y0nNA3qp8T3XNiMyMeP88Vv2fqBhTzOmn2Y6CLr554R2pmOTg
         T/r+KuTcup9T9F5KfoUj+mbLCFthsW9H5drUgagJFp6HDGrEOX5rEfzXhHmTUPMRO5Qg
         v9jjxy1VXgWGQhdwCWI8WliDsxyGo64fJs9PCN3fn3H6mcxhxNxq8KH5INJ3xGIvF161
         8GLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765570438; x=1766175238;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCtqwVvfmh9nSUZFfslmYUUcJYJfAJFfzxmpm1i7FFY=;
        b=PBkbqY9r8xE4G6dlHCT0nh/cm5oTwx/0FMots6tyLtHnR6B+3FfwSJ+uxpvnh2vnHD
         jty8Qxy2bpzvJnHl5WttkUvorKTd7UiypYvtXvDoOmxNiSSXewooouKLtdET2mXeXLr0
         1NvMcljsZ9e01/JFWnk3aoVsHMFpDHEfSnV5KEnFU6qGqtGY10LiuDzTi3KhumMa7vUk
         DZmYvUrTtRE+JskgYKRcEX5kK1MSaO2tv0o46jVq6V95zayklC2t6zAfg/KQ+BPNXgC2
         KHr/HjCQAxkDe7wPsgWOeVq1zlYjxMHMwAL0utjL1uDIjdOg/3y3A8Sdmh4yReA4fWZR
         K+uA==
X-Gm-Message-State: AOJu0Ywk1fKbargxLyTR0X4YfK0s/jKmaOGajPO90cOYYtfuLhUkptr5
	YVHDkBQ2pcu8Q84AOGlexHYz+rcgtfq9SXRwcC+xFAKW1nO2GLx278uA88Ms3Q==
X-Gm-Gg: AY/fxX5LE4YGWcuoM55UXBrfrL8VmXXL042lAH9yH0g1cLXQDMR43jwuIsZ0phMHgIJ
	zmVd/v7+KDI49HqG5gsEk8jEcScvCQmYfEe9nMiscjRQddFDPTRSiSQAHafW1PAJenUU2eRRA1H
	+mJVnwBbWQjg1Wu4c72jqALsZIaxcYlx1+/5EEism5rOki1/B1Z/kCFCudN53+15+V/8g4hMKLJ
	D+cLQhoZlQQ0dzFx4//t2OU/x29mIQuYbRQ2O2SK4XHBtiX9MV5VRO62KF1DERhNL3AGmFaLI6H
	a90UN0bSNC4/UCxIwWPoXj0CD8x5k5SgbY3tpAN2OTKfWr00Fv3LnTt+F9Z7jevvRn3wUgKXI5g
	URlNcOuZRey6YhfsMmDqdGGBgxwE6pICzYZVPL5iszZrUVr2NAUeYRdyLNZ3aFNrhL5AfVA1t9v
	taAqOKhmyRSuoHTlce1TfVxWKGOSQzzh+cEtjHEADDhB9EJWtlDgZyJao22aA/ytkKFqvmQR22r
	dTZrw==
X-Google-Smtp-Source: AGHT+IHyz7wtYAp8xrC88N2upPApoCGv1I/VEi3/D7FpVrFFBD358uK+hrK28ELuzIdl0c4Qa0HnZQ==
X-Received: by 2002:a05:6830:6e03:b0:7c7:2eaf:3337 with SMTP id 46e09a7af769-7cae836aaa7mr1335248a34.27.1765570437776;
        Fri, 12 Dec 2025 12:13:57 -0800 (PST)
Received: from [172.31.250.1] (47-162-126-134.bng01.plan.tx.frontiernet.net. [47.162.126.134])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cadb2fc086sm4048638a34.18.2025.12.12.12.13.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 12:13:57 -0800 (PST)
Message-ID: <1944a019-39af-46e6-b489-96715dd2dd01@gmail.com>
Date: Fri, 12 Dec 2025 14:13:56 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: netfilter-devel@vger.kernel.org
From: Ian Pilcher <arequipeno@gmail.com>
Subject: RFD - Exposing netfilter types?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Recently, I asked what I thought would be a simple question.  How should
an application go about determining the type of objects stored in an
nftables set.

   https://marc.info/?l=netfilter&m=176546062431223&w=2

As seen in the response (thanks Florian!), doing this for all possible
types, including concatenations, is actually pretty complicated.

Presumably, this is why the NFTA_SET_KEY_TYPE values that correspond to
simple types aren't in any public header.  Instead, those values, along
with all of the logic associated with complex types seem to exist solely
within the nftables user-space utility (nft).

Of course, this presents a problem for any other application that wants
to work with these types/values.  Today, any such program needs to copy
the values and/or logic that it needs from the nft sources.

Is there any reason that the type-related stuff that's currently in nft
shouldn't be broken out into a separate library that other applications
could also use?

(Or have I missed something glaringly obvious.  That's always a
possibility.)

-- 
========================================================================
If your user interface is intuitive in retrospect ... it isn't intuitive
========================================================================

