Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132233F44C1
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006148; cv=pass; b=WwXznCLAkNA3K/noRnUu7WzfOXZiIDZHGAtnOFTnxbL41HVgiLJurNspOXhm1L/D31PDl+F0DLPUEAhdR8PkHEBvCgaopoYobemhcuoCqSShjRa0mnRjFoDHZ/y83Wt5H3SpNGX2mREqtaNdzkceWW7yStHOUI8Uuea7DPeF8zE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006148; c=relaxed/simple;
	bh=FKJs8B/CpzRObFelhj5Ni9IZqTohjsKgThlEuhgNuUs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qDK2TOkjO6C2E/CiEtm/HiDbTubBVZXDmb7LMzvYUHmmzM1lpcgZ3GKa+HPB7WiidO0qPq2BotPD2yuT4qQoS63O5ijQ6hBy+hKMl4W8A6jisxzUDd/q6z0G5UCSyFlkKUJcEvp+s6j1KklVCUCtkCeL086x2qAd3XXUMyZI3Kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eM8rVVSy; arc=pass smtp.client-ip=209.85.219.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eM8rVVSy"
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-8cce26ee1e9so83602786d6.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 04:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781006146; cv=none;
        d=google.com; s=arc-20240605;
        b=eBfNofPMNQv3QqRcAdvr9YGsqEMhADVzsdeWvy7LVabNBF8+RX00Xteqe0oCMa7Lyz
         mrgObes+4G9VJfBF27B5UGrtP86lSsbzt2qgemxNvbA5fc7ipyhZPMTXsQa9HrzE7N6z
         qRvo9DWD/Oqj8TC0gYiP+A3PIJWgLCAd0Aku48UvW0A2uskLKlReDlz1mEzjwml/tD3v
         ILnrk5DCgDy3RJ/qgY0ASUeGhYUQvnqma8uJSoJJXASLIQ6ic7eJ7Trsa83Qup73XwDR
         gsNfs1SM2w0izPsf7w6V0eiLiuIhNsBt2/HQEOS4MVt7wLCrDsLib/byUOrHcR6o8yAq
         xGSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ccLfzzecOI94kITVqiyQjRCRJIDy/3yUfKVrOQs2bcI=;
        fh=o4sEFfQnWbu/ZSS9g3GMfGyzD2oDMHr/TAwsbTMxN/o=;
        b=SDX3dTINsspk2X8eU2dS3Hd9taXH2/9+vWHwgqj/OnzSCEN+jFl7lQO1q6TUAj14Au
         BDWDUcIvalmtT4hFH1s4tUFsZhBiBewJ/9aQYR+1XyruA6AH/osMGPQ+9pirp6x7CgXF
         DYJdF5mhLPQcgL88ea2J8cWxxumajtQHzvsBengwlnvdXlVX5em3+tc29SJqWrumqQFq
         b1ZyqplvD1VgkJw1sUGWnMmOzgsIQYC8VPKqG+G4190BJIPyITY6KStGeFpW1f8I2l2j
         aLI6Er1WGHl79FE6SGroDM6ZY3mGrkgiKEJ+ZjmoVQIbTRMCDLFmtZtQ31bNKaGk1nad
         3Ofg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781006146; x=1781610946; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccLfzzecOI94kITVqiyQjRCRJIDy/3yUfKVrOQs2bcI=;
        b=eM8rVVSyj6nOD6r4GepekEv9mlDw6sMkuXGGSG9Mtyn3UdyMtKNFRUpbfhGraeaaq0
         y5h4Mj7GCI8yXd7vM4L99+L021+ucu3+8fTWuvQ9lqSse0S4uco4bgEiygytsXAU50+k
         BLl3yP+b7lWDqH2Q8jAMrisw0M9cRsLNk5Mw8nlfYTAG3EtH+cuC8fWfue7CeIbIAWtU
         d2vefPV5vvGzF4gXoi4JZG4NpkiUmi++xDiUQ1wYzlHgRu8qOG/Oftwzr4LZlcoyhPBM
         STB8Cs6pMOjJ7kI07/q5DG7ProB4lLequtyP5MIAuCjSjjA2iMZJ4vguxtQG1UHkqaxS
         QvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781006146; x=1781610946;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccLfzzecOI94kITVqiyQjRCRJIDy/3yUfKVrOQs2bcI=;
        b=hE3hNOuN0/2wfmBOSeRMFKT8MTGV5hzrk5mCXypqXesl9t2s0tEjT/1OGzkG2HNomH
         Mxqg/03fKRYh2HU+DEu4oM8Z2IH8/Xip/vJ23QwePkDm757PyTD5asGqlidfdmaK0KfR
         /vXitrFfEr/RLcOyCcULiBh6daLwIx3ZpW0j4xGa/lVNDGjrNdusLA8dDo0uHaaQNhEF
         UdmHIm0vvdytk0HMl8D/vqt78AY5E1uIYpKg0ZCoSuDRSQ+RD/Q4S/9IpJk/ohMnEOse
         6BXzEIdk1JosUDCdr/3uaxfV3vjCVYfE8LfSbLSh0UvgX2igd0ZmLOM0JSJ9aXsOm8gc
         7EPA==
X-Forwarded-Encrypted: i=1; AFNElJ/7IiUCmCWlxRkAx+hZ4aUZakllfoi94XxWzwgYN8JFyDSR8P07p6D0VzwY5xmb2KGkP5WRSQGRHnefSZxTgQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgcGrQ/ewLtC508FVYKhW1kjEawFxIzP1hLDUynl+vEzcERCHy
	pzMjGvzy6mnUkOZKp7iWbC1gbQFH9XXtgv0+82MFtuFLPy4Jxt+bkniyxY2d7ZCs4cnRPCF57Nq
	ptmn5mNYqJt1CnS0fWRG3IkBkZYINd04=
X-Gm-Gg: Acq92OEibcyY7H6ouKNZEHWsXXNxtX9bZYs0gD2FVsvOkPhmZCyQYjDq7u2DIxAiflG
	PdUNBVzWzCihTEeIqygNARB3jxd4ReMerCi5hOP7cunEdgskpuybvk1m1fiZSbSdvVasAplpUYK
	LSJtDolFMcyiQh1lElA8uBWvJqa2c9sIFpUxYGvhQqGxCcO/+/SwhGYvx8OC1qYlHFCRIwsE6h/
	lrAK8stSvNumeFTXCulfA8tCAi2SY1DViU+c3d7megUzFtgd8NfhXsHAncxbEYXuxVF+vjLvKH2
	7cGzqSDugGiC/pPrL3z/jFY7nJxE
X-Received: by 2002:a0c:f156:0:10b0:8ce:b2e9:a4bf with SMTP id
 6a1803df08f44-8cee5fed2edmr261948636d6.16.1781006146033; Tue, 09 Jun 2026
 04:55:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 9 Jun 2026 19:55:34 +0800
X-Gm-Features: AVVi8Cf-JY9xHUp5ARwbSMr5Ssxu8o6eb8KyWoWmOUOtK_hy1_hOV33TAjOBkZg
Message-ID: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>
Subject: [Kernel Bug] INFO: task hung in xt_find_table
To: syzkaller@googlegroups.com, pablo@netfilter.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. INFO: task
hung in xt_find_table. Details are as follows.

Kernel commit: v7.0.6
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

==================================================================
https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?usp=drive_link

https://drive.google.com/file/d/1ELWnHa1fKJSXMFMNxMzw-Yje3XSETRBt/view?usp=drive_link
