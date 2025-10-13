Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BA927F166
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359819; cv=none; b=L5ruusFrGTLyAkBAmmCBZtFNE0F3boIAsBgnTgCXrty/72VyX7+I9W9qCZlFHANdXfV0IpBIsxUYCahpJjfNI1uubYCxZeXiCzs0um5HKXaDYS1ogIfp05P4DZrwbFLxM/eEeIQihkTLH+ridFxy9R9iI+zwdEKg26F/nUx0xt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359819; c=relaxed/simple;
	bh=hX8Zfl3Ft9exMkDlK68ZU3kuDCYZybS5T4oNtjWKQVE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oDuTAZCFsb/TNF+GRgeosZqe32fcfNKKhVm7K6ztVNGU4MmZZmaFb5A9BqxOU8wE4eydCZdnRqO7r46Iyc7yRFelMaEI+Zv2VOXpkrmUJlywpN/EIeHZFBF7B+h8wBNn96dHLFX6bWRYZWL2BZ+fPRwu8PkuAWX4n3RDe76Vcsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfPXu+IW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfPXu+IW"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3324523dfb2so4062947a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 05:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760359816; x=1760964616; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hX8Zfl3Ft9exMkDlK68ZU3kuDCYZybS5T4oNtjWKQVE=;
        b=GfPXu+IWPWtu4y0JKXxrMCEYph+kST2fbx/lNlzAMqi2qjVUtaM9dqi8HNeQWueJRG
         eSbhWGlPEa8YuUK5JMRQgolDigKLR5pFDlgduj+9Vg3v4GmjQSB4gf89auS2H6vjb3sr
         0qAlYtZlxoi8ezCxjTtoXsp3ISyxbrtRUBvhYk1gjKQetSQyj5metkB8QztQc1nga5rN
         ofEWu6nGYdJi3UvJjOHDWMKz145OczDYnQNJV15svqFdae8D6XAJpUw+KL1ggzLGfdox
         +i9xXtDZI4MEq5rYXOJMSHBjQtTLv+SBSCvCvyLRRoFAGZrB8xxP9uvSkNHLy/asaLbH
         UQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359816; x=1760964616;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hX8Zfl3Ft9exMkDlK68ZU3kuDCYZybS5T4oNtjWKQVE=;
        b=PEgit2/IUo4q2aFDTSM/2c5JyPOPxZSZgubEx3hbsEiRDKe9tz+6n7yHbtT3XDPzgE
         tK4sxEHTapnI1tnm2PE5kQoU258IukpIC56U66RbAxpT2teNzhS0OWBBAyuzT3/kwETo
         4dUrssfa9Qev4OINqjhL5tt24lvVaz3Bgj6yDuSg9XQzoYrRGHmvr/bCL4Es2b4cakPJ
         Wo91ko17LI2FV2jOBtNlES6CRwX9ysnkYKt4yqEKraRysNHLKz7qHUpWqe0J+50ZpEix
         yjRpwz5ees2wZLN8au//q7sY879wOg/Io32YDKLREDUA+wpUbS2iBAzVPMX9ybA7Ka6e
         KkTQ==
X-Gm-Message-State: AOJu0YzaWA+grtHF8qVl3KP4th5aV/UlKqqP0tKJj5p+a+JUZgUCB7yL
	IekgkCl12OV/uvzUectN4WLfP3NElJtybFkYYiuUy1usl2zzhnzZDT1iz7QUDDlZMc4ihjG+4yc
	YDJKB5HgSql+bm+HDD3Ffks41WVXKBAOK6dmlAjk=
X-Gm-Gg: ASbGncv8N3v27Js2ZQMjpDeDV/jlfUpMFWfWdOurJXfAPXL4gHq/7UnrY9QbGeUPHQr
	YU2wq8PR42ycAlb8sINxyRdujzHU0JkXmTVYGaexhBJjVCtJxFpACD1iqG/hJs1KSCKEx3j0ibE
	qVEe431RDbs9LGd4IyAc3wzh6ZFADqqEzhdNX4JFy9gl21zTD+mQJNCkmw6wtq8fLi9B1YnhC5N
	xC5Lwm71sC9QIULN3qastRn1VqXquZD6r8=
X-Google-Smtp-Source: AGHT+IFVaz5ae3mFAoNE8pbeK22fvNg2lnh2Z6pomOK5ZcMFOuEH7D0pf8n37tmMgFEeUN4FLZULE+9AXR5nkbJEPFk=
X-Received: by 2002:a17:90b:3e83:b0:330:797a:f4ea with SMTP id
 98e67ed59e1d1-33b513a2006mr29203133a91.29.1760359816329; Mon, 13 Oct 2025
 05:50:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ata Yardimci <atayardimci97@gmail.com>
Date: Mon, 13 Oct 2025 15:50:05 +0300
X-Gm-Features: AS18NWBJNY_ikkSRZd_6Us_TcMg67OztKdrgNzCHhDrjIRf0XPh57tF6frq18nY
Message-ID: <CAGE3PDpNxA6eY_0Eo9Hj7anxtE9QMhAi3FUT5QONLvXnZ0Xk9Q@mail.gmail.com>
Subject: [libipset] lifetime & reuse of context from ipset_init()
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Greetings,

I am using libipset in an application that continuously keeps the
ipset context active and accepts events from outside to issue commands
to ipset, this way I avoid opening a new process for each task.

I supplied modified error function pointers to ipset_custom_printf to
avoid the exit() call after an error, to keep the process running. Mostly
it runs fine, I tested it with many basic commands.

However I also encountered various problems during my tests, some of
which I may report as a bug, others, I have to ask about the intended
usage instructions first.

My questions are,
1-) Does this library aim to support executing many ipset commands
without exiting the process? (I guess it does but the exit() in
default_custom_error confused me)
2-) If it does, are you supposed to reinit the ipset context after each error?

In my tests, I found the library to be quite usable for issuing many
ipset commands with the same context even after errors, but needed
some tweaks like resetting the output buffers after an error, or
handling an extra packet arriving at the Netlink channel and such.

According to the reply, I will understand which of these I should approach
as a bug or intended behavior.

My environment:
-------------------------
- libipset: 7.24, compiled with default ./configure
- Userspace toolchain: GCC 15.1
- Kernel: 6.14.0-33-generic
- Distro: Ubuntu 24.04.2 LTS
- Arch: x86_64

Thank you for your good work and your time.
Ata YARDIMCI
