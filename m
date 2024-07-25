Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC90770F5
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2024 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721938310; cv=none; b=CUJPJSXP5qQqltRrVGpDPSwo7LCIvZbVpEs7nGFvRR1n/56hw8UXyzW6Plj9Wso4oLlnxtbkTbKFLbehk/yDcx36Z3FNgkIiibszWaH3PqhYn2TkLEJYIaGArUBcu56hm1GjYY803tNTlidgZ/9jCzhQxncts6IX92zQ0lEVCC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721938310; c=relaxed/simple;
	bh=IvdqZvTacjy6MAQ5qDRh4fw3aGKlpJ5TgBBkoXVfd24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtNe52E3xjIZEqBUM/tC7maNPhLRTFL8HJUHYXTuN1OREZqmj0g4XfzhFGQYGDO5IlvVyAPGbJct7FnFtTGXij/h6twZ4nVmHWZo/jLKcusSBfp7Fz/wzQ1qhjZDWJMorNDKeHgDCd0ncT4dqF94FkvP7BMedcmOO+jUoZO29qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UtlxkOiJ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UtlxkOiJ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a2a90243c9so1469970a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2024 13:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721938307; x=1722543107; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HYXza095pMOoHpnczk24pBNsoS9nyihsTN3J/3umgZw=;
        b=UtlxkOiJaNxEJ7GCiFTiyCfgnTnR7dJhHbUhconsbhoWe6gtIufbwh6TqHC7mOqzrP
         0uE5MPjYPHeLE8euOu6aIDxUdQmKu+OSGTzIJx367aundxX4ZMI0WfXizDrfw80SmPr8
         GBac0wxX4ru4j8IUq/YhdqJarmB4oKIqs9XJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721938307; x=1722543107;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HYXza095pMOoHpnczk24pBNsoS9nyihsTN3J/3umgZw=;
        b=ncI2V0npPF4AJTVg2DOdO4VL7BNID4RlPzn/VfVvkY87N3cuL2yGxOcN+VeMbXe6Ux
         /hYhYGQ5lyV8g7LBLFevrmSTviXqPOjmG69K1HASUvWJ3lctsfXcLzBTXnszG0xbWVdi
         6zMwy5fCegfG2oU7cLfLzB24r8QkOkVPzVthVcOh+eYwsKz8O91xCAi2tdhX1EldLgrY
         IHmC4ul1aFcvFBqj8jmXDBZMa/v+G0uHK62X0aGFyCzoAz4lj+WRW0W29k6+5/RAGpM7
         WY1NkQu5zl6SNKm4yDGLaJLac2ifuP5JnxOT89VNp6rl7wNKjj9UDJfkENzoBpKWIi7s
         lNwA==
X-Forwarded-Encrypted: i=1; AJvYcCVp5q51vHv/EmI1dtKExk5DQ4/HfDzZAt/ej4etxjKAvU56JZn8ZsZgwryMiCabQGOIEcP4UCK58jyEPiA4Rds6Vc0O7Pckk++/zUgSInMN
X-Gm-Message-State: AOJu0YymCIAIn7/4msvkLBbcZjBt2r+D70GktGPvHFm4hVY9bHsfulZg
	xq9ORey6f2bUI3PNtA27eLJ2OgcHt/UFvk52rHvv15lKI/zblq68jxQqWW8ZjcCAIJJF5b1Hev/
	9lsg=
X-Google-Smtp-Source: AGHT+IFr+2CJiR2+AIRYzsXtAESaqAp3pyzPFV8MYOUkmcfegGbtQINJ754B1LWv16PdcwUX1y0NBQ==
X-Received: by 2002:a50:c30f:0:b0:584:8feb:c3a1 with SMTP id 4fb4d7f45d1cf-5ac631afaf4mr2186794a12.1.1721938307110;
        Thu, 25 Jul 2024 13:11:47 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63590e7esm1114365a12.36.2024.07.25.13.11.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 13:11:45 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a88be88a3aso1718365a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2024 13:11:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX+WvdZc2/Ig4TOsHOuS2P9qugSX5L+phSwbZj5/7+AkL3WNpIwVCUG9SrIJfmT9TVOuX2cr++wxbqYjArKQn9UdS3+adHml19d8nL08LS7
X-Received: by 2002:a50:a686:0:b0:5a1:1:27a9 with SMTP id 4fb4d7f45d1cf-5ac63b59c17mr2468749a12.18.1721938304541;
 Thu, 25 Jul 2024 13:11:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240724210020eucas1p2db4a3e71e4b9696804ac8f1bad6e1c61@eucas1p2.samsung.com>
 <20240724210014.mc6nima6cekgiukx@joelS2.panther.com>
In-Reply-To: <20240724210014.mc6nima6cekgiukx@joelS2.panther.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jul 2024 13:11:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHHDGQ03qJc+yZKmUpmKOgbz26Tq=XBrYcmNww8L_V0A@mail.gmail.com>
Message-ID: <CAHk-=wiHHDGQ03qJc+yZKmUpmKOgbz26Tq=XBrYcmNww8L_V0A@mail.gmail.com>
Subject: Re: [GIT PULL] sysctl constification changes for v6.11-rc1
To: Joel Granados <j.granados@samsung.com>
Cc: =?UTF-8?B?VGhvbWFzIFdlae+/vXNjaHVo?= <linux@weissschuh.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bpf@vger.kernel.org, kexec@lists.infradead.org, 
	linux-hardening@vger.kernel.org, bridge@lists.linux.dev, 
	mptcp@lists.linux.dev, lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org, 
	linux-nfs@vger.kernel.org, apparmor@lists.ubuntu.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Jul 2024 at 14:00, Joel Granados <j.granados@samsung.com> wrote:
>
> This is my first time sending out a semantic patch, so get back to me if
> you have issues or prefer some other way of receiving it.

Looks fine to me.

Sometimes if it's just a pure scripting change, people send me the
script itself and just ask me to run it as a final thing before the
rc1 release or something like that.

But since in practice there's almost always some additional manual
cleanup, doing it this way with the script documented in the commit is
typically the right way to go.

This time it was details like whitespace alignment, sometimes it's
"the script did 95%, but there was another call site that also needed
updating", or just a documentation update to go in together with the
change or whatever.

Anyway, pulled and just going through my build tests now.

              Linus
