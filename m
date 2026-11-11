Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394731;
	b=AulijuQSiX8q/J5M7ZWMXAvyzNwj7tIiKbm+Od6KXtSZ/VhN4xQ1ectZSWRyzxnAakRe
	 wrhA5Uh9r9y9q+KQYWhnGINYXWAmVlEklolkXzrQ1zMTFWYuBkAysJOMgvlEcaQGztjlM
	 0VKwTICnzeIQm4hk/py8SBJf58CBjEo7g2q83ROyYdrMCh/Qs4nWgOQ1NYGYkizpwkIg7
	 2Y1CySvXLonC7HWbNUITuBxf6PdSJMZdVxwyASN8kvLMXPzmt0S5MO+HLJgSvR+ZMf/1v
	 OcpfT6cqV439kUHGLnIS+iAUz/jcaPnCa3a8riKnDs67dF/ChIcXa4h5zrDdbkH6OOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sf1tt2v2F7z60dRi/oBz2yd7DEQDV6vHFfI+FVlgCag=;
	b=yKhMAdCr55bOh0D5H+vFgUOA7IWzC+3s7ZqDjKE69VdJmP0TXXdxUCpXNlTnJIQ9ua2K
	 3bt4llQP9gJDkw7xOR620aLqhGZmaHOpvwwe3/rzmMAgjo3BRVFqjzUzSQj9BK1LitfmZ
	 /Pa/IpEMat3QzDXwO+dBvzRBANT33BDwrfyxuWFwKt4fy1bUX5u77fndelZYWaEF0G4ep
	 wFNOWcKW2SaSg0QuVwlGKky8fvO/OIXOy80dy/pxJwAHZBbgdkWXcDaDoeu+dDd5Nq/8l
	 OQnx1gB5hnbrRmHEEve/DqKDp6fDWh0rlgToG7iDSJA5PycG1/icTNj5UgfCz3Xr3uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdKuLtFd;
	arc=none smtp.remote-ip=74.125.231.128
