Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BFB7082F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770915399; cv=pass; b=ATG6yoDpBSCoFvOteqJfNCp/i2qaYUZFrhxev0/reQYaoqhoLqPN2gusHqDJUm84dQAGzQRi7J2z5BJIGPwo9eWmhzZfkTJ/yLWKuwIexB7axsMkn1ayEGpVuBi74vRPSAseC5tsNX3N9SD9J/npqoLJWq/rz29UoNpaoJNtLq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770915399; c=relaxed/simple;
	bh=mm9/tw9/pf1TRqHHYZzlnJ/dC5IMEYQR3SihXpHLk1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxXcUpBosP7Nhp3Izr0AFGm9Z7+/m9S4NaJYiG3Y+Gwp4THPzMRtLuLb/Xb5pOMKprOpcVuE4AnP3q42gHt57HPckDpEGCERCAUnVNrYdLnaJTZxzSBPNUerU9e2XXPU+lNaHxh2aCO1LvwegKyTBNBBQDkBL5Av0dyS8dwvG0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai; spf=fail smtp.mailfrom=sleuthco.ai; dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b=E4WA6zC4; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b="E4WA6zC4"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64ae1729637so9295d50.2
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 08:56:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770915397; cv=none;
        d=google.com; s=arc-20240605;
        b=lLcsEOQ1QxQ5P5BPqDGO1CKQAyi5LIxH24XJDxhBuuJh9uJa0Gzv4j7Wp6Mv4OJ6Zr
         MjZ9d+YW7FyJb+qUaczY46Ps+jhwp+uSatMnWgl/opFojbhDuoh92/tXPay0zzq0CMoz
         yNke5w8900mNcoJ5oG+uJpSkmQBqsO0mEEuUzSdnH+dIC6OEtFFE6ke5obZ2gMUUp37M
         ccC/9IjHpqebnf0BkwtbxCKLrzlQK3A4DbU8oTdQT0anuXLO9g+8WI2zSJIFjacY0AFw
         +8Trk0/cgOng0xhqYq64r/5/f8Ek86WfT7z9hH512gRaDba271PGHIidPzHq4qwOmeu9
         BEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ws2q5h7dpyNMZfgnUWQjoTdweyro/YizCv2kO19QKPY=;
        fh=xgAaXZ3dJxh1ri7sto4BHspykiIFkMXiweU0zkU0bQg=;
        b=K3xGdyPZHAL++vKRugYdLdHCkspdLkkRigKMt5KmREtZ17DWqqqoBmiWD7pR5eoZS7
         lt1NRVfcTcBaz4BdReH1E/Rv0XQvCJWMzlbjy//mt2Q2zGHph3/oId2Ixm56XUu0u9LO
         nFlIY8d8dYCDzk6lgHtTOJLVHJ9HOVDIhNi4kq5ofZB9mPn8lhbla5WtARjZg/Ze1iow
         066H2bzkKmxkbvTwjuxGMwnqiFvvfcFIrufSLfZS2SXiwvUGiHT2ppqxTEhngzodmVOq
         mtLnNiPV3A2KoUgnlhTG8Htf5GkSb6eBYWBExWafIGFxTIdjLVA66xey3HWJDLFhUqlL
         MPJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sleuthco.ai; s=google; t=1770915397; x=1771520197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ws2q5h7dpyNMZfgnUWQjoTdweyro/YizCv2kO19QKPY=;
        b=E4WA6zC4r6sQnXATLwcazhV6KDvvFy19ByrPic69tRK6T6HwWBJ8eUwpuXjyD5X4ue
         b6Bd8SYfV8zEToB8E2CLOcQ5nWFPBoABmzbcaRkLa+ZShEbpujhO/fKhosIh9rgC2rgw
         vpaMlf5OcWJUnXRsDcU2gm+BLhn9BhvAhLQPbpH9AESmulctmEd4WpmMWreN41Z9B3wY
         eE+6SLxLveI+A3VgB3KStt2bh7eWBlTlDBEGAojbBihxGhdmbqZgyhnsbZXrAbJmZ1Fs
         FmRx6/RJT10Gg9H1OmYBMRJrpK4WeQrThQO8Ne5eAa1ahjXbSo1ilELu0My4qVzyqaU8
         WI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770915397; x=1771520197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ws2q5h7dpyNMZfgnUWQjoTdweyro/YizCv2kO19QKPY=;
        b=fdc+9MdGsg9a1HuTobGrL8jZ6sWtTzhrry2YPw91tbpg3GLKZZlzeRZU+BBFSBNNDQ
         9D06c75KfZsaz3TPOzAQP5cTYXToHwh0uWn41//y0cfbLNmV34fggJHgxi+RgvtjOSuE
         qwS/JYhzdkIBn7dcRbXxSTrjQQE3gMFnETFh/kZPPfNGlok+UVMt+F2e8iSXxTfq7vsT
         +bJ6Iudm5wyjISe6TS6QRqewETNe55fYSXMrzZlNCo+j4sSO7Qp2EWxKzkwpcDaog0hq
         ZLGJPVBjQElALMVI3qRIwLikA1cgFJK8iZ9HG0u2dFkm2zvCV/La0F8FdNa4+annMQ6Y
         iZGA==
