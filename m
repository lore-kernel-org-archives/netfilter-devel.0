Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CC9248886
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769189832; cv=pass; b=I6KReIb4Zzm3u47Xf5fAoLvr6/a+si4FHHybPspDcI59d/J5E38JWmdQSZ1NLOnUdO0kklGTlH73Lu4hObJLAKW17O6G9SKMOTfaABjORu2GE4z90QGdcOC3py8ZJc5NLBErGcVyMUH7qzhrYflENb2ln0t5bs/TFRWEFTqHHZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769189832; c=relaxed/simple;
	bh=CE1mYUPP+dJWzbRwFwG0zU70emWH3XQLGQneBZIYiyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOEOj+BSG/Jga0U5QWWs7IgTvtEJAgP8V/lIxyB7ZKYtCty/3clXyJjjKx3MGwyzcM28Dyyg1RLGWCmCwEai4B+evLY34wH+4rK69Fi8jeJNeWrG5dNiczuasCzgQJOG9zp9Mho8dZyVcdL0mjghnyhXpT/eMXhCTf7JmJkbDg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLf+7SsQ; arc=pass smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLf+7SsQ"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5eae7bb8018so768492137.2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 09:37:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769189830; cv=none;
        d=google.com; s=arc-20240605;
        b=TtTya8RvT65QP1hxCURqyuVN/NVYG7K/SaIYO0cSUvcnqepEv+j1pHZKXJH75wVTNs
         yVHZuXmbpSBS0445zpT3QBuFyZPY5RAePzOTjK4yQs2BzFRA/XnSsXfOFWn+3Lr317gy
         YWLMb11lu52QkVrKMR/1nhX51FbRfkCC8l5Qyr6z/Zri79zDOCuYQOKlOJP2l5Z9jefU
         vg2w66G90w9swKquDbqMQRiSDlGnWcIhbooUUS9a8y1vEMxSMTLEjuV2feCYH2cjwuuv
         sY/w6JxU4YbTT2hO9i8g5njCWXGjXWqhMZQMeRoxlD4aRrCukB5sJ7FqxG3y8146N4eh
         xEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ckNzReXQn0i/lQ3h3QxV5VRINW7AeB5W+94ipr9CL6g=;
        fh=6o508ip0gR7vYwWwuRhyOT4DWPIt45TeavJkzNdl6Hk=;
        b=b7UwvqSy9hEB1jKOy5u+asUu8TW2iq6tyMm+Z4xG+5S8GNjTt+hJPq9NZmdieJWYTX
         +8dj3k0f6lQQRiiKiiqjA8vzPRJdGkNiiEmumXOiSSNAmhC+k+0pz/lwzDiDGSzzhs9c
         TfhTgA5AbtBLmR42DuLZa8HvvIWA/GjrFkEKAC9rcBfgDPfQopDP6wb28lhQE/QDRuws
         1MjuOA7KTSK6MK8THoWHicpz+2InvIFDTK8yCvWARErRPwoRbrTIDog3hywz/Ewlbkwo
         6EA6qxQS9os3Al1S38hwf8yiKcAwn3+GcUP0/yOstP8Vj8A0W+I9cRwUKVvr5etmoGGm
         BoUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769189830; x=1769794630; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ckNzReXQn0i/lQ3h3QxV5VRINW7AeB5W+94ipr9CL6g=;
        b=FLf+7SsQN/OMjkx3Yr9bNxkVaVvWqN859tOxq5Seb2uDtlLLFT1CPqN9NQIO6lwEDY
         6HGZSnlNKts3uI6OZ5lRZHqJ1dG+TAIu3pSF6wJM2ZDFuCyelEFTjPWiR7yaPR5Wzpsk
         GOrUOsuSlSbFkY8oKPajMaa0R1xsrjXB8EV8/y/v22JnKrznLrVZiRgb496etIPpT7vV
         4JbFpcNAvK6MUeKFFFTiB//d8DFVIbCNolVY1SF2sDARZJqo5m4znHhtQeMiZ++PDqac
         YPnRqDPBZjv9MktVYNh2Lr4+fPw7cAoBbWW8ZBMKaExlo07zziv0HSV5ZvruaL3XJ4h/
         IwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769189830; x=1769794630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckNzReXQn0i/lQ3h3QxV5VRINW7AeB5W+94ipr9CL6g=;
        b=jZVidRRvfj4HTWSkke/enOQKfbr/19FjXrTXnw2vDngchBUSzqSJxeZj9A03hQeXhX
         kXVGe7Um5bwQmDHKxgzM6ROFgZ02w0/I7T/tbbcqb5klX0dysWDKDDm6rpLOelGt90R0
         RKuBTlSHl/39Ud9RxDQw4M7H+sAru0DYXJ6TFTQGEZts8H+TrH5kCTYCSCG2AJIINmxk
         hf04m1YlVuPMC+W4kZyh2mlV3W2SQ0ATW/oi/2yt//trrJkaKbnekiYTxCcZHsduncSU
         ZnKN8vCbv1mmsUTcWwPhLjwLnGGaNkSZFx1LyWegYIm86SY/awTH3QwPH12oIWYhrbT9
         89Uw==
X-Gm-Message-State: AOJu0YygfFL9GKwob/6AsmjdLYxv7JSMXLFO9NMqjPdjxY8x/FjXIAQa
	kbc4FLqfY9mpivV46klcRs5FRPbNLrOJuZDgEqFjoEGeE9sHb/gcLq4JWpNSpnLiRndah/95vu3
	HRbNQIbDEhw0fTz2FDQRHhzOOUTx/wiA4XA==
X-Gm-Gg: AZuq6aK4iuazyLeEUEWq3p+Z0TWaj7DE4gidUXAxM30pt98i/UcoT55dOclj8mbJdXD
	8zNPnS4/+3oua8Yuxljo69ZgXwjD4qYU19x2FdzQ2YT/PhtgcZsbd1M5eMaG+4ohI81FRLNl0/f
	RUxEAA0+Tif2q4jdg6GAAnCpnGiVyEwI8X4Gig1eXiUMR6kKYPzVv7vE8dfBZkfK4GSliBZLE8U
	foDUleRHoJAFfDbfzZ0arkfeQGdl1S6LDV5tR/MJJznN5Q7KrhvaMrnQDNvTN0U4ddEmNE=
X-Received: by 2002:a05:6102:dd0:b0:5db:cc69:739c with SMTP id
 ada2fe7eead31-5f54bb634d7mr1084782137.17.1769189830073; Fri, 23 Jan 2026
 09:37:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260123135404.21118-1-scott.k.mitch1@gmail.com> <aXOMkP9ovdFwLjwO@strlen.de>
In-Reply-To: <aXOMkP9ovdFwLjwO@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Fri, 23 Jan 2026 09:36:59 -0800
X-Gm-Features: AZwV_QhwHEbm4VD4hyrW-Q_LnYkh0664nfo9kfUionxXLVs5NH1bfBpFz3AvCjQ
Message-ID: <CAFn2buBGBe8o8+gXckZ35seBgbNXF+JMLjN7xcVcFJPrYw9NYA@mail.gmail.com>
Subject: Re: [PATCH v7] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Comments make sense and I will address them with a v8.

> > +static inline int
> >  __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
> >  {
>
> Is the inline keyword needed here?

I will remove it for v8.