Received: from mail-oo2-f0.google.com (mail-oo2-f0.google.com [74.125.231.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15FB606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E15FB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdKuLtFd
Received: by mail-oo2-f0.google.com with SMTP id 46e09a7af769-847bb37911fso108219a34.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 02:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794394730; x=1794999530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sf1tt2v2F7z60dRi/oBz2yd7DEQDV6vHFfI+FVlgCag=;
        b=pdKuLtFd22zQv3mntfGrLcwzOHfwWeQiw2T00DaqerN7qLMnDjZifTa1fK7SepZCYj
         N5sdJUryuEQB4l9p2551TERCTOc1yQuyL95dhPeG3cPJMsTnbxoyBwzHmPcDxuiaNzmB
         9dR6g3YKJNv18+TMbnVxf61S0DcSvFfYFh9tmTI1iyrRBmBjCcA4xoCm/406tKTnEyX0
         ObNry8SJhz0uUo4izErndqVwsGLOWWZWmTpAEZb9y8mAqOy5k21ODWlsg8gLL3+aX7CE
         KKSyjVvJEt4iRtNGlfAp3XS7yY69oLD/ixbgWPJnaCGvD6vv3VwB5yy777V5hv3OKlTM
         e+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794394730; x=1794999530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sf1tt2v2F7z60dRi/oBz2yd7DEQDV6vHFfI+FVlgCag=;
        b=c5XEZ1tmw9r8YcuN+r20yQwhCzmLz/efkH8KBAhNo3ZwJTESUbTP3Xaw46vD/6qSGs
         V8flRFh5meNwVuWsz2Wi66PCX2HZuhY4G/ovzwR1/OAavohPOG5mGQRjc9XHe4eGsup+
         pQWen8950H9zM71jKY+bzZyyRLSaETficrXiZvx0gdOrmbb6tAtyUISc123k1G0zNq5m
         OsNlOx6Eh5w1Qac2luMVu1AXQY4VUsngnd1Bgm41zeQMTQcL0StnQ0LLI/BmirbqGVx6
         K515AV2YmDd1drTg8JC91vrRn1/aJXNhv4R1kvsi+DTeiFmW8/a2GA6N/ML8FfVMaiY7
         diCw==
X-Gm-Message-State: APuU4Z+FjDZ7NjICFlq85X21DQIzNKOIunZbrljacYaxnQrT+DXW2rIU
	9aw1dfDxOLVwpTQEF7VuHMUcU0Aes2CIGIp8qNQgQW7bL+JhFp9J0mLN
X-Gm-Gg: AYBFou0W2zSPgxmYw8WpXQT5eYs25sj5UVGqiSbiKeLILNPaKgbvLxKZfHbzL/4J1AH
	EYKKg7DFLVLiq7iaCOx114BAW2VFrwwzVcns6lOKX9lP3pE3vkZDEG+NO1ORNDdAmrsUphqm8UL
	emF92hOkh6SP0L9qFwzEx/sWRgT2+E+8x9H8zep2aqHFIc6EHrhgU6yL2jp6iUme6D9NNw+nW7S
	1BgzdMoTooTm7MUflXLvRLo5QVDp22pC3rYm0UWB6yD1oz3o2x2VmFisMSaqHkufqp1HvyYalog
	7M0xs2rQa4foxh30ku+9YMQCKggV6EMDpdDTBcakf3Z43aJxdLUfcaKBbDbxBHzwdGdhEBuK9z+
	zEjXwFqEju+zh0k6YEcsXzyVnkLeVuNVx8JL6qNFT7NH9P8O1ElTxjyNGHb53SsrfAn7Gvhcxr2
	rh4k4MGQzIFUp7v7FlbNmUYaHuZVdRb5D5icoV9jUJQj5b1v2NGhRvpY62JkAvq+g6ZX5f5q3lv
	+BYIGlGVXj1bOsZbGZNK2wnbi8+WMKbRqHuNrFh13hV2vWHrMiESttu0xaKIC9Gk2UJ5H86PflS
	rI4ZIeCD2W0EEDwz/qqtBFd7i9MMfw7L5nMe939JfmQr4jfGVwRmIVkcYvPv7Nsu16CF
X-Received: by 2002:a05:6830:2a0e:b0:823:e626:277e with SMTP id 46e09a7af769-860f281b2d2mr1071393a34.4.1794394729747;
        Wed, 11 Nov 2026 02:58:49 -0800 (PST)
Received: from localhost.localdomain ([14.116.239.38])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-860dcb62443sm4216519a34.6.2026.11.11.02.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 02:58:48 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: fuchen.dust@gmail.com,
	kadlec@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: Re: [PATCH nf v3] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Wed, 11 Nov 2026 18:58:33 +0800
Message-ID: <20261111105833.2060684-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261026102957.5530-1-fuchen.dust@gmail.com>
References: <20261026102957.5530-1-fuchen.dust@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Xue,

Tested on mainline b3dfbde62cf19 (~7.4-rc2), unprivileged userns/netns,
comment-enabled hash set with timeout:

- kernel-side delete trigger (SET --del-set rule, userspace adds driving
  the resizes): double-free no longer reproduces with the patch.
- forced-GC trigger (mtype_add on a full region calls mtype_gc_do(),
  freeing comments of expired elements the resize copy loop may already
  have copied): use-after-free in ip_set_comment_free() via hash_*_gc_do
  within seconds on the unpatched tree, quiet for 40+ min (~8.3M ops)
  with the patch. The forceadd eviction path behaves the same.

The deferred kernel-side add, replayed at drain time, appears to
neutralize this whole family rather than just the delete entry: when the
replay hits an expired element the copy loop had skipped,
overwrite_extensions/ip_set_init_comment() drops the dangling extension
and installs a fresh one.

Tested-by: Henry Martin <bsdhenrymartin@gmail.com>
