Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B0436AB4B
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 20:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593301; cv=pass; b=U/tyllh2adi6W8ezGMaSGbam3Io3qPqiH+V9cxWNjNpf/QT1YBjYIGmQ7YEze7VedRIipjFm7wnC7sANTqFr3oWkz5arN6egFX/Hkd5JDRHwt+h5YFYzzVpLesJSyDr4tJ0xYPUji+iYn89/bQrAvbhftG83qXFCimxpgNSOAFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593301; c=relaxed/simple;
	bh=OJ1tQJvTeGMBujVZAtwZtubFV7cagCryNfAmpVWvX2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aYg4gUrlOFrAXiT5S90B3jJ1XNysTQsKypSCp34+Mz02CYkk2yi8F/E5XFwZBl4ZJJ7RJCaz7GVbJVKr86t0uKXSUb+7/2TkGxkswOtCXSaxwOcPVCkSkA0K65pS9SyMrMQ3yAbuo4g/uga1TMUW8VNyAKWlNtuoU4bV1F89yaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Digbjsaj; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Digbjsaj"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b941762394aso740011166b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 13:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593298; cv=none;
        d=google.com; s=arc-20240605;
        b=RaJHG/E/bOwnPLviJXHWi29X3s+8uqeUF22tTFboGuGplYf9Gh1Cr99dQfXAZ8YhmH
         3nmpepU9nR2ko/NNRvNbW9cDcFjw5bkCi2iIF+QpNsvPPV5MSJafI6/VywybJebxFhVs
         tw3vpEN8f/N0ID3VHY61jBc++ha3Q9+wj/Kkl5O1/qRS6xnqigqTVZxTZhIDySu7PtFe
         JGYe6wYThRv0JbgJz9/+2cGYjSgnGr4FVaO5E5DJWG/AVeyfPONIYYKdQ8i9dQu+RZ8d
         2mvzuJAdNTyi87HR0Q4NRrUOALoqXUUj4YNt8CNfZIpMWj8FguFFIrytLIrHCAGEj78A
         JhkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OJ1tQJvTeGMBujVZAtwZtubFV7cagCryNfAmpVWvX2I=;
        fh=CFtcNuEImR1/T3IuR8Bq5+Zu+ktxYk85Hk/DHVclikM=;
        b=dMd1FWpwYXxaSySl8ShxIjhqyjgQhvyun4k4ZYN5ppmdilNiAt7uyzOV601MgJZnz+
         lpQ3gafzD9vB7dR8dLFB3TXQzk1risHeYA3fHmSjUC/R8CHnuZIgxL/FNmpMYsIBfSnw
         PlvCDr1rLDQQ+uuUiol5v++HO+SJZAeAqK9DkfHY1GlokupPS+SnygGEqCfOrhjUXTpQ
         UdsefVEoONYcbVb3zIK5OkZ69vDq2Z6ECnKoiBcLw2LZWMh++ZAvAOPQpW+UxxTeV5v4
         1sGqWP5QAFDH2DWspz9DvVSL37ay/92T64FhjUgJ3RFWQ+1SYY0Un2pNYtCXepFvOpnd
         UNlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775593298; x=1776198098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJ1tQJvTeGMBujVZAtwZtubFV7cagCryNfAmpVWvX2I=;
        b=Digbjsaj5m93nHOVCFbrS3mEpKIjOF4kS6gA7CWIqEpP3wvyqeZ/dsdw3MIxmi27HL
         VZWC9n+VFO/hCZ3c5zbfPz3WafWZBytYKl8NbTq7Pn8ejMvVECeP8s1DHrLCFz/WVzHg
         U8DgyM+IEaU1tBI4PlQ8DB7kI+czlsSQL0bgKEX+/lLwjTruuJ+J4EtQI7aEqlIopIZs
         5pBtHrWzBBRMy49lhxL6D4ksvk7rueuqlp/8QGqAbYgfnykffsJMEhVqqcKgKbP9TCWW
         aGYogSMDWI5ArIpl8vGQRgVQzrKgMMJibmE543+XHuFjJsAl4lw5hm1G1PjwKwKWXzlJ
         j6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593298; x=1776198098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OJ1tQJvTeGMBujVZAtwZtubFV7cagCryNfAmpVWvX2I=;
        b=QtHEeObrralToKi50bgk/YeQc+xf24jJHr3t40SpZNbXgyxbxAltVbvbKqDcfKWMX8
         Zykw7bRzBRId7juPNwWfJQiITcWCY6dgWqbfpmQWoH81OcqelLDf0feL6lbsxuPJ+06h
         EAHNBvQL+bUxx5OtOalapSc1GQ7orC4EuVsZ5f+LKgHfmphzgvW6P9628S/rbV+W3bN9
         6kqoUKARYRtTWuux/whStmFExoAG0rYHxAn3YtBr+j2mg6TY9X6kmUz4jqYbWdwDWpu/
         MFiqT77uVUhPKSg4xObHUCwGzv0HulO5qYCPuQcD3k3wrA++x3DXAvDPPhH9jjXBtXbS
         OTUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5wsQc9HWtg4nG++sL/ymeGp6rbdCVBh1FlGXun2Sbt0wgrhIbbTfwra9Pi961fbH9uME3O7lA9jzfFLk/gkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNJsZ6+FieBKqDhG51qIetH6vPdh9NrejUlwK+XUKHEajtdZA1
	RTG6tYYdhvFXnOWclHEjmLomABQxEjFFbzX9mT5kJ7UmFhzjWh56I3/TJ9oIrLI4yfKUKpoRzGq
	iCRo1yP5+Z3KBfBC1SkrVmVz8B+bHv6+213yJIc4=
X-Gm-Gg: AeBDiesmGl1mv2P6PvhOsoshDjufxhmg6d/ep728S8yUQkAF4DZxywch7t8rwfvrk+a
	jpTlLojfGp939D8vdczgrG7ByRZ+sSP8P6c9q2QS9NZQjXarcwraNaCj0NTGet9mT1Nxu4yEz3V
	tYEqLrqpJCKtuYDFP9DP/9TTLFy6elkQaxpp0vPw33q+ugtx7jegCdFWXEPCuRdVpi8UhktuKgv
	hXMZiIS9N4b9nN+2WGDGvPbW9PFYUKHwqezdq5+cRVO3+e3ZVKumvLtGLkHqZs8kyUVQyFOjdTt
	o3PU/quMYw8Amrjn0nw2r36euEhsOQjYAk52
X-Received: by 2002:a17:907:d87:b0:b9c:9594:e10 with SMTP id
 a640c23a62f3a-b9c9594137dmr648296266b.14.1775593297523; Tue, 07 Apr 2026
 13:21:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407083219.478203185@kernel.org> <20260407083248.303293327@kernel.org>
In-Reply-To: <20260407083248.303293327@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 7 Apr 2026 13:21:25 -0700
X-Gm-Features: AQROBzC7PDFv8vCtFbIbXkiDn8QPhKuu5um8yGzNerNDgS5PLItAWlJfqN0nP1w
Message-ID: <CANDhNCoTUyvQ_-Vn3neffN_Cu2uwPW36O4CtZLCu2JHPztW8Kg@mail.gmail.com>
Subject: Re: [patch 12/12] alarmtimer: Remove unused interfaces
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

On Tue, Apr 7, 2026 at 1:55=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> wr=
ote:
>
> All alarmtimer users are converted to alarmtimer_start(). Remove the now
> unused interfaces.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>

Acked-by: John Stultz <jstultz@google.com>
