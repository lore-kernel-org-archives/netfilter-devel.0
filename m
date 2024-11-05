Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BF11D14E3;
	Tue,  5 Nov 2024 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730803322; cv=none; b=ivqov4LHaf7SfcOzzjtpW1oMEKvREGq6eiPNmM0kPHuGnnI0qXIILgFZ2dGWJ36+D4PJHLdQECdDy4rUODiMxJ/SLsOodWulLBfSKQF3HVLUWiN18O7FvSV+Ha+pt4Mawu0GxyEg1tyBybqA6G29BFmNPa+/5Z2m9qUVSFYOiIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730803322; c=relaxed/simple;
	bh=BnS26AQg0SzshMgXPfzFYflSzpoZ8i/wb+ElcH4CSFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CXoV/hrHuZxVnAABTaoH8ei2PTI6qr6ea/GxNkWq4/JUm1GdDo8Y5zmjMuBP8rkWXzKvdyVXuJqWcfENjWhbfNyL6Az6qwdSyP0EUC1CI/iBRjkHroOnDN/K0eC9KfO0PPhfSQE4TQahYHoOxsmI/P/XgnkjaJnlXY4sYQinT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBCzuuyo; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBCzuuyo"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83aac75fcceso178118839f.0;
        Tue, 05 Nov 2024 02:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730803320; x=1731408120; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=66RM71Gk3IyyATVOHZt3+CHfu8uUND2pDAurbR6NNrg=;
        b=eBCzuuyo6xbT+Hv2A+BnmknyEQ7PPxyHuBbKln4CGNVibMgfH7jn7tBwh6WfYR8aWE
         NfpSu5z3HhKPmu3zxVH0kiIyOP+5EAn2AhDH4mFG7MvaB3p76+th/zxmsCS52+YJ8uhF
         5jFbg4GP5Y/jdkri3X8AD6tqFg/lGEYk5i0Jc63nx+xTZwiECXdpYd44ygg0Tw1CUCOj
         P+k99bZ/AOlWG8zvFoFkzKLK94lgkJN0Q/HYFC8Pihgo93GNdgDwpz1C+bjGsjMj4DaQ
         uIVXRnZm8WrIbZxltNixzn+E53Lr5n7sOV8ActRToZovxlo8lhy3HCnUvO5E8HbRdlt3
         NKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730803320; x=1731408120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66RM71Gk3IyyATVOHZt3+CHfu8uUND2pDAurbR6NNrg=;
        b=t4WOZ6Ri+SJIWtA84Pp/rDH0WwLO/qYnq5fdPt/OVMWaLiwRBirVk+KCewYdXtikam
         rMImygkiSq49bH/3k8j41qo8NuR2pNDHQlTDodTFvAFZbbx7RHEwKv/h4wJmUElnu0Pe
         QM9SFTJXD60fl7/UUkd1yonjKkFr2D8WXN27X+cKxT8YyPM5WWoXhXDVU+ILa8vAwEv6
         ElUJ6AVP8ias/ZACPu6eXcZtspMqlq9C9d3WxPJLRsDi0IIQ7bOO8Lvh+o1C7dB9VBg6
         f5BVIXG9zSIoT0SoG1etPxCr63h8aLctQZHrcmlFA5xvtibQvJTdwPY5QjzMW6PGEDV8
         pKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlakQ2CB4aG7WFP1a/Ub5rlwZLufqSC9AxjEfbfj9jh7FCMzGhOEnmX2eBai8ZWNSP1GCB07q1D1Pxfz0nGUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwztEwV37wdKVwOmm94EDX44PhMY7zO1SSGvVeB2vWqP7qtExQz
	H8SKrTGvQhM1CXUe48qEwZLysi+/T+hsU0KTqbb3hWP3aZnp+nitZiDKlvf+ML311evQJTOZb++
	q4ASbiWRzjA/Ipp9s9yYRJQy/NZa7iyGGk8IZCA==
X-Google-Smtp-Source: AGHT+IFxFl9HfElWCj3B2D3gRKMV4N7I9cImN+qOXwAUqNcAjmcyLes4Hv4gmYSF+HGHIZ3vTOpqe3Vu3a8tPqangiU=
X-Received: by 2002:a05:6e02:b41:b0:3a0:a311:6773 with SMTP id
 e9e14a558f8ab-3a6b035dc3emr144590665ab.21.1730803319901; Tue, 05 Nov 2024
 02:41:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104142821.2608-1-fw@strlen.de>
In-Reply-To: <20241104142821.2608-1-fw@strlen.de>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Tue, 5 Nov 2024 10:41:23 +0000
Message-ID: <CABhP=tbOnrUaN1kT9Q0R=xJ-8XsasxfwjLN22sCyLxpHSR3YAw@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix warnings
 with socat 1.8.0.0
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Nov 2024 at 14:30, Florian Westphal <fw@strlen.de> wrote:
>
> Updated to a more recent socat release and saw this:
>  socat E xioopen_ipdgram_listen(): unknown address family 0
>  socat W address is opened in read-write mode but only supports read-only
>
> First error is avoided via pf=ipv4 option, second one via -u
> (unidirectional) mode.
>
>

Yeah, I hit that in  7e37e0e , I ended adding the "-4" and "-6" flags
because it was easier to me to reuse the test code, but this LGTM

> # socat 1.8.0 has a bug that requires to specify the IP family to bind (fixed in 1.8.0.1)