X-Forwarded-Encrypted: i=1; AJvYcCX2bdseyAJH67kt5BuUxGC9MFcdpmAhoOU/WB+osTGhhbg2lQj8R6pzyRpSpLD88lQdpCTPrP3WnPGSDRyVuDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhOe50oxqjH8RMRqkvyYCbQ0xc1CCJZ49jMM8kUf39c8VUnRFo
	4Dtmk9HEWOWqktjZUwaWOdqny2dd5ZV/nAgU2kxgPzLygBaOiPZ7TFJUliNDZ8+vg5PNhPZ4yO8
	W6oOM4sBqLfwb7ORxhpNl4yys5bBM2c+MtZHem/JQtWdKZ80H8tlw4P75
X-Gm-Gg: AZuq6aJLqSOfpyDxxR1tU8F1omCq7sA7lFZM32uzoKhXtMaWnKNcnGcP2gjZnm04ZyZ
	hFGiSqi9+tLGQ07yQNjpbGLGqzPRLoxnxhbEthf/b7523rky1ScsjwomVseB6vEJXz5CojUQ0oy
	a6v+gf0rkKIcTN48Pbc8itot5EKGzFwM0P56NILvBdFpYFX/Zdnut8MKnoG7mXDlyTresL2RYDB
	xzTLxv7n9QfeIiCf3VTlfFrPi8CV8qOL2kdwI9Y3rAk2P/gzvVTKDfvYazcytuge0SBXfoHidXb
	18cKqKOcU4VZvuf5vyBIAN4/pEC10i5X/8qV6jv1dVEKoD5sqQ==
X-Received: by 2002:a05:690e:14c2:b0:642:836:f27 with SMTP id
 956f58d0204a3-64bbaaddb2bmr3109323d50.44.1770915396947; Thu, 12 Feb 2026
 08:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>
 <aY3aAChfNI3LWvfO@strlen.de> <qq4or008-331o-628q-rr32-409p846r02o9@vanv.qr>
In-Reply-To: <qq4or008-331o-628q-rr32-409p846r02o9@vanv.qr>
From: Alan Ross <alan@sleuthco.ai>
Date: Thu, 12 Feb 2026 11:56:27 -0500
X-Gm-Features: AZwV_QinQg0Vhmf4TXVAKxZBMrmgDOd-jMgTL0-qBoPWO3Dvot7jA-656M5BXiY
Message-ID: <CAKgz23HD3UDEubpDfVK2dumYfTr+ODOyKmbfDunVeoPPjX2x3A@mail.gmail.com>
Subject: Re: [PATCH v2] libxtables: refuse to run under file capabilities
To: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 Good feedback. If the binary is built with NO_SHARED_LIBS (static, no
dlopen()), then the env vars
  never reach plugin loading, so the setcap risk is mostly gone and
it's okay to allow it.

  The fix is simple =E2=80=94 keep the existing setuid guard unconditional,
but gate the new getauxval(AT_SECURE) check behind
  #ifndef NO_SHARED_LIBS:

  /* xtables cannot be used with setuid in a safe way. */
  if (getuid() !=3D geteuid())
      _exit(111);
  #ifndef NO_SHARED_LIBS
  /* When plugins are loaded via dlopen(), file capabilities are
   * also unsafe =E2=80=94 attacker-controlled env vars reach dlopen(). */
  if (getauxval(AT_SECURE))
      _exit(111);
  #endif

  This way:
  - Shared builds (default): refuses to run under both setuid and setcap
  - Static builds (NO_SHARED_LIBS): still refuses setuid, but allows
setcap since there's no dlopen attack surface

  Want me to update the patch file?


On Thu, Feb 12, 2026 at 11:15=E2=80=AFAM Jan Engelhardt <ej@inai.de> wrote:
>
>
> On Thursday 2026-02-12 14:47, Florian Westphal wrote:
> >Alan Ross <alan@sleuthco.ai> wrote:
> >>
> >>Attacker-controlled env vars (XTABLES_LIBDIR, IPTABLES_LIB_DIR,
> >>IP6TABLES_LIB_DIR) still reach dlopen(), allowing arbitrary code
> >>execution as the capability-elevated user.
> >>
> >>Extend the existing setuid guard in xtables_init() to also detect
> >>file capabilities via getauxval(AT_SECURE).
> >
> >I'll apply this tomorrow unless anyone else has any objections.
>
> Ah, but we can test for `#ifdef NO_SHARED_LIBS` to see when dlopen
> is not used, in which case setuid/fscap-enabled program binaries
> might be tolerable.
