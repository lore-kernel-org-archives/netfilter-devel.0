Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150832C6A3
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727972466; cv=none; b=k7Er0JQYnR32tEgA1mcimfes6CWiXxv47pbiIgOBBsYvjBErA/ofK4P50CrBhc0H2OjPlQz46eCGzrnQ2yMdFZUt+J5ZpwCV5lHKJqbnG8Dw6O/gU2tEFN6T4/j+OKJ/3r+/OjYbQnarLLFk5xIVZOk/VjlBUVTksdYgjzQLCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727972466; c=relaxed/simple;
	bh=phcUqo3xH2uEzOt4nWimJ90S6LJAldcVwztGX186zGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAFXSa8zX5BaiF9Xr/wMbd64+RwvJRwWwmDZ5pvo064XYlKQSQYYF8gFw7+w1PnAmM6JacfPPmfezq+hMN+UCAhT5l5+FL4GtBHgsLzfY61I4uGrxzD1JiubyhiMhVVSBO8eCcXKn2v2+p01rQN8BxP67VTJHv5dxaLvsBvbXa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ymAdctxy; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ymAdctxy"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37ccc21ceb1so435417f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2024 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727972463; x=1728577263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4AMHyota3tkdFmoOCaUrSl8aqZ2USc7/BC5yJtpHMg=;
        b=ymAdctxyyCtLE8+h2eSkAigJ8RS+pkClpSFa/JS4e1idjBJVci3c28spBCuZ7pp1X2
         TaRgRD6rTZ2mZWVlIeVXmqq3IgqJItVe5uE2Ksp3+GdL//71iPyU7uLtip30VfIdiLo+
         U5TjY4sN14ekpC3HUtAZQZwTYsmDexP9zFhqWoGKRQabGPbl0AMf3GXeipGZu4Apcka8
         K7wH2t2oy2WLUgkW8RvoFDfPFG06ThPz2+orEX9rm4lIaPFCMSJ51z/XnqXrx4s+2tMq
         GVZk11q1z/Wy+YCY1XBhY1lQx7dpDKspAHknx68rbdpcFrJ3bvc0zX/4IYSfQ4HHK3mD
         T39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727972463; x=1728577263;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v4AMHyota3tkdFmoOCaUrSl8aqZ2USc7/BC5yJtpHMg=;
        b=r7888ZiTzAw5JT25YxkIV04nNEwB4sLFONC0kLIV401yAzlClxzz+rEEz+SwOdXRA7
         OkHvxvHk0e/MiHXdlHYQNDph4XMyaDOWcZFb0PH3Er1ZXBuMT42I0uDMIZyZYU6DfgY3
         SQEEMvy88QYsffk9UJU8oBvG4Gg1/Lw52rwe63X39dOALglOI7YBbhEN5MUxy7v/nI68
         2uG+Nr49rLyLrdhNRNyk7ue3Yxyex8zkg9y8tmqwwXmLF8j4O4LrSd/ISBOm3LR8MgTS
         CLApJJaJF8FSIU5qytAC+bsc+GRaJB8ipf80ZahPh7WLTgeaAOD2xtedXQGfyMIWbs8W
         s7CA==
X-Forwarded-Encrypted: i=1; AJvYcCXm5gsf9Zjsznj9yYSemkgqqcbF9M0s3KKL+e+fNVqz3Rt4EWZ31rHF60yLuoF/aXvsovaIRVckPlR95NSO0NU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+yOC75OkMlUsQxLylTPCmdDif5dpVve4KTASv/Za2WXTj9FH1
	6561QtxaA4l4T5tpgA85Lt6OxYG+hcGebPp0ZyI3vFUz2owSWcIHx44Fh9/tctEHgzyKxSM3ACl
	lOQ==
X-Google-Smtp-Source: AGHT+IEOdSyWAmORFapKSEpH7G6R0n6gyVWbE/o2evQEGmgpcdbF9DaA5iglc2Nvw06fJUx28bAaePlI4hY=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a5d:648d:0:b0:37c:cdb2:9767 with SMTP id
 ffacd0b85a97d-37cfba3fe9bmr3840f8f.10.1727972463162; Thu, 03 Oct 2024
 09:21:03 -0700 (PDT)
Date: Thu, 3 Oct 2024 18:21:01 +0200
In-Reply-To: <db38b163-ceb9-c74b-bcd5-402c646abea7@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-20-ivanov.mikhail1@huawei-partners.com>
 <ZvufroAFgLp_vZcF@google.com> <db38b163-ceb9-c74b-bcd5-402c646abea7@huawei-partners.com>
Message-ID: <Zv7EbY2v6aElb5BI@google.com>
Subject: Re: [RFC PATCH v3 19/19] landlock: Document socket rule type support
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 03, 2024 at 05:00:14PM +0300, Mikhail Ivanov wrote:
> On 10/1/2024 10:09 AM, G=C3=BCnther Noack wrote:
> > IMHO, the length of the "Defining and enforcing a security policy" sect=
ion is
> > slowly getting out of hand.  This was easier to follow when it was only=
 file
> > system rules. -- I wonder whether we should split this up in subsection=
s for the
> > individual steps to give this a more logical outline, e.g.
> >=20
> > * Creating a ruleset
> > * Adding rules to the ruleset
> >    * Adding a file system rule
> >    * Adding a network rule
> >    * Adding a socket rule
> > * Enforcing the ruleset
>=20
> I agree, it's important to keep usage usage description as simple as it
> possible. Should I include related commit in current patchset?

Sure, sounds good to me. =F0=9F=91=8D

=E2=80=94G=C3=BCnther
