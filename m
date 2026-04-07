Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D7234A76B
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 20:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593400; cv=pass; b=YtZ7thTbo+auzp7hOPL8t9QB1b5BtIo3XdboNvJ47HnzXwVTxPFAME8QXOSrq4p4quHSOX7BMbpDt/mX9EOwKu+ZU1MUbnl2lutoVd6EGzAV8u59NO8PA9AxH/+7UvEk1jg+DFWa5vGmxsWGJXrOl8Pe2Vmjv1IzhzY3UJKClv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593400; c=relaxed/simple;
	bh=/vo8Ho9uK7QNdoBdsxzXkL/VUAV5uKB8HFsyFKhwoOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fb8d0NhUVWl15A0yIuv+6Y2raKk4tOmocPkAZrK6+EaM075sQMm1nvO8SPsafOg9oVX7RW5w2cWCeBJKWYIgBHh0HjzZHzUbmjJyuqDYzce2GoPj2tp5WWaFNjIq6693be8Vc2SqkC3edQ9WVP7i4WOl7P9+oNJnnVY6GQr7DWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9ShAHrh; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9ShAHrh"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b932fe2e1a7so734101766b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 13:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593397; cv=none;
        d=google.com; s=arc-20240605;
        b=GZyFx03a1ZoNtgagdGm9U1spe1RJ4nTvGmnsenh1kEdnKaO6vsi2WaauwZajTsk13p
         5pS2TBY/nYwk7Rbzl3S3JLxxR7/zcnywuQE+0JCVxM+Y+uYvLzkGGDJrMrucb8juyTsl
         sTECjsv7i5OQmulAlZUurxyUyJMtnUdByLpm6x7FAMHRvbC6Fqy0cfqp/dsLNJ+SdGxm
         mKxculjyj7qYyokMMDgpFxUYyDg88kF7cRYqS/mU7vEuLUr2cAgiWIg6jb9zGzXTXGzb
         b6ImHZjmyJzwIz+nWH2PcVzAsAltHlSnUxQ8IdNborE3NYVfUboQfNeXDrez3N/8C56/
         kalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZCx8twqJvR9nn7bLFe0MWiBT1PMklf9crqW/etIEYlw=;
        fh=v5H0m4ia9YSs8TFcwCANGF98GfP7pcn6eqq5c3gwfu0=;
        b=CkmSF4mlYIcL7Rv/x+C3warNMyYnHyIUeba9DY8+QYj7ffqCTz7jLlARqi9FTaI0cl
         wclzlVkp4AsDTvKzWdvxJVNaNiDJ1ahmbZM009/bGMJ+UQM5ybfe948xKsVBY4FVxnhM
         +Vj/RUYF6NrMHuIpoiJow8+9y7lweJaZl9bH7ICZabK7E/Kz4at3JGN758gMOCJRJXlJ
         4FNA8vUIzP9hA6/++OE2BDogo72YHtvPj8JQk0/ndJI5VB/RFFxcrrBsE+nykUR8/VG2
         bNUe0qTbA4M58Jcin8rWnaWMVTb39+29RzIV6dq2ulu+CLizeX/JZgclZChojzbV6ORA
         R0lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775593397; x=1776198197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCx8twqJvR9nn7bLFe0MWiBT1PMklf9crqW/etIEYlw=;
        b=C9ShAHrhqE76X97cIBZf5dHkbyR9lBkcPtM+Vqw/Bvk1yZN3HIKf1hCEQr3YmNY1N7
         Zx02UaezcXaHGuceYyemshxBMYz0Q/bbb1pB0Ex/qlRtQLLnRiNAUskOnqDjFEGTLDQ4
         okgc8+lIi1gAObQ0N7NcDC44RicH5dBkpoZNBfyWaKZ1eiVD6Fe9YLnXQyG3dbxfesl3
         T/tCW5VB3BF50RiBp3tqT7OqZgdo4+quvZPicECm0I7YroE9ExG/CcU5hrRb6xkuICaX
         S1g06lzf1PSG1V3vxwuibGeD0kj5OFskWhQHFaNph4P+Q0n7ZLmU1xvD8dIApmw5wMaQ
         TpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593397; x=1776198197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZCx8twqJvR9nn7bLFe0MWiBT1PMklf9crqW/etIEYlw=;
        b=KXqRFKavFY2QulYP0+BJJPwKMaTyRw8oV1rFHNKngsWGZ745plkfs0wOEWRrXeEBRm
         F8i4xWK2R/Au4fBeTdvlfGdrgPJMiEsqPbWYQiTubayCDK0Tm9ZA/JOqRb2SpAKJTaen
         ACSxx0AiPsiiOMGDlQDsxvU+lgNFDEyBWSLdtn7lUFJiQeQDBgWUmYY6fJzm6qi+t83/
         GITXXJ3kQC3LG+mYcUNYInxhfLUw9S0814AKFfCkYB+5QdTXzfIqAgj0inr9yzCe1/pd
         t+Sz/yoro9xI5LdhANYUjrSwii7WOuy7h/H2Z5oAulWSqoCVhVKGi2M2X3ImOsiGHux9
         EfZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm30LzoCQCTG4zWzv73kZUxWYP0uzCx8UDQT2rW5YXs0ahb3wobOlu6cWdhOi8ElBs/oNYtTb37MPUjlyciYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YybghmTd5YoqfIJtXLbJ8/PCrMxznUBVLHtaJP4hySV+kXhco0p
	rvhw/5kvAM2qffk9uG82AOfQTdnmhvJe5E1HpPg0hPZckrhhGGFxb4NQvkeOcW16LfytMxHHVYE
	zPmpjaxcjsv8vM5YHB3EqUUuaHvevMkbzCoQfTVk=
