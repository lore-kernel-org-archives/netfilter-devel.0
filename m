Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A5F377ECE
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 20:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593246; cv=pass; b=o9m9CG/UAmHZoxRWiq4I1cc33whyRoa5M7r/3yGBaMgOdvk9MiN4TaYXGAIDHPWlVgSTx9gCKHw7zK0rOGn+BfOp4vz0QQZdYsuKdLFs3UOQz6C23jC71RxDy47ZmJ/c9IOOvmiXUTEV54wcZ4NrZ/uI4F7GQ3P75ytLaqWtoLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593246; c=relaxed/simple;
	bh=cjT74Ocy+s/QiUPJBz2L2D9lT8JxlLpHzuEDVDl9Xlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmwD9w+GucWFHXSZlo8MCskynEqHzTcpRrPbNSdAOcasCEqkLMHr9PUu+61gniKSLrRpWZlQTtjnp3+PoCHuJ8RqFExXftNF4nTzTKJyItd00hGf9dw9lgMdh+BvYwui3gi4Izo0L/6zlXMvgRizIh25g/i9MbBnclo05qimsMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tEFDH9Ri; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEFDH9Ri"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso706981766b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 13:20:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593243; cv=none;
        d=google.com; s=arc-20240605;
        b=hMlH0otsL3qGsB8SOmx8r2KAaJJlCG+IUUs2SkkwkrOvbR52woxFYbN6RtKhkTLgPS
         XH1Up6OI2gVRLMzMtLgdin5XlGe7R1tYFQsc4nTZBCwl/exEF08jEd899pZdNLBfWpCd
         3XJRUCf6SEXCbzI3gWAXYQjEckZnNwPjc2huID6eIcW61Uby5Qi+DYGKFaqCJj4arqML
         RsFFA2CQ3CScZ4lEHRaY871N0bm0p7XcgJ/AHKkYOzBdPWIodxUK7/UpJWq2hdsBhM4q
         cbgIE3zGdSMH8XHR0nEAtBzmYp8yYdas9nT9Ym6h4vPMxDeHwjzXQgqMW10+6mlXLolm
         Vw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cjT74Ocy+s/QiUPJBz2L2D9lT8JxlLpHzuEDVDl9Xlk=;
        fh=s15lpcbA35fFS1ch3zUS/Qs9jFJ8sxtMNw33ywblpVU=;
        b=dGQwStgHaNfc+Zr+cOiWnKMBRz8NflPadHGyTsGLRRM5MCYZlytpspfQwrNC/91ycl
         5LcEhR5LxTdEdR6f+NvX+dZnZ0UGC/cu/c7kWFD+8KaQnuU9SV/7zR4QmcfE3VKpAW1s
         74YpEmdHOzmiKFZ5GIMmDmBp2xaeISsRSeXOOet9qX7lSP4i2iYD/FO0ILNgN3wkZECJ
         N7R1DB6hgLOzMOpjOOMZleIN/FRVbsLH7h/PThXeDEml5QPNLeiywOEp3kro3WMDUKX5
         2+FpJO/q4tfsVVGAcHc0BebyKmtFX8bBgdIy6H4F1CNzpvLIEG2tmnylaPsaVN/aRGcf
         CliQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775593243; x=1776198043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cjT74Ocy+s/QiUPJBz2L2D9lT8JxlLpHzuEDVDl9Xlk=;
        b=tEFDH9RilULLpzbXtcJhRp8eKc/U45MaQeEOCBfP57R01x9ZQhnv2QSlBiNawt+rEJ
         WiTV88m6PGXaYhIpTj/LSkIFYMe/chWzskINUuXjOM7t6JB3pWTrScrcJeqSQVs/6DII
         /XXEyNRNTG+JAmAq45oL6wOAVNI2H6FB7Dvg1rMPox75U9dOY71OUIoGl7fGezIil7ij
         PtLGGbMfAGpkBVFNy5NEoUlxu5QL/iR4PAc1jOp82gw5+JHVYTQlogiJMXIBFNs64m3n
         ocoSUp/QC0/vaqDTAmVvNDk9W9qTOXoR7KCIXmOg3fceNnW6IaEgp16oW/aoz8FcolHU
         En2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593243; x=1776198043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cjT74Ocy+s/QiUPJBz2L2D9lT8JxlLpHzuEDVDl9Xlk=;
        b=Rpqmw20AmqP1BtKQJW9nbaP4XhYIU0LCD/2g9d7vyi8sdWLqspSgTTGhY4P80iSfmc
         d6BHFZEVFN9zZhih+wLHJJmq4X91qm9mluJhla5wdYWznYIDQ+AMa3rbPudXWaVGVHFL
         0/N0DrvZuI04GRlNLNx5rUFM8HaXTbCEx0C1yeMp0QxO/33tL1lKpNQchqLl57HiuiOw
         9gpQCZ3otIETKao4y5OAzMHYRw27MWkjCp4MG/tELitKb5O1pFY51jY+c3l9PuQ4koqG
         3WV9DaIGX75yOlbJPtOkbF/5LWwSBK/XRDpezsJPPQZGuBebhgqER5enbFE15TTComJ4
         YiKg==
