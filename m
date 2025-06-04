Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044517AE11;
	Wed,  4 Jun 2025 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749011234; cv=none; b=tgP0Hn4HbQKdIqq6X5/fTgQjR9VWZ1eUGApoJaSuHlVtTf0P9yLCWtz4sQoUfGLuxn81MZk80LTdKKKGY+rR5PidxuTSzAPLxormLkaPMn0hEBQCMfllYf+F6Ifiqvh6cnws6J27tZSViWrkhFwDrGjBATDD3cCZ7bgF6phzdL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749011234; c=relaxed/simple;
	bh=1evMnnmMSYJSXg2IXlGewHSViRm7MB6nkSC7LHyLqrc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qz9m5QNRmoSv74DH1pw4re8I+0riTT4V3sv1Nz1xKcfGv/yEWR39yQQGLwFFIuXaJ14F7O/lxRr3tuetf/9+8X+MwQ4W5jAjPepYArvz0gVQk8VN/3bGYP/jdeixpWzfHRzIps0M1wwWjcMKDgvm+0A6kfuJ+fHM8zOZYAcV7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JaKBp9xK; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JaKBp9xK"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32aa864e0e9so33210991fa.2;
        Tue, 03 Jun 2025 21:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749011230; x=1749616030; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tJuhntjfcXBPQ/m5wkBZugOryuT0atdnE1px3Wo8XlE=;
        b=JaKBp9xKF1mC4Y4UAgtTdQWu7SaGmepYDc7m0yXfhoieB8hfy8WFrnVonyv5EDA3Fo
         PXFbH/Q0YWMAA5DKPBUCguYmIVOx+EHToQBO4Iv4hukDuVWQAdOJ9HaaInnEtotzH5KF
         KtVM3xvLC5rdC9fEpXg06860LuzTz1NK+qJFnA8OfEe7hOlHxSXw2q7jyK+8Bgty0fEn
         s3uSLM1WVb6VIvU8V0KBrA+hezo4soM5h8o5WQIbqicP7AIXixm/NdhA/UQVtvYQA5Zl
         T40PUGyxxpC5Uj3OyeCcgZ0NlPdmNKzUaGaMbkx7sjYggre2zEXoI4QF0S6/g92SGp3W
         F15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749011230; x=1749616030;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tJuhntjfcXBPQ/m5wkBZugOryuT0atdnE1px3Wo8XlE=;
        b=Zq2WiF0y5qRnNNGyHBdrkHZaDVlpUnOAF2eKxw4mwjc4RtOPulVLFcATO9bxd8AG0i
         w43ZVJlHd+Wy13vL+i8O3B0L/OVeGVAPaPnUuJ/nlk18utkXCsI4g2RRuT0BhptCBn58
         rNHgooTNz6ZKbx+MMPDDld43m42H9N6bNsMfh+sgj6T1FmYr+Q/IVN6doTZ06c07dgRo
         wYFEQWONjhnO53AtQM63mh6VeVcT8Z5X5MbgZhBd9HorQ8uFbvzp/7vcd+hpso3JYcFE
         oEuhSO+n1XaYoF4jNTYWWq6KIO1BfiYvr8UhpcyhEiMQNMYHwbyxC8gwvx3GRs5iU0nx
         m+rw==
X-Forwarded-Encrypted: i=1; AJvYcCVXnUHZ/hzB9dQ1c9fvV9Jm7vQvnWQKKnOAYVFG/Sb/xsNLkr0EF9cmdFf7rWLPSDY9zfEoSTcy@vger.kernel.org, AJvYcCVgqH/5FTb2j6dTBdiy1HbqQLtQ6nKuRHCNWx3AxBCl7JfX6N0XSjPkNXPQ2MB0AQd35vWDkDLXpEwNb+s8fJJs@vger.kernel.org, AJvYcCXISU/WZrqpiu2VYH9v1e521+5xsPhPTA9z92CNmZ86yujL/NiGugqslAXQxoXa7mc4ujVUzyyebPLe7VY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNuXJcnSkc99pU1EwkpoqzuAqNtYebIIMX4BIxEcmAAiTPOI+H
	ELbgyOFTu66itRnoFZ2LKkuHzEcIYfPUsK5vc4D6cYehnp3sZdis+SWO3eKwrpK6/Cyf9ks5pT5
	2B4RswhCqGFuGNkXcOxVrqeqQHLUqGd3JVHrj
X-Gm-Gg: ASbGncs1J0v/tTEEKtuKhXz1fqnYKsbY5UbdRHyBNK+8kshySCQKuxO6px8d04sYLFG
	t7l1mW+MiyZsoxoqmg+UlqJlwKuFstOcdfnoyY3h4oP7K/qZMsWdmUj6+CHoMLSuP7Foi4WMqpK
	gDslNY5q8wyOkntWsNwyLN/AHexZzOeCCpaGg=
X-Google-Smtp-Source: AGHT+IFX5jO3COLUJRnQhQyuxD770TZX6dYTmz+LGSVP2ythi3VgcFI6e2i33CEPsfvT9BRa5aEQJyadsG/zb1GL6Jo=
X-Received: by 2002:a2e:b8ce:0:b0:32a:8101:bc06 with SMTP id
 38308e7fff4ca-32ac71d5b06mr3561681fa.9.1749011229566; Tue, 03 Jun 2025
 21:27:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Luka <luka.2016.cs@gmail.com>
Date: Wed, 4 Jun 2025 12:26:57 +0800
X-Gm-Features: AX0GCFtc7TndShEm9CaEvmnN1dDhjQyV6OO5S6NpHrqWWW48tDVqbd_Eigo7-ZY
Message-ID: <CALm_T+1uP=2cXh3D8eCu8A6URcKLwpy+4wMDaErg_RMNswyCSA@mail.gmail.com>
Subject: [Bug] kernel panic: Hard LOCKUP at 'net/netfilter/nf_conntrack_core.c'
 in Linux kernel v6.12
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	"David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Kernel Maintainers,

I am writing to report a potential vulnerability identified in the
upstream Linux Kernel version v6.12, corresponding to the following
commit in the mainline repository:

Git Commit:  adc218676eef25575469234709c2d87185ca223a (tag: v6.12)

This issue was discovered during the testing of the Android 16 AOSP
kernel, which is based on Linux kernel version 6.12, specifically from
the AOSP kernel branch:

AOSP kernel branch: android16-6.12
Manifest path: kernel/common.git
Source URL:  https://android.googlesource.com/kernel/common/+/refs/heads/android16-6.12

Although this kernel branch is used in Android 16 development, its
base is aligned with the upstream Linux v6.12 release. I observed this
issue while conducting stability and fuzzing tests on the Android 16
platform and identified that the root cause lies in the upstream
codebase.


Bug Location: gc_worker+0x2a0/0x1024 net/netfilter/nf_conntrack_core.c:1534

Bug Report: https://hastebin.com/share/bupiconuya.bash

Entire Log: https://hastebin.com/share/inunasepaj.less


Thank you very much for your time and attention. I sincerely apologize
that I am currently unable to provide a reproducer for this issue.
However, I am actively working on reproducing the problem, and I will
make sure to share any findings or reproducing steps with you as soon
as they are available.

I greatly appreciate your efforts in maintaining the Linux kernel and
your attention to this matter.

Best regards,
Luka