X-Gm-Gg: AeBDievMiY+p+jB/RzUIFws+HDyUZ2jWslxwkMeFwDk7l6xATKzu/c2EsJ1LOWP/mhc
	/0nIOkF3jkPRsCwtq1zqVTYKAMpPhqrBnd+W1OABO7JphLJyK3o5wklHkawO2MgvOp6HSwT98qN
	cbwoaA3hOfZo9yWyVdfxFXq74qwkTwPIo1JLq4bMYsWxgEibbhzX53mZKqZrfzXzWt5f7L3tiG5
	CiA/XWDf+PtEp7Dz5KliMjnxPh/MPD9RV8s6DfEs7hdiSda5xqpxOc6GpmTLUTH7tm1RizlQYaX
	p1mmEPliAH9oybJ4oNk1jRScSGUyERfjObPM
X-Received: by 2002:a17:907:8703:b0:b98:4c58:f499 with SMTP id
 a640c23a62f3a-b9c67957ff5mr691793266b.28.1775593396835; Tue, 07 Apr 2026
 13:23:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407083219.478203185@kernel.org> <20260407083247.965539525@kernel.org>
In-Reply-To: <20260407083247.965539525@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 7 Apr 2026 13:23:04 -0700
X-Gm-Features: AQROBzB82cXuNdt0Ng1iSzJ-7D2GJGPn4Rejnm3RvPTfCJRZuUw3Y0MamQBLYuk
Message-ID: <CANDhNCo9QZKoEwX0r8JeP_8YTSvKg5ENTSw5Zjj9Po-FywBftQ@mail.gmail.com>
Subject: Re: [patch 07/12] alarmtimer: Provide alarmtimer_start()
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
	Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 1:54=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> wr=
ote:
>
> Alarm timers utilize hrtimers for normal operation and only switch to the
> RTC on suspend. In order to catch already expired timers early and withou=
t
> going through a timer interrupt cycle, provide a new start function which
> internally uses hrtimer_start_range_ns_user().
>
> If hrtimer_start_range_ns_user() detects an already expired timer, it doe=
s
> not queue it. In that case remove the timer from the alarm base as well.
>
> Return the status queued or not back to the caller to handle the early
> expiry.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>

Acked-by: John Stultz <jstultz@google.com>   (also with Peter's
suggested name change)