X-Forwarded-Encrypted: i=1; AJvYcCVKLEZcxZ/vqYHWehDuG4pmHKrBuPeccPVRsNdOxvOVCVw8rYCtPcBqD9+zZN/wpfLIGftNqGP0OFB3I3TPiMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJixXmAb9TqeMU11EiHIgNyZxWNr5+CyMbmlSaghbEMZZ9wx9a
	lFkJx905oN+Kyw4DDGXBO9+a0qXUYM6dfSoqaf24bH5ZAno4v6LU1sLcoeJy/7nMsblOmtryz1o
	NC0F30JjRK+T3T+/+sG6DWWmJxhoOnfFy5wYk8j8=
X-Gm-Gg: AeBDiesxCbzYQs/UMuNWDk8CBDa1b8YtBBPmSumQ+a4DSxgSgXKetWDxPuFlVNa9Bws
	rO9I3Jm+b2O7iC03HgYJXemjIRengGy9Z231IbJiFGMPv0evqw/h7YFFzmrBL3RL+hGoSz07e5t
	dEVsAyZAemO62TQ64FkDu7Avs+Fkk7+l+rBXIdiEIr4/1EF9p0N4KYRg+agYeXeH4rRztw1iSI6
	lP/AwKJuhk7S9JGxvrYbd5h9lXVMzPcYQ+/K6/90bKr6KyqIi7uDEnWCQlhsA7A6bnPjTuzNoPi
	v+J+22JFrF6Do/097vlg/2Zom2AZeHunvWt5
X-Received: by 2002:a17:907:8b93:b0:b9b:ddb2:b1c1 with SMTP id
 a640c23a62f3a-b9c6780cd71mr930525866b.21.1775593242554; Tue, 07 Apr 2026
 13:20:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407083219.478203185@kernel.org> <20260407083247.763539663@kernel.org>
In-Reply-To: <20260407083247.763539663@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 7 Apr 2026 13:20:30 -0700
X-Gm-Features: AQROBzD-zfvxt2CXKn7k44eSW_jC6hzwik2D295qjg-xw73ZHrijJ7W3y5q868U
Message-ID: <CANDhNCrPm0w6sFADMY_6-Ne3XeHp5aDXU9a8QNt8WPbeLWX5gw@mail.gmail.com>
Subject: Re: [patch 04/12] posix-timers: Expand timer_[re]arm() callbacks with
 a boolean return value
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 1:54=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> wr=
ote:
>
> In order to catch expiry times which are already in the past the
> timer_arm() and timer_rearm() callbacks need to be able to report back to
> the caller whether the timer has been queued or not.
>
> Change the function signature and let all implementations return true for
> now. While at it simplify posix_cpu_timer_rearm().
>
> No functional change intended.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Cc: Frederic Weisbecker <frederic@kernel.org>

Acked-by: John Stultz <jstultz@google.com>
