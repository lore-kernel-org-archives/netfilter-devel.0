Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD8120402F
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729272730; cv=none; b=EkuYFi9eyelnHTVuf3K6KS0tI17CSeKk7tPNSqfLPTEJQ4J4RIba1DB3mVtwfEXo/lb0OSgRWKmJUZ0hjXgteJ5GhcOXAHtCyLxy9HfXPD9o2VQCLtz1X0GZBzFvOk588V0Q+BVPBhkrnUrSueOMXOwVugspIYDB+ZEwmUTVqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729272730; c=relaxed/simple;
	bh=ZDNe4EoJkf/NTI16rB8s2nptcI5WCsAG5/CIj6chawg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=g82ywSxVLGGlXfDIG0hd+B3+bX1z03CKFiEy2RrxFSjw68zCyiAlw5x4xQg/NbMlo3JQUyKj1u+Dec7GrRs+YpNKJNymzYeMoSlGcYaIVkfqoNN+C+uEXiO/ZxpoAk4sXuPw3pMOGv6RkkxAGZM/fei1NwvKpwFhuQidW6QEjSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geexology.com; spf=pass smtp.mailfrom=geexology.com; dkim=pass (2048-bit key) header.d=geexology-com.20230601.gappssmtp.com header.i=@geexology-com.20230601.gappssmtp.com header.b=0iro5a9f; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geexology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geexology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=geexology-com.20230601.gappssmtp.com header.i=@geexology-com.20230601.gappssmtp.com header.b="0iro5a9f"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37d495d217bso2232706f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 10:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=geexology-com.20230601.gappssmtp.com; s=20230601; t=1729272726; x=1729877526; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r3KTpoPfawcr4EZRtryeoMzkWozNa4TDFm7fO/2KthI=;
        b=0iro5a9f9zFAJNJDZrnkXdMa+R8WPdJ8OJG+CdRHlDjfGC5LK/hoO1d7Hq/AxhSW+/
         S6Ka4iJowA7/xGWefrn1HmMR3QX72WhQcIynaXb4fKjthjlscNZybFnjl1+ZHV1ln4ke
         sEpOS6EiDOkwRfZzEcnx2qVhF3XfizxuCNNyHJQ040Dvg5o2zMyvtni71A+rwZGmvKCp
         2XlBFr9yB9i3WwESaiSgU9TVYPkO0aTn144Qadw7V6meoROJXTszrLtOucR54hh70oM3
         yt6s4+DQQL/R6y/tv9ayE2GgmTWGMotIE8uQhFkNdcWY+BOLKOxY8yHOTmyPY2hua6SB
         BUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729272726; x=1729877526;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3KTpoPfawcr4EZRtryeoMzkWozNa4TDFm7fO/2KthI=;
        b=CVuKDqJ7PvwbIQiA8M664Ka0yQ0B6WuV7i8DiRo0ETO/V1VxxSlnIF0yMWhU3E0r0b
         T+8rfjWoeaipmDAqpDfpIqd704Ek0BFeQnGcn76i0wfUnR5SWJ3pALiMuRpsZEWrTKqE
         Hz6cPXfi6AuRSsDu/8Artn0DNCX766qHuEjGIgqDDI/t7KsByNYYmT8VL8mlMqeGPriZ
         Ok81kbKOD29JfsNpBMNP/Uub/7Iy+F9Mo05+AGJFd4B91xQ6SkF6PbobYUkLAxGweEDF
         kR4I1BxQhr/aykzatyihLyY/hT18QnA+dtGmcbBlXdrp1E3ev5cVtRg+AGEET7iCFuka
         L0NQ==
X-Gm-Message-State: AOJu0Yyaf/2J0v0ZObTGU27PjbZFwNseptH0KJI230gpz3Epz0r+gXpO
	oktOFOkf71wSuvDFh2oQ3jzUMgKOG3P789MbriDyEJjuX4JJ7rdUHC3LuilW7770SoZjMGPwzOs
	f7NDrBlAVt4MliPwbJQ//YXGwco7M5yWKhpOw
X-Google-Smtp-Source: AGHT+IHv28sHijUf6jwlEORDaw8A81AN0Nf1nkfQ7GEiWy/uQaL+KTHzg/srThsbqXgVpV3A0488MhKi2UIGp7kAxYc=
X-Received: by 2002:a5d:424c:0:b0:37d:51b7:5e08 with SMTP id
 ffacd0b85a97d-37ea21d8fbdmr2627033f8f.18.1729272726184; Fri, 18 Oct 2024
 10:32:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: fredr@gxize.net
From: Fred Richards <fredr@geexology.com>
Date: Fri, 18 Oct 2024 13:31:55 -0400
Message-ID: <CANPzkXkRKf1a6ZvOJU=m3NwW4B0gQnQSRggw=ZnK6kBYmqLtBw@mail.gmail.com>
Subject: strange error from the xt_mark module for kernels 6.1.113 & 6.11.4
To: pablo@netfilter.or
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Hello,
I have a homelab with a bunch of rocky vms where I use the elrepo
kernel-ml kernel, noticed this morning an error with the xt_mark
module, saying it doesn't recognize the --xor-mark option ...

E1018 15:18:11.083644       1 proxier.go:1432] "Failed to execute
iptables-restore" err=<        exit status 2: Warning: Extension MARK
revision 0 not supported, missing kernel module?
ip6tables-restore v1.8.8 (nf_tables): unknown option "--xor-mark"
  Error occurred at line: 11        Try `ip6tables-restore -h' or
'ip6tables-restore --help' for more information.

I think it has to do with this commit but I could be terribly wrong:

...
   netfilter: xtables: avoid NFPROTO_UNSPEC where needed
   [ Upstream commit 0bfcb7b71e735560077a42847f69597ec7dcc326 ]
...
It's only those two newest kernels with that commit, if I revert back
to the prior version, the application (kube-proxy for kubernetes)
operates correctly.
