Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CAA26D4E5
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779745490; cv=pass; b=r3+yZ/8HhMU9yBT9AbYHYibAmwE3yOISwZ20ztHpI54S/v5DAeq8x+/uumkaBClD4P+YQeDfbxEEoJDalm9GFp7jL02qZ9T4QUeDh2u26UIkB1TWijQap58MxdwN3ZVfGMTaeDLUpuQ+HPbxvkcHhvd0Co2gGGa/EZfPCYD+UbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779745490; c=relaxed/simple;
	bh=ohFb5JUUsqtnkWu+wQSsJVMsuG7CcJFkAaC28tSHXlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8r/Hi987a+0QicTqIgZ1Ma9Ra0cPF/FQE2eTCWNo8dsKFSn6pt9naQJwdmrS79VrYHqUNBT303mT1w6mOJcsv166JPSZ0rN7TvYzuIrAo4dnGmJqvpZUlrgvCcfKlygZpP8K3+5M/JkL0kIp148xdlPChIUZ4IYJ8zfMooYAv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CuJCl26A; arc=pass smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuJCl26A"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-482de4ef03aso6501170b6e.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 14:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779745488; cv=none;
        d=google.com; s=arc-20240605;
        b=anhBNWgZpX4qEYX9qwQ3JMSbbaG8OZIvBrPqnLGSqNXI7aijkusIhFQOYQzGjR/X4v
         OwJ5nJn5y1x9I3Jgp2jx8j3CNIyPC4PuzZXrkXCGNXdMj/HOuXPbH6U+0fSSv7pkFOQQ
         9x1B2lYpCvU5GnL6qOCT7rSlQV2I2aOYijgbRqP8BAJ+VpqsZZKb7zVr86MjPMivhL/k
         /AJq0X9awaOEz1ZvrDW1XRNP+iIt2k8pWPpYa9+1nzCvgrYEe47yurA2wiF+45nwkzeR
         O1xxW7EvjlaFoy9gikf/EYbdoxnhiR30C51y/V76tvydOZlpVGb1k58JKikgb4U27h7e
         WQZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SJw+4vUxZAoayUGTaqsiP7xIKkIP7i9ALofQjy5tRac=;
        fh=+xAlKYkTLKbSoNoPyhlLrjL0P6KZ/YIzGlQ7TR2Mdk4=;
        b=V2IpNDomGvqFHmhg0HkW+hiriyliY99iR8GUrLgStkp5gQR4p/7YwoM1zDskzQHb8b
         ILD/aN6gFGambeuiiCUPADyi1uq9Ea/qsqKC9ksu0yfZUYbpLGFo9gIX9JQ0Bk8QVNAQ
         BaGfWXeZh7Ux+a3OniLYQPsRCKKVlIqa/S4IUEXONJ8mk8yHh+pjTWqUUP7WbpX7DsGv
         ytuKPGxMebb+lzrvKlpYInO6Yai45PiP/jdRPO3BVrrPuH+yeb2NiAwzcg5Sex6a6uIp
         ApiO/1BtxwdAbz9MTPPSGsz7F+EelEKhinF4078HzikassO6jFtut+cJoB55Ltfe0oyx
         kP6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779745488; x=1780350288; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SJw+4vUxZAoayUGTaqsiP7xIKkIP7i9ALofQjy5tRac=;
        b=CuJCl26AetG7KSd/fTG+LAv4HpMsNupmHxk7fhNrWE2s7FlmzFLBp9287f9UeQLpoe
         JTeGpinGRZp35P4TpWwsrc5IktKf69zIZvSpqiawOL1Qin9oOHSGr8lbHpaY5V3zx+5r
         zx81Ny3+H2uyVgCCY6Ju6Ywy7gCt6TZYN41HQslN8PKbb/cUj9jSZSQGgy55gTZUQ3aR
         7e4ixTZZk+E+eQD0kdpvDYbPI6PL4APliHUB3TG2CdIKxy+nT2cE1TG8iK/+KfrL8oAQ
         0Z5JOfcW5qbM53aNVi8jQDnUXgH8VGBI8nSgHHUnUHyVNyVZjSsPexmVUz02NL/5M1NW
         qDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779745488; x=1780350288;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJw+4vUxZAoayUGTaqsiP7xIKkIP7i9ALofQjy5tRac=;
        b=n4F4Yi51k9NMhOVORvrznabCERDaWANFd+NvRx4T4d6OsYj4G0eNzMm/h4sS64OW+5
         r9smXYzhTknT1iwDLqTFk0o6bbPynqsruaqO0b9zNimAQ9KmYlCzzit92xDfndbzPUDJ
         4KmEmsLdiHmHaGQOgJ+Q/I5V32mUgHDKEP21+jsg8u7eVRfcKUMRizHX19BUNDYYeB3T
         BneWjpShUymD82pL6JT56fLv9v39R4GYvXN9lpUEISnaCLfqkTBjGUTJzqzUWBQEuNhD
         YGUCr2uSNiK+dN66z98BSpyUQxwlYsvsgjj9+pN9SQC6h2561i6t32SR0QW3E+BFFeQh
         FWqQ==
X-Forwarded-Encrypted: i=1; AFNElJ80yjmcuVy0BMZ8gkcLDygiGevSNrO+BR9cMIQaVoz6j/ZpZsE+Oq3hn5bux+Mp/QHBHk1r/wRDruWRPhilPOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4FpqY1TkYQP2FTfaqQb3alug0vHeb+HFqGwTN54YyWAdlKs5o
	hyo/yAWIAsw9xYraP0YasjHMLBo3ghzcJkJ+rNjaa6PIn2XHAROKbvN1ijL/WV0g7E8A4toL+4B
	HfYoiHfiBt9IjrI+YicTok3VFU8x9sns=
X-Gm-Gg: Acq92OERzldr57kVNiRiMUXIZmyLINkgw5hzJE5Vl9MjxP0sg55aXx+TWN/SHojTdax
	e/5YlE9Qqsp4Zr0lto2S17J4Uo0i6tOp5avk6fD+BfIeNsZiDaMKSGAY+vwetQFRsuUAlgvdS62
	+3GOF/QTO5TGUQLu22tbH3gVF0O2eJOAcuazd90KlsEeMDZ+YXpVma3PBm3LjHxN29hji6gqUFm
	YSV7Ku22jaWy9prJE3ERQ6cX/cEqFpL6sCiE2XX2s39TTpR7m6lR8zxR6djtqqMgzVXnoNFZzxh
	2/yOpt/g5+ogVT3o
X-Received: by 2002:a05:6808:6786:b0:463:a42c:503a with SMTP id
 5614622812f47-4854ae802demr7862655b6e.14.1779745488308; Mon, 25 May 2026
 14:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com> <ahS--cPlhv6NHAcO@strlen.de>
In-Reply-To: <ahS--cPlhv6NHAcO@strlen.de>
From: Kacper Kokot <kacper.kokot.44@gmail.com>
Date: Mon, 25 May 2026 22:44:36 +0100
X-Gm-Features: AVHnY4L0Lr1XHbcvt5E12PJzwDX33S_ExYucZKBalfL_rpD9sdnEVwCRq6K5ujY
Message-ID: <CAG-Fur6f65LeVVRrK2PF9_JNyjEwd3jWR1vcChn-FqZFQrjK+A@mail.gmail.com>
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option is unaligned
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Is this an actual, real world bug?  This code is 20+ years old, all that
> this hints at is that they are always aligned in reality?

No, as far as I know it's theoretical - I just stumbled on it while
debugging something else.
