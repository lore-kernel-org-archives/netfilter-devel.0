Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CE830595C
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 19:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768332943; cv=none; b=h7NwBHuHc1NvaiZRdtEZs1aVaMJglb2ddLE+5CZrnL6S2jayLb4YULQPd1TUbZ5qc3GuJ7JSmqV5sLV1Cgy/w8MjgR9qz0XPM8JRZYa/DAraWQ8bTu7q52NDrN7i2SUqiX0vndyPhvR+gVwZBLnflRAZpHr7Me2YR6hjUsqPGpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768332943; c=relaxed/simple;
	bh=jZZQroJrE7VeYEj+wn5kl2UT2gBb09x/39StwfupwIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQNOO1MRKE6HQ2NZ7TTLZgfrI+s4ycl4U0+ehxoBDlsiuKgoiTjoV01WxcIZabrBH8KASZbkN1DTJr9p731tcSZ/IXbx3+VkoR2BIFPKCCsT8TrDu2uW6s66UiHrkYeBlKSYObDBOM6PZGJFI0TSLdDoqhtZ2UIdxjUCE4GsBEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViqxgXKK; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViqxgXKK"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-5ee9fa419f5so1401394137.3
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 11:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768332941; x=1768937741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZZQroJrE7VeYEj+wn5kl2UT2gBb09x/39StwfupwIw=;
        b=ViqxgXKKLT39s15E372Cwq6EHuZwtS8SP+IuBa3xEevcTqmgZYJ9oQ+ID/Fipr4Kz3
         LiGUiKcNRqRt+7j/HWVzLR3j0MyL8Uij+g57K/8ESPRc3+SHcJgT11Tgp4otbtPyY0nC
         qsSracuXoQZ49FwzsKXi6+0Ca+S4buSC5yF08KTdWzQphAE1cxhqpBLYrnKu/ZcHjSKZ
         jm1En8/W6d62b0uXrr5X+Pe4B0Ftggzhq9NwqCOdjx3a9judqQaVTMJ/0WoPtveaHIU7
         McOQMS2jFdiUboi8ueFIimGHCTKelQWtsYmW0ZtA1JbWGctfaPco0h3yhCWEvUDqUkyS
         X0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332941; x=1768937741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jZZQroJrE7VeYEj+wn5kl2UT2gBb09x/39StwfupwIw=;
        b=Af7APc2We1XaIxSLekdpm8cX1PVk8CkRGEqd5qRCkQWjAqZ5x2mvFVU1MAMwQV/Wyw
         lZbwJsjyw3iok4wyyb03euPNnY0IUkPxtJHUICKqmtg6bNgIUyxFXlM8dpn9kmNEDl+c
         f/pncPYT/YHs7++qNrkK7o+xYY6NUKSFsgQTIKimRAqzFZAzcGlzlyZnMMvnqE9Lee/Y
         56/9Ji0iwsucOCoZ6JvwTHD06RVHIvPOIRzh3NPdrBz/A0XmThfXjmVlaAzbNB7ZNjan
         Qe2wd6Q9MpgFBaTFfTZdL5cNrsv6k4sIb/syWMDkI1LHiKQNmUA9vzSxoiapWCVVIBWE
         RYbg==
X-Forwarded-Encrypted: i=1; AJvYcCVLdq7VLteDt0UnD6P63opsyVLBXECN0JcPqLXkL9FpBvTSIMerizjkEaVPPl3b1uGc1gIzWzc0tVGy5VaGXNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEQv0LF/q2o5s86DBmaazUqNproEKNIS1At6zPx9feFRWsH8Ln
	MS/DBaDLBV5Jtg8H8U7lgCrcEW/UtRerOw2LsAzI2zKb5dXxS3uwQt03YHGK0EPs985EZ/yf/ZJ
	5/9dmX9VwWizTpKzS6F83Z2KcXJ/mx2s=
X-Gm-Gg: AY/fxX5jEFFEcL3b5ODFvPcx+zvx/PCuohOpVfrnQzgj7C7UxaSqPTkcVqbfnZOF0R7
	VMMjwXAWTTEPYAZLYohUIECGxqxARrAbgcYB8GSJmtjkCtVDsvSx4oN0a2YIH51oYP7Ijnnrg3s
	rtkTFQw7P4m3R/Vh/HIpFSFDIvOy6B1A0BEwqg0gt/F49ykMZnMwE6E9jlC7f8wmUhdHW7jhi8w
	2WCskVoLBfYGkAQd+NzXO26N6CkeS4B5xIlrQn4KgRI0/1/4OHXhRFpB3ogNFYmquM1ATZVV0BY
	GYKzK+s8Uru8AhmDk9yQLfTIaI/+OkOHE5tlE+8=
X-Received: by 2002:a05:6102:809f:b0:5ef:a554:c125 with SMTP id
 ada2fe7eead31-5f17f66b0fdmr134285137.43.1768332941303; Tue, 13 Jan 2026
 11:35:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260112222017.3d1da4c9@phoenix.local>
In-Reply-To: <20260112222017.3d1da4c9@phoenix.local>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 13 Jan 2026 11:35:29 -0800
X-Gm-Features: AZwV_QhX-tlO5YXcnb3KoSHtLpLjLJLNMLEkRcpYDY8DEX7WgjlkBYoB8QWntWY
Message-ID: <CAM_iQpWmiuOOUHHo0dnizjJDqU2KrLH8kWW1-zZXJD4UyJKXhw@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 10:20=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
> This is a complex patch series so I decided to get a second opinion using=
 AI.
> It is worth reading (but not completely trusting). Review prompt is Chris=
 Mason's
> Claude review prompts.

Please prompt your AI what's a symptom and what is the cause. :)

Infinite loop is a symptom, not cause. Fixing symptoms does not
make sense, it only covers out the root cause even deeper.

Regards,
Cong
